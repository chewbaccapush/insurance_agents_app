import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:msg/models/Measurement/measurement.dart';
import 'package:msg/services/connectivity_cheker.dart';
import 'package:msg/services/navigator_service.dart';
import 'package:msg/services/storage_service.dart';

import 'package:msg/screens/building_assessment_form.dart';
import 'package:msg/screens/settings.dart';
import 'package:msg/widgets/building_assessment_tile.dart';
import 'package:msg/widgets/building_part_tile.dart';

import 'package:msg/widgets/measurement_tile.dart';
import 'package:msg/widgets/routing_button.dart';

import 'package:intl/intl.dart';

import '../models/BuildingAssessment/building_assessment.dart';
import '../models/BuildingPart/building_part.dart';
import '../models/Database/database_helper.dart';
import '../services/sqs_sender.dart';
import '../services/state_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/custom_popup.dart';

enum AlignedTo { all, draft, finialized, synced }

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  List<BuildingAssessment> buildingAssessments = [];

  List<BuildingAssessment> searchResults = [];
  List<BuildingAssessment> draftAssessments = [];
  List<BuildingAssessment> finalizedAssessments = [];
  List<BuildingAssessment> syncedAssessments = [];
  String languageCode = StorageService.getLocale()!.languageCode.toString();

  TextEditingController textController = TextEditingController();
  final SQSSender sqsSender = SQSSender();
  int numberOfUnsent = 0;
  AlignedTo alignment = AlignedTo.all;
  int countDraftAssessments = 0;
  int countFinalizedAssessments = 0;
  int countSyncedAssessments = 0;
  int allAssessments = 0;
  bool _isExpanded = false;
  bool synchronizable = true;
  late StreamSubscription subscription;
  bool hasConnection = false;

  @override
  void initState() {
    _localGet();
    ConnectivityCheker().initialize();
    subscription =
        ConnectivityCheker().connectionChange.listen(connectionChanged);
    super.initState();
  }

  void connectionChanged(dynamic hasInternetConnection) {
    setState(() {
      hasConnection = hasInternetConnection;
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    textController.dispose();
    super.dispose();
  }

  void synchronize() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
            AppLocalizations.of(context)!.snackBar_sending,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary),
    );

    List<BuildingAssessment> unsent = buildingAssessments
        .where((c) => c.finalized == true && c.sent == false)
        .toList();

    int successful = 0;
    int unsuccessful = 0;

    for (BuildingAssessment element in unsent) {
      await sqsSender.sendToSQS(element.toMessage().toString()).then((value) {
        successful++;
        setState(() {
          element.sent = true;
        });
        DatabaseHelper.instance.updateAssessment(element);
      }).onError((error, stackTrace) {
        unsuccessful++;
      });
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    Text title = Text(AppLocalizations.of(context)!.dialog_assessments_sent);
    if (unsuccessful != 0) {
      title = Text(AppLocalizations.of(context)!.successfullySent +
          successful.toString() +
          ', ' +
          AppLocalizations.of(context)!.unsuccessfullySent +
          unsuccessful.toString());
      setState(() {
        countFinalizedAssessments = unsuccessful;
      });
    } else {
      setState(() {
        synchronizable = false;
        countFinalizedAssessments = 0;
      });
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(
          title: title,
          twoButtons: false,
          titleButtonOne: Text(AppLocalizations.of(context)!.dialog_dissmiss),
          onPressedButtonOne: () => {Navigator.pop(context, true)}),
    );

    filterBuildingAssessments();
  }

  void filterBuildingAssessments() {
    draftAssessments.clear();
    finalizedAssessments.clear();
    syncedAssessments.clear();

    for (var assessment in buildingAssessments) {
      if (assessment.finalized == false) {
        draftAssessments.add(assessment);
      } else if (assessment.finalized == true && assessment.sent == false) {
        finalizedAssessments.add(assessment);
      } else if (assessment.finalized == true && assessment.sent == true) {
        syncedAssessments.add(assessment);
      }
    }

    countDraftAssessments =
        buildingAssessments.where((c) => c.finalized == false).length;
    countFinalizedAssessments = buildingAssessments
        .where((c) => c.finalized == true && c.sent == false)
        .length;

    countSyncedAssessments = buildingAssessments
        .where((c) => c.finalized == true && c.sent == true)
        .length;

    setState(() {});
  }

  _localGet() async {
    await DatabaseHelper.instance
        .readAllAssessments()
        .then((value) => buildingAssessments = value.reversed.toList());

    countFinalizedAssessments = buildingAssessments
        .where((c) => c.finalized == true && c.sent == false)
        .length;

    // disables sync button if there are no finalized assessments
    if (countFinalizedAssessments == 0) {
      setState(() {
        synchronizable = false;
      });
    }

    filterBuildingAssessments();
    setState(() {});
  }

  onSearchTextChanged(String text) {
    searchResults.clear();

    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (var assessment in buildingAssessments) {
      if (assessment.description != null) {
        if ((assessment.description!.contains(text) ||
            assessment.appointmentDate.toString().contains(text))) {
          searchResults.add(assessment);
          continue;
        }
      }

      if (DateFormat.MMMMEEEEd(languageCode)
          .format(assessment.appointmentDate as DateTime)
          .contains(text)) {
        searchResults.add(assessment);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double verticalWidth = MediaQuery.of(context).size.width * 0.55;
    double horizontalWidth = MediaQuery.of(context).size.width * 0.5;
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: OrientationBuilder(
            builder: (context, orientation) {
              return orientation == Orientation.portrait
                  ? _buildVerticalLayout(verticalWidth)
                  : _buildHorizontalLayout(horizontalWidth);
            },
          ),
        ));
  }

  Widget _buildVerticalLayout(double width) {
    return Padding(
        padding: const EdgeInsets.only(top: 50, right: 50, left: 50),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              searchBar(width),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Padding(
                  padding: const EdgeInsets.only(right: 25.0),
                  child: ElevatedButton.icon(
                      icon: const Icon(
                        Icons.sync,
                        size: 22,
                        color: Colors.white,
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        primary: (StorageService.getAppThemeId() == false)
                            ? const Color.fromARGB(220, 112, 14, 46)
                            : const Color.fromARGB(148, 112, 14, 46),
                      ),
                      onPressed: synchronizable && hasConnection
                          ? () => synchronize()
                          : null,
                      label: Text(
                          "${AppLocalizations.of(context)!.assessments_sendButton} ($countFinalizedAssessments)",
                          style: const TextStyle(
                              fontSize: 15, color: Colors.white))),
                ),
                RoutingButton(
                  destination: SettingsPage(),
                  icon: Icon(Icons.settings),
                  tooltip: 'Settings',
                )
              ])
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width:
                          StorageService.getLocale()!.languageCode.toString() ==
                                  "en"
                              ? 480
                              : 520,
                      child: _buildFilterRow(),
                    ),
                  ],
                ),
                AnimationConfiguration.staggeredList(
                    position: 1,
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 25),
                    child: FadeInAnimation(
                        child: SlideAnimation(
                            verticalOffset: 35.0,
                            curve: Curves.easeOutCubic,
                            duration: const Duration(milliseconds: 500),
                            child: ScaleAnimation(
                                scale: .9,
                                child: Row(
                                  children: [
                                    OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                              color: Colors.transparent)),
                                      onPressed: () => {
                                        StateService.resetState(),
                                        NavigatorService.navigateTo(context,
                                            const BuildingAssessmentForm())
                                      },
                                      label: Text(
                                        AppLocalizations.of(context)!
                                            .assessments_addButton,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary),
                                      ),
                                      icon: Icon(
                                        Icons.add,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                    ),
                                  ],
                                )))))
              ],
            ),
            if (searchResults.isNotEmpty || textController.text.isNotEmpty) ...[
              buildView(searchResults),
            ] else if (alignment == AlignedTo.draft &&
                (searchResults.isEmpty || textController.text.isEmpty)) ...[
              buildView(draftAssessments),
            ] else if (alignment == AlignedTo.finialized &&
                (searchResults.isEmpty || textController.text.isEmpty)) ...[
              buildView(finalizedAssessments)
            ] else if (alignment == AlignedTo.synced &&
                (searchResults.isEmpty || textController.text.isEmpty)) ...[
              buildView(syncedAssessments)
            ] else ...[
              buildView(buildingAssessments)
            ]
          ],
        ));
  }

  Widget _buildHorizontalLayout(double width) {
    return Padding(
        padding: const EdgeInsets.only(top: 50, right: 50, left: 50),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              searchBar(width),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    RoutingButton(
                      destination: SettingsPage(),
                      icon: Icon(Icons.settings),
                      tooltip: 'Settings',
                    )
                  ])
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width:
                          StorageService.getLocale()!.languageCode.toString() ==
                                  "en"
                              ? 480
                              : 640,
                      child: _buildFilterRow(),
                    ),
                  ],
                ),
                AnimationConfiguration.staggeredList(
                    position: 1,
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 25),
                    child: FadeInAnimation(
                        child: SlideAnimation(
                            verticalOffset: 35.0,
                            curve: Curves.easeOutCubic,
                            duration: const Duration(milliseconds: 500),
                            child: ScaleAnimation(
                                scale: .9,
                                child: Row(
                                  children: [
                                    OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                              color: Colors.transparent)),
                                      onPressed: () => {
                                        StateService.resetState(),
                                        NavigatorService.navigateTo(context,
                                            const BuildingAssessmentForm())
                                      },
                                      label: Text(
                                        AppLocalizations.of(context)!
                                            .assessments_addButton,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary),
                                      ),
                                      icon: Icon(
                                        Icons.add,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: ElevatedButton.icon(
                                          icon: const Icon(
                                            Icons.sync,
                                            size: 22,
                                            color: Colors.white,
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            shape: const StadiumBorder(),
                                            primary: (StorageService
                                                        .getAppThemeId() ==
                                                    false)
                                                ? const Color.fromARGB(
                                                    220, 112, 14, 46)
                                                : const Color.fromARGB(
                                                    148, 112, 14, 46),
                                          ),
                                          onPressed:
                                              synchronizable && hasConnection
                                                  ? () => synchronize()
                                                  : null,
                                          label: Text(
                                              "${AppLocalizations.of(context)!.assessments_sendButton} ($countFinalizedAssessments)",
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white))),
                                    )
                                  ],
                                )))))
              ],
            ),
            if (searchResults.isNotEmpty || textController.text.isNotEmpty) ...[
              buildView(searchResults),
            ] else if (alignment == AlignedTo.draft &&
                (searchResults.isEmpty || textController.text.isEmpty)) ...[
              buildView(draftAssessments),
            ] else if (alignment == AlignedTo.finialized &&
                (searchResults.isEmpty || textController.text.isEmpty)) ...[
              buildView(finalizedAssessments)
            ] else if (alignment == AlignedTo.synced &&
                (searchResults.isEmpty || textController.text.isEmpty)) ...[
              buildView(syncedAssessments)
            ] else ...[
              buildView(buildingAssessments)
            ]
          ],
        ));
  }

  Widget searchBar(width) {
    return AnimationConfiguration.staggeredList(
        position: 1,
        duration: const Duration(milliseconds: 500),
        delay: const Duration(milliseconds: 25),
        child: FadeInAnimation(
            child: SlideAnimation(
                verticalOffset: 35.0,
                curve: Curves.easeOutCubic,
                duration: const Duration(milliseconds: 500),
                child: ScaleAnimation(
                    scale: .9,
                    child: Row(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                            margin: const EdgeInsets.only(bottom: 20),
                            width: width,
                            height: 50,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Icon(Icons.search)),
                                  SizedBox(
                                      width: width - 85,
                                      child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: TextField(
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary),
                                            cursorColor: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                            controller: textController,
                                            decoration: InputDecoration(
                                                hintText: AppLocalizations.of(
                                                        context)!
                                                    .assessments_search,
                                                border: InputBorder.none),
                                            onChanged: onSearchTextChanged,
                                          ))),
                                  IconButton(
                                    icon: const Icon(Icons.cancel),
                                    onPressed: () {
                                      textController.clear();
                                      onSearchTextChanged('');
                                    },
                                  )
                                ])),
                      ],
                    )))));
  }

  Widget buildView(List<BuildingAssessment> assessments) {
    return Expanded(
        child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: assessments.length,
            itemBuilder: (context, position) {
              return BuildingAssessmentTile(
                  onDelete: () async => {
                        await DatabaseHelper.instance
                            .deleteAssessment(assessments[position]),
                        _localGet(),
                        Navigator.pop(context, true),
                      },
                  context: context,
                  entry: assessments[position],
                  buildingParts: _getBuildingParts(assessments[position]));
            }));
  }

  List<Widget> _getBuildingParts(BuildingAssessment entry) {
    List<Widget> children = [];
    List<BuildingPart>? parts = entry.buildingParts;

    parts.forEach((element) {
      children.add(Container(
          margin: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 10, bottom: 10),
                child: ExpansionTile(
                    onExpansionChanged: (value) {
                      setState(() {
                        _isExpanded = value;
                      });
                    },
                    collapsedIconColor: Colors.white,
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    trailing: AnimatedRotation(
                        turns: _isExpanded ? .5 : 0,
                        duration: const Duration(milliseconds: 400),
                        child: Icon(
                          Icons.expand_circle_down_outlined,
                          size: 30,
                          color: (StorageService.getAppThemeId() == false)
                              ? Color.fromARGB(148, 112, 14, 46)
                              : Theme.of(context).colorScheme.onPrimary,
                        )),
                    title: Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: Text(
                        element.description.toString() == "DRAFT"
                            ? AppLocalizations.of(context)!.assessments_draft
                            : element.description.toString(),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                    children: [
                      BuildingPartTile(
                          context: context,
                          entry: element,
                          measurements: _getMeasurements(element))
                    ]),
              )
            ],
          )));
    });
    return children;
  }

  List<Widget> _getMeasurements(BuildingPart entry) {
    List<Widget> children = [];
    List<Measurement>? parts = entry.measurements;

    parts.forEach((element) {
      children.add(Container(
          margin:
              const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.tertiary,
          ),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [MeasurementTile(widgetContext: context, entry: element)],
          )));
    });
    return children;
  }

  Widget _buildFilterRow() {
    return AnimationConfiguration.staggeredList(
      position: 1,
      duration: const Duration(milliseconds: 200),
      delay: const Duration(milliseconds: 25),
      child: FadeInAnimation(
        child: SlideAnimation(
          verticalOffset: 35.0,
          curve: Curves.easeOutCubic,
          duration: const Duration(milliseconds: 500),
          child: ScaleAnimation(
            scale: .9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.25),
                  ),
                  child: Stack(
                    children: [
                      AnimatedAlign(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutCubic,
                        alignment: getCorrectContainerAlignment(),
                        child: FractionallySizedBox(
                          widthFactor: .25,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 6.0,
                              vertical: 5.0,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: const Color.fromARGB(255, 95, 10, 38)
                                    .withOpacity(0.8)),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child: GestureDetector(
                            onTap: () {
                              setState(() {
                                alignment = AlignedTo.all;
                              });
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .assessments_all,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color:
                                              (StorageService.getAppThemeId() ==
                                                          false &&
                                                      alignment ==
                                                          AlignedTo.all)
                                                  ? Colors.white
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary),
                                    ),
                                    Text(
                                      ' (' +
                                          buildingAssessments.length
                                              .toString() +
                                          ")",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color:
                                              (StorageService.getAppThemeId() ==
                                                          false &&
                                                      alignment ==
                                                          AlignedTo.all)
                                                  ? Colors.white
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary,
                                          fontSize: 13.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                          Expanded(
                              child: GestureDetector(
                            onTap: () {
                              setState(() {
                                alignment = AlignedTo.draft;
                              });
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .assessments_drafts,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color:
                                              (StorageService.getAppThemeId() ==
                                                          false &&
                                                      alignment ==
                                                          AlignedTo.draft)
                                                  ? Colors.white
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary),
                                    ),
                                    Text(
                                      ' (' +
                                          countDraftAssessments.toString() +
                                          ')',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color:
                                              (StorageService.getAppThemeId() ==
                                                          false &&
                                                      alignment ==
                                                          AlignedTo.draft)
                                                  ? Colors.white
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary,
                                          fontSize: 13.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                          Expanded(
                              child: GestureDetector(
                            onTap: () {
                              setState(() {
                                alignment = AlignedTo.finialized;
                              });
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .assessments_finalized,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color:
                                              (StorageService.getAppThemeId() ==
                                                          false &&
                                                      alignment ==
                                                          AlignedTo.finialized)
                                                  ? Colors.white
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary),
                                    ),
                                    Text(
                                      ' (' +
                                          countFinalizedAssessments.toString() +
                                          ')',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color:
                                              (StorageService.getAppThemeId() ==
                                                          false &&
                                                      alignment ==
                                                          AlignedTo.finialized)
                                                  ? Colors.white
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary,
                                          fontSize: 12.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                          Expanded(
                              child: GestureDetector(
                            onTap: () {
                              setState(() {
                                alignment = AlignedTo.synced;
                              });
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .assessments_synced,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color:
                                              (StorageService.getAppThemeId() ==
                                                          false &&
                                                      alignment ==
                                                          AlignedTo.synced)
                                                  ? Colors.white
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary),
                                    ),
                                    Text(
                                      ' (' +
                                          countSyncedAssessments.toString() +
                                          ')',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color:
                                              (StorageService.getAppThemeId() ==
                                                          false &&
                                                      alignment ==
                                                          AlignedTo.synced)
                                                  ? Colors.white
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary,
                                          fontSize: 12.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Alignment getCorrectContainerAlignment() {
    switch (alignment) {
      case AlignedTo.all:
        return const Alignment(-1, 0);
      case AlignedTo.draft:
        return const Alignment(-0.35, 0);
      case AlignedTo.finialized:
        return const Alignment(0.33, 0);
      case AlignedTo.synced:
        return const Alignment(0.99, 0);
      default:
        return const Alignment(-1, 0);
    }
  }
}

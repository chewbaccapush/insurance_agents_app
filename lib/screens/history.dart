import 'dart:async';
import 'dart:ffi';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:msg/models/Measurement/measurement.dart';
import 'package:msg/services/connectivity_cheker.dart';
import 'package:msg/services/navigator_service.dart';
import 'package:msg/services/storage_service.dart';
import 'package:msg/widgets/alert.dart';
import 'package:msg/screens/building_assessment_form.dart';
import 'package:msg/screens/settings.dart';
import 'package:msg/widgets/building_assessment_tile.dart';
import 'package:msg/widgets/building_part_tile.dart';
import 'package:msg/widgets/filter_assessments.dart';

import 'package:msg/widgets/measurement_tile.dart';
import 'package:msg/widgets/routing_button.dart';
import 'package:msg/widgets/search_bar.dart';

import 'package:intl/intl.dart';
import 'package:connectivity/connectivity.dart';

import '../models/BuildingAssessment/building_assessment.dart';
import '../models/BuildingPart/building_part.dart';
import '../models/Database/database_helper.dart';
import '../services/sqs_sender.dart';
import '../services/state_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum AlignedTo { all, sent, queue }

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<BuildingAssessment> buildingAssessments = [];

  List<BuildingAssessment> searchResults = [];
  List<BuildingAssessment> sentAssessments = [];
  List<BuildingAssessment> unsentAssessments = [];
  TextEditingController textController = TextEditingController();
  final SQSSender sqsSender = SQSSender();
  int numberOfUnsent = 0;
  AlignedTo alignment = AlignedTo.all;
  int countSentAssessments = 0;
  int allAssessments = 0;
  bool _isExpanded = false;
  bool hasConnection = false;
  late StreamSubscription subscription;

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
      const SnackBar(content: Text('Sending..')),
    );
    debugPrint("Sending");
    List<BuildingAssessment> unsentAssessments = [];
    int numOfUnsent = 0;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    List unsent = await iterateAssessments();
    print("UNSENT:" + unsent[0].toString());
    print(unsentAssessments.length);

    if (unsent[0] != 0) {
      if (unsent[1].length == 0) {
        if (unsent[0] == 1) {
          showDialogPopup("Info", "Assessments successfully sent");
        } else {
          showDialogPopup(
              "Info", "All ${unsent[0]} assessments successfully sent");
        }
      } else {
        showDialogPopup(
            "Alert", "${unsent[1].length} assessment has not been sent!");
      }
    }
  }

  // TODO: async
  List iterateAssessments() {
    int numOfUnsent = 0;
    List<BuildingAssessment> unsentAssessments = [];
    buildingAssessments.forEach((element) async {
      if (element.sent == false) {
        numOfUnsent++;
        debugPrint("Sending" + element.id.toString());
        await sqsSender.sendToSQS(element.toMessage().toString()).then((value) {
          print("ok");
          element.sent = true;
          DatabaseHelper.instance.updateAssessment(element);
        }).onError((error, stackTrace) {
          print(error);
          print(stackTrace);
          unsentAssessments.add(element);
        });
      }
    });
    return [numOfUnsent, unsentAssessments];
  }

  // TODO: move to
  void showDialogPopup(String title, String content) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Alert(title: title, content: content);
        });
  }

  void filterBuildingAssessments() {
    for (var assessment in buildingAssessments) {
      if (assessment.sent == true) {
        sentAssessments.add(assessment);
      } else if (assessment.sent == false) {
        unsentAssessments.add(assessment);
      }
    }

    setState(() {});
  }

  _localGet() async {
    await DatabaseHelper.instance
        .readAllAssessments()
        .then((value) => buildingAssessments = value.reversed.toList());

    countSentAssessments =
        buildingAssessments.where((c) => c.sent == true).length;
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
      if (assessment.description!.contains(text) ||
          assessment.assessmentCause!.contains(text) ||
          assessment.appointmentDate.toString().contains(text)) {
        searchResults.add(assessment);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double cWidth = MediaQuery.of(context).size.width * 0.5;
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.only(top: 50, right: 50, left: 50),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      searchBar(cWidth),
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
                          width: 300,
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
                                                    ? Color.fromARGB(
                                                        220, 112, 14, 46)
                                                    : Color.fromARGB(
                                                        148, 112, 14, 46),
                                              ),
                                              onPressed: hasConnection
                                                  ? () => synchronize()
                                                  : null,
                                              label: Text(
                                                  AppLocalizations.of(context)!
                                                      .assessments_sendButton,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white))),
                                        )
                                      ],
                                    )))))
                  ],
                ),
                if (searchResults.isNotEmpty ||
                    textController.text.isNotEmpty) ...[
                  buildView(searchResults),
                ] else if (alignment == AlignedTo.sent &&
                    (searchResults.isEmpty || textController.text.isEmpty)) ...[
                  buildView(sentAssessments),
                ] else if (alignment == AlignedTo.queue &&
                    (searchResults.isEmpty || textController.text.isEmpty)) ...[
                  buildView(unsentAssessments)
                ] else ...[
                  buildView(buildingAssessments)
                ]
              ],
            )));
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
            //color: Color.fromARGB(121, 154, 56, 91),
            //color: Color.fromARGB(124, 90, 17, 43),
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
                          widthFactor: .33,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 6.0,
                              vertical: 5.0,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Color.fromARGB(255, 95, 10, 38)
                                    .withOpacity(0.8)),
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: GestureDetector(
                            onTap: () {
                              setState(() {
                                alignment = AlignedTo.all;
                              });
                            },
                            child: Container(
                              // DON'T REMOVE THIS CONTAINER! HIT TARGET IS ONLY TEXT WITHOUT IT
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
                                      '(' +
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
                                alignment = AlignedTo.sent;
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
                                          .assessments_sent,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color:
                                              (StorageService.getAppThemeId() ==
                                                          false &&
                                                      alignment ==
                                                          AlignedTo.sent)
                                                  ? Colors.white
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary),
                                    ),
                                    Text(
                                      '(' +
                                          sentAssessments.length.toString() +
                                          ')',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color:
                                              (StorageService.getAppThemeId() ==
                                                          false &&
                                                      alignment ==
                                                          AlignedTo.sent)
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
                                alignment = AlignedTo.queue;
                              });
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Center(
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 18),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .assessments_queue,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: (StorageService
                                                            .getAppThemeId() ==
                                                        false &&
                                                    alignment ==
                                                        AlignedTo.queue)
                                                ? Colors.white
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary),
                                      ),
                                    ),
                                    Text(
                                      '(' +
                                          (buildingAssessments.length -
                                                  countSentAssessments)
                                              .toString() +
                                          ')',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color:
                                              (StorageService.getAppThemeId() ==
                                                          false &&
                                                      alignment ==
                                                          AlignedTo.queue)
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
        return Alignment.centerLeft;
      case AlignedTo.sent:
        return Alignment.center;
      case AlignedTo.queue:
        return Alignment.centerRight;
      default:
        return Alignment.centerLeft;
    }
  }
}

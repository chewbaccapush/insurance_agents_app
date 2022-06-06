import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:msg/screens/building_assessment_form.dart';
import 'package:msg/services/navigator_service.dart';

import '../models/BuildingAssessment/building_assessment.dart';
import '../services/state_service.dart';
import '../services/storage_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BuildingAssessmentTile extends StatefulWidget {
  final BuildContext context;
  final BuildingAssessment? entry;
  final List<Widget>? buildingParts;
  final dynamic onDelete;

  const BuildingAssessmentTile(
      {Key? key,
      required this.context,
      this.entry,
      this.buildingParts,
      required this.onDelete})
      : super(key: key);

  @override
  State<BuildingAssessmentTile> createState() => _BuildingAssessmentTileState();
}

class _BuildingAssessmentTileState extends State<BuildingAssessmentTile> {
  bool _isExpanded = false;
  String languageCode = StorageService.getLocale()!.languageCode;

  // Creates icon for sent/unsent
  Icon getIcon() {
    if (widget.entry!.finalized == false) {
      return const Icon(Icons.access_time_outlined,
          size: 32, color: Color.fromARGB(255, 197, 179, 24));
    } else {
      if (widget.entry!.sent == true) {
        return const Icon(Icons.sync, size: 32, color: Colors.green);
      } else {
        return const Icon(Icons.sync, size: 32, color: Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
        position: 1,
        duration: const Duration(milliseconds: 100),
        child: FadeInAnimation(
            child: SlideAnimation(
                verticalOffset: 35.0,
                curve: Curves.easeOutCubic,
                duration: const Duration(milliseconds: 300),
                child: ScaleAnimation(
                    scale: .9,
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Theme.of(widget.context).colorScheme.primary,
                        ),
                        margin: const EdgeInsets.only(bottom: 30.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 30, bottom: 0, left: 35, right: 25),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          getIcon(),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              DateFormat('dd.MM.yyyy',
                                                      languageCode)
                                                  .format(widget.entry!
                                                          .appointmentDate
                                                      as DateTime),
                                              style: Theme.of(widget.context)
                                                  .textTheme
                                                  .headline1,
                                            ),
                                          ),
                                        ],
                                      ),
                                      widget.entry!.finalized == false
                                          ? Row(
                                              children: [
                                                ElevatedButton(
                                                  child: const Icon(Icons.edit,
                                                      size: 18,
                                                      color: Colors.white),
                                                  onPressed: () => {
                                                    StateService
                                                            .buildingAssessment =
                                                        widget.entry!,
                                                    NavigatorService.navigateTo(
                                                        context,
                                                        const BuildingAssessmentForm())
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape: const CircleBorder(),
                                                    primary: (StorageService
                                                                .getAppThemeId() ==
                                                            false)
                                                        ? const Color.fromARGB(
                                                            220, 112, 14, 46)
                                                        : const Color.fromARGB(
                                                            148, 112, 14, 46),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  child: const Icon(
                                                      Icons.delete,
                                                      size: 18,
                                                      color: Colors.white),
                                                  onPressed: widget.onDelete,
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape: const CircleBorder(),
                                                    primary: (StorageService
                                                                .getAppThemeId() ==
                                                            false)
                                                        ? const Color.fromARGB(
                                                            220, 112, 14, 46)
                                                        : const Color.fromARGB(
                                                            148, 112, 14, 46),
                                                  ),
                                                )
                                              ],
                                            )
                                          : Container(),
                                    ]),
                              ),
                              IntrinsicHeight(
                                child: Row(children: [
                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, left: 40),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10.0),
                                                    child: Text(
                                                      AppLocalizations.of(
                                                                  context)!
                                                              .buildingAssessment_appointmentDate +
                                                          ":",
                                                      style: Theme.of(
                                                              widget.context)
                                                          .textTheme
                                                          .bodyText2,
                                                    ),
                                                  ),
                                                  Text(
                                                      DateFormat('dd.MM.yyyy',
                                                              languageCode)
                                                          .format(widget.entry!
                                                                  .appointmentDate
                                                              as DateTime),
                                                      style: Theme.of(
                                                              widget.context)
                                                          .textTheme
                                                          .bodyText1)
                                                ],
                                              )),
                                          widget.entry!.numOfAppartments
                                                      .toString() !=
                                                  "null"
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 15, left: 40),
                                                  child: Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 10.0),
                                                        child: Text(
                                                          AppLocalizations.of(
                                                                      context)!
                                                                  .buildingAssessment_numberOFApartaments +
                                                              ":",
                                                          style: Theme.of(widget
                                                                  .context)
                                                              .textTheme
                                                              .bodyText2,
                                                        ),
                                                      ),
                                                      Text(
                                                          widget.entry!
                                                                      .numOfAppartments
                                                                      .toString() ==
                                                                  "null"
                                                              ? ""
                                                              : widget.entry!
                                                                  .numOfAppartments
                                                                  .toString(),
                                                          style: Theme.of(widget
                                                                  .context)
                                                              .textTheme
                                                              .bodyText1)
                                                    ],
                                                  ))
                                              : Container(),
                                          widget.entry!.voluntaryDeduction
                                                      .toString() !=
                                                  "null"
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 15, left: 40),
                                                  child: Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 10.0),
                                                        child: Text(
                                                          AppLocalizations.of(
                                                                      context)!
                                                                  .buildingAssessment_voulentaryDeduction +
                                                              ":",
                                                          style: Theme.of(widget
                                                                  .context)
                                                              .textTheme
                                                              .bodyText2,
                                                        ),
                                                      ),
                                                      Text(
                                                          widget.entry!
                                                                  .voluntaryDeduction!
                                                                  .toStringAsFixed(
                                                                      0) +
                                                              " %",
                                                          style: Theme.of(widget
                                                                  .context)
                                                              .textTheme
                                                              .bodyText1)
                                                    ],
                                                  ))
                                              : Container(),
                                          widget.entry!.assessmentFee
                                                      .toString() !=
                                                  "null"
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 15, left: 40),
                                                  child: Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 10.0),
                                                        child: Text(
                                                          AppLocalizations.of(
                                                                      context)!
                                                                  .buildingAssessment_assessmentFee +
                                                              ":",
                                                          style: Theme.of(widget
                                                                  .context)
                                                              .textTheme
                                                              .bodyText2,
                                                        ),
                                                      ),
                                                      Text(
                                                          widget.entry!
                                                                  .assessmentFee!
                                                                  .toStringAsFixed(
                                                                      0) +
                                                              " \u20A3",
                                                          style: Theme.of(widget
                                                                  .context)
                                                              .textTheme
                                                              .bodyText1)
                                                    ],
                                                  ))
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Container(
                                        margin: const EdgeInsets.only(
                                            top: 20, right: 30),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              widget.entry!.description
                                                          .toString() !=
                                                      "null"
                                                  ? Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 15.0),
                                                          child: Row(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            10.0),
                                                                child: Text(
                                                                  AppLocalizations.of(
                                                                              context)!
                                                                          .description +
                                                                      ":",
                                                                  style: Theme.of(
                                                                          widget
                                                                              .context)
                                                                      .textTheme
                                                                      .bodyText2,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Flexible(
                                                              child: Text(
                                                                  widget.entry!
                                                                      .description
                                                                      .toString(),
                                                                  style: Theme.of(
                                                                          widget
                                                                              .context)
                                                                      .textTheme
                                                                      .bodyText1),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                  : Container(),
                                            ])),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 20, right: 100),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          widget.entry!.assessmentCause
                                                      .toString() !=
                                                  "null"
                                              ? Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 15.0),
                                                      child: Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right:
                                                                        10.0),
                                                            child: Text(
                                                              AppLocalizations.of(
                                                                          context)!
                                                                      .buildingAssessment_assessmentCause +
                                                                  ":",
                                                              style: Theme.of(
                                                                      widget
                                                                          .context)
                                                                  .textTheme
                                                                  .bodyText2,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                              widget.entry!
                                                                  .assessmentCause
                                                                  .toString(),
                                                              style: Theme.of(
                                                                      widget
                                                                          .context)
                                                                  .textTheme
                                                                  .bodyText1),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                              widget.buildingParts!.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 25,
                                          top: 0,
                                          left: 25,
                                          right: 25),
                                      child: Theme(
                                          data: ThemeData().copyWith(
                                              dividerColor: Color.fromARGB(
                                                  0, 246, 0, 0)),
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
                                                  duration: Duration(
                                                      milliseconds: 400),
                                                  child: Icon(Icons.expand_circle_down_outlined,
                                                      size: 30,
                                                      color: (StorageService
                                                                  .getAppThemeId() ==
                                                              false)
                                                          ? const Color.fromARGB(
                                                              148, 112, 14, 46)
                                                          : Theme.of(context)
                                                              .colorScheme
                                                              .onPrimary)),
                                              title: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10.0),
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .assessments_buildingParts,
                                                  style:
                                                      Theme.of(widget.context)
                                                          .textTheme
                                                          .headline2,
                                                ),
                                              ),
                                              children: widget.buildingParts
                                                  as List<Widget>)))
                                  : Container(
                                      margin: EdgeInsets.only(bottom: 40),
                                    )
                            ]))))));
  }
}

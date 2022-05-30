// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:msg/screens/building_assessment_form.dart';
import 'package:msg/services/theme_provider.dart';

import '../models/BuildingAssessment/building_assessment.dart';

class BuildingAssessmentTile extends StatefulWidget {
  final BuildContext context;
  final BuildingAssessment? entry;
  final List<Widget>? buildingParts;

  const BuildingAssessmentTile({
    Key? key,
    required this.context,
    this.entry,
    this.buildingParts,
  }) : super(key: key);

  @override
  State<BuildingAssessmentTile> createState() => _BuildingAssessmentTileState();
}

class _BuildingAssessmentTileState extends State<BuildingAssessmentTile> {
  bool _isExpanded = false;

  // Creates icon for sent/unsent
  Icon getIcon() {
    if (widget.entry!.sent == true) {
      return const Icon(Icons.check_circle_rounded,
          size: 32, color: Colors.green);
    } else {
      return const Icon(Icons.access_time_outlined,
          size: 32, color: Color.fromARGB(255, 197, 179, 24));
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
                                child: Row(children: [
                                  getIcon(),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      DateFormat.MMMMEEEEd().format(widget
                                          .entry!.appointmentDate as DateTime),
                                      style: Theme.of(widget.context)
                                          .textTheme
                                          .headline1,
                                    ),
                                  ),
                                  Spacer(),
                                  ElevatedButton(
                                    child: Icon(Icons.edit,
                                        size: 18, color: Colors.white),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            BuildingAssessmentForm(
                                          buildingAssessment: widget.entry,
                                        ),
                                      ));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        shape: CircleBorder(),
                                        primary: const Color.fromARGB(
                                            148, 112, 14, 46)),
                                  ),
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
                                                  Text(
                                                    'Appointment Date:    ',
                                                    style:
                                                        Theme.of(widget.context)
                                                            .textTheme
                                                            .bodyText1,
                                                  ),
                                                  Text(
                                                      DateFormat.yMMMMd()
                                                          .format(widget.entry!
                                                                  .appointmentDate
                                                              as DateTime),
                                                      style: Theme.of(
                                                              widget.context)
                                                          .textTheme
                                                          .bodyText2)
                                                ],
                                              )),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15, left: 40),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Number of Apartments:    ',
                                                    style:
                                                        Theme.of(widget.context)
                                                            .textTheme
                                                            .bodyText1,
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
                                                      style: Theme.of(
                                                              widget.context)
                                                          .textTheme
                                                          .bodyText2)
                                                ],
                                              )),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15, left: 40),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Voluntary Deduction:    ',
                                                    style:
                                                        Theme.of(widget.context)
                                                            .textTheme
                                                            .bodyText1,
                                                  ),
                                                  Text(
                                                      widget.entry!
                                                              .voluntaryDeduction
                                                              .toString() +
                                                          " %",
                                                      style: Theme.of(
                                                              widget.context)
                                                          .textTheme
                                                          .bodyText2)
                                                ],
                                              )),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15, left: 40),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Assessment Fee:    ',
                                                    style:
                                                        Theme.of(widget.context)
                                                            .textTheme
                                                            .bodyText1,
                                                  ),
                                                  Text(
                                                      widget.entry!
                                                              .assessmentFee
                                                              .toString() +
                                                          " €",
                                                      style: Theme.of(
                                                              widget.context)
                                                          .textTheme
                                                          .bodyText2)
                                                ],
                                              )),
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
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 15.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'Description:    ',
                                                          style: Theme.of(widget
                                                                  .context)
                                                              .textTheme
                                                              .bodyText1,
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
                                                            //'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s.',
                                                            style: Theme.of(
                                                                    widget
                                                                        .context)
                                                                .textTheme
                                                                .bodyText2),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
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
                                          Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 15.0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Assessment Cause:    ',
                                                      style: Theme.of(
                                                              widget.context)
                                                          .textTheme
                                                          .bodyText1,
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
                                                        //'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s.',
                                                        style: Theme.of(
                                                                widget.context)
                                                            .textTheme
                                                            .bodyText2),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 25, top: 0, left: 25, right: 25),
                                  child: Theme(
                                      data: ThemeData().copyWith(
                                          dividerColor:
                                              Color.fromARGB(0, 246, 0, 0)),
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
                                              duration:
                                                  Duration(milliseconds: 400),
                                              child: Icon(
                                                  Icons
                                                      .expand_circle_down_outlined,
                                                  size: 30,
                                                  color: Colors.white)),
                                          title: Text(
                                            'Building parts',
                                            style: Theme.of(widget.context)
                                                .textTheme
                                                .headline2,
                                          ),
                                          children: widget.buildingParts
                                              as List<Widget>)))
                            ]))))));
  }
}

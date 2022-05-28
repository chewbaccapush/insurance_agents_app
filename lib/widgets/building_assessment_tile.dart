import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/BuildingAssessment/building_assessment.dart';

class BuildingAssessmentTile extends StatefulWidget {
  final BuildContext context;
  final BuildingAssessment? entry;
  final List<Widget>? buildingParts;

  const BuildingAssessmentTile(
      {Key? key, required this.context, this.entry, this.buildingParts})
      : super(key: key);

  @override
  State<BuildingAssessmentTile> createState() => _BuildingAssessmentTileState();
}

class _BuildingAssessmentTileState extends State<BuildingAssessmentTile> {
  bool _isExpanded = false;

  // Creates icon for sent/unsent
  Icon getIcon() {
    if (widget.entry!.sent == true) {
      return const Icon(Icons.check_circle_rounded,
          size: 40, color: Colors.green);
    } else {
      return const Icon(Icons.schedule_rounded,
          size: 40, color: Color.fromARGB(224, 212, 194, 29));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Theme.of(widget.context).colorScheme.primary),
        margin: const EdgeInsets.only(bottom: 30.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 30, bottom: 0, left: 35, right: 40),
            child: Row(children: [
              getIcon(),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  DateFormat.yMMMd()
                      .format(widget.entry!.appointmentDate as DateTime),
                  style: Theme.of(widget.context).textTheme.headline1,
                ),
              )
            ]),
          ),
          IntrinsicHeight(
            child: Row(children: [
              Expanded(
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 10, left: 40),
                          child: Row(
                            children: [
                              Text(
                                'Appointment Date:    ',
                                style: Theme.of(widget.context)
                                    .textTheme
                                    .bodyText1,
                              ),
                              Text(
                                  DateFormat.yMMMMd().format(widget
                                      .entry!.appointmentDate as DateTime),
                                  style: Theme.of(widget.context)
                                      .textTheme
                                      .bodyText2)
                            ],
                          )),
                      Padding(
                          padding: const EdgeInsets.only(top: 15, left: 40),
                          child: Row(
                            children: [
                              Text(
                                'Number of Apartments:    ',
                                style: Theme.of(widget.context)
                                    .textTheme
                                    .bodyText1,
                              ),
                              Text(widget.entry!.numOfAppartments.toString(),
                                  style: Theme.of(widget.context)
                                      .textTheme
                                      .bodyText2)
                            ],
                          )),
                      Padding(
                          padding: const EdgeInsets.only(top: 15, left: 40),
                          child: Row(
                            children: [
                              Text(
                                'Voluntary Deduction:    ',
                                style: Theme.of(widget.context)
                                    .textTheme
                                    .bodyText1,
                              ),
                              Text(
                                  widget.entry!.voluntaryDeduction.toString() +
                                      " %",
                                  style: Theme.of(widget.context)
                                      .textTheme
                                      .bodyText2)
                            ],
                          )),
                      Padding(
                          padding: const EdgeInsets.only(top: 15, left: 40),
                          child: Row(
                            children: [
                              Text(
                                'Assessment Fee:    ',
                                style: Theme.of(widget.context)
                                    .textTheme
                                    .bodyText1,
                              ),
                              Text(
                                  widget.entry!.assessmentFee.toString() + " €",
                                  style: Theme.of(widget.context)
                                      .textTheme
                                      .bodyText2)
                            ],
                          )),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                    margin: const EdgeInsets.only(top: 20, right: 30),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Description:    ',
                                      style: Theme.of(widget.context)
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
                                        widget.entry!.description.toString(),
                                        //'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s.',
                                        style: Theme.of(widget.context)
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
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.only(top: 20, right: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Row(
                              children: [
                                Text(
                                  'Assessment Cause:    ',
                                  style: Theme.of(widget.context)
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
                                    widget.entry!.assessmentCause.toString(),
                                    //'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s.',
                                    style: Theme.of(widget.context)
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
                  data: ThemeData()
                      .copyWith(dividerColor: Color.fromARGB(0, 246, 0, 0)),
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
                          duration: Duration(milliseconds: 400),
                          child: const Icon(Icons.expand_circle_down_outlined,
                              size: 30)),
                      title: Text(
                        'Building parts',
                        style: Theme.of(widget.context).textTheme.headline2,
                      ),
                      children: widget.buildingParts as List<Widget>)))
        ]));
  }
}

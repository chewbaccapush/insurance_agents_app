import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/BuildingAssessment/building_assessment.dart';

class BuildingAssessmentTile extends StatefulWidget {
  final BuildingAssessment? entry;
  final List<Widget>? buildingParts;

  const BuildingAssessmentTile({Key? key, this.entry, this.buildingParts})
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
      return const Icon(Icons.error_rounded, size: 40, color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: const Color.fromARGB(148, 135, 18, 57),
        ),
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
                  style: const TextStyle(fontSize: 25),
                ),
              )
            ]),
          ),
          Row(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 10, left: 40),
                    child: Row(
                      children: [
                        const Text(
                          'Appointment Date:    ',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                            DateFormat.yMMMMd().format(
                                widget.entry!.appointmentDate as DateTime),
                            style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 219, 219, 219)))
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 15, left: 40),
                    child: Row(
                      children: [
                        const Text(
                          'Number of Apartments:    ',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(widget.entry!.numOfAppartments.toString(),
                            style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 219, 219, 219)))
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 15, left: 40),
                    child: Row(
                      children: [
                        const Text(
                          'Voluntary Deduction:    ',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(widget.entry!.voluntaryDeduction.toString() + " %",
                            style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 219, 219, 219)))
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 15, left: 40),
                    child: Row(
                      children: [
                        const Text(
                          'Assessment Fee:    ',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(widget.entry!.assessmentFee.toString() + " €",
                            style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 219, 219, 219)))
                      ],
                    )),
              ],
            ),
            Padding(
                padding: const EdgeInsets.only(left: 150),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(bottom: 20, top: 25),
                          child: Row(
                            children: [
                              const Text(
                                'Description:    ',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(widget.entry!.description.toString(),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color:
                                          Color.fromARGB(255, 219, 219, 219)))
                            ],
                          )),
                      Padding(
                          padding: const EdgeInsets.only(top: 40, bottom: 50),
                          child: Row(
                            children: [
                              const Text(
                                'Assessment Cause:    ',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(widget.entry!.assessmentCause.toString(),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color:
                                          Color.fromARGB(255, 225, 225, 225)))
                            ],
                          )),
                    ])),
          ]),
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
                      title: const Text(
                        'Building parts',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                      children: widget.buildingParts as List<Widget>)))
        ]));
  }
}

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:msg/models/Measurement/measurement.dart';

import '../models/BuildingPart/building_part.dart';

class BuildingPartTile extends StatefulWidget {
  final BuildingPart? entry;
  final List<Widget>? measurements;

  const BuildingPartTile({Key? key, this.entry, this.measurements})
      : super(key: key);

  @override
  State<BuildingPartTile> createState() => _BuildingPartTileState();
}

class _BuildingPartTileState extends State<BuildingPartTile> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                  padding: const EdgeInsets.only(
                      top: 35, bottom: 5, left: 30, right: 20),
                  child: Row(
                    children: [
                      const Text(
                        'Building Year:    ',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(widget.entry!.buildingYear.toString(),
                          style: const TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 219, 219, 219)))
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 5, left: 30, right: 20),
                  child: Row(
                    children: [
                      const Text(
                        'Fire Protection:    ',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                          EnumToString.convertToString(
                              widget.entry!.fireProtection),
                          style: const TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 219, 219, 219)))
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 5, left: 30, right: 20),
                  child: Row(
                    children: [
                      const Text(
                        'Construction Class:    ',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                          EnumToString.convertToString(
                              widget.entry!.constructionClass),
                          style: const TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 219, 219, 219)))
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 5, left: 30, right: 20),
                  child: Row(
                    children: [
                      const Text(
                        'Risk Class:    ',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                          EnumToString.convertToString(widget.entry!.riskClass),
                          style: const TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 219, 219, 219)))
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 5, left: 30, right: 20),
                  child: Row(
                    children: [
                      const Text(
                        'Unit Price:    ',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(widget.entry!.unitPrice.toString() + ' €',
                          style: const TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 219, 219, 219)))
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 5, left: 30, right: 20),
                  child: Row(
                    children: [
                      const Text(
                        'Insured Type:    ',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                          EnumToString.convertToString(
                              widget.entry!.insuredType),
                          style: const TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 219, 219, 219)))
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 30, left: 30, right: 20),
                  child: Row(
                    children: [
                      const Text(
                        'Devaluation Percentage:    ',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                          widget.entry!.devaluationPercentage.toString() + ' %',
                          style: const TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 219, 219, 219)))
                    ],
                  )),
            ]),
            Expanded(
                child: Container(
                    margin: const EdgeInsets.only(left: 80),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 35, bottom: 105, left: 20, right: 20),
                            child: Row(
                              children: [
                                const Text(
                                  'Description:    ',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(widget.entry!.description.toString(),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 219, 219, 219)))
                              ],
                            )),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 5, bottom: 5, left: 20, right: 20),
                            child: Row(
                              children: [
                                const Text(
                                  'Cubature:    ',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(widget.entry!.cubature.toString(),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 219, 219, 219)))
                              ],
                            )),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 5, bottom: 5, left: 20, right: 20),
                            child: Row(
                              children: [
                                const Text(
                                  'Value:    ',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(widget.entry!.value.toString(),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 219, 219, 219)))
                              ],
                            )),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 5, bottom: 5, left: 20, right: 20),
                            child: Row(
                              children: [
                                const Text(
                                  'Sum Insured:    ',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(widget.entry!.sumInsured.toString(),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 219, 219, 219)))
                              ],
                            )),
                      ],
                    )))
          ]),
        ),
        Padding(
            padding: const EdgeInsets.only(bottom: 30, left: 15, right: 30),
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
                        child: Icon(Icons.expand_circle_down_outlined)),
                    title: const Text(
                      'Measurements',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    children: widget.measurements!))),
      ],
    );
  }
}

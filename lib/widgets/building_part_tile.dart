import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';

import '../models/BuildingPart/building_part.dart';

class BuildingPartTile extends StatefulWidget {
  final BuildContext context;
  final BuildingPart? entry;
  final List<Widget>? measurements;

  const BuildingPartTile(
      {Key? key, required this.context, this.entry, this.measurements})
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
                      Text(
                        'Building Year:    ',
                        style: Theme.of(widget.context).textTheme.bodyText1,
                      ),
                      Text(widget.entry!.buildingYear.toString(),
                          style: Theme.of(widget.context).textTheme.bodyText2)
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 5, left: 30, right: 20),
                  child: Row(
                    children: [
                      Text(
                        'Fire Protection:    ',
                        style: Theme.of(widget.context).textTheme.bodyText1,
                      ),
                      Text(
                          EnumToString.convertToString(
                              widget.entry!.fireProtection),
                          style: Theme.of(widget.context).textTheme.bodyText2)
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 5, left: 30, right: 20),
                  child: Row(
                    children: [
                      Text(
                        'Construction Class:    ',
                        style: Theme.of(widget.context).textTheme.bodyText1,
                      ),
                      Text(
                          EnumToString.convertToString(
                              widget.entry!.constructionClass),
                          style: Theme.of(widget.context).textTheme.bodyText2)
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 5, left: 30, right: 20),
                  child: Row(
                    children: [
                      Text(
                        'Risk Class:    ',
                        style: Theme.of(widget.context).textTheme.bodyText1,
                      ),
                      Text(
                          EnumToString.convertToString(widget.entry!.riskClass),
                          style: Theme.of(widget.context).textTheme.bodyText2)
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 5, left: 30, right: 20),
                  child: Row(
                    children: [
                      Text(
                        'Unit Price:    ',
                        style: Theme.of(widget.context).textTheme.bodyText1,
                      ),
                      Text(widget.entry!.unitPrice.toString() + ' €',
                          style: Theme.of(widget.context).textTheme.bodyText2)
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 5, left: 30, right: 20),
                  child: Row(
                    children: [
                      Text(
                        'Insured Type:    ',
                        style: Theme.of(widget.context).textTheme.bodyText1,
                      ),
                      Text(
                          EnumToString.convertToString(
                              widget.entry!.insuredType),
                          style: Theme.of(widget.context).textTheme.bodyText2)
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 30, left: 30, right: 20),
                  child: Row(
                    children: [
                      Text(
                        'Devaluation Percentage:    ',
                        style: Theme.of(widget.context).textTheme.bodyText1,
                      ),
                      Text(
                          widget.entry!.devaluationPercentage.toString() + ' %',
                          style: Theme.of(widget.context).textTheme.bodyText2)
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
                                top: 35, bottom: 95, left: 20, right: 20),
                            child: Row(
                              children: [
                                Text(
                                  'Description:    ',
                                  style: Theme.of(widget.context)
                                      .textTheme
                                      .bodyText1,
                                ),
                                Text(widget.entry!.description.toString(),
                                    style: Theme.of(widget.context)
                                        .textTheme
                                        .bodyText2)
                              ],
                            )),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 5, bottom: 5, left: 20, right: 20),
                            child: Row(
                              children: [
                                Text(
                                  'Cubature:    ',
                                  style: Theme.of(widget.context)
                                      .textTheme
                                      .bodyText1,
                                ),
                                Text(widget.entry!.cubature.toString(),
                                    style: Theme.of(widget.context)
                                        .textTheme
                                        .bodyText2)
                              ],
                            )),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 5, bottom: 5, left: 20, right: 20),
                            child: Row(
                              children: [
                                Text(
                                  'Value:    ',
                                  style: Theme.of(widget.context)
                                      .textTheme
                                      .bodyText1,
                                ),
                                Text(widget.entry!.value.toString(),
                                    style: Theme.of(widget.context)
                                        .textTheme
                                        .bodyText2)
                              ],
                            )),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 5, bottom: 0, left: 20, right: 20),
                            child: Row(
                              children: [
                                Text(
                                  'Sum Insured:    ',
                                  style: Theme.of(widget.context)
                                      .textTheme
                                      .bodyText1,
                                ),
                                Text(widget.entry!.sumInsured.toString(),
                                    style: Theme.of(widget.context)
                                        .textTheme
                                        .bodyText2)
                              ],
                            )),
                      ],
                    )))
          ]),
        ),
        Padding(
            padding: const EdgeInsets.only(bottom: 15, left: 15, right: 30),
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
                        child:
                            Icon(Icons.expand_circle_down_outlined, size: 30)),
                    title: Text(
                      'Measurements',
                      style: Theme.of(widget.context).textTheme.headline3,
                    ),
                    children: widget.measurements!))),
      ],
    );
  }
}

import 'package:aws_sqs_api/sqs-2012-11-05.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:msg/models/Measurement/measurement.dart';
import 'package:msg/widgets/search_bar.dart';

import '../models/BuildingAssessment/building_assessment.dart';
import '../models/BuildingPart/building_part.dart';
import '../models/Database/database_helper.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<BuildingAssessment> buildingAssessments = [];
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    _localGet();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Get orders from users local storage
  _localGet() async {
    buildingAssessments = await DatabaseHelper.instance.readAllAssessments();
    print(buildingAssessments);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.5;
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.only(top: 40, right: 50, left: 50),
            child: Column(
              children: [
                Row(
                  children: [
                    AnimSearchBar(
                      helpText: 'Search',
                      color: Colors.grey[600],
                      width: c_width,
                      textController: textController,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: const Icon(Icons.close),
                      onSuffixTap: () {
                        setState(() {
                          textController.clear();
                        });
                      },
                    )
                  ],
                ),
                buildView(),
              ],
            )));
  }

  Widget buildView() {
    return Expanded(
        child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: buildingAssessments.length,
            itemBuilder: (context, position) {
              return buildTile(buildingAssessments[position]);
            }));
  }

  Widget buildTile(BuildingAssessment entry) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: const Color.fromARGB(150, 132, 20, 57),
        ),
        margin: const EdgeInsets.only(bottom: 30.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: const [
              Padding(
                padding:
                    EdgeInsets.only(top: 35, bottom: 10, left: 40, right: 40),
                child: Text(
                  'Building Assessment',
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ],
          ),
          Row(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 15, left: 40),
                    child: Row(
                      children: [
                        const Text(
                          'Appointment Date:    ',
                          style: TextStyle(fontSize: 22),
                        ),
                        Text(entry.appointmentDate.toString().substring(0, 10),
                            style: const TextStyle(fontSize: 20))
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 15, left: 40),
                    child: Row(
                      children: [
                        const Text(
                          'Number of Apartments:    ',
                          style: TextStyle(fontSize: 22),
                        ),
                        Text(entry.numOfAppartments.toString(),
                            style: const TextStyle(fontSize: 20))
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 15, left: 40),
                    child: Row(
                      children: [
                        const Text(
                          'Voluntary Deduction:    ',
                          style: TextStyle(fontSize: 22),
                        ),
                        Text(entry.voluntaryDeduction.toString() + " %",
                            style: const TextStyle(fontSize: 20))
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 15, left: 40),
                    child: Row(
                      children: [
                        const Text(
                          'Assessment Fee:    ',
                          style: TextStyle(fontSize: 22),
                        ),
                        Text(entry.assessmentFee.toString() + " €",
                            style: const TextStyle(fontSize: 20))
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
                          padding: const EdgeInsets.only(bottom: 20, top: 40),
                          child: Row(
                            children: [
                              const Text(
                                'Description:    ',
                                style: TextStyle(fontSize: 22),
                              ),
                              Text(entry.description.toString(),
                                  style: const TextStyle(fontSize: 20))
                            ],
                          )),
                      Padding(
                          padding: const EdgeInsets.only(top: 40, bottom: 65),
                          child: Row(
                            children: [
                              const Text(
                                'Assessment Cause:    ',
                                style: TextStyle(fontSize: 22),
                              ),
                              Text(entry.assessmentCause.toString(),
                                  style: const TextStyle(fontSize: 20))
                            ],
                          )),
                    ])),
          ]),
          Padding(
              padding: const EdgeInsets.only(
                  bottom: 25, top: 10, left: 25, right: 25),
              child: Theme(
                  data: ThemeData()
                      .copyWith(dividerColor: Color.fromARGB(0, 246, 0, 0)),
                  child: ExpansionTile(
                      collapsedIconColor: Colors.white,
                      iconColor: Colors.white,
                      textColor: Colors.white,
                      title: const Text(
                        'Building parts',
                        style: TextStyle(fontSize: 28, color: Colors.white),
                      ),
                      children: _getBuildingParts(entry))))
        ]));
  }

  List<Widget> _getBuildingParts(BuildingAssessment entry) {
    List<Widget> children = [];
    List<BuildingPart>? parts = entry.buildingParts;

    parts.forEach((element) {
      children.add(Container(
          margin: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color.fromARGB(147, 129, 32, 64),
          ),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [buildingPartTile(element)],
          )));
    });
    return children;
  }

  Widget buildingPartTile(BuildingPart entry) {
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
                      Text(entry.buildingYear.toString(),
                          style: const TextStyle(fontSize: 18))
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
                      Text(EnumToString.convertToString(entry.fireProtection),
                          style: const TextStyle(fontSize: 18))
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
                          EnumToString.convertToString(entry.constructionClass),
                          style: const TextStyle(fontSize: 18))
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
                      Text(EnumToString.convertToString(entry.riskClass),
                          style: const TextStyle(fontSize: 18))
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
                      Text(entry.unitPrice.toString() + ' €',
                          style: const TextStyle(fontSize: 18))
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
                      Text(EnumToString.convertToString(entry.insuredType),
                          style: const TextStyle(fontSize: 18))
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
                      Text(entry.devaluationPercentage.toString() + ' %',
                          style: const TextStyle(fontSize: 18))
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
                                Text(entry.description.toString(),
                                    style: const TextStyle(fontSize: 18))
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
                                Text(entry.cubature.toString(),
                                    style: const TextStyle(fontSize: 18))
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
                                Text(entry.value.toString(),
                                    style: const TextStyle(fontSize: 18))
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
                                Text(entry.sumInsured.toString(),
                                    style: const TextStyle(fontSize: 18))
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
                    collapsedIconColor: Colors.white,
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    title: const Text(
                      'Measurements',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    children: _getMeasurements(entry)))),
      ],
    );
  }
}

List<Widget> _getMeasurements(BuildingPart entry) {
  List<Widget> children = [];
  List<Measurement>? parts = entry.measurements;

  parts.forEach((element) {
    children.add(Container(
        margin: EdgeInsets.only(top: 20, left: 10, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color.fromARGB(124, 90, 17, 43),
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [measurementTile(element)],
        )));
  });
  return children;
}

Widget measurementTile(Measurement entry) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
              flex: 2,
              child: Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 5, left: 20, right: 20),
                        child: Row(
                          children: [
                            const Text(
                              'Length:    ',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(entry.length.toString(),
                                style: const TextStyle(fontSize: 18))
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 5, left: 20, right: 20),
                        child: Row(
                          children: [
                            const Text(
                              'Height:    ',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(entry.height.toString(),
                                style: const TextStyle(fontSize: 18))
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 5, left: 20, right: 20),
                        child: Row(
                          children: [
                            const Text(
                              'Width:    ',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(entry.width.toString(),
                                style: const TextStyle(fontSize: 18))
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 20, left: 20, right: 20),
                        child: Row(
                          children: [
                            const Text(
                              'Radius:    ',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(entry.radius.toString(),
                                style: const TextStyle(fontSize: 18))
                          ],
                        )),
                  ]))),
          Expanded(
              flex: 7,
              child: Container(
                  margin: const EdgeInsets.only(left: 80),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 20, bottom: 105, right: 20),
                          child: Row(
                            children: [
                              const Text(
                                'Description:    ',
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(entry.description.toString(),
                                  style: const TextStyle(fontSize: 18))
                            ],
                          )),
                    ],
                  )))
        ]),
      ),
    ],
  );
}

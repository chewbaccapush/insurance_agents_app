import 'package:flutter/material.dart';
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
            padding: const EdgeInsets.only(top: 50, right: 50, left: 50),
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
                padding: EdgeInsets.symmetric(vertical: 35, horizontal: 40),
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
                    padding: const EdgeInsets.only(top: 10, left: 40),
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
                    padding: const EdgeInsets.only(top: 20, left: 40),
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
                    padding: const EdgeInsets.only(top: 20, left: 40),
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
                    padding: const EdgeInsets.only(top: 20, left: 40),
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
                          padding: const EdgeInsets.only(bottom: 20, top: 15),
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
                          padding: const EdgeInsets.symmetric(vertical: 50),
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
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
              child: ExpansionTile(
                  iconColor: Colors.white,
                  textColor: Colors.white,
                  title: const Text(
                    'Building parts',
                    style: TextStyle(fontSize: 28),
                  ),
                  children: _getChildren(entry)))
        ]));
  }

  List<Widget> _getChildren(BuildingAssessment entry) {
    List<Widget> children = [];
    List<BuildingPart>? parts = entry.buildingParts;

    parts.forEach((element) {
      children.add(ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [buildingPartTile(entry)],
      ));
    });
    return children;
  }

  Widget buildingPartTile(entry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
            child: Row(
              children: [
                const Text(
                  'Appointment Date:    ',
                  style: TextStyle(fontSize: 18),
                ),
                Text(entry.appointmentDate.toString().substring(0, 10),
                    style: const TextStyle(fontSize: 20))
              ],
            )),
      ],
    );
  }
}

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:msg/models/Measurement/measurement.dart';
import 'package:msg/screens/building_assessment_form.dart';
import 'package:msg/screens/settings.dart';
import 'package:msg/widgets/building_assessment_tile.dart';
import 'package:msg/widgets/building_part_tile.dart';
import 'package:msg/widgets/measurement_tile.dart';
import 'package:msg/widgets/routing_button.dart';
import 'package:msg/widgets/search_bar.dart';

import 'package:intl/intl.dart';

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
  List<BuildingAssessment> searchResults = [];
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    _localGet();
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  // Get orders from users local storage
  _localGet() async {
    buildingAssessments = await DatabaseHelper.instance.readAllAssessments();

    print(buildingAssessments);

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
            padding:
                const EdgeInsets.only(top: 60, right: 50, left: 50, bottom: 20),
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          searchBar(cWidth),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: RoutingButton(
                                    destination: BuildingAssessmentForm(),
                                    icon: Icon(Icons.send_rounded),
                                    tooltip: 'Send',
                                  ),
                                ),
                                RoutingButton(
                                  destination: SettingsPage(),
                                  icon: Icon(Icons.settings),
                                  tooltip: 'Settings',
                                )
                              ])
                        ])),
                if (searchResults.isNotEmpty ||
                    textController.text.isNotEmpty) ...[
                  buildSearchView()
                ] else ...[
                  buildView(),
                ],
              ],
            )));
  }

  Widget searchBar(width) {
    return Row(
      children: [
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Colors.grey,
            ),
            margin: const EdgeInsets.only(bottom: 10),
            width: width,
            height: 55,
            child: Row(children: [
              const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(Icons.search)),
              Container(
                  width: width - 85,
                  child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: TextField(
                        style: TextStyle(fontSize: 18),
                        cursorColor: Colors.white,
                        controller: textController,
                        decoration: const InputDecoration(
                            fillColor: Colors.grey,
                            hintText: 'Search',
                            border: InputBorder.none),
                        onChanged: onSearchTextChanged,
                      ))),
              IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () {
                  textController.clear();
                  onSearchTextChanged('');
                },
              ),
            ])),
      ],
    );
  }

  Widget buildView() {
    return Expanded(
        child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: buildingAssessments.length,
            itemBuilder: (context, position) {
              return BuildingAssessmentTile(
                  entry: buildingAssessments[position],
                  buildingParts:
                      _getBuildingParts(buildingAssessments[position]));
            }));
  }

  Widget buildSearchView() {
    return Expanded(
        child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: searchResults.length,
            itemBuilder: (context, position) {
              return BuildingAssessmentTile(
                  entry: searchResults[position],
                  buildingParts: _getBuildingParts(searchResults[position]));
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
            color: const Color.fromARGB(147, 129, 32, 64),
          ),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              BuildingPartTile(
                  entry: element, measurements: _getMeasurements(element))
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
          margin: EdgeInsets.only(top: 20, left: 10, right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color.fromARGB(121, 154, 56, 91),
            //color: Color.fromARGB(124, 90, 17, 43),
          ),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [MeasurementTile(entry: element)],
          )));
    });
    return children;
  }
}

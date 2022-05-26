import 'dart:ffi';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:msg/models/Measurement/measurement.dart';
import 'package:msg/widgets/alert.dart';
import 'package:msg/screens/building_assessment_form.dart';
import 'package:msg/screens/settings.dart';
import 'package:msg/widgets/building_assessment_tile.dart';
import 'package:msg/widgets/building_part_tile.dart';
import 'package:msg/widgets/measurement_tile.dart';
import 'package:msg/widgets/routing_button.dart';
import 'package:msg/widgets/search_bar.dart';

import 'package:intl/intl.dart';
import 'package:connectivity/connectivity.dart';

import '../models/BuildingAssessment/building_assessment.dart';
import '../models/BuildingPart/building_part.dart';
import '../models/Database/database_helper.dart';
import '../services/sqs_sender.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<BuildingAssessment> buildingAssessments = [];
  List<BuildingAssessment> searchResults = [];
  TextEditingController textController = TextEditingController();
  final Connectivity _connectivity = Connectivity();
  final SQSSender sqsSender = SQSSender();

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

  void resendAll() async {
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
          return new Alert(title: title, content: content);
        });
  }

  // Get orders from users local storage
  _localGet() async {
    buildingAssessments = await DatabaseHelper.instance.readAllAssessments();

    // print(buildingAssessments[buildingAssessments.length-1].toJson());
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
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      searchBar(cWidth),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                                padding: EdgeInsets.only(right: 40),
                                child: ElevatedButton.icon(
                                    icon: Icon(
                                      Icons.send_and_archive_outlined,
                                      size: 22,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      shape: StadiumBorder(),
                                      primary:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    onPressed: () => resendAll(),
                                    label: Text("Resend",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondary)))),
                            const Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: const RoutingButton(
                                destination: BuildingAssessmentForm(),
                                icon: const Icon(Icons.send_rounded),
                                tooltip: 'Send',
                              ),
                            ),
                            const RoutingButton(
                              destination: SettingsPage(),
                              icon: const Icon(Icons.settings),
                              tooltip: 'Settings',
                            )
                          ])
                    ]),
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
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            margin: const EdgeInsets.only(bottom: 10),
            width: width,
            height: 55,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(Icons.search)),
                  Container(
                      width: width - 85,
                      child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: TextField(
                            style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.onPrimary),
                            cursorColor:
                                Theme.of(context).colorScheme.onPrimary,
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
                  )
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
                  context: context,
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
                  context: context,
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
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              BuildingPartTile(
                  context: context,
                  entry: element,
                  measurements: _getMeasurements(element))
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
}

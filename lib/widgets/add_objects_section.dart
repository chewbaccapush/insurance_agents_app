import 'package:flutter/material.dart';
import 'package:msg/models/BuildingAssessment/building_assessment.dart';
import 'package:msg/models/BuildingPart/building_part.dart';
import 'package:msg/models/Measurement/measurement.dart';

enum ObjectType { buildingPart, measurement }

class AddObjectsSection extends StatefulWidget {
  final dynamic onPressed;
  final BuildingAssessment? buildingAssessment;
  final BuildingPart? buildingPart;
  final ObjectType objectType;

  const AddObjectsSection(
      {Key? key,
      this.onPressed,
      this.buildingAssessment,
      this.buildingPart,
      required this.objectType})
      : super(key: key);

  @override
  State<AddObjectsSection> createState() => _AddObjectsSectionState();
}

class _AddObjectsSectionState extends State<AddObjectsSection> {
  List<ListTile> objects = [];

  @override
  void initState() {
    objects = widget.objectType == ObjectType.buildingPart
        ? widget.buildingAssessment!.buildingParts
            .map((e) => ListTile(title: Text(e.description!)))
            .toList()
        : widget.buildingPart!.measurements
            .map((e) => ListTile(title: Text(e.description!)))
            .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        OutlinedButton(
            onPressed: widget.onPressed, child: const Icon(Icons.add)),
        SizedBox(
          height: 500,
          width: 500,
          child: ListView(
            children: objects,
          ),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:msg/models/BuildingAssessment/building_assessment.dart';
import 'package:msg/models/BuildingPart/building_part.dart';
import 'package:msg/screens/measurement_form.dart';
import 'package:msg/screens/building_part_form.dart';

enum ObjectType { buildingPart, measurement }

class AddObjectsSection extends StatefulWidget {
  final dynamic onPressed;
  final BuildingAssessment buildingAssessment;
  final BuildingPart? buildingPart;
  final ObjectType objectType;

  const AddObjectsSection(
      {Key? key,
      this.onPressed,
      required this.buildingAssessment,
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
        ? widget.buildingAssessment.buildingParts
            .map((e) => ListTile(
                  title: Text(e.description!),
                  trailing: IconButton(
                    onPressed: () => {},
                    icon: const Icon(Icons.delete),
                  ),
                  onTap: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BuildingPartForm(
                          buildingPart: e,
                          buildingAssessment: widget.buildingAssessment,
                        ),
                      ),
                    )
                  },
                ))
            .toList()
        : widget.buildingPart!.measurements
            .map((e) => ListTile(
                  title: Text(e.description!),
                  trailing: IconButton(
                    onPressed: () => {},
                    icon: const Icon(Icons.delete),
                  ),
                  onTap: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MeasurementForm(
                          measurement: e,
                          buildingPart: widget.buildingPart!,
                          buildingAssessment: widget.buildingAssessment,
                        ),
                      ),
                    )
                  },
                ))
            .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.transparent)),
          onPressed: widget.onPressed,
          label: Text(
            widget.objectType == ObjectType.buildingPart
                ? "Add Building Part"
                : "Add Measurement",
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
          icon: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        SizedBox(
          height: 500,
          width: 500,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            color: const Color.fromRGBO(255, 255, 255, 0.05),
            child: ListView(
              children: objects,
            ),
          ),
        )
      ],
    );
  }
}

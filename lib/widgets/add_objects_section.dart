import 'package:flutter/material.dart';
import 'package:msg/models/BuildingPart/building_part.dart';
import 'package:msg/models/Measurement/measurement.dart';

class AddObjectsSection extends StatefulWidget {
  final BuildingPart buildingPart;

  const AddObjectsSection({Key? key, required this.buildingPart})
      : super(key: key);

  @override
  State<AddObjectsSection> createState() => _AddObjectsSectionState();
}

class _AddObjectsSectionState extends State<AddObjectsSection> {
  BuildingPart buildingPart = BuildingPart();
  List<ListTile> objects = [];

  @override
  void initState() {
    buildingPart = widget.buildingPart;
    objects = buildingPart.measurements!
        .map<ListTile>((Measurement measurement) =>
            ListTile(title: Text(measurement.description)))
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        OutlinedButton(
            onPressed: () {
              setState(() {
                ListTile testBuildingPart = const ListTile(title: Text("Test"));
                objects.add(testBuildingPart);
              });
            },
            child: const Icon(Icons.add)),
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

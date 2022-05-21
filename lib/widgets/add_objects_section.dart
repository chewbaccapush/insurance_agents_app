import 'package:flutter/material.dart';

class AddObjectsSection extends StatefulWidget {
  const AddObjectsSection({Key? key}) : super(key: key);

  @override
  State<AddObjectsSection> createState() => _AddObjectsSectionState();
}

class _AddObjectsSectionState extends State<AddObjectsSection> {
  List<ListTile> _addedBuildingParts = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        OutlinedButton(
            onPressed: () {
              setState(() {
                ListTile testBuildingPart = const ListTile(title: Text("Test"));
                _addedBuildingParts.add(testBuildingPart);
              });
            },
            child: const Icon(Icons.add)),
        SizedBox(
          height: 500,
          width: 500,
          child: ListView(
            children: _addedBuildingParts,
          ),
        )
      ],
    );
  }
}

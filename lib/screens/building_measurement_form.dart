import 'package:flutter/material.dart';
import 'package:msg/models/Measurement/measurement.dart';
import 'package:msg/screens/building_part_form.dart';
import 'package:msg/widgets/custom_text_form_field.dart';

import '../models/BuildingPart/building_part.dart';

class BuildingMeasurementForm extends StatefulWidget {
  final BuildingPart? buildingPart;
  final Measurement? measurement;
  const BuildingMeasurementForm({Key? key, this.measurement, this.buildingPart})
      : super(key: key);

  @override
  State<BuildingMeasurementForm> createState() =>
      _BuildingMeasurementFormState();
}

class _BuildingMeasurementFormState extends State<BuildingMeasurementForm> {
  final _formKey = GlobalKey<FormState>();
  Measurement measurement = Measurement();
  BuildingPart buildingPart = BuildingPart();

  @override
  void initState() {
    buildingPart = widget.buildingPart ?? BuildingPart();
    measurement = widget.measurement ?? Measurement();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Building Part Measurement")),
      body: Container(
        padding: const EdgeInsets.all(50.0),
        child: Form(
          key: _formKey,
          child: Row(
            children: <Widget>[
              Flexible(
                child: Column(
                  children: <Widget>[
                    CustomTextFormField(
                      type: TextInputType.text,
                      labelText: "Description",
                      initialValue: measurement.description,
                      onChanged: (newValue) => {
                        setState(() => {measurement.description = newValue})
                      },
                    ),
                    CustomTextFormField(
                      type:
                          const TextInputType.numberWithOptions(decimal: false),
                      labelText: "Length",
                      initialValue: measurement.length.toString(),
                      onChanged: (newValue) => {
                        setState(
                            () => {measurement.length = double.parse(newValue)})
                      },
                    ),
                    CustomTextFormField(
                      type:
                          const TextInputType.numberWithOptions(decimal: true),
                      labelText: "Height",
                      initialValue: measurement.height.toString(),
                      onChanged: (newValue) => {
                        setState(
                            () => {measurement.height = double.parse(newValue)})
                      },
                    ),
                    CustomTextFormField(
                      type:
                          const TextInputType.numberWithOptions(decimal: true),
                      labelText: "Width",
                      initialValue: measurement.width.toString(),
                      onChanged: (newValue) => {
                        setState(
                            () => {measurement.width = double.parse(newValue)})
                      },
                    ),
                    CustomTextFormField(
                      type:
                          const TextInputType.numberWithOptions(decimal: true),
                      labelText: "Radius",
                      initialValue: measurement.radius.toString(),
                      onChanged: (newValue) => {
                        setState(
                            () => {measurement.radius = double.parse(newValue)})
                      },
                    ),
                    OutlinedButton(
                      onPressed: () => {
                        setState(
                          () {
                            print(buildingPart.measurements);
                            buildingPart.measurements.add(measurement);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => BuildingPartForm(
                                    buildingPart: buildingPart)));
                          },
                        ),
                      },
                      child: const Text("Add"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

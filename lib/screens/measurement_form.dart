import 'package:flutter/material.dart';
import 'package:msg/models/BuildingAssessment/building_assessment.dart';
import 'package:msg/models/Measurement/measurement.dart';
import 'package:msg/screens/building_part_form.dart';
import 'package:msg/screens/history.dart';
import 'package:msg/screens/settings.dart';
import 'package:msg/validators/validators.dart';
import 'package:msg/widgets/custom_navbar.dart';
import 'package:msg/widgets/custom_text_form_field.dart';

import '../models/BuildingPart/building_part.dart';

class MeasurementForm extends StatefulWidget {
  final BuildingAssessment buildingAssessment;
  final BuildingPart? buildingPart;
  final Measurement? measurement;
  const MeasurementForm(
      {Key? key,
      this.measurement,
      this.buildingPart,
      required this.buildingAssessment})
      : super(key: key);

  @override
  State<MeasurementForm> createState() => _MeasurementFormState();
}

class _MeasurementFormState extends State<MeasurementForm> {
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
      resizeToAvoidBottomInset: true,
      body: Container(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            CustomNavbar(
              leading: Row(
                children: [
                  IconButton(
                    onPressed: () => {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: ((context) => BuildingPartForm(
                              buildingAssessment: widget.buildingAssessment,
                              buildingPart: buildingPart)),
                        ),
                      )
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Text(
                    "Add Measurement",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              firstIcon: const Icon(Icons.history),
              secondIcon: const Icon(Icons.settings),
              firstDestination: const HistoryPage(),
              secondDestination: const SettingsPage(),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 20)),
            Form(
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
                          validator: (value) =>
                              Validators.defaultValidator(value!),
                        ),
                        CustomTextFormField(
                          type: const TextInputType.numberWithOptions(
                              decimal: false),
                          labelText: "Length",
                          initialValue: measurement.length.toString(),
                          onChanged: (newValue) => {
                            setState(() =>
                                {measurement.length = double.parse(newValue)})
                          },
                          validator: (value) =>
                              Validators.measurementValidator(value!),
                        ),
                        CustomTextFormField(
                          type: const TextInputType.numberWithOptions(
                              decimal: true),
                          labelText: "Height",
                          initialValue: measurement.height.toString(),
                          onChanged: (newValue) => {
                            setState(() =>
                                {measurement.height = double.parse(newValue)})
                          },
                          validator: (value) =>
                              Validators.measurementValidator(value!),
                        ),
                        CustomTextFormField(
                          type: const TextInputType.numberWithOptions(
                              decimal: true),
                          labelText: "Width",
                          initialValue: measurement.width.toString(),
                          onChanged: (newValue) => {
                            setState(() =>
                                {measurement.width = double.parse(newValue)})
                          },
                          validator: (value) =>
                              Validators.measurementValidator(value!),
                        ),
                        CustomTextFormField(
                          type: const TextInputType.numberWithOptions(
                              decimal: true),
                          labelText: "Radius",
                          initialValue: measurement.radius.toString(),
                          onChanged: (newValue) => {
                            setState(() =>
                                {measurement.radius = double.parse(newValue)})
                          },
                          validator: (value) =>
                              Validators.measurementValidator(value!),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(148, 135, 18, 57),
                              textStyle: TextStyle(fontSize: 15)),
                          onPressed: () => {
                            if (_formKey.currentState!.validate())
                              {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Saving..'),
                                  ),
                                ),
                                setState(
                                  () {
                                    buildingPart.measurements.add(measurement);
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => BuildingPartForm(
                                            buildingAssessment:
                                                widget.buildingAssessment,
                                            buildingPart: buildingPart),
                                      ),
                                    );
                                  },
                                ),
                              },
                          },
                          child: const Text("Add"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

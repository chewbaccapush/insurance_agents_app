import 'package:flutter/material.dart';
import 'package:msg/models/BuildingAssessment/building_assessment.dart';
import 'package:msg/models/Database/database_helper.dart';
import 'package:msg/models/Measurement/measurement.dart';
import 'package:msg/screens/building_part_form.dart';
import 'package:msg/services/navigator_service.dart';
import 'package:msg/validators/validators.dart';
import 'package:msg/widgets/custom_navbar.dart';
import 'package:msg/widgets/custom_text_form_field.dart';

import '../models/BuildingPart/building_part.dart';
import '../services/state_service.dart';

class MeasurementForm extends StatefulWidget {
  const MeasurementForm({Key? key}) : super(key: key);

  @override
  State<MeasurementForm> createState() => _MeasurementFormState();
}

class _MeasurementFormState extends State<MeasurementForm> {
  final _formKey = GlobalKey<FormState>();
  BuildingAssessment buildingAssessment = StateService.buildingAssessment;
  BuildingPart buildingPart = StateService.buildingPart;
  Measurement measurement = StateService.measurement;

  saveMeasurement() async {
    await DatabaseHelper.instance
        .persistMeasurement(measurement, buildingPart, buildingAssessment)
        .then((value) => {
              measurement.measurementId = value.measurementId,
              buildingPart.id = value.fk_buildingPartId,
              buildingAssessment.id = buildingPart.fk_buildingAssesmentId
            });

    if (!buildingPart.measurements.contains(measurement)) {
      buildingPart.measurements.add(measurement);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            CustomNavbar(
              leading: Row(
                children: [
                  IconButton(
                    onPressed: () async => {
                      measurement.description ??= "DRAFT",
                      await saveMeasurement(),
                      NavigatorService.navigateTo(
                          context, const BuildingPartForm())
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Text(
                    "Add Measurement",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
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
                          suffix: const Padding(
                            padding: EdgeInsets.only(top: 15.0),
                            child: Text("metres",
                                style: TextStyle(color: Colors.grey)),
                          ),
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
                          suffix: const Padding(
                            padding: EdgeInsets.only(top: 15.0),
                            child: Text("metres",
                                style: TextStyle(color: Colors.grey)),
                          ),
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
                          suffix: const Padding(
                            padding: EdgeInsets.only(top: 15.0),
                            child: Text("metres",
                                style: TextStyle(color: Colors.grey)),
                          ),
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
                          suffix: const Padding(
                            padding: EdgeInsets.only(top: 15.0),
                            child: Text("meters",
                                style: TextStyle(color: Colors.grey)),
                          ),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(
                                Icons.check_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                primary: Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () async => {
                                if (_formKey.currentState!.validate())
                                  {
                                    await saveMeasurement(),
                                    NavigatorService.navigateTo(
                                        context, const BuildingPartForm())
                                  },
                              },
                              label: const Text("OK",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: ElevatedButton.icon(
                                icon: const Icon(
                                  Icons.cancel_rounded,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  NavigatorService.navigateTo(
                                      context, const BuildingPartForm());
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  primary:
                                      Theme.of(context).colorScheme.primary,
                                ),
                                label: const Text("Cancel",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white)),
                              ),
                            ),
                          ],
                        )
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

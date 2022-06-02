import 'dart:math';

import 'package:flutter/material.dart';
import 'package:msg/models/BuildingAssessment/building_assessment.dart';
import 'package:msg/models/Database/database_helper.dart';
import 'package:msg/models/Measurement/measurement.dart';
import 'package:msg/models/Measurement/measurement_type.dart';
import 'package:msg/screens/building_part_form.dart';
import 'package:msg/services/navigator_service.dart';
import 'package:msg/validators/validators.dart';
import 'package:msg/widgets/custom_navbar.dart';
import 'package:msg/widgets/custom_text_form_field.dart';
import 'package:msg/widgets/measurement_type_switcher.dart';

import '../models/BuildingPart/building_part.dart';
import '../services/state_service.dart';
import '../services/storage_service.dart';
import '../widgets/custom_popup.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  Measurement uneditedMeasurement = Measurement();
  bool dirtyFlag = false;

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
  void initState() {
    uneditedMeasurement = measurement.copy();
    measurement.measurementType =
        measurement.measurementType ?? MeasurementType.rectangular;
    super.initState();
  }

  int getCubature() {
    if (measurement.measurementType == MeasurementType.rectangular) {
      if (measurement.height != null &&
          measurement.width != null &&
          measurement.length != null) {
        measurement.cubature =
            measurement.height! * measurement.width! * measurement.length!;
      } else {
        measurement.cubature = 0.0;
      }
    } else {
      if (measurement.height != null && measurement.radius != null) {
        measurement.cubature =
            3.14 * pow(measurement.radius!, 2) * measurement.height!;
      } else {
        measurement.cubature = 0.0;
      }
    }
    return measurement.cubature!.round();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              children: [
                CustomNavbar(
                  leading: Row(
                    children: [
                      IconButton(
                        onPressed: () async => {
                          if (dirtyFlag)
                            {
                              await showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      CustomDialog(
                                        title: const Text("Save Changes?"),
                                        twoButtons: true,
                                        titleButtonOne: const Text("No"),
                                        onPressedButtonOne: () => {
                                          if (buildingPart.measurements
                                              .contains(measurement))
                                            {
                                              buildingPart.measurements
                                                  .remove(measurement),
                                              buildingPart.measurements
                                                  .add(uneditedMeasurement),
                                            },
                                          NavigatorService.navigateTo(
                                              context, const BuildingPartForm())
                                        },
                                        titleButtonTwo: const Text("Yes"),
                                        onPressedButtonTwo: () async => {
                                          measurement.description ??= "DRAFT",
                                          await saveMeasurement(),
                                          NavigatorService.navigateTo(
                                              context, const BuildingPartForm())
                                        },
                                      )),
                            },
                          NavigatorService.navigateTo(
                              context, const BuildingPartForm())
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                      Text(
                        AppLocalizations.of(context)!.measurementForm_add,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(bottom: 20)),
                Form(
                  key: _formKey,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        child: Column(
                          children: <Widget>[
                            CustomTextFormField(
                              type: TextInputType.text,
                              labelText:
                                  AppLocalizations.of(context)!.description,
                              initialValue: measurement.description,
                              onChanged: (newValue) => {
                                setState(() => {
                                      dirtyFlag = true,
                                      measurement.description = newValue,
                                    })
                              },
                              validator: (value) =>
                                  Validators.defaultValidator(value!),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Text(AppLocalizations.of(context)!
                                          .measurement_type)),
                                  Container(
                                      width: 270,
                                      child: MeasurementTypeSwitcher(
                                        measurement: measurement,
                                        onTapCircular: () => setState(() {
                                          print(measurement.toJson());
                                          measurement.measurementType =
                                              MeasurementType.circular;
                                        }),
                                        onTapRectangular: () => setState(() {
                                          print(measurement.toJson());
                                          measurement.measurementType =
                                              MeasurementType.rectangular;
                                        }),
                                      )),
                                  Spacer(),
                                  Text(AppLocalizations.of(context)!.cubature +
                                      ": ${getCubature()}m\u00B3"),
                                ],
                              ),
                            ),
                            CustomTextFormField(
                              enabled: measurement.measurementType ==
                                      MeasurementType.rectangular
                                  ? true
                                  : false,
                              suffix: const Padding(
                                padding: EdgeInsets.only(top: 15.0),
                                child: Text("metres",
                                    style: TextStyle(color: Colors.grey)),
                              ),
                              type: const TextInputType.numberWithOptions(
                                  decimal: false),
                              labelText: AppLocalizations.of(context)!
                                  .measurement_length,
                              initialValue: measurement.length.toString(),
                              onChanged: (newValue) => {
                                setState(() => {
                                      dirtyFlag = true,
                                      measurement.length =
                                          double.tryParse(newValue)
                                    })
                              },
                              validator: (value) =>
                                  Validators.measurementValidator(value!),
                            ),
                            CustomTextFormField(
                              enabled: measurement.measurementType ==
                                      MeasurementType.rectangular
                                  ? true
                                  : false,
                              suffix: const Padding(
                                padding: EdgeInsets.only(top: 15.0),
                                child: Text("meters",
                                    style: TextStyle(color: Colors.grey)),
                              ),
                              type: const TextInputType.numberWithOptions(
                                  decimal: true),
                              labelText: AppLocalizations.of(context)!
                                  .measurement_width,
                              initialValue: measurement.width.toString(),
                              onChanged: (newValue) => {
                                setState(() => {
                                      dirtyFlag = true,
                                      measurement.width =
                                          double.tryParse(newValue),
                                    })
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
                              labelText: AppLocalizations.of(context)!
                                  .measurement_height,
                              initialValue: measurement.height.toString(),
                              onChanged: (newValue) => {
                                setState(() => {
                                      dirtyFlag = true,
                                      measurement.height =
                                          double.tryParse(newValue)
                                    })
                              },
                              validator: (value) =>
                                  Validators.measurementValidator(value!),
                            ),
                            CustomTextFormField(
                              enabled: measurement.measurementType ==
                                      MeasurementType.circular
                                  ? true
                                  : false,
                              suffix: const Padding(
                                padding: EdgeInsets.only(top: 15.0),
                                child: Text("meters",
                                    style: TextStyle(color: Colors.grey)),
                              ),
                              type: const TextInputType.numberWithOptions(
                                  decimal: true),
                              labelText: AppLocalizations.of(context)!
                                  .measurement_radius,
                              initialValue: measurement.radius.toString(),
                              onChanged: (newValue) => {
                                setState(() => {
                                      dirtyFlag = true,
                                      measurement.radius =
                                          double.tryParse(newValue)
                                    })
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
                                    primary: (StorageService.getAppThemeId() ==
                                            false)
                                        ? Color.fromARGB(220, 112, 14, 46)
                                        : Color.fromARGB(148, 112, 14, 46),
                                  ),
                                  onPressed: () async => {
                                    if (_formKey.currentState!.validate())
                                      {
                                        await saveMeasurement(),
                                        NavigatorService.navigateTo(
                                            context, const BuildingPartForm())
                                      },
                                  },
                                  label: Text(
                                      AppLocalizations.of(context)!
                                          .buildingAssessment_okButton,
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
                                          (StorageService.getAppThemeId() ==
                                                  false)
                                              ? Color.fromARGB(220, 112, 14, 46)
                                              : Color.fromARGB(
                                                  148, 112, 14, 46),
                                    ),
                                    label: Text(
                                        AppLocalizations.of(context)!
                                            .buildingAssessment_cancelButton,
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
        ),
      ),
    );
  }
}

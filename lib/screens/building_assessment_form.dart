import 'package:flutter/material.dart';
import 'package:msg/models/BuildingAssessment/building_assessment.dart';
import 'package:msg/models/BuildingPart/building_part.dart';
import 'package:msg/screens/building_part_form.dart';
import 'package:msg/screens/history.dart';
import 'package:msg/screens/settings.dart';
import 'package:msg/validators/validators.dart';
import 'package:msg/widgets/add_objects_section.dart';
import 'package:msg/widgets/custom_text_form_field.dart';
import 'package:msg/widgets/date_form_field.dart';

import '../models/BuildingPart/construction_class.dart';
import '../models/BuildingPart/fire_protection.dart';
import '../models/BuildingPart/insured_type.dart';
import '../models/BuildingPart/risk_class.dart';
import '../models/Database/database_helper.dart';
import '../models/Measurement/measurement.dart';
import '../services/sqs_sender.dart';
import '../widgets/alert.dart';
import '../widgets/routing_button.dart';

class BuildingAssessmentForm extends StatefulWidget {
  final BuildingAssessment? buildingAssessment;
  const BuildingAssessmentForm({Key? key, this.buildingAssessment})
      : super(key: key);

  @override
  State<BuildingAssessmentForm> createState() => _BuildingAssessmentFormState();
}

class _BuildingAssessmentFormState extends State<BuildingAssessmentForm> {
  final _formKey = GlobalKey<FormState>();
  BuildingAssessment buildingAssessment = BuildingAssessment();

  @override
  void initState() {
    buildingAssessment = widget.buildingAssessment ?? BuildingAssessment();
    super.initState();
  }

  final SQSSender sqsSender = SQSSender();

  void sendMessage(String message) async {
    try {
      await sqsSender.sendToSQS(message);
      showDialogPopup("Info", "Assessment successfully sent.");
    } catch (e) {
      showDialogPopup("Error", "Assessment not sent.");
    }
  }

  void showDialogPopup(String title, String content) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new Alert(title: title, content: content);
        });
  }

  // // Locally save order to users device
  void localSave() async {
    BuildingAssessment assessment = await DatabaseHelper.instance
        .createAssessment(buildingAssessment, buildingAssessment.buildingParts);

    print(assessment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        padding: const EdgeInsets.all(50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Send building assessement',
                          style: TextStyle(fontSize: 35)),
                      Row(children: [
                        Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: RoutingButton(
                              icon: Icon(Icons.history),
                              destination: HistoryPage(),
                            )),
                        RoutingButton(
                          icon: Icon(Icons.settings),
                          destination: SettingsPage(),
                        ),
                      ])
                    ],
                  )),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        CustomDateFormField(
                          initialValue: buildingAssessment.appointmentDate,
                          onDateSaved: (newValue) => {
                            setState((() => {
                                  buildingAssessment.appointmentDate = newValue
                                }))
                          },
                        ),
                        CustomTextFormField(
                          type: TextInputType.text,
                          labelText: "Description",
                          fontSize: 20,
                          initialValue: buildingAssessment.description,
                          onChanged: (newValue) => {
                            setState(() =>
                                {buildingAssessment.description = newValue})
                          },
                          validator: (value) =>
                              Validators.defaultValidator(value!),
                        ),
                        CustomTextFormField(
                          fontSize: 20,
                          type: TextInputType.text,
                          labelText: "Assessment Cause",
                          initialValue: buildingAssessment.assessmentCause,
                          onChanged: (newValue) => {
                            setState(() =>
                                {buildingAssessment.assessmentCause = newValue})
                          },
                          validator: (value) =>
                              Validators.defaultValidator(value!),
                        ),
                        CustomTextFormField(
                          fontSize: 20,
                          type: const TextInputType.numberWithOptions(
                              decimal: false),
                          labelText: "Number of Apartments",
                          initialValue:
                              buildingAssessment.numOfAppartments.toString(),
                          onChanged: (newValue) => {
                            setState(() => {
                                  buildingAssessment.numOfAppartments =
                                      int.parse(newValue)
                                })
                          },
                          validator: (value) =>
                              Validators.numberOfApartmentsValidator(value!),
                        ),
                        CustomTextFormField(
                          fontSize: 20,
                          type: const TextInputType.numberWithOptions(
                              decimal: true),
                          labelText: "Voluntary Deduction",
                          initialValue:
                              buildingAssessment.voluntaryDeduction.toString(),
                          onChanged: (newValue) => {
                            setState(() => {
                                  buildingAssessment.voluntaryDeduction =
                                      double.parse(newValue)
                                })
                          },
                          validator: (value) =>
                              Validators.floatValidator(value!),
                        ),
                        CustomTextFormField(
                          fontSize: 20,
                          type: const TextInputType.numberWithOptions(
                              decimal: true),
                          labelText: "Assessment Fee",
                          initialValue:
                              buildingAssessment.assessmentFee.toString(),
                          onChanged: (newValue) => {
                            setState(() => {
                                  buildingAssessment.assessmentFee =
                                      double.parse(newValue)
                                })
                          },
                          validator: (value) =>
                              Validators.floatValidator(value!),
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(148, 135, 18, 57),
                                textStyle: TextStyle(fontSize: 15)),
                            onPressed: () {
                              // Validates form
                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Sending..')),
                                );
                                _formKey.currentState!.save();

                                //TODO: Remove for production!
                                print(buildingAssessment.toMessage());
                                localSave();
                                sendMessage(
                                    buildingAssessment.toMessage().toString());
                              }
                            },
                            child: Text("Send"))
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        AddObjectsSection(
                          objectType: ObjectType.buildingPart,
                          buildingAssessment: buildingAssessment,
                          onPressed: () => {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BuildingPartForm(
                                  buildingAssessment: buildingAssessment,
                                ),
                              ),
                            )
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

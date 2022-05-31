import 'package:flutter/material.dart';
import 'package:msg/models/BuildingAssessment/building_assessment.dart';
import 'package:msg/screens/building_part_form.dart';
import 'package:msg/screens/history.dart';
import 'package:msg/services/state_service.dart';
import 'package:msg/validators/validators.dart';
import 'package:msg/widgets/add_objects_section.dart';
import 'package:msg/widgets/custom_navbar.dart';
import 'package:msg/widgets/custom_text_form_field.dart';
import 'package:msg/widgets/date_form_field.dart';

import '../models/BuildingPart/building_part.dart';
import '../models/Database/database_helper.dart';
import '../services/navigator_service.dart';
import '../services/sqs_sender.dart';
import '../services/storage_service.dart';
import '../widgets/custom_popup.dart';

class BuildingAssessmentForm extends StatefulWidget {
  const BuildingAssessmentForm({Key? key}) : super(key: key);

  @override
  State<BuildingAssessmentForm> createState() => _BuildingAssessmentFormState();
}

class _BuildingAssessmentFormState extends State<BuildingAssessmentForm> {
  final _formKey = GlobalKey<FormState>();
  final SQSSender sqsSender = SQSSender();
  BuildingAssessment buildingAssessment = StateService.buildingAssessment;
  BuildingAssessment uneditedBuildingAssessment = BuildingAssessment();
  bool dirtyFlag = false;

  @override
  void initState() {
    uneditedBuildingAssessment = buildingAssessment.copy();
    super.initState();
  }

  // Save to database
  Future<void> saveBuildingAssessment() async {
    buildingAssessment.sent = false;
    await DatabaseHelper.instance.persistAssessment(buildingAssessment);
  }

  void sendMessage(String message) async {
    try {
      await sqsSender
          .sendToSQS(message)
          .then((value) => buildingAssessment.sent = true);
      buildingAssessment.sent = true;
    } catch (e) {
      buildingAssessment.sent = false;
    } finally {
      saveBuildingAssessment();
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
                      if (dirtyFlag)
                        {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) => CustomDialog(
                              title: const Text("Save Changes?"),
                              actions: [
                                ElevatedButton(
                                  child: const Text("No"),
                                  style: ElevatedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    primary: (StorageService.getAppThemeId() ==
                                            false)
                                        ? const Color.fromARGB(220, 112, 14, 46)
                                        : const Color.fromARGB(
                                            148, 112, 14, 46),
                                  ),
                                  onPressed: () => {
                                    NavigatorService.navigateTo(
                                        context, const HistoryPage())
                                  },
                                ),
                                ElevatedButton(
                                  child: const Text("Yes"),
                                  style: ElevatedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    primary: (StorageService.getAppThemeId() ==
                                            false)
                                        ? const Color.fromARGB(220, 112, 14, 46)
                                        : const Color.fromARGB(
                                            148, 112, 14, 46),
                                  ),
                                  onPressed: () async => {
                                    await saveBuildingAssessment(),
                                    NavigatorService.navigateTo(
                                        context, const HistoryPage())
                                  },
                                ),
                              ],
                            ),
                          ),
                        },
                      NavigatorService.navigateTo(context, const HistoryPage())
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Text(
                    "Edit Building Assessment",
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 20)),
            Form(
              key: _formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Column(
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
                          initialValue: buildingAssessment.description,
                          onChanged: (newValue) => {
                            setState(() => {
                                  dirtyFlag = true,
                                  buildingAssessment.description = newValue,
                                })
                          },
                          validator: (value) =>
                              Validators.defaultValidator(value!),
                        ),
                        CustomTextFormField(
                          type: TextInputType.text,
                          labelText: "Assessment Cause",
                          initialValue: buildingAssessment.assessmentCause,
                          onChanged: (newValue) => {
                            setState(() => {
                                  dirtyFlag = true,
                                  buildingAssessment.assessmentCause = newValue,
                                })
                          },
                          validator: (value) =>
                              Validators.defaultValidator(value!),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextFormField(
                              width: 175,
                              type: const TextInputType.numberWithOptions(
                                  decimal: false),
                              labelText: "Number of Apartments",
                              initialValue: buildingAssessment.numOfAppartments
                                  .toString(),
                              onChanged: (newValue) => {
                                setState(() => {
                                      dirtyFlag = true,
                                      buildingAssessment.numOfAppartments =
                                          int.parse(newValue)
                                    })
                              },
                              validator: (value) =>
                                  Validators.numberOfApartmentsValidator(
                                      value!),
                            ),
                            CustomTextFormField(
                              width: 175,
                              type: const TextInputType.numberWithOptions(
                                  decimal: true),
                              labelText: "Voluntary Deduction",
                              initialValue: buildingAssessment
                                  .voluntaryDeduction
                                  .toString(),
                              onChanged: (newValue) => {
                                setState(() => {
                                      dirtyFlag = true,
                                      buildingAssessment.voluntaryDeduction =
                                          double.parse(newValue)
                                    })
                              },
                              validator: (value) =>
                                  Validators.floatValidator(value!),
                            ),
                            CustomTextFormField(
                              width: 175,
                              suffix: const Icon(Icons.euro_rounded,
                                  color: Colors.grey),
                              type: const TextInputType.numberWithOptions(
                                  decimal: true),
                              labelText: "Assessment Fee",
                              initialValue:
                                  buildingAssessment.assessmentFee.toString(),
                              onChanged: (newValue) => {
                                setState(() => {
                                      dirtyFlag = true,
                                      buildingAssessment.assessmentFee =
                                          double.parse(newValue)
                                    })
                              },
                              validator: (value) =>
                                  Validators.floatValidator(value!),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(
                                Icons.check_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                primary:
                                    (StorageService.getAppThemeId() == false)
                                        ? Color.fromARGB(220, 112, 14, 46)
                                        : Color.fromARGB(148, 112, 14, 46),
                              ),
                              onPressed: () async => {
                                _formKey.currentState!.save(),
                                await saveBuildingAssessment(),
                                NavigatorService.navigateTo(
                                    context, const HistoryPage()),
                              },
                              label: const Text(
                                "OK",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(right: 10)),
                            ElevatedButton.icon(
                              icon: const Icon(
                                Icons.cancel_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                NavigatorService.navigateTo(
                                    context, const HistoryPage());
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                primary:
                                    (StorageService.getAppThemeId() == false)
                                        ? Color.fromARGB(220, 112, 14, 46)
                                        : Color.fromARGB(148, 112, 14, 46),
                              ),
                              label: const Text("Cancel",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white)),
                            ),
                            const Padding(padding: EdgeInsets.only(right: 10)),
                            ElevatedButton.icon(
                              icon: const Icon(
                                Icons.send_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                // Validates form
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  sendMessage(buildingAssessment
                                      .toMessage()
                                      .toString());
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                primary:
                                    (StorageService.getAppThemeId() == false)
                                        ? Color.fromARGB(220, 112, 14, 46)
                                        : Color.fromARGB(148, 112, 14, 46),
                              ),
                              label: const Text("Finalize",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white)),
                            ),
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            ElevatedButton(
                                onPressed: () => DatabaseHelper.instance
                                    .deleteDatabase(
                                        "/data/user/0/com.example.msg/databases/msgDatabase.db"),
                                child: const Text("Pobrisi bazo"))
                          ],
                        )
                      ],
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 60.0),
                      child: Column(
                        children: <Widget>[
                          AddObjectsSection(
                            objectType: ObjectType.buildingPart,
                            onPressed: () async => {
                              StateService.buildingPart = BuildingPart(),
                              NavigatorService.navigateTo(
                                  context, const BuildingPartForm()),
                            },
                          ),
                        ],
                      ),
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

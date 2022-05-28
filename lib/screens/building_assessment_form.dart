import 'package:flutter/material.dart';
import 'package:msg/models/BuildingAssessment/building_assessment.dart';
import 'package:msg/screens/building_part_form.dart';
import 'package:msg/screens/history.dart';
import 'package:msg/validators/validators.dart';
import 'package:msg/widgets/add_objects_section.dart';
import 'package:msg/widgets/custom_dialog.dart';
import 'package:msg/widgets/custom_navbar.dart';
import 'package:msg/widgets/custom_text_form_field.dart';
import 'package:msg/widgets/date_form_field.dart';

import '../models/Database/database_helper.dart';
import '../services/sqs_sender.dart';
import '../widgets/alert.dart';

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
      await sqsSender
          .sendToSQS(message)
          .then((value) => buildingAssessment.sent = true);
      //showDialogPopup("Info", "Assessment successfully sent.");
      Navigator.of(context).push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) => const CustomDialog(
              text: 'Building assessment successfully sent')));
      buildingAssessment.sent = true;
    } catch (e) {
      //showDialogPopup("Error", "Assessment not sent.");
      Navigator.of(context).push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) =>
              const CustomDialog(text: 'Building assessment not sent')));
      buildingAssessment.sent = false;
    } finally {
      // Saves to database
      localSave();
    }
  }

  // TODO: move to
  void showDialogPopup(String title, String content) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Alert(title: title, content: content);
        });
  }

  // // Locally save order to users device
  Future<void> localSave() async {
    debugPrint("SQL: saving...");
    print("SQL:");
    print(buildingAssessment);
    buildingAssessment.sent = false;
    BuildingAssessment assessment =
        await DatabaseHelper.instance.persistAssessment(buildingAssessment);
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
                    onPressed: () => {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: ((context) => const HistoryPage()),
                        ),
                      )
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
                          initialValue: buildingAssessment.description,
                          onChanged: (newValue) => {
                            setState(() =>
                                {buildingAssessment.description = newValue})
                          },
                          validator: (value) =>
                              Validators.defaultValidator(value!),
                        ),
                        CustomTextFormField(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary:
                                      Theme.of(context).colorScheme.primary,
                                  textStyle: TextStyle(fontSize: 15)),
                              onPressed: () {
                                // Validates form
                                if (_formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Saving..')),
                                  );
                                  _formKey.currentState!.save();
                                  localSave()
                                      .then((val) {
                                        print("sending.......");
                                        showDialogPopup("", "Draft saved");
                                      })
                                      .onError((error, stackTrace) => null)
                                      .then((value) =>
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar());
                                }
                              },
                              child: const Text("Save Draft"),
                            ),
                            Padding(padding: EdgeInsets.only(right: 10)),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary:
                                      Theme.of(context).colorScheme.primary,
                                  textStyle: TextStyle(fontSize: 15)),
                              onPressed: () {
                                //DatabaseHelper.instance.deleteDatabase("/data/user/0/com.example.msg/databases/msgDatabase.db");
                                // Validates form
                                if (_formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Sending..')),
                                  );
                                  _formKey.currentState!.save();

                                  // Starts sending message process
                                  sendMessage(buildingAssessment
                                      .toMessage()
                                      .toString());
                                }
                              },
                              child: const Text("Finalize"),
                            ),
                            Padding(padding: EdgeInsets.only(left: 10)),
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
                    child: Column(
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
            ),
          ],
        ),
      ),
    );
  }
}

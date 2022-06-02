import 'package:flutter/material.dart';
import 'package:msg/models/BuildingAssessment/building_assessment.dart';
import 'package:msg/screens/building_part_form.dart';
import 'package:msg/screens/history.dart';
import 'package:msg/services/state_service.dart';
import 'package:msg/validators/validate_all.dart';
import 'package:msg/validators/validators.dart';
import 'package:msg/widgets/add_objects_section.dart';
import 'package:msg/widgets/custom_navbar.dart';
import 'package:msg/widgets/custom_text_form_field.dart';
import 'package:msg/widgets/date_form_field.dart';

import '../models/BuildingPart/building_part.dart';
import '../models/Database/database_helper.dart';
import '../services/navigator_service.dart';
import '../services/storage_service.dart';
import '../widgets/custom_popup.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widgets/alert.dart';
import '../widgets/custom_popup.dart';
import '../widgets/custom_dialog.dart' as customDialog;

class BuildingAssessmentForm extends StatefulWidget {
  const BuildingAssessmentForm({Key? key}) : super(key: key);

  @override
  State<BuildingAssessmentForm> createState() => _BuildingAssessmentFormState();
}

class _BuildingAssessmentFormState extends State<BuildingAssessmentForm> {
  final _formKey = GlobalKey<FormState>();
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
    buildingAssessment.appointmentDate = new DateTime.now();
    await DatabaseHelper.instance.persistAssessment(buildingAssessment);
  }

  showFinalizeDialog(bool result) {
    if (result) {
      return showDialog(
        context: context,
        builder: (BuildContext context) => CustomDialog(
          title: const Text(
              "Are you sure you want to finalize this assessment? Further changes will not be possible."),
          actions: [
            ElevatedButton(
              child: const Text("No"),
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                primary: (StorageService.getAppThemeId() == false)
                    ? const Color.fromARGB(220, 112, 14, 46)
                    : const Color.fromARGB(148, 112, 14, 46),
              ),
              onPressed: () => {Navigator.pop(context, true)},
            ),
            ElevatedButton(
              child: const Text("Yes"),
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                primary: (StorageService.getAppThemeId() == false)
                    ? const Color.fromARGB(220, 112, 14, 46)
                    : const Color.fromARGB(148, 112, 14, 46),
              ),
              onPressed: () async => {
                buildingAssessment.finalized = true,
                await saveBuildingAssessment(),
                NavigatorService.navigateTo(context, const HistoryPage())
              },
            ),
          ],
        ),
      );
    } else {
      return showDialog(
          context: context,
          builder: (BuildContext context) => customDialog.CustomDialog(
              text: "Please complete all building part forms."));
    }
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
                                builder: (BuildContext context) => CustomDialog(
                                  title: const Text("Save Changes?"),
                                  actions: [
                                    ElevatedButton(
                                      child: const Text("No"),
                                      style: ElevatedButton.styleFrom(
                                        shape: const StadiumBorder(),
                                        primary:
                                            (StorageService.getAppThemeId() ==
                                                    false)
                                                ? const Color.fromARGB(
                                                    220, 112, 14, 46)
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
                                        primary:
                                            (StorageService.getAppThemeId() ==
                                                    false)
                                                ? const Color.fromARGB(
                                                    220, 112, 14, 46)
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
                          NavigatorService.navigateTo(
                              context, const HistoryPage())
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                      Text(
                        AppLocalizations.of(context)!
                            .buildingAssessmentForm_edit,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: CustomDateFormField(
                                initialValue:
                                    buildingAssessment.appointmentDate,
                                onDateSaved: (newValue) => {
                                  setState((() => {
                                        buildingAssessment.appointmentDate =
                                            newValue
                                      }))
                                },
                              ),
                            ),
                            CustomTextFormField(
                              type: TextInputType.text,
                              labelText:
                                  AppLocalizations.of(context)!.description,
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
                              labelText: AppLocalizations.of(context)!
                                  .buildingAssessment_assessmentCause,
                              initialValue: buildingAssessment.assessmentCause,
                              onChanged: (newValue) => {
                                setState(() => {
                                      dirtyFlag = true,
                                      buildingAssessment.assessmentCause =
                                          newValue,
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
                                  labelText: AppLocalizations.of(context)!
                                      .buildingAssessment_numberOFApartaments,
                                  initialValue: buildingAssessment
                                      .numOfAppartments
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
                                  labelText: AppLocalizations.of(context)!
                                      .buildingAssessment_voulentaryDeduction,
                                  initialValue: buildingAssessment
                                      .voluntaryDeduction
                                      .toString(),
                                  onChanged: (newValue) => {
                                    setState(() => {
                                          dirtyFlag = true,
                                          buildingAssessment
                                                  .voluntaryDeduction =
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
                                  labelText: AppLocalizations.of(context)!
                                      .buildingAssessment_assessmentFee,
                                  initialValue: buildingAssessment.assessmentFee
                                      .toString(),
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
                                    primary: (StorageService.getAppThemeId() ==
                                            false)
                                        ? Color.fromARGB(220, 112, 14, 46)
                                        : Color.fromARGB(148, 112, 14, 46),
                                  ),
                                  onPressed: () async => {
                                    _formKey.currentState!.save(),
                                    await saveBuildingAssessment(),
                                    NavigatorService.navigateTo(
                                        context, const HistoryPage()),
                                  },
                                  label: Text(
                                    AppLocalizations.of(context)!
                                        .buildingAssessment_okButton,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(right: 10)),
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
                                    primary: (StorageService.getAppThemeId() ==
                                            false)
                                        ? Color.fromARGB(220, 112, 14, 46)
                                        : Color.fromARGB(148, 112, 14, 46),
                                  ),
                                  label: Text(
                                      AppLocalizations.of(context)!
                                          .buildingAssessment_cancelButton,
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.white)),
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(right: 10)),
                                ElevatedButton.icon(
                                  icon: const Icon(
                                    Icons.send_rounded,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  onPressed: () async {
                                    // Validates form
                                    if (_formKey.currentState!.validate()) {
                                      if (!buildingAssessment
                                          .buildingParts.isEmpty) {
                                        List<BuildingPart> unvalidParts =
                                            await ValidateAll()
                                                .check(buildingAssessment);
                                        if (unvalidParts.isEmpty) {
                                          showFinalizeDialog(true);
                                          _formKey.currentState!.save();
                                        } else {
                                          showFinalizeDialog(false);
                                        }
                                      } else {
                                        showFinalizeDialog(true);
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    primary: (StorageService.getAppThemeId() ==
                                            false)
                                        ? Color.fromARGB(220, 112, 14, 46)
                                        : Color.fromARGB(148, 112, 14, 46),
                                  ),
                                  label: Text(
                                      AppLocalizations.of(context)!
                                          .buildingAssessment_finalizeButton,
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.white)),
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(left: 10)),
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
        ),
      ),
    );
  }
}

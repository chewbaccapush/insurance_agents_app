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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    getBuildingParts();
    uneditedBuildingAssessment = buildingAssessment.copy();
    super.initState();
  }

  void getBuildingParts() async {
    if (buildingAssessment.id != null) {
      List<BuildingPart> measurementsFromDb = await DatabaseHelper.instance.getBuildingPartsByFk(buildingAssessment.id!);
      setState(() {
        buildingAssessment.buildingParts = measurementsFromDb;
      });
    }
  }

  // Save to database
  Future<void> saveBuildingAssessment() async {
    buildingAssessment.sent = false;
    await DatabaseHelper.instance.persistAssessment(buildingAssessment);
  }

  showFinalizeDialog(bool result) {
    if (result) {
      return showDialog(
        context: context,
        builder: (BuildContext context) => CustomDialog(
          title: Text(AppLocalizations.of(context)!.dialog_finilize),
          twoButtons: true,
          titleButtonOne: Text(AppLocalizations.of(context)!.dialog_no),
          onPressedButtonOne: () => {Navigator.pop(context, true)},
          titleButtonTwo: Text(AppLocalizations.of(context)!.dialog_yes),
          onPressedButtonTwo: () async => {
            buildingAssessment.finalized = true,
            await saveBuildingAssessment(),
            NavigatorService.navigateTo(context, const HistoryPage())
          },
        ),
      );
    } else {
      Text title = Text(AppLocalizations.of(context)!.missingDialog_finalize);
      if (buildingAssessment.buildingParts.isEmpty) {
        title = Text(AppLocalizations.of(context)!.noBuildingParts_finalize);
      }
      return showDialog(
        context: context,
        builder: (BuildContext context) => CustomDialog(
          title: title,
          twoButtons: false,
          titleButtonOne: Icon(Icons.clear),
          onPressedButtonOne: () => {Navigator.pop(context, true)},
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double verticalWidth = MediaQuery.of(context).size.width * 0.88;
    double horzontalWidth = MediaQuery.of(context).size.width * 0.42;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: OrientationBuilder(
          builder: (context, orientation) {
            return orientation == Orientation.portrait
                ? _buildVerticalLayout(verticalWidth)
                : _buildHorizontalLayout(horzontalWidth);
          },
        ),
      ),
    );
  }

  Widget _buildHorizontalLayout(double width) {
    return SingleChildScrollView(
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
                              title: Text(
                                  AppLocalizations.of(context)!.dialog_save),
                              twoButtons: true,
                              titleButtonOne:
                                  Text(AppLocalizations.of(context)!.dialog_no),
                              onPressedButtonOne: () => {
                                NavigatorService.navigateTo(
                                    context, const HistoryPage())
                              },
                              titleButtonTwo: Text(
                                  AppLocalizations.of(context)!.dialog_yes),
                              onPressedButtonTwo: () async => {
                                await saveBuildingAssessment(),
                                NavigatorService.navigateTo(
                                    context, const HistoryPage())
                              },
                            ),
                          ),
                        },
                      NavigatorService.navigateTo(context, const HistoryPage()),
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Text(
                    AppLocalizations.of(context)!.buildingAssessmentForm_edit,
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
                            initialValue: buildingAssessment.appointmentDate,
                            setDirtyFlag: () => {
                              setState(() => {
                                    dirtyFlag = true,
                                  }),
                            },
                          ),
                        ),
                        CustomTextFormField(
                          type: TextInputType.text,
                          labelText: AppLocalizations.of(context)!.description,
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
                              labelText: AppLocalizations.of(context)!
                                  .buildingAssessment_numberOFApartaments,
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
                              labelText: AppLocalizations.of(context)!
                                  .buildingAssessment_voulentaryDeduction,
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
                              suffix: const Icon(FontAwesomeIcons.francSign,
                                  color: Colors.grey),
                              type: const TextInputType.numberWithOptions(
                                  decimal: true),
                              labelText: AppLocalizations.of(context)!
                                  .buildingAssessment_assessmentFee,
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
                                primary: (StorageService.getAppThemeId() ==
                                        false)
                                    ? const Color.fromARGB(220, 112, 14, 46)
                                    : const Color.fromARGB(148, 112, 14, 46),
                              ),
                              onPressed: () async => {
                                await saveBuildingAssessment(),
                                NavigatorService.navigateTo(
                                    context, const HistoryPage()),
                              },
                              label: Text(
                                AppLocalizations.of(context)!
                                    .buildingAssessment_okButton,
                                style: const TextStyle(
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
                              label: Text(
                                  AppLocalizations.of(context)!
                                      .buildingAssessment_cancelButton,
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.white)),
                            ),
                            const Padding(padding: EdgeInsets.only(right: 10)),
                            ElevatedButton.icon(
                              icon: const Icon(
                                Icons.send_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                // Validates form
                                if (_formKey.currentState!.validate()) {
                                  if (buildingAssessment.buildingParts.isNotEmpty) {
                                    List<BuildingPart> unvalidParts = await ValidateAll().check(buildingAssessment);
                                    if (unvalidParts.isEmpty) {
                                      showFinalizeDialog(true);
                                      _formKey.currentState!.save();
                                    } else {
                                      showFinalizeDialog(false);
                                    }
                                  } else {
                                    showFinalizeDialog(false);
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                primary:
                                    (StorageService.getAppThemeId() == false)
                                        ? Color.fromARGB(220, 112, 14, 46)
                                        : Color.fromARGB(148, 112, 14, 46),
                              ),
                              label: Text(
                                  AppLocalizations.of(context)!
                                      .buildingAssessment_finalizeButton,
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.white)),
                            ),
                            const Padding(padding: EdgeInsets.only(left: 10)),
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
                            deleteNotifier: () => getBuildingParts(),
                            width: width,
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

  Widget _buildVerticalLayout(double width) {
    return SingleChildScrollView(
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
                              title: Text(
                                  AppLocalizations.of(context)!.dialog_save),
                              twoButtons: true,
                              titleButtonOne:
                                  Text(AppLocalizations.of(context)!.dialog_no),
                              onPressedButtonOne: () => {
                                NavigatorService.navigateTo(
                                    context, const HistoryPage())
                              },
                              titleButtonTwo: Text(
                                  AppLocalizations.of(context)!.dialog_yes),
                              onPressedButtonTwo: () async => {
                                await saveBuildingAssessment(),
                                NavigatorService.navigateTo(
                                    context, const HistoryPage())
                              },
                            ),
                          ),
                        },
                      NavigatorService.navigateTo(context, const HistoryPage())
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Text(
                    AppLocalizations.of(context)!.buildingAssessmentForm_edit,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: CustomDateFormField(
                          initialValue: buildingAssessment.appointmentDate,
                          setDirtyFlag: () => {
                            setState(() => {
                                  dirtyFlag = true,
                                }),
                          },
                        ),
                      ),
                      CustomTextFormField(
                        type: TextInputType.text,
                        labelText: AppLocalizations.of(context)!.description,
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
                            labelText: AppLocalizations.of(context)!
                                .buildingAssessment_numberOFApartaments,
                            initialValue:
                                buildingAssessment.numOfAppartments.toString(),
                            onChanged: (newValue) => {
                              setState(() => {
                                    dirtyFlag = true,
                                    buildingAssessment.numOfAppartments =
                                        int.parse(newValue)
                                  })
                            },
                            validator: (value) =>
                                Validators.numberOfApartmentsValidator(value!),
                          ),
                          CustomTextFormField(
                            width: 175,
                            type: const TextInputType.numberWithOptions(
                                decimal: true),
                            labelText: AppLocalizations.of(context)!
                                .buildingAssessment_voulentaryDeduction,
                            initialValue: buildingAssessment.voluntaryDeduction
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
                            suffix: const Icon(FontAwesomeIcons.francSign,
                                color: Colors.grey),
                            type: const TextInputType.numberWithOptions(
                                decimal: true),
                            labelText: AppLocalizations.of(context)!
                                .buildingAssessment_assessmentFee,
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
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Column(
                          children: <Widget>[
                            AddObjectsSection(
                              deleteNotifier: () => getBuildingParts(),
                              width: width,
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
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
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
                            primary: (StorageService.getAppThemeId() == false)
                                ? Color.fromARGB(220, 112, 14, 46)
                                //Color.fromARGB(220, 18, 136, 85)
                                : Color.fromARGB(148, 112, 14, 46),
                            //Color.fromARGB(220, 18, 136, 85),
                          ),
                          onPressed: () async => {
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
                            primary: (StorageService.getAppThemeId() == false)
                                ? Color.fromARGB(220, 112, 14, 46)
                                : Color.fromARGB(148, 112, 14, 46),
                          ),
                          label: Text(
                              AppLocalizations.of(context)!
                                  .buildingAssessment_cancelButton,
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.white)),
                        ),
                        const Padding(padding: EdgeInsets.only(right: 10)),
                        ElevatedButton.icon(
                          icon: const Icon(
                            Icons.send_rounded,
                            size: 18,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            // Validates form
                            if (_formKey.currentState!.validate()) {
                              if (!buildingAssessment.buildingParts.isEmpty) {
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
                            primary: (StorageService.getAppThemeId() == false)
                                ? Color.fromARGB(220, 112, 14, 46)
                                : Color.fromARGB(148, 112, 14, 46),
                          ),
                          label: Text(
                              AppLocalizations.of(context)!
                                  .buildingAssessment_finalizeButton,
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.white)),
                        ),
                        const Padding(padding: EdgeInsets.only(left: 10)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

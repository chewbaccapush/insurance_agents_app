import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:msg/models/BuildingAssessment/building_assessment.dart';
import 'package:msg/models/BuildingPart/building_part.dart';
import 'package:msg/models/BuildingPart/fire_protection.dart';
import 'package:msg/models/BuildingPart/construction_class.dart';
import 'package:msg/models/BuildingPart/insured_type.dart';
import 'package:msg/models/BuildingPart/risk_class.dart';
import 'package:msg/models/Database/database_helper.dart';
import 'package:msg/screens/building_assessment_form.dart';
import 'package:msg/screens/measurement_form.dart';
import 'package:msg/services/navigator_service.dart';
import 'package:msg/validators/validate_building_part.dart';
import 'package:msg/validators/validators.dart';
import 'package:msg/widgets/add_objects_section.dart';
import 'package:msg/widgets/custom_dropdown.dart';
import 'package:msg/widgets/custom_popup.dart';
import 'package:msg/widgets/custom_text_form_field.dart';

import '../models/Measurement/measurement.dart';
import '../services/state_service.dart';
import '../services/storage_service.dart';
import '../widgets/custom_navbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BuildingPartForm extends StatefulWidget {
  const BuildingPartForm({Key? key}) : super(key: key);

  @override
  State<BuildingPartForm> createState() => _BuildingPartFormState();
}

class _BuildingPartFormState extends State<BuildingPartForm> {
  final _formKey = GlobalKey<FormState>();
  BuildingAssessment buildingAssessment = StateService.buildingAssessment;
  BuildingPart buildingPart = StateService.buildingPart;
  BuildingPart uneditedBuildingPart = BuildingPart();
  bool dirtyFlag = false;
  var formatter = NumberFormat.decimalPattern('de');

  @override
  void initState() {
    getMeasurements();
    uneditedBuildingPart = buildingPart.copy();
    super.initState();
  }

  // Gets measurements for calculations
  void getMeasurements() async {
    if (buildingPart.id != null) {
      List<Measurement> measurementsFromDb =
          await DatabaseHelper.instance.getMeasurementsByFk(buildingPart.id!);
      setState(() {
        buildingPart.measurements = measurementsFromDb;
      });
    }
  }

  int? getCubature() {
    buildingPart.cubature = 0;
    for (Measurement measurement in buildingPart.measurements) {
      if (buildingPart.cubature != null) {
        buildingPart.cubature = buildingPart.cubature! + measurement.cubature!;
      }
    }
    return buildingPart.cubature!.round();
  }

  int? getValue() {
    buildingPart.value = 0;
    if (double.tryParse(buildingPart.unitPrice.toString()) != null) {
      buildingPart.value = buildingPart.cubature! * buildingPart.unitPrice!;
    }
    return buildingPart.value?.round();
  }

  int? getSumInsured() {
    buildingPart.sumInsured = 0;
    switch (buildingPart.insuredType) {
      case null:
        break;
      case InsuredType.newValue:
        buildingPart.sumInsured = buildingPart.value;
        break;
      case InsuredType.timeValue:
        if (buildingPart.devaluationPercentage != null) {
          buildingPart.sumInsured =
              (buildingPart.devaluationPercentage! / 100) * buildingPart.value!;
        } else {
          buildingPart.sumInsured = 0;
        }
        break;
    }
    return buildingPart.sumInsured?.round();
  }

  void isValid() {
    buildingPart.validated = false;
    if (ValidateBuildingPart().check(buildingPart))
      buildingPart.validated = true;
    print("VALID: ${buildingPart.validated.toString()}");
  }

  saveBuildingPart() async {
    isValid();
    await DatabaseHelper.instance
        .persistBuildingPart(buildingPart, buildingAssessment)
        .then((value) => {
              buildingPart.id = value.id,
              buildingAssessment.id = value.fk_buildingAssesmentId
            });
    if (!buildingAssessment.buildingParts.contains(buildingPart)) {
      buildingAssessment.buildingParts.add(buildingPart);
    }
  }

  @override
  Widget build(BuildContext context) {
    double verticalWidth = MediaQuery.of(context).size.width * 0.88;
    double horizontalWidth = MediaQuery.of(context).size.width * 0.42;
    List<DropdownMenuItem<FireProtection>> fireProtectionList = FireProtection
        .values
        .map<DropdownMenuItem<FireProtection>>((FireProtection value) {
      return DropdownMenuItem<FireProtection>(
        value: value,
        child: Text(value.name.toString()),
      );
    }).toList();

    List<DropdownMenuItem<ConstructionClass>> constructionClassList =
        ConstructionClass.values.map<DropdownMenuItem<ConstructionClass>>(
            (ConstructionClass value) {
      return DropdownMenuItem<ConstructionClass>(
        value: value,
        child: Text(value.name.toString()),
      );
    }).toList();

    List<DropdownMenuItem<InsuredType>> insuredTypeList = InsuredType.values
        .map<DropdownMenuItem<InsuredType>>((InsuredType value) {
      return DropdownMenuItem<InsuredType>(
        value: value,
        child: Text(value.name.toString()),
      );
    }).toList();

    List<DropdownMenuItem<RiskClass>> riskClassList =
        RiskClass.values.map<DropdownMenuItem<RiskClass>>((RiskClass value) {
      return DropdownMenuItem<RiskClass>(
        value: value,
        child: Text(value.name.toString()),
      );
    }).toList();

    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: OrientationBuilder(
            builder: (context, orientation) {
              return orientation == Orientation.portrait
                  ? _buildVerticalLayout(verticalWidth, fireProtectionList,
                      constructionClassList, insuredTypeList, riskClassList)
                  : _buildHorizontalLayout(horizontalWidth, fireProtectionList,
                      constructionClassList, insuredTypeList, riskClassList);
            },
          ),
        ));
  }

  Widget _buildHorizontalLayout(
      double horizontalWidth,
      List<DropdownMenuItem<FireProtection>> fireProtectionList,
      List<DropdownMenuItem<ConstructionClass>> constructionClassList,
      List<DropdownMenuItem<InsuredType>> insuredTypeList,
      List<DropdownMenuItem<RiskClass>> riskClassList) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
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
                                    title: Text(AppLocalizations.of(context)!
                                        .dialog_save),
                                    twoButtons: true,
                                    titleButtonOne: Text(
                                        AppLocalizations.of(context)!
                                            .dialog_no),
                                    onPressedButtonOne: () => {
                                      NavigatorService.navigateTo(context,
                                          const BuildingAssessmentForm())
                                    },
                                    titleButtonTwo: Text(
                                        AppLocalizations.of(context)!
                                            .dialog_yes),
                                    onPressedButtonTwo: () async => {
                                      if (buildingPart.description == null ||
                                          buildingPart.description == "")
                                        {
                                          buildingPart.description = "DRAFT",
                                        },
                                      await saveBuildingPart(),
                                      NavigatorService.navigateTo(context,
                                          const BuildingAssessmentForm())
                                    },
                                  )),
                        },
                      NavigatorService.navigateTo(
                          context, const BuildingAssessmentForm())
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Text(
                    AppLocalizations.of(context)!.buildingAssessment_addButton,
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ],
              ),
            ),
            Form(
              key: _formKey,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CustomTextFormField(
                          type: TextInputType.text,
                          labelText: AppLocalizations.of(context)!.description,
                          initialValue: buildingPart.description,
                          onChanged: (newValue) => {
                            setState(() {
                              dirtyFlag = true;
                              buildingPart.description = newValue;
                            })
                          },
                          validator: (value) =>
                              Validators.defaultValidator(value!),
                        ),
                        CustomTextFormField(
                          type: const TextInputType.numberWithOptions(
                              decimal: false),
                          labelText: AppLocalizations.of(context)!
                              .buildingPartForm_buildingYear,
                          initialValue: buildingPart.buildingYear.toString(),
                          onChanged: (newValue) => {
                            setState(() {
                              dirtyFlag = true;
                              buildingPart.buildingYear =
                                  int.tryParse(newValue);
                            })
                          },
                          validator: (value) => Validators.intValidator(value!),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomDropdown(
                                hint: Text(AppLocalizations.of(context)!
                                    .buildingPart_fireProtection),
                                height: 60,
                                value: buildingPart.fireProtection,
                                validator: (value) =>
                                    value == null ? 'Field required' : null,
                                items: fireProtectionList,
                                onChanged: (newValue) {
                                  setState(() {
                                    dirtyFlag = true;
                                    buildingPart.fireProtection = newValue;
                                  });
                                },
                                width: 170),
                            CustomDropdown(
                                hint: Text(AppLocalizations.of(context)!
                                    .buildingPart_constructionClass),
                                height: 60,
                                value: buildingPart.constructionClass,
                                validator: (value) =>
                                    value == null ? 'Field required' : null,
                                items: constructionClassList,
                                onChanged: (newValue) {
                                  setState(() {
                                    dirtyFlag = true;
                                    buildingPart.constructionClass = newValue;
                                  });
                                },
                                width: 180),
                            CustomDropdown(
                                hint: Text(AppLocalizations.of(context)!
                                    .buildingPart_riskClass),
                                height: 60,
                                value: buildingPart.riskClass,
                                validator: (value) =>
                                    value == null ? 'Field required' : null,
                                items: riskClassList,
                                onChanged: (newValue) {
                                  setState(() {
                                    dirtyFlag = true;
                                    buildingPart.riskClass = newValue;
                                  });
                                },
                                width: 170),
                          ],
                        ),
                        CustomTextFormField(
                          suffix: const Icon(FontAwesomeIcons.francSign,
                              color: Colors.grey),
                          type: TextInputType.numberWithOptions(decimal: true),
                          labelText: AppLocalizations.of(context)!
                              .buildingPart_unitPrice,
                          initialValue: buildingPart.unitPrice.toString(),
                          onChanged: (newValue) => {
                            setState(() {
                              dirtyFlag = true;
                              buildingPart.unitPrice =
                                  double.tryParse(newValue);
                            })
                          },
                          validator: (value) =>
                              Validators.floatValidator(value!),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: CustomDropdown(
                                  hint: Text(AppLocalizations.of(context)!
                                      .buildingPart_insuredType),
                                  height: 53,
                                  value: buildingPart.insuredType,
                                  validator: (value) =>
                                      value == null ? 'Field required' : null,
                                  items: insuredTypeList,
                                  onChanged: (newValue) {
                                    setState(() {
                                      dirtyFlag = true;
                                      buildingPart.insuredType = newValue;
                                    });
                                  },
                                  width: 150),
                            ),
                            CustomTextFormField(
                              suffix: Icon(Icons.percent_rounded,
                                  color: (buildingPart.insuredType ==
                                          InsuredType.timeValue)
                                      ? Colors.grey
                                      : Colors.grey[700]),
                              enabled: buildingPart.insuredType ==
                                      InsuredType.timeValue
                                  ? true
                                  : false,
                              width: 450,
                              type: const TextInputType.numberWithOptions(
                                  decimal: true),
                              labelText: AppLocalizations.of(context)!
                                  .buildingPart_devaluationPercentage,
                              initialValue:
                                  buildingPart.devaluationPercentage.toString(),
                              onChanged: (newValue) => {
                                setState(() {
                                  dirtyFlag = true;
                                  buildingPart.devaluationPercentage =
                                      double.tryParse(newValue);
                                })
                              },
                              validator: (value) {
                                if (buildingPart.getInsuredType ==
                                    InsuredType.timeValue) {
                                  return Validators.floatValidator(value!);
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppLocalizations.of(context)!.cubature +
                                  ': ${formatter.format(getCubature())} m\u00B3'),
                              Text(AppLocalizations.of(context)!.value +
                                  ': ${formatter.format(getValue())} \u20A3'),
                              Text(AppLocalizations.of(context)!.sumInsured +
                                  ': ${formatter.format(getSumInsured())} \u20A3'),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
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
                                  primary: (StorageService.getAppThemeId() ==
                                          false)
                                      ? const Color.fromARGB(235, 141, 130, 6)
                                      : const Color.fromARGB(235, 141, 130, 6),
                                ),
                                label: Text(
                                  AppLocalizations.of(context)!
                                      .buildingAssessment_okButton,
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                                onPressed: () async => {
                                  if (_formKey.currentState!.validate())
                                    {
                                      buildingPart.validated = true,
                                      await saveBuildingPart(),
                                      NavigatorService.navigateTo(context,
                                          const BuildingAssessmentForm())
                                    }
                                },
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
                                    NavigatorService.navigateTo(context,
                                        const BuildingAssessmentForm());
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
                              ),
                            ],
                          ),
                        ),
                        //Cubature
                        //Value
                        //Sum Insured
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      children: <Widget>[
                        AddObjectsSection(
                          deleteNotifier: () => getMeasurements(),
                          width: horizontalWidth,
                          objectType: ObjectType.measurement,
                          onPressed: () => {
                            StateService.measurement = Measurement(),
                            NavigatorService.navigateTo(
                                context, const MeasurementForm())
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

  Widget _buildVerticalLayout(
      double verticalWidth,
      List<DropdownMenuItem<FireProtection>> fireProtectionList,
      List<DropdownMenuItem<ConstructionClass>> constructionClassList,
      List<DropdownMenuItem<InsuredType>> insuredTypeList,
      List<DropdownMenuItem<RiskClass>> riskClassList) {
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
                      isValid(),
                      if (dirtyFlag)
                        {
                          await showDialog(
                              context: context,
                              builder: (BuildContext context) => CustomDialog(
                                    title: Text(AppLocalizations.of(context)!
                                        .dialog_save),
                                    twoButtons: true,
                                    titleButtonOne: Text(
                                        AppLocalizations.of(context)!
                                            .dialog_no),
                                    onPressedButtonOne: () => {
                                      NavigatorService.navigateTo(context,
                                          const BuildingAssessmentForm())
                                    },
                                    titleButtonTwo: Text(
                                        AppLocalizations.of(context)!
                                            .dialog_yes),
                                    onPressedButtonTwo: () async => {
                                      if (buildingPart.description == null ||
                                          buildingPart.description == "")
                                        {
                                          buildingPart.description = "DRAFT",
                                        },
                                      await saveBuildingPart(),
                                      NavigatorService.navigateTo(context,
                                          const BuildingAssessmentForm())
                                    },
                                  )),
                        },
                      NavigatorService.navigateTo(
                          context, const BuildingAssessmentForm())
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Text(
                    AppLocalizations.of(context)!.buildingAssessment_addButton,
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ],
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: [
                      CustomTextFormField(
                        type: TextInputType.text,
                        labelText: AppLocalizations.of(context)!.description,
                        initialValue: buildingPart.description,
                        onChanged: (newValue) => {
                          setState(() {
                            dirtyFlag = true;
                            buildingPart.description = newValue;
                          })
                        },
                        validator: (value) =>
                            Validators.defaultValidator(value!),
                      ),
                      CustomTextFormField(
                        type: const TextInputType.numberWithOptions(
                            decimal: false),
                        labelText: AppLocalizations.of(context)!
                            .buildingPartForm_buildingYear,
                        initialValue: buildingPart.buildingYear.toString(),
                        onChanged: (newValue) => {
                          setState(() {
                            dirtyFlag = true;
                            buildingPart.buildingYear = int.tryParse(newValue);
                          })
                        },
                        validator: (value) => Validators.intValidator(value!),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomDropdown(
                              hint: Text(AppLocalizations.of(context)!
                                  .buildingPart_fireProtection),
                              height: 60,
                              value: buildingPart.fireProtection,
                              validator: (value) =>
                                  value == null ? 'Field required' : null,
                              items: fireProtectionList,
                              onChanged: (newValue) {
                                setState(() {
                                  dirtyFlag = true;
                                  buildingPart.fireProtection = newValue;
                                });
                              },
                              width: 170),
                          CustomDropdown(
                              hint: Text(AppLocalizations.of(context)!
                                  .buildingPart_constructionClass),
                              height: 60,
                              value: buildingPart.constructionClass,
                              validator: (value) =>
                                  value == null ? 'Field required' : null,
                              items: constructionClassList,
                              onChanged: (newValue) {
                                setState(() {
                                  dirtyFlag = true;
                                  buildingPart.constructionClass = newValue;
                                });
                              },
                              width: 170),
                          CustomDropdown(
                              hint: Text(AppLocalizations.of(context)!
                                  .buildingPart_riskClass),
                              height: 60,
                              value: buildingPart.riskClass,
                              validator: (value) =>
                                  value == null ? 'Field required' : null,
                              items: riskClassList,
                              onChanged: (newValue) {
                                setState(() {
                                  dirtyFlag = true;
                                  buildingPart.riskClass = newValue;
                                });
                              },
                              width: 170),
                        ],
                      ),
                      CustomTextFormField(
                        suffix: const Icon(FontAwesomeIcons.francSign,
                            color: Colors.grey),
                        type: TextInputType.numberWithOptions(decimal: true),
                        labelText: AppLocalizations.of(context)!
                            .buildingPart_unitPrice,
                        initialValue: buildingPart.unitPrice.toString(),
                        onChanged: (newValue) => {
                          setState(() {
                            dirtyFlag = true;
                            buildingPart.unitPrice = double.tryParse(newValue);
                          })
                        },
                        validator: (value) => Validators.floatValidator(value!),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, right: 30),
                            child: CustomDropdown(
                                hint: Text(AppLocalizations.of(context)!
                                    .buildingPart_insuredType),
                                height: 50,
                                value: buildingPart.insuredType,
                                validator: (value) =>
                                    value == null ? 'Field required' : null,
                                items: insuredTypeList,
                                onChanged: (newValue) {
                                  setState(() {
                                    dirtyFlag = true;
                                    buildingPart.insuredType = newValue;
                                  });
                                },
                                width: 150),
                          ),
                          CustomTextFormField(
                            suffix: Icon(Icons.percent_rounded,
                                color: (buildingPart.insuredType ==
                                        InsuredType.timeValue)
                                    ? Colors.grey
                                    : Colors.grey[700]),
                            enabled: buildingPart.insuredType ==
                                    InsuredType.timeValue
                                ? true
                                : false,
                            width: 450,
                            type: const TextInputType.numberWithOptions(
                                decimal: true),
                            labelText: AppLocalizations.of(context)!
                                .buildingPart_devaluationPercentage,
                            initialValue:
                                buildingPart.devaluationPercentage.toString(),
                            onChanged: (newValue) => {
                              setState(() {
                                dirtyFlag = true;
                                buildingPart.devaluationPercentage =
                                    double.tryParse(newValue);
                              })
                            },
                            validator: (value) {
                              if (buildingPart.getInsuredType ==
                                  InsuredType.timeValue) {
                                return Validators.floatValidator(value!);
                              } else {
                                return null;
                              }
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.of(context)!.cubature +
                                ': ${getCubature()} m\u00B3'),
                            Text(AppLocalizations.of(context)!.value +
                                ': ${getValue()} \u20A3'),
                            Text(AppLocalizations.of(context)!.sumInsured +
                                ': ${getSumInsured()} \u20A3'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      AddObjectsSection(
                        deleteNotifier: () => getMeasurements(),
                        width: verticalWidth,
                        objectType: ObjectType.measurement,
                        onPressed: () => {
                          StateService.measurement = Measurement(),
                          NavigatorService.navigateTo(
                              context, const MeasurementForm())
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, right: 10),
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
                                ? const Color.fromARGB(235, 141, 130, 6)
                                : const Color.fromARGB(235, 141, 130, 6),
                          ),
                          label: Text(
                            AppLocalizations.of(context)!
                                .buildingAssessment_okButton,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.white),
                          ),
                          onPressed: () async => {
                            if (_formKey.currentState!.validate())
                              {
                                buildingPart.validated = true,
                                await saveBuildingPart(),
                                NavigatorService.navigateTo(
                                    context, const BuildingAssessmentForm())
                              }
                          },
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
                                  context, const BuildingAssessmentForm());
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

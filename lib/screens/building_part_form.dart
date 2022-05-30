import 'package:flutter/material.dart';
import 'package:msg/models/BuildingAssessment/building_assessment.dart';
import 'package:msg/models/BuildingPart/building_part.dart';
import 'package:msg/models/BuildingPart/fire_protection.dart';
import 'package:msg/models/BuildingPart/construction_class.dart';
import 'package:msg/models/BuildingPart/insured_type.dart';
import 'package:msg/models/BuildingPart/risk_class.dart';
import 'package:msg/models/Database/database_helper.dart';
import 'package:msg/screens/building_assessment_form.dart';
import 'package:msg/screens/history.dart';
import 'package:msg/screens/measurement_form.dart';
import 'package:msg/screens/settings.dart';
import 'package:msg/validators/validators.dart';
import 'package:msg/widgets/add_objects_section.dart';
import 'package:msg/widgets/custom_dropdown.dart';
import 'package:msg/widgets/custom_text_form_field.dart';

import '../services/storage_service.dart';
import '../widgets/custom_navbar.dart';

class BuildingPartForm extends StatefulWidget {
  final BuildingAssessment buildingAssessment;
  final BuildingPart? buildingPart;
  const BuildingPartForm(
      {Key? key, required this.buildingAssessment, this.buildingPart})
      : super(key: key);

  @override
  State<BuildingPartForm> createState() => _BuildingPartFormState();
}

class _BuildingPartFormState extends State<BuildingPartForm> {
  final _formKey = GlobalKey<FormState>();
  BuildingPart buildingPart = BuildingPart();
  bool dirtyFlag = false;
  @override
  void initState() {
    buildingPart = widget.buildingPart ??
        BuildingPart(
          fireProtection: FireProtection.bma,
          constructionClass: ConstructionClass.mixedConstruction,
          riskClass: RiskClass.one,
          insuredType: InsuredType.newValue,
        );
    super.initState();
  }

  Future<BuildingPart> saveBuildingPart() async {
    // BuildingAssessment tempAssessment = await DatabaseHelper.instance.persistAssessmentFromPart(widget.buildingAssessment);
    return await DatabaseHelper.instance
        .persistBuildingPart(buildingPart, widget.buildingAssessment);
  }

  @override
  Widget build(BuildContext context) {
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
                      if (!widget.buildingAssessment.buildingParts
                          .contains(buildingPart))
                        {
                          if (buildingPart.description == null)
                            {
                              buildingPart.description = "DRAFT",
                            },
                          await saveBuildingPart().then((value) {
                            buildingPart.id = value.id;
                            widget.buildingAssessment.id =
                                value.fk_buildingAssesmentId;
                          }),
                          widget.buildingAssessment.buildingParts
                              .add(buildingPart),
                        },
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: ((context) => BuildingAssessmentForm(
                              buildingAssessment: widget.buildingAssessment)),
                        ),
                      )
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Text(
                    "Add Building Part",
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
                        CustomTextFormField(
                          type: TextInputType.text,
                          labelText: "Description",
                          initialValue: buildingPart.description,
                          onChanged: (newValue) => {
                            setState(() {
                              buildingPart.description = newValue;
                            })
                          },
                          validator: (value) =>
                              Validators.defaultValidator(value!),
                        ),
                        CustomTextFormField(
                          type: const TextInputType.numberWithOptions(
                              decimal: false),
                          labelText: "Building Year",
                          initialValue: buildingPart.buildingYear.toString(),
                          onChanged: (newValue) => {
                            setState(() {
                              buildingPart.buildingYear = int.parse(newValue);
                            })
                          },
                          validator: (value) => Validators.intValidator(value!),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomDropdown(
                                height: 60,
                                value: buildingPart.fireProtection,
                                items: fireProtectionList,
                                onChanged: (newValue) {
                                  setState(() {
                                    buildingPart.fireProtection = newValue;
                                  });
                                },
                                width: 170),
                            CustomDropdown(
                                height: 60,
                                value: buildingPart.constructionClass,
                                items: constructionClassList,
                                onChanged: (newValue) {
                                  setState(() {
                                    buildingPart.constructionClass = newValue;
                                  });
                                },
                                width: 170),
                            CustomDropdown(
                                height: 60,
                                value: buildingPart.riskClass,
                                items: riskClassList,
                                onChanged: (newValue) {
                                  setState(() {
                                    buildingPart.riskClass = newValue;
                                  });
                                },
                                width: 170),
                          ],
                        ),
                        CustomTextFormField(
                          suffix: const Icon(Icons.euro, color: Colors.grey),
                          type: const TextInputType.numberWithOptions(
                              decimal: true),
                          labelText: "Unit Price",
                          initialValue: buildingPart.unitPrice.toString(),
                          onChanged: (newValue) => {
                            setState(() {
                              buildingPart.unitPrice = double.parse(newValue);
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
                                  height: 60,
                                  value: buildingPart.insuredType,
                                  items: insuredTypeList,
                                  onChanged: (newValue) {
                                    setState(() {
                                      buildingPart.insuredType = newValue;
                                    });
                                  },
                                  width: 110),
                            ),
                            CustomTextFormField(
                              suffix: Icon(Icons.percent_rounded,
                                  color: (buildingPart.insuredType ==
                                          InsuredType.timeValue)
                                      ? Colors.grey
                                      : Colors.grey[700]),
                              enabeled: buildingPart.insuredType ==
                                      InsuredType.timeValue
                                  ? true
                                  : false,
                              width: 450,
                              type: const TextInputType.numberWithOptions(
                                  decimal: true),
                              labelText: "Devaluation percentage",
                              initialValue:
                                  buildingPart.devaluationPercentage.toString(),
                              onChanged: (newValue) => {
                                setState(() {
                                  buildingPart.devaluationPercentage =
                                      double.parse(newValue);
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
                                if (_formKey.currentState!.validate())
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Saving..')),
                                    ),
                                    await saveBuildingPart().then((value) =>
                                        widget.buildingAssessment.id =
                                            value.fk_buildingAssesmentId),
                                    if (!widget.buildingAssessment.buildingParts
                                        .contains(buildingPart))
                                      {
                                        widget.buildingAssessment.buildingParts
                                            .add(buildingPart)
                                      },
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BuildingAssessmentForm(
                                                buildingAssessment:
                                                    widget.buildingAssessment),
                                      ),
                                    )
                                  }
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
                                  Navigator.of(context).pop();
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
                            ),
                          ],
                        )
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
                          objectType: ObjectType.measurement,
                          buildingPart: buildingPart,
                          buildingAssessment: widget.buildingAssessment,
                          onPressed: () => {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MeasurementForm(
                                    buildingAssessment:
                                        widget.buildingAssessment,
                                    buildingPart: buildingPart),
                              ),
                            ),
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

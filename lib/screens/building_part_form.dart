import 'package:flutter/material.dart';
import 'package:msg/models/BuildingAssessment/building_assessment.dart';
import 'package:msg/models/BuildingPart/building_part.dart';
import 'package:msg/models/BuildingPart/fire_protection.dart';
import 'package:msg/models/BuildingPart/construction_class.dart';
import 'package:msg/models/BuildingPart/insured_type.dart';
import 'package:msg/models/BuildingPart/risk_class.dart';
import 'package:msg/screens/building_assessment_form.dart';
import 'package:msg/screens/history.dart';
import 'package:msg/screens/measurement_form.dart';
import 'package:msg/screens/settings.dart';
import 'package:msg/validators/validators.dart';
import 'package:msg/widgets/add_objects_section.dart';
import 'package:msg/widgets/custom_dropdown.dart';
import 'package:msg/widgets/custom_text_form_field.dart';

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
                          builder: ((context) => BuildingAssessmentForm(
                              buildingAssessment: widget.buildingAssessment)),
                        ),
                      )
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Text(
                    "Add Building Part",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              firstIcon: Icon(Icons.history),
              secondIcon: Icon(Icons.settings),
              firstDestination: HistoryPage(),
              secondDestination: SettingsPage(),
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
                                value: buildingPart.fireProtection,
                                items: fireProtectionList,
                                onChanged: (newValue) {
                                  setState(() {
                                    buildingPart.fireProtection = newValue;
                                  });
                                },
                                width: 170),
                            CustomDropdown(
                                value: buildingPart.constructionClass,
                                items: constructionClassList,
                                onChanged: (newValue) {
                                  setState(() {
                                    buildingPart.constructionClass = newValue;
                                  });
                                },
                                width: 170),
                            CustomDropdown(
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
                            CustomDropdown(
                                value: buildingPart.insuredType,
                                items: insuredTypeList,
                                onChanged: (newValue) {
                                  setState(() {
                                    buildingPart.insuredType = newValue;
                                  });
                                },
                                width: 100),
                            CustomTextFormField(
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
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(148, 135, 18, 57),
                              textStyle: TextStyle(fontSize: 15)),
                          onPressed: () => {
                            if (_formKey.currentState!.validate())
                              {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Saving..')),
                                ),
                                setState(() {
                                  widget.buildingAssessment.buildingParts
                                      .add(buildingPart);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BuildingAssessmentForm(
                                              buildingAssessment:
                                                  widget.buildingAssessment),
                                    ),
                                  );
                                })
                              },
                          },
                          child: const Text("Add"),
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

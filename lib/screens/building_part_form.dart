import 'package:flutter/material.dart';
import 'package:msg/models/BuildingAssessment/building_assessment.dart';
import 'package:msg/models/BuildingPart/building_part.dart';
import 'package:msg/models/BuildingPart/fire_protection.dart';
import 'package:msg/models/BuildingPart/construction_class.dart';
import 'package:msg/models/BuildingPart/insured_type.dart';
import 'package:msg/models/BuildingPart/risk_class.dart';
import 'package:msg/screens/building_assessment_form.dart';
import 'package:msg/screens/building_measurement_form.dart';
import 'package:msg/widgets/add_objects_section.dart';
import 'package:msg/widgets/custom_text_form_field.dart';

class BuildingPartForm extends StatefulWidget {
  final BuildingAssessment? buildingAssessment;
  final BuildingPart? buildingPart;
  const BuildingPartForm({Key? key, this.buildingAssessment, this.buildingPart})
      : super(key: key);

  @override
  State<BuildingPartForm> createState() => _BuildingPartFormState();
}

class _BuildingPartFormState extends State<BuildingPartForm> {
  final _formKey = GlobalKey<FormState>();
  BuildingPart buildingPart = BuildingPart();
  BuildingAssessment buildingAssessment = BuildingAssessment();

  @override
  void initState() {
    buildingPart = widget.buildingPart ??
        BuildingPart(
          fireProtection: FireProtection.bma,
          constructionClass: ConstructionClass.mixedConstruction,
          riskClass: RiskClass.one,
          insuredType: InsuredType.newValue,
        );
    buildingAssessment = widget.buildingAssessment ?? BuildingAssessment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<FireProtection>> fireProtectionList = FireProtection
        .values
        .map<DropdownMenuItem<FireProtection>>((FireProtection value) {
      return DropdownMenuItem<FireProtection>(
        value: value,
        child: Text(value.toString()),
      );
    }).toList();

    List<DropdownMenuItem<ConstructionClass>> constructionClassList =
        ConstructionClass.values.map<DropdownMenuItem<ConstructionClass>>(
            (ConstructionClass value) {
      return DropdownMenuItem<ConstructionClass>(
        value: value,
        child: Text(value.toString()),
      );
    }).toList();

    List<DropdownMenuItem<InsuredType>> insuredTypeList = InsuredType.values
        .map<DropdownMenuItem<InsuredType>>((InsuredType value) {
      return DropdownMenuItem<InsuredType>(
        value: value,
        child: Text(value.toString()),
      );
    }).toList();

    List<DropdownMenuItem<RiskClass>> riskClassList =
        RiskClass.values.map<DropdownMenuItem<RiskClass>>((RiskClass value) {
      return DropdownMenuItem<RiskClass>(
        value: value,
        child: Text(value.toString()),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Add Building Part")),
      body: Container(
        padding: const EdgeInsets.all(50.0),
        child: Form(
          key: _formKey,
          child: Row(
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
                            }),
                    DropdownButton<FireProtection>(
                      value: buildingPart.fireProtection,
                      items: fireProtectionList,
                      onChanged: (newValue) {
                        setState(() {
                          buildingPart.fireProtection = newValue;
                        });
                      },
                    ),
                    DropdownButton<ConstructionClass>(
                      value: buildingPart.constructionClass,
                      items: constructionClassList,
                      onChanged: (newValue) {
                        setState(() {
                          buildingPart.constructionClass = newValue;
                        });
                      },
                    ),
                    DropdownButton<RiskClass>(
                      value: buildingPart.riskClass,
                      items: riskClassList,
                      onChanged: (newValue) {
                        setState(() {
                          buildingPart.riskClass = newValue;
                        });
                      },
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
                            }),
                    DropdownButton<InsuredType>(
                      value: buildingPart.insuredType,
                      items: insuredTypeList,
                      onChanged: (newValue) {
                        setState(() {
                          buildingPart.insuredType = newValue;
                        });
                      },
                    ),
                    CustomTextFormField(
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
                            }),
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
                        onPressed: () => {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => BuildingMeasurementForm(
                                    buildingPart: buildingPart),
                              )),
                            }),
                    OutlinedButton(
                      onPressed: () => {
                        setState(() {
                          buildingAssessment.buildingParts.add(buildingPart);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => BuildingAssessmentForm(
                                  buildingAssessment: buildingAssessment)));
                        }),
                      },
                      child: const Text("Add"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:msg/models/BuildingPart/building_part.dart';
import 'package:msg/models/BuildingPart/fire_protection.dart';
import 'package:msg/models/BuildingPart/construction_class.dart';
import 'package:msg/models/BuildingPart/insured_type.dart';
import 'package:msg/models/BuildingPart/risk_class.dart';
import 'package:msg/models/Measurement/measurement.dart';
import 'package:msg/widgets/add_objects_section.dart';
import 'package:msg/widgets/custom_text_form_field.dart';

class BuildingPartForm extends StatefulWidget {
  const BuildingPartForm({Key? key}) : super(key: key);

  @override
  State<BuildingPartForm> createState() => _BuildingPartFormState();
}

class _BuildingPartFormState extends State<BuildingPartForm> {
  final _formKey = GlobalKey<FormState>();
  BuildingPart buildingPart = BuildingPart(
      fireProtection: FireProtection.bma,
      constructionClass: ConstructionClass.mixedConstruction,
      riskClass: RiskClass.one,
      insuredType: InsuredType.newValue,
      measurements: [
        Measurement(description: "description"),
        Measurement(description: "description1"),
        Measurement(description: "description2"),
        Measurement(description: "description3")
      ]);

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

    return Form(
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
                    type: const TextInputType.numberWithOptions(decimal: false),
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
                    type: const TextInputType.numberWithOptions(decimal: true),
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
                    type: TextInputType.numberWithOptions(decimal: true),
                    labelText: "Devaluation percentage",
                    initialValue: buildingPart.devaluationPercentage.toString(),
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
                  buildingPart: buildingPart,
                ),
                OutlinedButton(
                    onPressed: () => {
                          setState(() {}),
                        },
                    child: const Text("Add"))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

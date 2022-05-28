// ignore_for_file: unnecessary_this

import 'dart:ffi';
import 'dart:math';
import 'package:enum_to_string/enum_to_string.dart';

import 'package:msg/models/BuildingPart/construction_class.dart';
import 'package:msg/models/BuildingPart/fire_protection.dart';
import 'package:msg/models/BuildingPart/insured_type.dart';
import 'package:msg/models/Measurement/measurement.dart';
import 'package:msg/models/BuildingPart/risk_class.dart';

const String tableBuildingPart = 'buildingPart';

class BuildingPartFields {
  static final List<String> values = [
    id,
    description,
    buildingYear,
    fireProtection,
    constructionClass,
    riskClass,
    unitPrice,
    insuredType,
    devaluationPercentage,
    cubature,
    value,
    sumInsured,
  ];

  static const String id = 'buildingPartId';
  static const String description = 'description';
  static const String buildingYear = 'buildingYear';
  static const String fireProtection = 'fireProtection';
  static const String constructionClass = 'constructionClass';
  static const String riskClass = 'riskClass';
  static const String unitPrice = 'unitPrice';
  static const String insuredType = 'insuredType';
  static const String devaluationPercentage = 'devaluationPercentage';
  static const String cubature = 'cubature';
  static const String value = 'value';
  static const String sumInsured = 'sumInsured';
  static const String buildingAssesment = 'fk_buildingAssessmentId';
  static const String measurements = 'measurements';
}

class BuildingPart {
  int? id;
  String? description;
  int? buildingYear;
  FireProtection? fireProtection;
  ConstructionClass? constructionClass;
  RiskClass? riskClass;
  double? unitPrice;
  InsuredType? insuredType;
  double? devaluationPercentage;
  double? cubature = 0.0;
  double? value;
  double? sumInsured;
  int? fk_buildingAssesmentId;
  List<Measurement> measurements;

  BuildingPart(
      {this.id,
      this.description,
      this.buildingYear,
      this.fireProtection,
      this.constructionClass,
      this.riskClass,
      this.unitPrice,
      this.insuredType,
      this.devaluationPercentage,
      this.cubature,
      this.value,
      this.sumInsured,
      this.fk_buildingAssesmentId,
      List<Measurement>? measurements})
      : measurements = measurements ?? [];

  Map<String, dynamic> toJson() {
    return {
      BuildingPartFields.id: id,
      BuildingPartFields.description: description,
      BuildingPartFields.buildingYear: buildingYear,
      BuildingPartFields.fireProtection:
          EnumToString.convertToString(fireProtection),
      BuildingPartFields.constructionClass:
          EnumToString.convertToString(constructionClass),
      BuildingPartFields.riskClass: EnumToString.convertToString(riskClass),
      BuildingPartFields.unitPrice: unitPrice,
      BuildingPartFields.insuredType: EnumToString.convertToString(insuredType),
      BuildingPartFields.devaluationPercentage: devaluationPercentage,
      BuildingPartFields.cubature: cubature,
      BuildingPartFields.sumInsured: sumInsured,
      BuildingPartFields.value: value,
      BuildingPartFields.buildingAssesment: fk_buildingAssesmentId
    };
  }

  Map<String, dynamic> toMessage() {
    List measurementsJson = [];
    measurements.forEach((measrement) {
      measurementsJson.add(measrement.toMessage());
    });
    return {
      BuildingPartFields.description: description,
      BuildingPartFields.buildingYear: buildingYear,
      BuildingPartFields.fireProtection:
          EnumToString.convertToString(fireProtection),
      BuildingPartFields.constructionClass:
          EnumToString.convertToString(constructionClass),
      BuildingPartFields.riskClass: EnumToString.convertToString(riskClass),
      BuildingPartFields.unitPrice: unitPrice,
      BuildingPartFields.insuredType: EnumToString.convertToString(insuredType),
      BuildingPartFields.devaluationPercentage: devaluationPercentage,
      BuildingPartFields.cubature: cubature,
      BuildingPartFields.sumInsured: sumInsured,
      BuildingPartFields.value: value,
      BuildingPartFields.measurements: measurementsJson,
    };
  }

  static BuildingPart fromJson(Map<String, dynamic> json) {
    return BuildingPart(
      id: int.tryParse(json[BuildingPartFields.id].toString()),
      description: json[BuildingPartFields.description] as String?,
      buildingYear: int.tryParse(json[BuildingPartFields.buildingYear].toString()),
      fireProtection: EnumToString.fromString(FireProtection.values, json[BuildingPartFields.fireProtection]) as FireProtection?,
      constructionClass: EnumToString.fromString(ConstructionClass.values,
          json[BuildingPartFields.constructionClass]) as ConstructionClass?,
      riskClass: EnumToString.fromString(RiskClass.values, json[BuildingPartFields.riskClass]) as RiskClass?,
      unitPrice: double.tryParse(json[BuildingPartFields.unitPrice].toString()),
      insuredType: EnumToString.fromString(
              InsuredType.values, json[BuildingPartFields.insuredType])
          as InsuredType?,
      cubature: double.tryParse(json[BuildingPartFields.cubature].toString()),
      devaluationPercentage: double.tryParse(
          json[BuildingPartFields.devaluationPercentage].toString()),
      value: double.tryParse(json[BuildingPartFields.value].toString()),
      sumInsured: double.tryParse(json[BuildingPartFields.sumInsured].toString()),
    );
  }

  BuildingPart copy({
    int? id,
    String? description,
    int? buildingYear,
    FireProtection? fireProtection,
    ConstructionClass? constructionClass,
    RiskClass? riskClass,
    double? unitPrice,
    InsuredType? insuredType,
    double? devaluationPercentage,
    double? cubature,
    double? value,
    double? sumInsured,
    int? fk_buildingAssesmentId,
  }) =>
      BuildingPart(
        id: id ?? this.id,
        description: description ?? this.description,
        buildingYear: buildingYear ?? this.buildingYear,
        fireProtection: fireProtection ?? this.fireProtection,
        constructionClass: constructionClass ?? this.constructionClass,
        riskClass: riskClass ?? this.riskClass,
        unitPrice: unitPrice ?? this.unitPrice,
        insuredType: insuredType ?? this.insuredType,
        devaluationPercentage:
            devaluationPercentage ?? this.devaluationPercentage,
        cubature: cubature ?? this.cubature,
        value: value ?? this.value,
        sumInsured: sumInsured ?? this.sumInsured,
        fk_buildingAssesmentId: fk_buildingAssesmentId ?? this.fk_buildingAssesmentId
      );

  calculateAll(Measurement measurement) {
    calculateCubature(measurement);
    calculateValue();
    calculateSumInsured();
  }

  calculateCubature(Measurement measurement) {
    /*
    if(measurement.length == null) {
      cubature = measurement.radius * measurement.radius * measurement.height;
    } else {
      cubature = measurement.length * measurement.height * measurement.width;
    }
    */
  }

  calculateValue() {
    // value = cubature * unitPrice;
  }

  calculateSumInsured() {
    if (insuredType == InsuredType.newValue) {
      sumInsured = value;
    } else if (insuredType == InsuredType.timeValue) {
      // sumInsured = value - (devaluationPercentage * value);
    } else {
      throw Exception("Wrong Insured Type");
    }
  }

  get getId => this.id;

  set setId(id) => this.id = id;

  get getBuildingYear => this.buildingYear;

  set setBuildingYear(buildingYear) => this.buildingYear = buildingYear;

  get getFireProtection => this.fireProtection;

  set setFireProtection(fireProtection) => this.fireProtection = fireProtection;

  get getConstructionClass => this.constructionClass;

  set setConstructionClass(constructionClass) =>
      this.constructionClass = constructionClass;

  get getRiskClass => this.riskClass;

  set setRiskClass(riskClass) => this.riskClass = riskClass;

  get getUnitPrice => this.unitPrice;

  set setUnitPrice(unitPrice) => this.unitPrice = unitPrice;

  get getInsuredType => this.insuredType;

  set setInsuredType(insuredType) => this.insuredType = insuredType;

  get getDevaluationPercentage => this.devaluationPercentage;

  set setDevaluationPercentage(devaluationPercentage) =>
      this.devaluationPercentage = devaluationPercentage;

  get getValue => this.value;

  set setValue(value) => this.value = value;

  get getSumInsured => this.sumInsured;

  set setSumInsured(sumInsured) => this.sumInsured = sumInsured;

  get getMeasurments => measurements;

  set setMeasurments(measurments) => measurements = measurments;
}

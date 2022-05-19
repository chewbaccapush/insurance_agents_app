import 'dart:ffi';

import 'package:msg/models/BuildingPart/construction_class.dart';
import 'package:msg/models/BuildingPart/fire_protection.dart';
import 'package:msg/models/BuildingPart/insured_type.dart';
import 'package:msg/models/Measurement/measurement.dart';
import 'package:msg/models/BuildingPart/risk_class.dart';

const String tableBuildingPart = 'buildingPart';

class BuildingPartFields {
   static final List<String> values= [
    id, description, buildingYear, fireProtection, constructionClass, riskClass, unitPrice, insuredType, devaluationPercentage, cubature, value, sumInsured, measurements
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
  static const String measurements = 'fk_measurementId';
}

class BuildingPart {
  int? id;
  String description; 
  int buildingYear;
  FireProtection fireProtection;
  ConstructionClass constructionClass;
  RiskClass riskClass;
  double unitPrice;
  InsuredType insuredType;
  double devaluationPercentage;
  double cubature; 
  double value;
  double sumInsured;
  List<Measurement> measurements;

  BuildingPart({
    this.id,
    required this.description,
    required this.buildingYear,
    required this.fireProtection,
    required this.constructionClass,
    required this.riskClass,
    required this.unitPrice,
    required this.insuredType,
    required this.devaluationPercentage,
    required this.cubature,
    required this.value,
    required this.sumInsured,
    required this.measurements
  });

   Map<String, dynamic> toJson() {
    return {
      BuildingPartFields.id: id,
      BuildingPartFields.description: description,
      BuildingPartFields.buildingYear: buildingYear,
      BuildingPartFields.fireProtection: fireProtection,
      BuildingPartFields.constructionClass: constructionClass,
      BuildingPartFields.riskClass: riskClass,
      BuildingPartFields.unitPrice: unitPrice,
      BuildingPartFields.insuredType: insuredType,
      BuildingPartFields.devaluationPercentage: devaluationPercentage,
      BuildingPartFields.cubature: cubature,
      BuildingPartFields.measurements: measurements,
    };
  }

  static BuildingPart fromJson(Map<String,Object?> json) =>
    BuildingPart(                                             
      id: json[BuildingPartFields.id] as int?,
      description: json[BuildingPartFields.description] as String,
      buildingYear: json[BuildingPartFields.buildingYear] as int,
      fireProtection: json[BuildingPartFields.fireProtection] as FireProtection,
      constructionClass: json[BuildingPartFields.constructionClass] as ConstructionClass,
      riskClass: json[BuildingPartFields.riskClass] as RiskClass,
      unitPrice:json[BuildingPartFields.unitPrice] as double,
      insuredType:json[BuildingPartFields.insuredType] as InsuredType,
      cubature: json[BuildingPartFields.cubature] as double,
      devaluationPercentage: json[BuildingPartFields.devaluationPercentage] as double,
      value: json[BuildingPartFields.value] as double,
      sumInsured: json[BuildingPartFields.sumInsured] as double,
      measurements: json[BuildingPartFields.measurements] as List<Measurement>,
  );
  
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
    List<Measurement>? measurements,
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
      devaluationPercentage: devaluationPercentage ?? this.devaluationPercentage,
      cubature: cubature ?? this.cubature,
      value: value ?? this.value,
      sumInsured: sumInsured ?? this.sumInsured,
      measurements: measurements ?? this.measurements,
  );
  

  get getId => this.id;

  set setId( id) => this.id = id;

  get getBuildingYear => this.buildingYear;

  set setBuildingYear( buildingYear) => this.buildingYear = buildingYear;

  get getFireProtection => this.fireProtection;

  set setFireProtection( fireProtection) => this.fireProtection = fireProtection;

  get getConstructionClass => this.constructionClass;

  set setConstructionClass( constructionClass) => this.constructionClass = constructionClass;

  get getRiskClass => this.riskClass;

  set setRiskClass( riskClass) => this.riskClass = riskClass;

  get getUnitPrice => this.unitPrice;

  set setUnitPrice( unitPrice) => this.unitPrice = unitPrice;

  get getInsuredType => this.insuredType;

  set setInsuredType( insuredType) => this.insuredType = insuredType;

  get getDevaluationPercentage => this.devaluationPercentage;

  set setDevaluationPercentage( devaluationPercentage) => this.devaluationPercentage = devaluationPercentage;

  get getValue => this.value;

  set setValue( value) => this.value = value;

  get getSumInsured => this.sumInsured;

  set setSumInsured( sumInsured) => this.sumInsured = sumInsured;

  get getMeasurments => this.measurements;

 set setMeasurments( measurments) => this.measurements = measurments;


  

}

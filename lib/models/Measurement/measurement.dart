import 'dart:ffi';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:msg/models/Measurement/measurement_type.dart';

const String tableMeasurement = 'measurement';

class MeasurementFields {
  static final List<String> values = [
    id,
    description,
    length,
    height,
    width,
    measurementType,
    radius,
    buildingPart,
    cubature,
  ];

  static const String id = 'measurementId';
  static const String description = 'description';
  static const String length = 'length';
  static const String height = 'height';
  static const String width = 'width';
  static const String measurementType = 'measurement_type';
  static const String radius = 'radius';
  static const String buildingPart = 'fk_buildingPartId';
  static const String cubature = 'cubature';
}

class Measurement {
  int? measurementId;
  String? description;
  double? length;
  double? height;
  double? width;
  double? radius;
  int? fk_buildingPartId;
  MeasurementType? measurementType;
  double? cubature = 0.0;

  Measurement(
      {this.measurementId,
      this.description,
      this.length,
      this.height,
      this.width,
      this.radius,
      this.fk_buildingPartId,
      this.measurementType,
      this.cubature});

  Map<String, dynamic> toJson() {
    return {
      MeasurementFields.id: measurementId,
      MeasurementFields.description: description,
      MeasurementFields.length: length,
      MeasurementFields.height: height,
      MeasurementFields.width: width,
      MeasurementFields.measurementType: measurementType != null
          ? EnumToString.convertToString(measurementType)
          : null,
      MeasurementFields.radius: radius,
      MeasurementFields.buildingPart: fk_buildingPartId,
      MeasurementFields.cubature: cubature
    };
  }

  Map<String, dynamic> toMessage() {
    return {
      MeasurementFields.description: '"${description}"',
      MeasurementFields.length: '"${length}"',
      MeasurementFields.height: '"${height}"',
      MeasurementFields.width: '"${width}"',
      MeasurementFields.radius: '"${radius}"',
      MeasurementFields.cubature: '"${cubature}"'
    };
  }

  static Measurement fromJson(Map<String, Object?> json) => Measurement(
      measurementId: int.tryParse(json[MeasurementFields.id].toString()),
      description: json[MeasurementFields.description] as String,
      length: double.tryParse(json[MeasurementFields.length].toString()),
      height: double.tryParse(json[MeasurementFields.height].toString()),
      width: double.tryParse(json[MeasurementFields.width].toString()),
      measurementType: EnumToString.fromString(MeasurementType.values,
          json[MeasurementFields.measurementType].toString()),
      radius: double.tryParse(json[MeasurementFields.radius].toString()),
      cubature: double.tryParse(json[MeasurementFields.cubature].toString()),
      fk_buildingPartId:
          int.tryParse(json[MeasurementFields.buildingPart].toString()));

  Measurement copy(
          {int? id,
          String? description,
          double? length,
          double? height,
          double? width,
          double? radius,
          MeasurementType? measurementType,
          double? cubature}) =>
      Measurement(
          measurementId: id ?? measurementId,
          description: description ?? this.description,
          length: length ?? this.length,
          height: height ?? this.height,
          width: width ?? this.width,
          radius: radius ?? this.radius,
          measurementType: measurementType ?? this.measurementType,
          cubature: cubature ?? this.cubature);

  get getDescription => this.description;

  set setDescription(description) => this.description = description;

  get getLength => this.length;

  set setLength(length) => this.length = length;

  get getHeight => this.height;

  set setHeight(height) => this.height = height;

  get getWidth => this.width;

  set setWidth(width) => this.width = width;

  get getRadius => this.radius;

  set setRadius(radius) => this.radius = radius;

  get getMeasurementType => this.measurementType;

  set setMeasurementType(MeasurementType? measurementType) =>
      this.measurementType = measurementType;

  get getCubature => this.cubature;

  set setCubature(cubature) => this.cubature = cubature;
}

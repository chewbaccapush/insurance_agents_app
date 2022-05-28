import 'dart:ffi';

const String tableMeasurement = 'measurement';

class MeasurementFields {
  static final List<String> values = [
    id,
    description,
    length,
    height,
    width,
    width
  ];

  static const String id = 'measurementId';
  static const String description = 'description';
  static const String length = 'length';
  static const String height = 'height';
  static const String width = 'width';
  static const String radius = 'radius';
  static const String buildingPart = 'fk_buildingPartId';
}

class Measurement {
  int? measurementId;
  String? description;
  double? length;
  double? height;
  double? width;
  double? radius;
  int? fk_buildingPartId;

  Measurement(
      {this.measurementId,
      this.description,
      this.length,
      this.height,
      this.width,
      this.radius,
      this.fk_buildingPartId});

  Map<String, dynamic> toJson() {
    return {
      MeasurementFields.id: measurementId,
      MeasurementFields.description: description,
      MeasurementFields.length: length,
      MeasurementFields.height: height,
      MeasurementFields.width: width,
      MeasurementFields.radius: radius,
      MeasurementFields.buildingPart: fk_buildingPartId
    };
  }

  Map<String, dynamic> toMessage() {
    return {
      MeasurementFields.description: description,
      MeasurementFields.length: length,
      MeasurementFields.height: height,
      MeasurementFields.width: width,
      MeasurementFields.radius: radius,
    };
  }

  static Measurement fromJson(Map<String, Object?> json) => Measurement(
        measurementId: int.tryParse([MeasurementFields.id].toString()),
        description: json[MeasurementFields.description] as String,
        length: double.tryParse(json[MeasurementFields.length].toString()),
        height: double.tryParse(json[MeasurementFields.height].toString()),
        width: double.tryParse(json[MeasurementFields.width].toString()),
        radius: double.tryParse(json[MeasurementFields.radius].toString()),
      );

  Measurement copy({
    int? id,
    String? description,
    double? length,
    double? height,
    double? width,
    double? radius,
  }) =>
      Measurement(
          measurementId: id ?? measurementId,
          description: description ?? this.description,
          length: length ?? this.length,
          height: height ?? this.height,
          width: width ?? this.width,
          radius: radius ?? this.radius);

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
}

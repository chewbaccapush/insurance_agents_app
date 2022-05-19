import 'dart:ffi';

const String tableMeasurement = 'measurement';

class MeasurementFields {
  static final List<String> values= [
    id, description, length, height, width, width
  ];

  static const String id = 'measurementId';
  static const String description = 'description';
  static const String length = 'length';
  static const String height = 'height';
  static const String width = 'width';
  static const String radius = 'radius';
}

class Measurement {
  int? measurementId;
  String description;
  Float length;
  Float height;
  Float width;
  Float radius;

  Measurement({
    this.measurementId,
    required this.description,
    required this.length,
    required this.height,
    required this.width,
    required this.radius,
  });

    Map<String, dynamic> toJson() {
    return {
      MeasurementFields.id: measurementId,
      MeasurementFields.description: description,
      MeasurementFields.length: length,
      MeasurementFields.height: height,
      MeasurementFields.width: width,
      MeasurementFields.radius: radius
    };
  }

  static Measurement fromJson(Map<String,Object?> json) =>
    Measurement(                                             
      measurementId: json[MeasurementFields.id] as int?,
      description: json[MeasurementFields.description] as String,
      length: json[MeasurementFields.length] as Float,
      height: json[MeasurementFields.height] as Float,
      width: json[MeasurementFields.width] as Float,
      radius: json[MeasurementFields.radius] as Float,
  );
  
  Measurement copy({
      int? id,
      String? description,
      Float? length,
      Float? height,
      Float? width,
      Float? radius,
     
  }) => 
    Measurement(
      measurementId: id ?? measurementId,
      description: description ?? this.description,
      length: length ?? this.length,
      height: height ?? this.height,
      width: width ?? this.width,
      radius: radius ?? this.radius
  );

  get getDescription => this.description;

  set setDescription( description) => this.description = description;

  get getLength => this.length;

  set setLength( length) => this.length = length;

  get getHeight => this.height;

  set setHeight( height) => this.height = height;

  get getWidth => this.width;

  set setWidth( width) => this.width = width;

  get getRadius => this.radius;

  set setRadius( radius) => this.radius = radius;
}

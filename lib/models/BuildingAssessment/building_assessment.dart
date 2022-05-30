import 'dart:ffi';
import 'dart:convert';

import 'package:msg/models/BuildingPart/building_part.dart';

const String tableBuildingAssesment = 'buildingAssessment';

class BuildingAssessmentFields {
  static final List<String> values = [
    id,
    appointmentDate,
    description,
    assessmentCause,
    numOfAppartments,
    voluntaryDeduction,
    assessmentFee,
    sent
  ];

  static const String id = 'buildingAssessmentId';
  static const String appointmentDate = 'appointmentDate';
  static const String description = 'description';
  static const String assessmentCause = 'assessmentCause';
  static const String numOfAppartments = 'numOfAppartments';
  static const String voluntaryDeduction = 'voluntaryDeduction';
  static const String assessmentFee = 'assessmentFee';
  static const String buildingParts = 'buildingParts';
  static const String sent = 'sent';
}

class BuildingAssessment {
  int? id;
  DateTime? appointmentDate;
  String? description;
  String? assessmentCause;
  int? numOfAppartments;
  double? voluntaryDeduction;
  double? assessmentFee;
  List<BuildingPart> buildingParts;
  bool? sent = false;

  BuildingAssessment(
      {this.id,
      this.appointmentDate,
      this.description,
      this.assessmentCause,
      this.numOfAppartments,
      this.voluntaryDeduction,
      this.assessmentFee,
      this.sent,
      List<BuildingPart>? buildingParts})
      : buildingParts = buildingParts ?? [];

  Map<String, dynamic> toJson() {
    return {
      BuildingAssessmentFields.id: id,
      BuildingAssessmentFields.appointmentDate:
          appointmentDate!.toIso8601String(),
      BuildingAssessmentFields.description: description,
      BuildingAssessmentFields.assessmentCause: assessmentCause,
      BuildingAssessmentFields.numOfAppartments: numOfAppartments,
      BuildingAssessmentFields.voluntaryDeduction: voluntaryDeduction,
      BuildingAssessmentFields.assessmentFee: assessmentFee,
      BuildingAssessmentFields.sent: sent
    };
  }

  Map<String, dynamic> toMessage() {
    List buildingPartsJson = [];
    buildingParts.forEach((buildingPart) {
      buildingPartsJson.add(buildingPart.toMessage());
    });
    return {
      BuildingAssessmentFields.appointmentDate:
          '"${appointmentDate!.toIso8601String().substring(0, 10)}"',
      BuildingAssessmentFields.description: description,
      BuildingAssessmentFields.assessmentCause: assessmentCause,
      BuildingAssessmentFields.numOfAppartments: numOfAppartments,
      BuildingAssessmentFields.voluntaryDeduction: voluntaryDeduction,
      BuildingAssessmentFields.assessmentFee: assessmentFee,
      BuildingAssessmentFields.buildingParts: buildingPartsJson
    };
  }

  static BuildingAssessment fromJson(Map<String, Object?> json) {
    bool sentBoolean =
        int.tryParse(json[BuildingAssessmentFields.sent].toString()) == 1
            ? true
            : false;
    return BuildingAssessment(
        id: int.tryParse(json[BuildingAssessmentFields.id].toString()),
        appointmentDate: DateTime.parse(
            json[BuildingAssessmentFields.appointmentDate] as String),
        description: json[BuildingAssessmentFields.description] as String?,
        assessmentCause:
            json[BuildingAssessmentFields.assessmentCause] as String?,
        numOfAppartments: int.tryParse(
            json[BuildingAssessmentFields.numOfAppartments].toString()),
        voluntaryDeduction: double.tryParse(
            json[BuildingAssessmentFields.voluntaryDeduction].toString()),
        assessmentFee: double.tryParse(
            json[BuildingAssessmentFields.assessmentFee].toString()),
        sent: sentBoolean);
  }

  BuildingAssessment copy({
    int? id,
    DateTime? appointmentDate,
    String? description,
    String? assessmentCause,
    int? numOfAppartments,
    double? voluntaryDeduction,
    double? assessmentFee,
    List<BuildingPart>? buildingParts,
    bool? sent,
  }) =>
      BuildingAssessment(
          id: id ?? this.id,
          appointmentDate: appointmentDate ?? this.appointmentDate,
          description: description ?? this.description,
          assessmentCause: assessmentCause ?? this.assessmentCause,
          numOfAppartments: numOfAppartments ?? this.numOfAppartments,
          voluntaryDeduction: voluntaryDeduction ?? this.voluntaryDeduction,
          assessmentFee: assessmentFee ?? this.assessmentFee,
          buildingParts: buildingParts ?? this.buildingParts,
          sent: sent ?? this.sent);

  get getId => this.id;

  set setId(int id) => this.id = id;

  get getAppointmentDate => this.appointmentDate;

  set setAppointmentDate(appointmentDate) =>
      this.appointmentDate = appointmentDate;

  get getDescription => this.description;

  set setDescription(description) => this.description = description;

  get getAssessmentCause => this.assessmentCause;

  set setAssessmentCause(assessmentCause) =>
      this.assessmentCause = assessmentCause;

  get getNumOfAppartments => this.numOfAppartments;

  set setNumOfAppartments(numOfAppartments) =>
      this.numOfAppartments = numOfAppartments;

  get getVoluntaryDeduction => this.voluntaryDeduction;

  set setVoluntaryDeduction(voluntaryDeduction) =>
      this.voluntaryDeduction = voluntaryDeduction;

  get getAssessmentFee => this.assessmentFee;

  set setAssessmentFee(assessmentFee) => this.assessmentFee = assessmentFee;

  get getBuildingParts => this.buildingParts;

  set setBuildingParts(buildingParts) => this.buildingParts = buildingParts;

  set setSent(sent) => this.sent = sent;
}

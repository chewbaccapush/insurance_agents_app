import 'package:msg/models/BuildingAssessment/building_assessment.dart';
import 'package:msg/models/BuildingPart/building_part.dart';
import 'package:msg/models/Database/database_helper.dart';
import 'package:msg/models/Measurement/measurement.dart';

class StateService {
  static BuildingAssessment buildingAssessment = BuildingAssessment();
  static BuildingPart buildingPart = BuildingPart();
  static Measurement measurement = Measurement();

  static resetState() {
    buildingAssessment = BuildingAssessment();
    buildingPart = BuildingPart();
    measurement = Measurement();
  }

  static getStateFromDatabase() async {
     buildingAssessment.id != null
        ? buildingAssessment =
            await DatabaseHelper.instance.readAssessment(buildingAssessment.id!)
        : buildingAssessment = buildingAssessment;

    buildingPart.id != null
        ? buildingPart = buildingAssessment.buildingParts
            .where((e) => e.id == buildingPart.id)
            .first
        : buildingPart = buildingPart;
  }
}

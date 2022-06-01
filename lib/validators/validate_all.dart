import 'package:msg/models/BuildingAssessment/building_assessment.dart';
import 'package:msg/models/BuildingPart/building_part.dart';
import 'package:msg/models/Database/database_helper.dart';

class ValidateAll {
  ValidateAll._privateConstructor();

  static final ValidateAll _instance = ValidateAll._privateConstructor();

  factory ValidateAll() {
    return _instance;
  }

  Future<List<BuildingPart>> check(BuildingAssessment buildingAssessment) async {
    List<BuildingPart> buildingParts = await DatabaseHelper.instance.getBuildingPartsByFk(buildingAssessment.id!);
    List<BuildingPart> unvalid = [];

    for (BuildingPart buildingPart in buildingParts) {
      if (buildingPart.validated == false || buildingPart.validated == null) {
        unvalid.add(buildingPart);
      }
    }
    return unvalid;
  }
}
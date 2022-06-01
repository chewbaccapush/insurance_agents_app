import 'package:msg/models/BuildingPart/building_part.dart';
import 'package:msg/models/BuildingPart/insured_type.dart';

class ValidateBuildingPart {
  ValidateBuildingPart._privateConstructor();

  static final ValidateBuildingPart _instance = ValidateBuildingPart._privateConstructor();

  factory ValidateBuildingPart() {
    return _instance;
  }

  bool check(BuildingPart buildingPart) {
    bool devaluation = true;
    if (buildingPart.insuredType == null ||
        (buildingPart.insuredType == InsuredType.timeValue && 
        double.tryParse(buildingPart.devaluationPercentage.toString()) == null)
    ) devaluation = false; 

    if (buildingPart.description != null && 
      int.tryParse(buildingPart.buildingYear.toString()) != null &&
      buildingPart.fireProtection != null &&
      buildingPart.constructionClass != null &&
      buildingPart.riskClass != null &&
      double.tryParse(buildingPart.unitPrice.toString()) != null &&
      devaluation
    ) return true;

    return false;
  }
}
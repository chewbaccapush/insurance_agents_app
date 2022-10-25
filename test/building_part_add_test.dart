import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:msg/models/BuildingAssessment/building_assessment.dart';
import 'package:msg/models/BuildingPart/building_part.dart';
import 'package:msg/models/Database/database_helper.dart';
import 'package:msg/services/state_service.dart';

final BuildingAssessment mockAssessment = BuildingAssessment(id: 2, description: 'haha', assessmentCause: ' haha', numOfAppartments: 2, assessmentFee: 10, voluntaryDeduction: 12, buildingParts: []);
final BuildingPart mockBuildingPart = BuildingPart(id: 2, description: 'BuildingPart');
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  test('test adding building part to database, then reading it into state service', () {

    StateService.buildingPart.id = 2;
    DatabaseHelper.instance.persistBuildingPart(mockBuildingPart, mockAssessment);

    StateService.getStateFromDatabase();

    expect((StateService.buildingPart), mockBuildingPart);
  });
}
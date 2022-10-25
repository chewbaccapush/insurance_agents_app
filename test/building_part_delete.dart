import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:msg/models/BuildingAssessment/building_assessment.dart';
import 'package:msg/models/BuildingPart/building_part.dart';
import 'package:msg/models/Database/database_helper.dart';
import 'package:msg/services/state_service.dart';
import 'package:msg/widgets/building_assessment_tile.dart';

final BuildingAssessment mockAssessment = BuildingAssessment(id: 2, description: 'Mock Assessment');
final BuildingPart mockBuildingPart = BuildingPart(id: 2, description: 'Mock BuildingPart');

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  test('test deleting buildingPart to database, then reading it into state service', () {
    StateService.buildingPart.id = 2;
    DatabaseHelper.instance.deleteAssessment(mockAssessment);

    StateService.getStateFromDatabase();

    expect((StateService.buildingPart), mockBuildingPart);
  });
}

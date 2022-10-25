import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:msg/models/BuildingAssessment/building_assessment.dart';
import 'package:msg/models/BuildingPart/building_part.dart';
import 'package:msg/models/Database/database_helper.dart';
import 'package:msg/services/state_service.dart';

BuildingPart mockBuildingPart = BuildingPart(id: 2, description: 'Mock BuildingPart');
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  test('test updating building part, then reading it into state service', () {

    StateService.buildingPart = mockBuildingPart;
    mockBuildingPart.description = "Updated BuildingPart";
    DatabaseHelper.instance.updateBuildingPart(mockBuildingPart);

    StateService.getStateFromDatabase();

    expect((StateService.buildingPart), mockBuildingPart);
  });
}
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:msg/models/BuildingAssessment/building_assessment.dart';
import 'package:msg/models/Database/database_helper.dart';
import 'package:msg/services/state_service.dart';

final BuildingAssessment mockAssessment = BuildingAssessment(
    id: 2, description: 'haha', assessmentCause: ' hf', numOfAppartments: 2, assessmentFee: 10, voluntaryDeduction: 12, buildingParts: []);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  test('test updating assessment to database, then reading it into state service', () {
    StateService.buildingAssessment.id = 2;
    DatabaseHelper.instance.updateAssessment(mockAssessment);

    StateService.getStateFromDatabase();

    expect((StateService.buildingAssessment), mockAssessment);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:msg/models/BuildingAssessment/building_assessment.dart';
import 'package:msg/models/Database/database_helper.dart';
import 'package:msg/services/state_service.dart';
import 'package:msg/widgets/building_assessment_tile.dart';

final BuildingAssessment mockAssessment = BuildingAssessment(
    id: 2, description: 'haha', assessmentCause: ' haha', numOfAppartments: 2, assessmentFee: 10, voluntaryDeduction: 12, buildingParts: []);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  test('test deleting assessment to database, then reading it into state service', () {
    StateService.buildingAssessment.id = 2;
    DatabaseHelper.instance.deleteAssessment(mockAssessment);

    StateService.getStateFromDatabase();

    expect((StateService.buildingAssessment), mockAssessment);
  });
}

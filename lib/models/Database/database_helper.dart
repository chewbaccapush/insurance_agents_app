import 'package:flutter/cupertino.dart';
import 'package:msg/models/BuildingPart/building_part.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';

import '../BuildingAssessment/building_assessment.dart';
import '../Measurement/measurement.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('msgDatabase.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    debugPrint('db location: ' + path);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const intagerType = 'INTAGER NOT NULL';
    const intagerNullable = 'INTAGER';
    const stringType = 'TEXT NOT NULL';
    const stringNullable = 'TEXT';
    const numericType = 'NUMERIC NOT NULL';
    const numericNullable = "NUMERIC";
    const boolType = "BOOLEAN";

    await db.execute('''
      CREATE TABLE $tableBuildingAssesment(
          ${BuildingAssessmentFields.id} $idType,
          ${BuildingAssessmentFields.appointmentDate} $stringNullable,
          ${BuildingAssessmentFields.description} $stringNullable,
          ${BuildingAssessmentFields.assessmentCause} $stringNullable,
          ${BuildingAssessmentFields.numOfAppartments} $intagerNullable,
          ${BuildingAssessmentFields.voluntaryDeduction} $numericNullable,
          ${BuildingAssessmentFields.assessmentFee} $numericNullable,
          ${BuildingAssessmentFields.sent} $boolType   
      )''');

    await db.execute('''
      CREATE TABLE $tableBuildingPart (
          ${BuildingPartFields.id} $idType,
          ${BuildingPartFields.buildingAssesment} $intagerNullable,
          ${BuildingPartFields.description} $stringNullable,
          ${BuildingPartFields.buildingYear} $intagerNullable,
          ${BuildingPartFields.fireProtection} $stringNullable,
          ${BuildingPartFields.constructionClass} $stringNullable,
          ${BuildingPartFields.riskClass} $stringNullable,
          ${BuildingPartFields.unitPrice} $numericNullable,
          ${BuildingPartFields.insuredType} $stringNullable,
          ${BuildingPartFields.devaluationPercentage} $numericNullable,
          ${BuildingPartFields.cubature} $numericNullable,
          ${BuildingPartFields.value} $numericNullable,
          ${BuildingPartFields.sumInsured} $numericNullable,
          FOREIGN KEY(${BuildingPartFields.buildingAssesment}) REFERENCES $tableBuildingAssesment(${BuildingAssessmentFields.id})
          
      )''');

    await db.execute('''
      CREATE TABLE $tableMeasurement(
          ${MeasurementFields.id} $idType,
          ${MeasurementFields.buildingPart} $intagerNullable,
          ${MeasurementFields.description} $stringNullable,
          ${MeasurementFields.length} $numericNullable,
          ${MeasurementFields.height} $numericNullable,
          ${MeasurementFields.width} $numericNullable,
          ${MeasurementFields.radius} $numericNullable,
          FOREIGN KEY(${MeasurementFields.buildingPart}) REFERENCES $tableBuildingPart(${BuildingPartFields.id})
      )''');
  }

  Future<BuildingAssessment> persistAssessment(BuildingAssessment assessment) async {
    final db = await instance.database;

    print("CLOG:");
    print(assessment.buildingParts.length);
    final assessmentId = await db.insert(
      tableBuildingAssesment, 
      assessment.toJson(), 
      conflictAlgorithm: ConflictAlgorithm.replace
    );

    // final response = await createBuildingPartMeasurement(assessmentId, buildingParts);

    return assessment.copy(id: assessmentId);
  }

  Future<BuildingAssessment> persistAssessmentFromPart(BuildingAssessment assessment) async {
    final db = await instance.database;

    final assessmentId = await db.insert(
      tableBuildingAssesment, 
      assessment.toJson(), 
      conflictAlgorithm: ConflictAlgorithm.replace
    );

    return assessment.copy(id: assessmentId);
  }

  Future<BuildingPart> persistBuildingPart(BuildingPart buildingPart, BuildingAssessment assessment) async {
    debugPrint("SQL: saving building part");

    final db = await instance.database;

    int assessmentIdInteger;

    if (assessment.id == null) {
      //BuildingAssessment assessment = new BuildingAssessment();
      assessment.appointmentDate = new DateTime.now();
      assessment.sent = false;
      buildingPart.fk_buildingAssesmentId = await db.insert(tableBuildingAssesment, assessment.toJson());
    } else {
      buildingPart.fk_buildingAssesmentId = assessment.id;
    }

    // TODO - calculate (not here)
    buildingPart.cubature = 0;
    buildingPart.value = 0;
    buildingPart.sumInsured = 0;

    //print(buildingPart.toJson());
    final buildingPartId = await db.insert(
      tableBuildingPart,
      buildingPart.toJson(), 
      conflictAlgorithm: ConflictAlgorithm.replace
    );
    
    return buildingPart.copy();
  } 


  Future<Measurement> persistMeasurement(Measurement measurement, BuildingPart buildingPart, BuildingAssessment assessment) async {
    final db = await instance.database;

    if (buildingPart.id == null) {
      BuildingPart tempPart = await persistBuildingPart(buildingPart, assessment);
    }

    return measurement;


      final buildingPartId =
          await db.insert(tableBuildingPart, buildingParts[i].toJson(), conflictAlgorithm: ConflictAlgorithm.replace);

    // final measurementId = await db.insert(
    //   tableMeasurement,
    //   measurement.toJson()
    // );

    return measurement.copy();
  }

  // Future createBuildingPartMeasurement(
  //     int assessmentId, List<BuildingPart> buildingParts) async {
  //     final db = await instance.database;

  //     if (buildingParts.isEmpty) {
  //     throw Exception("No Building Parts inserted.");
  //   }

  //   // !!! NEED TO ALSO CALCULATE CUBATURE, SUM INSURED AND VALUE !!!
  //   for (int i = 0; i < buildingParts.length; i++) {
  //     buildingParts[i].fk_buildingAssesmentId = assessmentId;
  //     buildingParts[i].cubature = 0.0;
  //     buildingParts[i].value = 0.0;
  //     buildingParts[i].sumInsured = 0.0;

  //     final buildingPartId =
  //         await db.insert(tableBuildingPart, buildingParts[i].toJson(), conflictAlgorithm: ConflictAlgorithm.replace);

  //     for (int j = 0; j < buildingParts[i].measurements.length; j++) {
  //       buildingParts[i].measurements[j].fk_buildingPartId = buildingPartId;
  //       await db.insert(
  //           tableMeasurement, buildingParts[i].measurements[j].toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  //     }
  //   }

  //   return "Successfully inserted Building Assessment.";
  // }

  Future<BuildingAssessment> readAssessment(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableBuildingAssesment,
      columns: BuildingAssessmentFields.values,
      where: '${BuildingAssessmentFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return BuildingAssessment.fromJson(maps.first);
    } else {
      throw Exception(' ID $id not found.');
    }
  }

  Future<List<BuildingAssessment>> readAllAssessments() async {
    final db = await instance.database;

    final resultAssesments = await db.query(tableBuildingAssesment);

    List<BuildingAssessment> assessments = resultAssesments
        .map((json) => BuildingAssessment.fromJson(json))
        .toList();

    for (var buildingAssessment in assessments) {
      final resultParts = await db.query(tableBuildingPart,
          where: '${BuildingPartFields.buildingAssesment} = ?',
          whereArgs: [buildingAssessment.id]);
      List<BuildingPart> buildingParts =
          resultParts.map((json) => BuildingPart.fromJson(json)).toList();

      for (var buildingPart in buildingParts) {
        final resultMesurements = await db.query(tableMeasurement,
            where: '${MeasurementFields.buildingPart} = ?',
            whereArgs: [buildingPart.id]);
        List<Measurement> measurements = resultMesurements
            .map((json) => Measurement.fromJson(json))
            .toList();
        buildingPart.measurements = measurements;
      }
      buildingAssessment.buildingParts = buildingParts;
    }

    return assessments;
  }

  Future<void> updateAssessment(BuildingAssessment assessment) async {
    final db = await instance.database;
    await db.update(tableBuildingAssesment, assessment.toJson(),
        where: '${BuildingAssessmentFields.id} = ?',
        whereArgs: [assessment.id]);
  }

  Future close() async {
    final db = await instance.database;
    _database = null;
    db.close();
  }

  Future<void> deleteDatabase(String path) =>
      databaseFactory.deleteDatabase(path);
}

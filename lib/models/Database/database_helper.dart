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
    _database!.execute("PRAGMA foreign_keys = ON");
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
          ${BuildingAssessmentFields.sent} $boolType,   
          ${BuildingAssessmentFields.finalized} $boolType   
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
          ${BuildingPartFields.validated} $boolType,
          FOREIGN KEY(${BuildingPartFields.buildingAssesment}) REFERENCES $tableBuildingAssesment(${BuildingAssessmentFields.id})
          
      )''');

    await db.execute('''
      CREATE TABLE $tableMeasurement(
          ${MeasurementFields.id} $idType UNIQUE,
          ${MeasurementFields.buildingPart} $intagerNullable,
          ${MeasurementFields.description} $stringNullable,
          ${MeasurementFields.length} $numericNullable,
          ${MeasurementFields.height} $numericNullable,
          ${MeasurementFields.width} $numericNullable,
          ${MeasurementFields.measurementType} $numericNullable,
          ${MeasurementFields.radius} $numericNullable,
          ${MeasurementFields.cubature} $numericNullable,
          FOREIGN KEY(${MeasurementFields.buildingPart}) REFERENCES $tableBuildingPart(${BuildingPartFields.id})
      )''');
  }

  persistAssessment(BuildingAssessment assessment) async {
    final db = await instance.database;
    return await db.insert(tableBuildingAssesment, assessment.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<BuildingPart> persistBuildingPart(
      BuildingPart buildingPart, BuildingAssessment assessment) async {
    debugPrint("SQL: saving building part");
    final db = await instance.database;

    if (assessment.id == null) {
      assessment.appointmentDate = new DateTime.now();
      assessment.sent = false;
      buildingPart.fk_buildingAssesmentId = await persistAssessment(assessment);
    } else {
      buildingPart.fk_buildingAssesmentId = assessment.id;
    }

    //print(buildingPart.toJson());
    final buildingPartId = await db.insert(
        tableBuildingPart, buildingPart.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    buildingPart.id = buildingPartId;

    return buildingPart.copy();
  }

  Future<Measurement> persistMeasurement(Measurement measurement,
      BuildingPart buildingPart, BuildingAssessment assessment) async {
    final db = await instance.database;

    if (buildingPart.id == null) {
      buildingPart.description = "DRAFT";
      BuildingPart tempPart =
          await persistBuildingPart(buildingPart, assessment);
      measurement.fk_buildingPartId = tempPart.id;
    } else {
      measurement.fk_buildingPartId = buildingPart.id;
    }

    final measurementId = await db.insert(
        tableMeasurement, measurement.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    print("PRE SEND:");
    measurement.measurementId = measurementId;
    print(measurement.toJson());

    return measurement;
  }

  Future<int> deleteBuildingPart(int id) async {
    final db = await instance.database;
    await deleteMeasurementByFk(id);

    return await db.delete(tableBuildingPart, where: 'buildingPartId = ?', whereArgs: [id]);
  }

  Future<int> deleteMeasurement(int id) async {
    final db = await instance.database;

    return await db
        .delete(tableMeasurement, where: 'measurementId = ?', whereArgs: [id]);
  }

  Future<void> deleteMeasurementByFk(int id) async {
    final db = await instance.database;

    await db.delete(tableMeasurement, where: '${MeasurementFields.buildingPart} = ?', whereArgs: [id]);
  }

  Future<List<BuildingPart>> getBuildingPartsByFk(int id) async {
    final db = await instance.database;

    final result = await db.query(tableBuildingPart,
            where: '${BuildingPartFields.buildingAssesment} = ?',
            whereArgs: [id]);
    return result.map((json) => BuildingPart.fromJson(json)).toList();
  }

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

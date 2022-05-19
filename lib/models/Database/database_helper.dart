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

  Future<Database> get database async{
    if(_database != null) return _database!;

    _database = await _initDB('msg.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    print('db location: '+ path);
    return await openDatabase(path,version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const intagerType = 'INTAGER NOT NULL';
    const intagerNullable = 'INTAGER';
    const stringType = 'TEXT NOT NULL';
    const numericType = 'NUMERIC NOT NULL';

    await db.execute('''
      CREATE TABLE $tableMeasurement (
          ${MeasurementFields.id} $idType,
          ${MeasurementFields.description} $stringType,
          ${MeasurementFields.length} $numericType,
          ${MeasurementFields.height} $numericType,
          ${MeasurementFields.width} $numericType,
          ${MeasurementFields.radius} $numericType
      )'''
    );
    
    await db.execute('''
      CREATE TABLE $tableBuildingPart (
          ${BuildingPartFields.id} $idType,
          ${BuildingPartFields.measurements} INTAGER,
          ${BuildingPartFields.description} $stringType,
          ${BuildingPartFields.buildingYear} $intagerType,
          ${BuildingPartFields.fireProtection} $stringType,
          ${BuildingPartFields.constructionClass} $stringType,
          ${BuildingPartFields.riskClass} $stringType,
          ${BuildingPartFields.unitPrice} $numericType,
          ${BuildingPartFields.insuredType} $stringType,
          ${BuildingPartFields.devaluationPercentage} $numericType,
          ${BuildingPartFields.cubature} $numericType,
          ${BuildingPartFields.value} $numericType,
          ${BuildingPartFields.sumInsured} $numericType,
          FOREIGN KEY(${BuildingPartFields.measurements}) REFERENCES $tableMeasurement(${MeasurementFields.id})
      )'''
    );

    await db.execute('''
      CREATE TABLE $tableBuildingAssesment (
          ${BuildingAssessmentFields.id} $idType,
          ${BuildingAssessmentFields.appointmentDate} $stringType,
          ${BuildingAssessmentFields.description} $stringType,
          ${BuildingAssessmentFields.assessmentCause} $stringType,
          ${BuildingAssessmentFields.numOfAppartments} $intagerType,
          ${BuildingAssessmentFields.voluntaryDeduction} $numericType,
          ${BuildingAssessmentFields.assessmentFee} $numericType,
          ${BuildingAssessmentFields.buildingParts} $intagerType,
          FOREIGN KEY(${BuildingAssessmentFields.buildingParts}) REFERENCES $tableBuildingPart(${BuildingPartFields.id})
      )'''
    );
  }

  Future<BuildingAssessment> createAssessment(BuildingAssessment assessment) async{
    final db = await instance.database;

    final id = await db.insert(tableBuildingAssesment, assessment.toJson());
    return assessment.copy(id: id);
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

  Future<List<BuildingAssessment>> readAllAssessments()async{
    final db = await instance.database;

    final result = await db.query(tableBuildingAssesment); 

    return result.map((json)=>BuildingAssessment.fromJson(json)).toList();
  } 

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
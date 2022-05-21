import 'dart:convert';
import 'dart:ffi';

import 'package:aws_sqs_api/sqs-2012-11-05.dart';
import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/material.dart';
import 'package:msg/models/BuildingPart/construction_class.dart';
import 'package:msg/models/BuildingPart/fire_protection.dart';
import 'package:msg/models/BuildingPart/insured_type.dart';
import 'package:msg/models/BuildingPart/risk_class.dart';
import 'package:msg/models/Measurement/measurement.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'package:msg/models/BuildingAssessment/building_assessment.dart';
import 'package:msg/models/BuildingPart/building_part.dart';
import 'package:msg/models/Database/database_helper.dart';
import 'package:msg/models/proprety_value.dart';
import 'package:msg/services/sqs_sender.dart';
import 'package:msg/widgets/alert.dart';

class ValueForm extends StatefulWidget {
  const ValueForm({Key? key}) : super(key: key);

  @override
  State<ValueForm> createState() => _ValueFormState();
}

class _ValueFormState extends State<ValueForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for textfields
  final _nameController = TextEditingController();
  final _areaController = TextEditingController();
  
  // Clears the controller when the widget is disposed.
  @override
  void dispose() {
    
    _nameController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  final SQSSender sqsSender = SQSSender();

  void sendMessage() async{
    debugPrint("name:" + _nameController.text);
    debugPrint("area:" + _areaController.text);

    try {
      await sqsSender.sendToSQS(_nameController.text);
      showDialogPopup("ja", "Assessment successfully sent.");
    } catch (e) {
      showDialogPopup("Error", "Assessment not sent.");
    }
  }
  
  void showDialogPopup(String title, String content) {
      showDialog(
        context: context, 
        builder: (BuildContext context) {
          return new Alert(title: title, content: content);
        });
  }

  // Deletes Database - for testing 
  void deleteDatabase() {
    DatabaseHelper.instance.deleteDatabase('/data/user/0/com.example.msg/databases/msgDatabase.db');
  }

  // Locally save order to users device
  void localSave() async {
   

    Measurement measurement1 = Measurement(description: "ME1", height: 2.2, width: 23.0, length: 12.0, radius: 23.0);
    Measurement measurement2 = Measurement(description: "ME2", height: 2.0, width: 33.0, length: 2.0, radius: 9.0);

    List<Measurement> measurements = [measurement1, measurement2];

    BuildingPart buildingPart1 = BuildingPart(description: "BP1", buildingYear: 2022, fireProtection: FireProtection.bma, constructionClass: ConstructionClass.solidConstruction, riskClass: RiskClass.four, unitPrice: 12.2, insuredType: InsuredType.newValue, devaluationPercentage: 0.33, cubature: 0.0, value: 0.0, sumInsured: 0.0, measurements: measurements);
    BuildingPart buildingPart2 = BuildingPart(description: "BP2", buildingYear: 2022, fireProtection: FireProtection.bma, constructionClass: ConstructionClass.solidConstruction, riskClass: RiskClass.four, unitPrice: 12.2, insuredType: InsuredType.newValue, devaluationPercentage: 0.33, cubature: 0, value: 0, sumInsured: 0, measurements: measurements);
   
    List<BuildingPart> buildingParts = [buildingPart1, buildingPart2];

    BuildingAssessment assessment = BuildingAssessment(appointmentDate: DateTime(2017, 9, 7, 17 ,30), description: "neki", assessmentCause: "sdsdsd",numOfAppartments: 12, voluntaryDeduction: 22.2, assessmentFee: 22.2);

    await DatabaseHelper.instance.createAssessment(assessment, buildingParts);

    
   /*
    final instance = await SharedPreferences.getInstance();

    PropretyValue propretyValue =
        PropretyValue(_nameController.text, _areaController.text, 0);

    Map<String, dynamic> map = {
      'name': propretyValue.name,
      'area': propretyValue.area,
      'value': propretyValue.value
    };


    instance.setString(_nameController.text, jsonEncode(map));
    */
    clearText();
    
  }

  void clearText() {
    _nameController.clear();
    _areaController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
            padding: const EdgeInsets.all(30.0),
            child: Center(
                child: Column(children: [
              const Padding(padding: EdgeInsets.only(top: 200.0)),
              buildTextFormField(_nameController, "Vnesi naziv naloga"),
              const Padding(padding: EdgeInsets.only(top: 30.0)),
              buildTextFormField(_areaController, "Vnesi površino"),
              const Padding(padding: EdgeInsets.only(top: 30.0)),
              buildElevatedButton("Pošlji")
            ]))));
  }

  Widget buildTextFormField(controller, labelText) {
    return TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vnesite podatke.';
          }
          return null;
        },
        decoration: buildInputDecoration(labelText),
        cursorColor: Colors.white,
        keyboardType: TextInputType.text);
  }

  InputDecoration buildInputDecoration(labelText) {
    return InputDecoration(
        floatingLabelStyle: const TextStyle( color: Color.fromARGB(255, 184, 60, 93)),
        labelText: labelText,
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          borderSide: BorderSide(color: Color.fromARGB(255, 184, 60, 93), width: 2.0),
        ),
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide()));
  }

  Widget buildElevatedButton(labelText) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50), // NEW
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        primary: const Color.fromARGB(255, 184, 60, 93),
      ),
      child: Text(labelText, style: const TextStyle(fontSize: 20)),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          debugPrint('Value form fired');
          sendMessage();
          localSave();
          //deleteDatabase();
        }
      },
    );
  }
}

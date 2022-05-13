import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:msg/models/proprety_value.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ValueForm extends StatefulWidget {
    const ValueForm({Key? key}) : super(key: key);
  
    @override
    State<ValueForm> createState() => _ValueFormState();
  }
  
  class _ValueFormState extends State<ValueForm> {
    final _formKey = GlobalKey<FormState>();
    

    // Controllers for textfields
    final nameController = TextEditingController();
    final areaController = TextEditingController();

    // Clears the controller when the widget is disposed.
    @override
    void dispose() {
      nameController.dispose();
      areaController.dispose();
      super.dispose();
    }

    void sendMessage() {
      print("name:" + nameController.text);
      print("area:" + areaController.text);
    }

    // Locally save order to users device 
    void localSave() async {
      final instance = await SharedPreferences.getInstance();

      PropretyValue propretyValue = PropretyValue(nameController.text, areaController.text, 0);

      Map<String, dynamic> map = {
        'name': propretyValue.name,
        'area': propretyValue.area,
        'value': propretyValue.value
      };
      
      instance.setString(nameController.text, jsonEncode(map));
      print(instance.getKeys());
    }

    @override
    Widget build(BuildContext context) {
      return 
      
         Form(
          key: _formKey,
          child: Container(
              padding: const EdgeInsets.all(30.0),
              color: Colors.white,
              child: Center(
                  child: Column(children: [
                  
                const Padding(padding: EdgeInsets.only(top: 200.0)),
                TextFormField(
                  cursorColor: Color.fromARGB(255, 45, 43, 43),
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vnesite podatke.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    
                    floatingLabelStyle: TextStyle( color: Color.fromARGB(255, 184, 60, 93)),
                    labelText: "Vnesi naziv naloga",
                    focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        borderSide: BorderSide(color: Color.fromARGB(255, 184, 60, 93),width: 2.0)),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  style: const TextStyle(
                    fontFamily: "Poppins",
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 30.0)),
                TextFormField(
                   cursorColor: Color.fromARGB(255, 45, 43, 43),
                   controller: areaController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vnesite podatke.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    floatingLabelStyle: TextStyle( color: Color.fromARGB(255, 184, 60, 93)),
                    labelText: "Vnesi površino",
                    fillColor: Colors.white,
                    focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        borderSide: BorderSide(color: Color.fromARGB(255, 184, 60, 93), width: 2.0)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(),
                      
                    ),
                    
                  ),
                  keyboardType: TextInputType.text,
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.black,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 30.0)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 160, 39, 71),
                    minimumSize: const Size.fromHeight(50), // NEW
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  child: const Text(
                    'Pošlji',
                    style: TextStyle(color: Colors.white,fontSize: 20),
                    
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      debugPrint('Value form fired');
                      sendMessage();
                      localSave();
                    }
                  },
                ),
            ]))));
    }
  }
import 'package:flutter/material.dart';
import 'package:dart_amqp/dart_amqp.dart';


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
      print("area:" + areaController.text);
      print("area:" + areaController.text);
      print("area:" + areaController.text);
      print("area:" + areaController.text);
    }

    @override
    Widget build(BuildContext context) {
      return Form(
        key: _formKey,
        child: Container(
            padding: const EdgeInsets.all(30.0),
            color: Colors.white,
            child: Center(
                child: Column(children: [
              const Padding(padding: EdgeInsets.only(top: 280.0)),
              TextFormField(
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vnesite podatke.';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Vnesi naziv naloga",
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(),
                  ),
                  //fillColor: Colors.green
                ),
                keyboardType: TextInputType.text,
                style: const TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 20.0)),
              TextFormField(
                controller: areaController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vnesite podatke.';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Vnesi površino",
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(),
                  ),
                  //fillColor: Colors.green
                ),
                keyboardType: TextInputType.text,
                style: const TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 20.0)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  minimumSize: const Size.fromHeight(50), // NEW
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: const Text(
                  'Pošlji',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    debugPrint('Value form fired');
                    sendMessage();
                  }
                },
              ),
            ]))));
    }
  }
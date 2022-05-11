import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:msg/components/bottom.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: [_valueForm(), BottomNav()]));
  }

  Widget _valueForm() {
    return Form(
        key: _formKey,
        child: Container(
            padding: const EdgeInsets.all(30.0),
            color: Colors.white,
            child: Center(
                child: Column(children: [
              const Padding(padding: EdgeInsets.only(top: 280.0)),
              TextFormField(
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
                  print('Hello');
                },
              ),
            ]))));
  }
}

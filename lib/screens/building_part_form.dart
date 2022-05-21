import 'package:flutter/material.dart';
import 'package:msg/widgets/add_objects_section.dart';
import 'package:msg/widgets/custom_text_form_field.dart';

class BuildingPartForm extends StatefulWidget {
  const BuildingPartForm({Key? key}) : super(key: key);

  @override
  State<BuildingPartForm> createState() => _BuildingPartFormState();
}

class _BuildingPartFormState extends State<BuildingPartForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Row(
        children: <Widget>[
          Flexible(
            child: Column(
              children: const <Widget>[
                CustomTextFormField(
                    type: TextInputType.text, labelText: "Description"),
                CustomTextFormField(
                    type: TextInputType.numberWithOptions(decimal: false),
                    labelText: "Building Year"),
                //Fire protection
                //Construction class
                //Risk class
                CustomTextFormField(
                    type: TextInputType.numberWithOptions(decimal: true),
                    labelText: "Unit Price"),
                //Insured Type
                CustomTextFormField(
                    type: TextInputType.numberWithOptions(decimal: true),
                    labelText: "Devaluation percentage"),
                //Cubature
                //Value
                //Sum Insured
              ],
            ),
          ),
          Flexible(
            child: Column(
              children: const <Widget>[
                AddObjectsSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

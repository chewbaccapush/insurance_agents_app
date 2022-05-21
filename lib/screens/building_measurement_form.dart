import 'package:flutter/material.dart';
import 'package:msg/widgets/add_objects_section.dart';
import 'package:msg/widgets/custom_text_form_field.dart';

class BuildingMeasurementForm extends StatefulWidget {
  const BuildingMeasurementForm({Key? key}) : super(key: key);

  @override
  State<BuildingMeasurementForm> createState() =>
      _BuildingMeasurementFormState();
}

class _BuildingMeasurementFormState extends State<BuildingMeasurementForm> {
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
                    labelText: "Length"),
                CustomTextFormField(
                    type: TextInputType.numberWithOptions(decimal: true),
                    labelText: "Height"),
                CustomTextFormField(
                    type: TextInputType.numberWithOptions(decimal: true),
                    labelText: "Width"),
                CustomTextFormField(
                    type: TextInputType.numberWithOptions(decimal: true),
                    labelText: "Radius"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

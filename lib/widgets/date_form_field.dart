import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:msg/models/BuildingAssessment/building_assessment.dart';
import 'package:msg/services/state_service.dart';
import 'package:msg/widgets/custom_text_form_field.dart';

import '../services/storage_service.dart';

class CustomDateFormField extends StatefulWidget {
  final DateTime? initialValue;
  final dynamic setDirtyFlag;
  const CustomDateFormField({Key? key, this.initialValue, this.setDirtyFlag})
      : super(key: key);

  @override
  State<CustomDateFormField> createState() => _CustomDateFormFieldState();
}

class _CustomDateFormFieldState extends State<CustomDateFormField> {
  DateTime _selectedAppointmentDate = DateTime.now();
  final controller = TextEditingController();
  String languageCode = StorageService.getLocale()!.languageCode;
  BuildingAssessment buildingAssessment = StateService.buildingAssessment;

  @override
  void initState() {
    _selectedAppointmentDate = widget.initialValue ?? DateTime.now();
    setValue();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  setValue() {
    controller.text =
        DateFormat('d.M.yyyy', languageCode).format(_selectedAppointmentDate);
    buildingAssessment.appointmentDate = _selectedAppointmentDate;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          child: Column(
            children: [
              CustomTextFormField(
                enabled: false,
                controller: controller,
                type: TextInputType.datetime,
                labelText: "Appointment Date",
              )
            ],
          ),
        ),
        Column(
          children: [
            IconButton(
              color: Theme.of(context).colorScheme.onPrimary,
              onPressed: () => {
                widget.setDirtyFlag(),
                _selectDate(context),
              },
              icon: const Icon(Icons.calendar_month),
            ),
          ],
        )
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedAppointmentDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != _selectedAppointmentDate) {
      setState(() {
        _selectedAppointmentDate = picked;
        setValue();
      });
    }
  }
}

import 'package:flutter/material.dart';

class CustomDateFormField extends StatefulWidget {
  const CustomDateFormField({Key? key}) : super(key: key);

  @override
  State<CustomDateFormField> createState() => _CustomDateFormFieldState();
}

class _CustomDateFormFieldState extends State<CustomDateFormField> {
  DateTime _selectedAppointmentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Flexible(
        child: Column(
          children: [
            InputDatePickerFormField(
                initialDate: _selectedAppointmentDate,
                fieldLabelText: "Appointment Date",
                firstDate: DateTime(2000),
                lastDate: DateTime(2100)),
          ],
        ),
      ),
      Column(
        children: [
          OutlinedButton(
              onPressed: () => _selectDate(context),
              child: const Icon(Icons.calendar_month)),
        ],
      )
    ]);
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
      });
    }
  }
}

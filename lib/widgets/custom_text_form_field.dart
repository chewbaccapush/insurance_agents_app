import 'dart:ffi';

import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final TextInputType type;
  final String? labelText;
  final double? width;
  final String? initialValue;
  final ValueChanged<String>? onChanged;

  const CustomTextFormField(
      {Key? key,
      required this.type,
      this.labelText,
      this.width,
      this.initialValue,
      this.onChanged})
      : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(padding: EdgeInsets.all(10)),
        SizedBox(
          width: widget.width,
          child: TextFormField(
              initialValue: widget.initialValue,
              onChanged: widget.onChanged,
              decoration: inputDecoration(widget.labelText, widget.width),
              keyboardType: widget.type,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vnesite podatke.';
                }
                return null;
              }),
        ),
        const Padding(padding: EdgeInsets.all(10)),
      ],
    );
  }

  InputDecoration inputDecoration(labelText, width) {
    return InputDecoration(label: Text(labelText));
  }
}

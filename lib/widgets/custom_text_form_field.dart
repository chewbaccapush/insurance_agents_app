import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final TextInputType type;
  const CustomTextFormField({Key? key, required this.type}) : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: TextFormField(
          keyboardType: widget.type,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vnesite podatke.';
            }
            return null;
          }),
    );
  }
}

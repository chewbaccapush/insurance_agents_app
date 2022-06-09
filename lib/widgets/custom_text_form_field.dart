import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextInputType type;
  final String? labelText;
  final double? width;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final double? fontSize;
  final bool? enabled;
  final Widget? suffix;
  final bool? obscureText;

  const CustomTextFormField(
      {Key? key,
      required this.type,
      this.labelText,
      this.width,
      this.initialValue,
      this.onChanged,
      this.validator,
      this.fontSize,
      this.enabled,
      this.suffix,
      this.obscureText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(padding: EdgeInsets.all(10)),
        SizedBox(
          width: width,
          child: TextFormField(
            enabled: enabled,
            cursorColor: Theme.of(context).colorScheme.onPrimary,
            style: TextStyle(
                fontSize: fontSize,
                color: Theme.of(context).colorScheme.onPrimary),
            initialValue: initialValue == "null" ? "" : initialValue,
            onChanged: onChanged,
            decoration: inputDecoration(labelText, width),
            keyboardType: type,
            validator: validator,
            obscureText: obscureText == null ? false : true,
          ),
        ),
        const Padding(padding: EdgeInsets.all(10)),
      ],
    );
  }

  InputDecoration inputDecoration(labelText, width) {
    return InputDecoration(
      label: Text(labelText),
      suffixIcon: suffix,
      errorStyle: TextStyle(fontSize: 13.0),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class CustomDropdown extends StatelessWidget {
  final double? width;
  final double? height;
  final dynamic value;
  final Text? hint;
  final List<DropdownMenuItem<dynamic>> items;
  final dynamic onChanged;
  const CustomDropdown(
      {Key? key,
      required this.value,
      this.hint,
      required this.items,
      required this.onChanged,
      this.width,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: DropdownButton<dynamic>(
          isExpanded: true,
          value: value,
          hint: hint,
          items: items,
          onChanged: onChanged,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary, fontSize: 16)),
    );
  }
}

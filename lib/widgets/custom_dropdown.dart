import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class CustomDropdown extends StatelessWidget {
  final double? width;
  final dynamic value;
  final List<DropdownMenuItem<dynamic>> items;
  final dynamic onChanged;
  const CustomDropdown(
      {Key? key,
      required this.value,
      required this.items,
      required this.onChanged,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: DropdownButton<dynamic>(
          isExpanded: true, value: value, items: items, onChanged: onChanged),
    );
  }
}

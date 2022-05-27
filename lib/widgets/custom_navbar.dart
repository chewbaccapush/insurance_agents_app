import 'package:flutter/material.dart';
import 'package:msg/screens/history.dart';
import 'package:msg/screens/settings.dart';
import 'package:msg/widgets/routing_button.dart';

class CustomNavbar extends StatelessWidget {
  final Widget leading;
  final bool settings;
  const CustomNavbar({Key? key, required this.leading, this.settings = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[leading],
    );
  }
}

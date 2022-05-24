import 'package:flutter/material.dart';

class RoutingButton extends StatelessWidget {
  final Widget destination;
  final Icon icon;
  final Text label;
  const RoutingButton(
      {Key? key,
      required this.destination,
      required this.icon,
      required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      label: label,
      icon: icon,
      onPressed: () => {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => destination,
          ),
        )
      },
    );
  }
}

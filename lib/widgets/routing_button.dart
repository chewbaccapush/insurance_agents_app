import 'package:flutter/material.dart';

class RoutingButton extends StatelessWidget {
  final Widget destination;
  final Icon icon;
  final String? tooltip;

  const RoutingButton(
      {Key? key, required this.destination, required this.icon, this.tooltip})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon,
      tooltip: tooltip,
      iconSize: 40,
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

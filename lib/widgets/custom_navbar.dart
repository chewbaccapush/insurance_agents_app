import 'package:flutter/material.dart';
import 'package:msg/widgets/routing_button.dart';

class CustomNavbar extends StatelessWidget {
  final Widget leading;
  final Icon firstIcon;
  final Icon secondIcon;
  final Widget firstDestination;
  final Widget secondDestination;
  const CustomNavbar(
      {Key? key,
      required this.leading,
      required this.firstIcon,
      required this.secondIcon,
      required this.firstDestination,
      required this.secondDestination})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        leading,
        Row(
          children: [
            RoutingButton(
              icon: firstIcon,
              destination: firstDestination,
            ),
            const Padding(padding: EdgeInsets.only(right: 20)),
            RoutingButton(
              icon: secondIcon,
              destination: secondDestination,
            ),
          ],
        )
      ],
    );
  }
}

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../views/settings.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  String newEntryOtpCode = '';

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            height: MediaQuery.of(context).padding.bottom + 55.0,
            decoration: BoxDecoration(
                color: CupertinoTheme.of(context).primaryColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10.0))),
            padding: EdgeInsets.only(
              top: 10.0,
              left: 10.0,
              right: 10.0,
              bottom: MediaQuery.of(context).viewPadding.bottom,
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              reverse: true,
              children: [
                const SizedBox(width: 10.0),
                _buildButton(
                    'History',
                    CupertinoIcons.gear_alt_fill,
                    () => Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => const SettingsPage()))),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(String name, IconData? icon, Function() onTap) {
    return ElevatedButton(
      child: Row(
        children: [
          Icon(
            icon!,
            size: 20.0,
            color: Theme.of(context).textTheme.bodyText1!.color,
          ),
          const SizedBox(width: 10.0),
          Text(
            name,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyText1!.color,
            ),
          ),
        ],
      ),
      onPressed: onTap,
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all(CupertinoColors.white.withOpacity(.3)),
        elevation: MaterialStateProperty.all(0.0),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}

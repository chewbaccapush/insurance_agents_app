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
            height: MediaQuery.of(context).padding.bottom + 80.0,
            decoration: BoxDecoration(
                color: CupertinoTheme.of(context).primaryColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(35.0))),
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
                const SizedBox(width: 35.0),
                _buildButton(
                    'Zgodovina',
                    Icons.history,
                    () => Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => const SettingsPage()))),
                const SizedBox(width: 40.0),
                _buildButton(
                    'Nalogi',
                    Icons.history,
                    () => Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => const SettingsPage()))),
                const SizedBox(width: 40.0),
                _buildButton(
                    'Nalogi',
                    Icons.history,
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
        child: Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              Icon(
                icon!,
                size: 35.0,
                color: Colors.white,
              ),
              Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: Colors.transparent,
          ),
        ));
  }
}

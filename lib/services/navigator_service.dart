import 'package:flutter/material.dart';

class NavigatorService {
  static navigateTo(context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: ((context) => page)));
  }
}

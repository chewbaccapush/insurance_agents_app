import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class CustomDialog extends StatelessWidget {
  final Text? title;
  final dynamic actions;
  const CustomDialog({Key? key, this.title, this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding:
          const EdgeInsets.only(top: 100, left: 120, right: 120, bottom: 15),
      actionsPadding:
          const EdgeInsets.only(bottom: 100, left: 120, right: 120, top: 15),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(40))),
      title: title,
      actions: actions,
    );
  }
}

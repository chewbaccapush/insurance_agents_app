import 'package:flutter/material.dart';

import '../services/storage_service.dart';

class CustomDialog extends StatelessWidget {
  final dynamic title;
  final dynamic actions;
  final bool twoButtons;
  final dynamic titleButtonOne;
  final dynamic onPressedButtonOne;
  final Text? titleButtonTwo;
  final dynamic onPressedButtonTwo;
  const CustomDialog({
    Key? key,
    this.title,
    this.actions,
    this.twoButtons = true,
    required this.titleButtonOne,
    this.onPressedButtonOne,
    this.titleButtonTwo,
    this.onPressedButtonTwo,
  }) : super(key: key);

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
      actions: twoButtons
          ? [
              ElevatedButton(
                child: titleButtonOne,
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  primary: (StorageService.getAppThemeId() == false)
                      ? const Color.fromARGB(220, 112, 14, 46)
                      : const Color.fromARGB(148, 112, 14, 46),
                ),
                onPressed: onPressedButtonOne,
              ),
              ElevatedButton(
                child: titleButtonTwo,
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  primary: (StorageService.getAppThemeId() == false)
                      ? const Color.fromARGB(220, 112, 14, 46)
                      : const Color.fromARGB(148, 112, 14, 46),
                ),
                onPressed: onPressedButtonTwo,
              ),
            ]
          : [
              ElevatedButton(
                child: titleButtonOne,
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  primary: (StorageService.getAppThemeId() == false)
                      ? const Color.fromARGB(220, 112, 14, 46)
                      : const Color.fromARGB(148, 112, 14, 46),
                ),
                onPressed: onPressedButtonOne,
              ),
            ],
    );
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

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
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Scaffold(
            backgroundColor: Colors.black.withOpacity(
                0.4), // this is the main reason of transparency at next screen. I am ignoring rest implementation but what i have achieved is you can see.
            body: AnimationConfiguration.staggeredList(
                position: 1,
                duration: const Duration(milliseconds: 200),
                child: FadeInAnimation(
                    child: SlideAnimation(
                        verticalOffset: 35.0,
                        curve: Curves.easeOutCubic,
                        duration: const Duration(milliseconds: 500),
                        child: ScaleAnimation(
                            scale: .9,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [title],
                                    ),
                                  ),
                                  (twoButtons == true)
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10.0),
                                                child: ElevatedButton(
                                                  child: titleButtonOne,
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape:
                                                        const StadiumBorder(),
                                                    primary: (StorageService
                                                                .getAppThemeId() ==
                                                            false)
                                                        ? const Color.fromARGB(
                                                            220, 112, 14, 46)
                                                        : const Color.fromARGB(
                                                            255, 112, 14, 46),
                                                  ),
                                                  onPressed: onPressedButtonOne,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0),
                                                child: ElevatedButton(
                                                  child: titleButtonTwo,
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape:
                                                        const StadiumBorder(),
                                                    primary: (StorageService
                                                                .getAppThemeId() ==
                                                            false)
                                                        ? const Color.fromARGB(
                                                            255, 112, 14, 46)
                                                        : const Color.fromARGB(
                                                            255, 112, 14, 46),
                                                  ),
                                                  onPressed: onPressedButtonTwo,
                                                ),
                                              )
                                            ])
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              child: titleButtonOne,
                                              style: ElevatedButton.styleFrom(
                                                shape: const StadiumBorder(),
                                                primary: (StorageService
                                                            .getAppThemeId() ==
                                                        false)
                                                    ? const Color.fromARGB(
                                                        220, 112, 14, 46)
                                                    : const Color.fromARGB(
                                                        148, 112, 14, 46),
                                              ),
                                              onPressed: onPressedButtonOne,
                                            ),
                                          ],
                                        ),
                                ])))))));
  }

  /* AlertDialog(
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
    */
}

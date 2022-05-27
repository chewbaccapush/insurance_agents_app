import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class BuildFilterButtons extends StatelessWidget {
  const BuildFilterButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: 1,
      duration: const Duration(milliseconds: 200),
      delay: const Duration(milliseconds: 25),
      child: FadeInAnimation(
        child: SlideAnimation(
          verticalOffset: 35.0,
          curve: Curves.easeOutCubic,
          duration: const Duration(milliseconds: 500),
          child: ScaleAnimation(
            scale: .9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Brightness',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  height: 60.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Theme.of(context).highlightColor,
                  ),
                  child: Stack(
                    children: [
                      AnimatedAlign(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutCubic,
                        alignment: Alignment.center,
                        child: FractionallySizedBox(
                          widthFactor: .33,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 6.0,
                              vertical: 5.0,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color:
                                  Theme.of(context).primaryColor.withOpacity(1),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              // DON'T REMOVE THIS CONTAINER! HIT TARGET IS ONLY TEXT WITHOUT IT
                              color: Colors.transparent,
                              child: Center(
                                child: Text(
                                  'Light',
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          )),
                          Expanded(
                              child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              color: Colors.transparent,
                              child: Center(
                                child: Text(
                                  'Dark',
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          )),
                          Expanded(
                              child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              color: Colors.transparent,
                              child: Center(
                                child: Text(
                                  'System',
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

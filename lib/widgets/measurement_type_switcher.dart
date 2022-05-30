// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:msg/models/Measurement/measurement.dart';

import '../models/Measurement/measurement_type.dart';

class MeasurementTypeSwitcher extends StatefulWidget {
  Measurement measurement; 
  dynamic onTapRectangular;
  dynamic onTapCircular;
  MeasurementTypeSwitcher({
    Key? key,
    required this.measurement,
    required this.onTapRectangular,
    required this.onTapCircular,
  }) : super(key: key);

  @override
  State<MeasurementTypeSwitcher> createState() => _MeasurementTypeSwitcherState();
}

class _MeasurementTypeSwitcherState extends State<MeasurementTypeSwitcher> {
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
                Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.25),
                  ),
                  child: Stack(
                    children: [
                      AnimatedAlign(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutCubic,
                        alignment: getCorrectContainerAlignment(),
                        child: FractionallySizedBox(
                          widthFactor: .50,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 6.0,
                              vertical: 5.0,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: GestureDetector(
                            onTap: widget.onTapRectangular,
                            child: Container(
                              color: Colors.transparent,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Text('Rectangular',
                                          style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Theme.of(context).colorScheme.onPrimary),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )),
                          Expanded(
                              child: GestureDetector(
                            onTap: widget.onTapCircular,
                            child: Container(
                              color: Colors.transparent,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Text('Circular',
                                          style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Theme.of(context).colorScheme.onPrimary),
                                        ),
                                      ],
                                    )
                                  ],
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
  Alignment getCorrectContainerAlignment() {
    switch (widget.measurement.measurementType) {
      case MeasurementType.rectangular:
        return Alignment.centerLeft;
      case MeasurementType.circular:
        return Alignment.centerRight;
      default:
        return Alignment.centerLeft;
    }
  }

}
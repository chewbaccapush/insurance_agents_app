import 'package:flutter/material.dart';
import 'package:msg/models/Measurement/measurement.dart';

class MeasurementTile extends StatelessWidget {
  final Measurement entry;
  final BuildContext widgetContext;

  const MeasurementTile(
      {Key? key, required this.widgetContext, required this.entry})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 5, left: 20, right: 20),
                        child: Row(
                          children: [
                            Text(
                              'Length:    ',
                              style:
                                  Theme.of(widgetContext).textTheme.bodyText1,
                            ),
                            Text(
                              entry.length.toString() == "null"
                                  ? ""
                                  : entry.length.toString(),
                              style:
                                  Theme.of(widgetContext).textTheme.bodyText2,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 5, left: 20, right: 20),
                        child: Row(
                          children: [
                            Text(
                              'Height:    ',
                              style:
                                  Theme.of(widgetContext).textTheme.bodyText1,
                            ),
                            Text(
                                entry.height.toString() == "null"
                                    ? ""
                                    : entry.height.toString(),
                                style:
                                    Theme.of(widgetContext).textTheme.bodyText2)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 5, left: 20, right: 20),
                        child: Row(
                          children: [
                            Text(
                              'Width:    ',
                              style:
                                  Theme.of(widgetContext).textTheme.bodyText1,
                            ),
                            Text(
                                entry.width.toString() == "null"
                                    ? ""
                                    : entry.width.toString(),
                                style:
                                    Theme.of(widgetContext).textTheme.bodyText2)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 20, left: 20, right: 20),
                        child: Row(
                          children: [
                            Text(
                              'Radius:    ',
                              style:
                                  Theme.of(widgetContext).textTheme.bodyText1,
                            ),
                            Text(
                              entry.radius.toString() == "null"
                                  ? ""
                                  : entry.radius.toString(),
                              style:
                                  Theme.of(widgetContext).textTheme.bodyText2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Container(
                  margin: const EdgeInsets.only(left: 80),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 105, right: 20),
                        child: Row(
                          children: [
                            Text(
                              'Description:    ',
                              style:
                                  Theme.of(widgetContext).textTheme.bodyText1,
                            ),
                            Text(
                              entry.description.toString(),
                              style:
                                  Theme.of(widgetContext).textTheme.bodyText2,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

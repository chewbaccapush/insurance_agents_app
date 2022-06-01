import 'package:flutter/material.dart';
import 'package:msg/models/Measurement/measurement.dart';

class MeasurementTile extends StatelessWidget {
  final Measurement entry;
  final BuildContext widgetContext;

  bool checkIfEmpty() {
    if (entry.radius.toString() == "null" &&
        entry.height.toString() == "null" &&
        entry.width.toString() == "null" &&
        entry.length.toString() == "null") {
      return true;
    } else {
      return false;
    }
  }

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
              checkIfEmpty() == false
                  ? Expanded(
                      flex: 3,
                      child: Container(
                        margin: EdgeInsets.only(top: 20, bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            entry.length != null
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 10, left: 20, right: 20),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Length:    ',
                                          style: Theme.of(widgetContext)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                        Text(
                                          entry.length.toString() == "null"
                                              ? ""
                                              : entry.length.toString(),
                                          style: Theme.of(widgetContext)
                                              .textTheme
                                              .bodyText2,
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            entry.height != null
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 10, left: 20, right: 20),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Height:    ',
                                          style: Theme.of(widgetContext)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                        Text(
                                            entry.height.toString() == "null"
                                                ? ""
                                                : entry.height.toString(),
                                            style: Theme.of(widgetContext)
                                                .textTheme
                                                .bodyText2)
                                      ],
                                    ),
                                  )
                                : Container(),
                            entry.width != null
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 10, left: 20, right: 20),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Width:    ',
                                          style: Theme.of(widgetContext)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                        Text(
                                            entry.width.toString() == "null"
                                                ? ""
                                                : entry.width.toString(),
                                            style: Theme.of(widgetContext)
                                                .textTheme
                                                .bodyText2)
                                      ],
                                    ),
                                  )
                                : Container(),
                            entry.radius != null
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Radius:    ',
                                          style: Theme.of(widgetContext)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                        Text(
                                          entry.radius.toString() == "null"
                                              ? ""
                                              : entry.radius.toString(),
                                          style: Theme.of(widgetContext)
                                              .textTheme
                                              .bodyText2,
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              Expanded(
                flex: 7,
                child: Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20, left: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Description:    ',
                                  style: Theme.of(widgetContext)
                                      .textTheme
                                      .bodyText1,
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                        entry.description.toString() == "DRAFT"
                                            ? "Draft"
                                            : entry.description.toString(),

                                        // 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s.',
                                        style: Theme.of(widgetContext)
                                            .textTheme
                                            .bodyText2),
                                  ),
                                ],
                              ),
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

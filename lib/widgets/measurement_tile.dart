import 'package:flutter/material.dart';
import 'package:msg/models/Measurement/measurement.dart';

class MeasurementTile extends StatefulWidget {
  final Measurement entry;

  const MeasurementTile({Key? key, required this.entry}) : super(key: key);

  @override
  State<MeasurementTile> createState() => _MeasurementTileState();
}

class _MeasurementTileState extends State<MeasurementTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
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
                              const Text(
                                'Length:    ',
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(widget.entry.length.toString(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color:
                                          Color.fromARGB(255, 219, 219, 219)))
                            ],
                          )),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 20, right: 20),
                          child: Row(
                            children: [
                              const Text(
                                'Height:    ',
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(widget.entry.height.toString(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color:
                                          Color.fromARGB(255, 219, 219, 219)))
                            ],
                          )),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 20, right: 20),
                          child: Row(
                            children: [
                              const Text(
                                'Width:    ',
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(widget.entry.width.toString(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color:
                                          Color.fromARGB(255, 219, 219, 219)))
                            ],
                          )),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 20, left: 20, right: 20),
                          child: Row(
                            children: [
                              const Text(
                                'Radius:    ',
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(widget.entry.radius.toString(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color:
                                          Color.fromARGB(255, 219, 219, 219)))
                            ],
                          )),
                    ]))),
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
                                const Text(
                                  'Description:    ',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(widget.entry.description.toString(),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 219, 219, 219)))
                              ],
                            )),
                      ],
                    )))
          ]),
        ),
      ],
    );
  }
}

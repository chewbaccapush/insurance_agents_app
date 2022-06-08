import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:msg/models/BuildingPart/insured_type.dart';
import 'package:msg/models/BuildingPart/construction_class.dart';
import 'package:msg/models/BuildingPart/fire_protection.dart';
import 'package:msg/models/BuildingPart/risk_class.dart';

import '../models/BuildingPart/building_part.dart';
import '../services/storage_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BuildingPartTile extends StatefulWidget {
  final BuildContext context;
  final BuildingPart? entry;
  final List<Widget>? measurements;

  const BuildingPartTile(
      {Key? key, required this.context, this.entry, this.measurements})
      : super(key: key);

  @override
  State<BuildingPartTile> createState() => _BuildingPartTileState();
}

class _BuildingPartTileState extends State<BuildingPartTile> {
  bool checkIfEmptyFirstColumn() {
    if (int.tryParse(widget.entry!.buildingYear.toString()) == null &&
        widget.entry!.fireProtection == null &&
        widget.entry!.constructionClass == null &&
        widget.entry!.insuredType == null &&
        widget.entry!.riskClass == null &&
        widget.entry!.devaluationPercentage == null &&
        double.tryParse(widget.entry!.unitPrice.toString()) == null) {
      return true;
    } else {
      return false;
    }
  }

  bool checkIfEmptySecondColumn() {
    if (widget.entry!.cubature == 0.0 &&
        widget.entry!.value == 0.0 &&
        widget.entry!.sumInsured == 0.0) {
      return true;
    } else {
      return false;
    }
  }

  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Padding(
      padding: widget.entry!.measurements.isEmpty
          ? const EdgeInsets.only(bottom: 20.0)
          : const EdgeInsets.only(bottom: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntrinsicHeight(
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              checkIfEmptyFirstColumn() == false
                  ? Expanded(
                      flex: 3,
                      child: Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              widget.entry!.buildingYear != null
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10,
                                          bottom: 5,
                                          left: 20,
                                          right: 20),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                      .buildingPartForm_buildingYear +
                                                  ":",
                                              style: Theme.of(widget.context)
                                                  .textTheme
                                                  .bodyText2,
                                            ),
                                          ),
                                          Text(
                                              widget.entry!.buildingYear
                                                  .toString(),
                                              style: Theme.of(widget.context)
                                                  .textTheme
                                                  .bodyText1)
                                        ],
                                      ))
                                  : Container(),
                              widget.entry!.fireProtection != null
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5,
                                          bottom: 5,
                                          left: 20,
                                          right: 20),
                                      child: Row(
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10.0),
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                          .buildingPart_fireProtection +
                                                      ":",
                                                  style:
                                                      Theme.of(widget.context)
                                                          .textTheme
                                                          .bodyText2,
                                                ),
                                              ),
                                              Text(
                                                widget.entry!.fireProtection!
                                                    .name!,
                                                style: Theme.of(widget.context)
                                                    .textTheme
                                                    .bodyText1,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(),
                              widget.entry!.constructionClass != null
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5,
                                          bottom: 5,
                                          left: 20,
                                          right: 0),
                                      child: Row(
                                        children: [
                                          (isPortrait &&
                                                  checkIfEmptySecondColumn() ==
                                                      false)
                                              ? Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          AppLocalizations.of(
                                                                      context)!
                                                                  .buildingPart_constructionClass +
                                                              ":",
                                                          style: Theme.of(widget
                                                                  .context)
                                                              .textTheme
                                                              .bodyText2,
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          widget
                                                              .entry!
                                                              .constructionClass!
                                                              .name!,
                                                          style: Theme.of(widget
                                                                  .context)
                                                              .textTheme
                                                              .bodyText1,
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                )
                                              : Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 10.0),
                                                      child: Text(
                                                        AppLocalizations.of(
                                                                    context)!
                                                                .buildingPart_constructionClass +
                                                            ":",
                                                        style: Theme.of(
                                                                widget.context)
                                                            .textTheme
                                                            .bodyText2,
                                                      ),
                                                    ),
                                                    Text(
                                                      widget
                                                          .entry!
                                                          .constructionClass!
                                                          .name!,
                                                      style: Theme.of(
                                                              widget.context)
                                                          .textTheme
                                                          .bodyText1,
                                                    )
                                                  ],
                                                )
                                        ],
                                      ))
                                  : Container(),
                              widget.entry!.riskClass != null
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5,
                                          bottom: 5,
                                          left: 20,
                                          right: 20),
                                      child: Row(
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10.0),
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                          .buildingPart_riskClass +
                                                      ":",
                                                  style:
                                                      Theme.of(widget.context)
                                                          .textTheme
                                                          .bodyText2,
                                                ),
                                              ),
                                              Text(
                                                widget.entry!.riskClass!.name!,
                                                style: Theme.of(widget.context)
                                                    .textTheme
                                                    .bodyText1,
                                              )
                                            ],
                                          )
                                        ],
                                      ))
                                  : Container(),
                              widget.entry!.unitPrice != null
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5,
                                          bottom: 5,
                                          left: 20,
                                          right: 20),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                      .buildingPart_unitPrice +
                                                  ":",
                                              style: Theme.of(widget.context)
                                                  .textTheme
                                                  .bodyText2,
                                            ),
                                          ),
                                          Text(
                                              widget.entry!.unitPrice!
                                                      .toStringAsFixed(0) +
                                                  ' €',
                                              style: Theme.of(widget.context)
                                                  .textTheme
                                                  .bodyText1)
                                        ],
                                      ))
                                  : Container(),
                              widget.entry!.insuredType != null
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5,
                                          bottom: 5,
                                          left: 20,
                                          right: 20),
                                      child: Row(
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10.0),
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                          .buildingPart_insuredType +
                                                      ":",
                                                  style:
                                                      Theme.of(widget.context)
                                                          .textTheme
                                                          .bodyText2,
                                                ),
                                              ),
                                              Text(
                                                widget
                                                    .entry!.insuredType!.name!,
                                                style: Theme.of(widget.context)
                                                    .textTheme
                                                    .bodyText1,
                                              )
                                            ],
                                          )
                                        ],
                                      ))
                                  : Container(),
                              widget.entry!.devaluationPercentage != null
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, left: 20, right: 0),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                      .buildingPart_devaluationPercentage +
                                                  ":",
                                              style: Theme.of(widget.context)
                                                  .textTheme
                                                  .bodyText2,
                                            ),
                                          ),
                                          Text(
                                              widget.entry!
                                                          .devaluationPercentage
                                                          .toString() ==
                                                      "null"
                                                  ? ""
                                                  : widget.entry!
                                                          .devaluationPercentage!
                                                          .toStringAsFixed(0) +
                                                      ' %',
                                              style: Theme.of(widget.context)
                                                  .textTheme
                                                  .bodyText1)
                                        ],
                                      ))
                                  : Container(),
                            ]),
                      ),
                    )
                  : Container(),
              checkIfEmptySecondColumn() == false
                  ? Expanded(
                      flex: 3,
                      child: Container(
                          margin: const EdgeInsets.only(),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                widget.entry!.cubature != 0.0
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5,
                                            bottom: 5,
                                            left: 20,
                                            right: 20),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10.0),
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                        .cubature +
                                                    ":",
                                                style: Theme.of(widget.context)
                                                    .textTheme
                                                    .bodyText2,
                                              ),
                                            ),
                                            Text(
                                                widget.entry!.cubature!
                                                        .toStringAsFixed(0) +
                                                    " m\u00B3",
                                                style: Theme.of(widget.context)
                                                    .textTheme
                                                    .bodyText1)
                                          ],
                                        ))
                                    : Container(),
                                widget.entry!.value != 0.0
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5,
                                            bottom: 5,
                                            left: 20,
                                            right: 20),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10.0),
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                        .value +
                                                    ":",
                                                style: Theme.of(widget.context)
                                                    .textTheme
                                                    .bodyText2,
                                              ),
                                            ),
                                            Text(
                                                widget.entry!.value!
                                                        .toStringAsFixed(0) +
                                                    " \u20A3",
                                                style: Theme.of(widget.context)
                                                    .textTheme
                                                    .bodyText1)
                                          ],
                                        ))
                                    : Container(),
                                widget.entry!.sumInsured != 0.0
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5,
                                            bottom: 0,
                                            left: 20,
                                            right: 20),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10.0),
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                        .sumInsured +
                                                    ":",
                                                style: Theme.of(widget.context)
                                                    .textTheme
                                                    .bodyText2,
                                              ),
                                            ),
                                            Text(
                                                widget.entry!.sumInsured!
                                                        .toStringAsFixed(0) +
                                                    " \u20A3",
                                                style: Theme.of(widget.context)
                                                    .textTheme
                                                    .bodyText1)
                                          ],
                                        ))
                                    : Container(),
                              ])))
                  : Container(),
              Expanded(
                  flex: 3,
                  child: Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0),
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                    .description +
                                                ":",
                                            style: Theme.of(widget.context)
                                                .textTheme
                                                .bodyText2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                            widget.entry!.description
                                                        .toString() ==
                                                    "DRAFT"
                                                ? AppLocalizations.of(context)!
                                                    .assessments_draft
                                                : widget.entry!.description
                                                    .toString(),
                                            // 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s.',
                                            style: Theme.of(widget.context)
                                                .textTheme
                                                .bodyText1),
                                      ),
                                    ],
                                  )
                                ],
                              )),
                        ],
                      )))
            ]),
          ),
          widget.measurements!.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(
                    bottom: 0,
                    left: 5,
                    right: 15,
                  ),
                  child: Theme(
                      data: ThemeData()
                          .copyWith(dividerColor: Color.fromARGB(0, 246, 0, 0)),
                      child: ExpansionTile(
                          onExpansionChanged: (value) {
                            setState(() {
                              _isExpanded = value;
                            });
                          },
                          collapsedIconColor: Colors.white,
                          iconColor: Colors.white,
                          textColor: Colors.white,
                          trailing: AnimatedRotation(
                              turns: _isExpanded ? .5 : 0,
                              duration: Duration(milliseconds: 400),
                              child: Icon(
                                Icons.expand_circle_down_outlined,
                                size: 30,
                                color: (StorageService.getAppThemeId() == false)
                                    ? Color.fromARGB(148, 112, 14, 46)
                                    : Theme.of(context).colorScheme.onPrimary,
                              )),
                          title: Text(
                            AppLocalizations.of(context)!
                                .assessments_measurements,
                            style: Theme.of(widget.context).textTheme.headline3,
                          ),
                          children: widget.measurements!)))
              : Container(),
        ],
      ),
    );
  }
}

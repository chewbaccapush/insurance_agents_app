import 'package:flutter/material.dart';
import 'package:msg/screens/settings.dart';
import 'package:msg/services/storage_service.dart';
import 'package:pinput/pinput.dart';

import '../services/navigator_service.dart';
import 'history.dart';

class PinPage extends StatefulWidget {
  final bool changingPin;

  const PinPage({Key? key, required this.changingPin})
      : super(key: key);

  @override
  _PinPageState createState() => _PinPageState();

  @override
  String toStringShort() => 'Rounded Filled';
}

class _PinPageState extends State<PinPage> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  late final changingPin;

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Text getText() {
    if (widget.changingPin) {
      return Text('Please enter a new pin');
    }
    return Text('Please enter your pin');
  }

  @override
  Widget build(BuildContext context) {
    final length = 4;
    const borderColor = Color.fromRGBO(114, 178, 238, 1);
    const errorColor = Color.fromRGBO(255, 234, 238, 1);
    const fillColor = Color.fromRGBO(222, 231, 240, .57);
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ 
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: getText()
            ),
            Pinput(
            length: length,
            controller: controller,
            focusNode: focusNode,
            defaultPinTheme: defaultPinTheme,
            validator: (pin) {
              if (widget.changingPin) {
                NavigatorService.navigateTo(context, const SettingsPage());
                StorageService.setPinCode(pin!);
                return null;
              }
              if (pin == StorageService.getPinCode()) { 
                NavigatorService.navigateTo(context, const HistoryPage());
                return null; 
              }
              return 'Pin is incorrect';
            },
            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
            focusedPinTheme: defaultPinTheme.copyWith(
              height: 68,
              width: 64,
              decoration: defaultPinTheme.decoration!.copyWith(
                border: Border.all(color: borderColor),
              ),
            ),
            errorPinTheme: defaultPinTheme.copyWith(
              decoration: BoxDecoration(
                color: errorColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          ]
      ))),
    );
  }
}
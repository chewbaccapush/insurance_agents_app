import 'package:flutter/material.dart';
import 'package:msg/screens/history.dart';

class ConfirmCancelDialog extends StatelessWidget {
  final String text;
  final dynamic localSave;
  final dynamic previousPage;
  const ConfirmCancelDialog({Key? key, required this.text, required this.localSave, required this.previousPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).colorScheme.onSecondary.withOpacity(0.80),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Flexible(
                child: Text(text, style: Theme.of(context).textTheme.caption),
              )
            ]),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RawMaterialButton(
                    onPressed: () {
                      localSave;
                      Navigator.of(context).push(PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (BuildContext context, _, __) => previousPage));
                    },
                    elevation: 2.0,
                    fillColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(
                      Icons.check_rounded,
                      size: 25.0,
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(12.5),
                    shape: const CircleBorder(),
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      Navigator.of(context).push(PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (BuildContext context, _, __) => previousPage));
                    },
                    elevation: 2.0,
                    fillColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(
                      Icons.clear_rounded,
                      size: 25.0,
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(12.5),
                    shape: const CircleBorder(),
                  )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}

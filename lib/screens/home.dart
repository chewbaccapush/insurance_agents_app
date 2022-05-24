import 'package:flutter/material.dart';

import 'package:msg/screens/building_assessment_form.dart';
import 'package:msg/screens/building_part_form.dart';
import 'package:msg/screens/history.dart';
import 'package:msg/screens/settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    BuildingAssessmentForm(),
    HistoryPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: _widgetOptions.elementAt(1)),
    );
    /*
    bottomNavigationBar:
    BottomNavigationBar(
      items: buildNavigationBarItems(),
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() {
        _selectedIndex = index;
      }),
    );
    */
  }
}
/*
  List<BottomNavigationBarItem> buildNavigationBarItems() {
    return const [
      BottomNavigationBarItem(
        icon: Icon(Icons.send_rounded),
        label: 'Pošlji nalog',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.history),
        label: 'Zgodovina',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: 'Nastavitve',
      )
    ];
  }
}
*/

import 'package:flutter/material.dart';

import 'package:msg/views/value_form.dart';
import 'package:msg/views/history.dart';
import 'package:msg/views/settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    ValueForm(),
    HistoryPage(),
    SettingsPage(),
  ];

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: _widgetOptions.elementAt(_selectedIndex)),
        bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.send_rounded),
                label: 'Pošlji nalog',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.history),
                label: 'Zgodovina',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings),
                label: 'Nastavitve',
              )
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Color.fromARGB(255, 184, 60, 93),
            unselectedItemColor: Colors.grey,
            backgroundColor: Color.fromARGB(255, 54, 52, 52),
            onTap: _onTap,
            elevation: 5,
            iconSize: 40,
            selectedFontSize: 14.5));
  }
}

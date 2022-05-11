import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'widgets/add_entry_dialog.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavigation createState() {
    return _BottomNavigation();
  }
}

class _BottomNavigation extends State<BottomNav> {
  //List<String> _titles = ["Home", "Profile", "Shop"];
  List<Widget> _items = [
    Text(
      'Index 0: Home',
    ),
    Text(
      'Index 1: Profile',
    ),
    Text(
      'Index 2: Shop',
    ),
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag),
          label: 'Shop',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      onTap: _onTap,
    );
  }

  void _onTap(int index) {
    _selectedIndex = index;
    setState(() {});
  }
}

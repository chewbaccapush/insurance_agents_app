import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'widgets/add_entry_dialog.dart';

class BottomNavigationTabBarView extends StatelessWidget {
  var _currentIndex = 0;
  Function onTabChange;

  BottomNavigationTabBarView(this._currentIndex, {required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return bottomNavigationTabBarView();
  }



  BottomNavigationBar bottomNavigationTabBarView() {
    const iconSize = 25.0;
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      onTap: onTabTapped,
       items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: 'Nalogi',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.history),
                label: 'Zgodovina',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings),
                label: 'Nastavitve',
              ),
            ],
    );
  }

  void onTabTapped(int index) {
    _currentIndex = index;
    onTabChange(index);
  }
}

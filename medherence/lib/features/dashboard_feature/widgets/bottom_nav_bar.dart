import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomBottomNavigationBar extends StatelessWidget {
  dynamic model;
  CustomBottomNavigationBar({required this.model, super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 5,
      backgroundColor: Colors.blue,
      selectedItemColor: Colors.white,
      selectedLabelStyle: const TextStyle(
        fontSize: (15),
        fontWeight: FontWeight.w400,
      ),
      unselectedItemColor: Colors.grey.shade300,
      unselectedLabelStyle: const TextStyle(
        fontSize: (12),
        fontWeight: FontWeight.w300,
      ),
      type: BottomNavigationBarType.fixed,
      iconSize: 35,
      currentIndex: model.currentIndex,
      onTap: model.setIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: Colors.grey.shade400,
          ),
          activeIcon: Icon(
            Icons.home_filled,
            color: Colors.white,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.alarm_sharp,
            color: Colors.grey.shade400,
          ),
          activeIcon: Icon(
            Icons.alarm_sharp,
            color: Colors.white,
          ),
          label: 'Reminder',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.menu,
            color: Colors.grey.shade400,
          ),
          activeIcon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          label: 'Menu',
        ),
      ],
    );
  }
}

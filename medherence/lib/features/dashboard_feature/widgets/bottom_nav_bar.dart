import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/color_utils.dart';
import '../../../core/utils/size_manager.dart';

// ignore: must_be_immutable
class CustomBottomNavigationBar extends StatelessWidget {
  dynamic model;
  CustomBottomNavigationBar({required this.model, super.key});

  @override
  Widget build(BuildContext context) {
    SizeMg.init(context);
    return Container(
      height: SizeMg.height(80),
      color: AppColors.navBarColor,
      child: BottomNavigationBar(
        elevation: 5,
        backgroundColor: AppColors.navBarColor,
        selectedItemColor: AppColors.white,
        selectedLabelStyle: TextStyle(
          fontSize: SizeMg.text(14),
          fontWeight: FontWeight.w500,
        ),
        unselectedItemColor: AppColors.unselectedNavBarColor,
        unselectedLabelStyle: TextStyle(
          fontSize: SizeMg.text(12),
          fontWeight: FontWeight.w300,
        ),
        type: BottomNavigationBarType.fixed,
        iconSize: 28,
        unselectedIconTheme: IconThemeData(size: SizeMg.radius(20)),
        currentIndex: model.currentIndex,
        onTap: model.setIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.house_alt,
              color: AppColors.unselectedNavBarColor,
            ),
            activeIcon: Icon(
              CupertinoIcons.house_alt_fill,
              color: AppColors.white,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.alarm_sharp,
              color: AppColors.unselectedNavBarColor,
            ),
            activeIcon: Icon(
              Icons.alarm_sharp,
              color: AppColors.white,
            ),
            label: 'Reminder',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.more_horiz,
              color: AppColors.unselectedNavBarColor,
            ),
            activeIcon: Icon(
              Icons.more_horiz,
              color: AppColors.white,
            ),
            label: 'Menu',
          ),
        ],
      ),
    );
  }
}

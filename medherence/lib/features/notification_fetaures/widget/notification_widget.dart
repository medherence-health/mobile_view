import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constants_utils/color_utils.dart';

class NotificationWidget extends StatelessWidget {
  final int notification;
  final VoidCallback onPressed;

  const NotificationWidget(
      {Key? key, required this.notification, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (notification < 1) {
      return IconButton(
        icon: const Icon(
          CupertinoIcons.bell,
          color: AppColors.navBarColor,
        ),
        onPressed: onPressed,
      );
    }
    return Badge(
      alignment: const AlignmentDirectional(0.2, -0.5),
      smallSize: 5,
      label: const Icon(
        Icons.circle_rounded,
        color: AppColors.red,
        size: 8,
      ),
      //elevation: 0,
      backgroundColor: AppColors.white,
      child: IconButton(
        icon: const Icon(
          CupertinoIcons.bell,
          color: AppColors.navBarColor,
        ),
        onPressed: onPressed,
      ),
    );
  }
}

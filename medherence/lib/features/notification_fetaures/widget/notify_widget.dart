import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants_utils/color_utils.dart';
import '../../../core/model/models/notification_model.dart';

class NotificationContainer extends StatelessWidget {
  final VoidCallback? onPressed;
  final NotificationModel notification;

  const NotificationContainer({
    Key? key,
    this.onPressed,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: AppColors.shadowColor,
      shadowColor: AppColors.progressBarFill,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 3,
                spreadRadius: 0,
                offset: Offset(1, 1),
                color: AppColors.shadowColor,
              ),
              BoxShadow(
                blurRadius: 6,
                spreadRadius: 0,
                offset: Offset(4, 5),
                color: Color.fromRGBO(26, 85, 171, 0.06),
              ),
              BoxShadow(
                blurRadius: 9,
                spreadRadius: 0,
                offset: Offset(10, 10),
                color: Color.fromRGBO(26, 85, 171, 0.04),
              ),
              BoxShadow(
                blurRadius: 10,
                spreadRadius: 0,
                offset: Offset(17, 18),
                color: Color.fromRGBO(26, 85, 171, 0.01),
              ),
              BoxShadow(
                blurRadius: 11,
                spreadRadius: 0,
                offset: Offset(27, 29),
                color: Color.fromRGBO(26, 85, 171, 0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    Icons.yard,
                    size: 24,
                    color: AppColors.pillIconColor,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        notification.subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  notification.notificationDate,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

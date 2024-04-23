import 'dart:math';

import 'package:flutter/material.dart';
import 'package:medherence/core/shared_widget/buttons.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../core/model/models/history_model.dart';
import '../../../core/service/notification_service.dart';
import '../../../core/utils/color_utils.dart';
import '../../../core/utils/size_manager.dart';
import '../view_model/reminder_view_model.dart';

class EditReminderDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ReminderState>(
      builder: (context, reminderState, _) {
        List<HistoryModel> regimenList = reminderState.regimenList;
        int checkedCount = reminderState.getCheckedCount();
        bool showButton = checkedCount > 0;

        // Keep track of scheduled regimens to avoid duplicate notifications
        Set<String> scheduledRegimens = {};

        // Schedule notifications for each regimen
        for (HistoryModel regimen in regimenList) {
          // Check if the regimen is checked and has not been scheduled before
          if (reminderState.isChecked(regimen) &&
              !scheduledRegimens.contains(regimen.regimenName)) {
            // Generate a random time between 8:00 AM and 10:00 PM
            final random = Random();
            final hour = random.nextInt(15) + 8; // Random hour between 8 and 22
            final minute = random.nextInt(60); // Random minute between 0 and 59

            // Format the hour to include "AM" or "PM"
            String formattedHour;
            if (hour >= 12) {
              formattedHour = (hour == 12) ? '12' : (hour - 12).toString();
              formattedHour += ' PM';
            } else {
              formattedHour = (hour == 0) ? '12' : hour.toString();
              formattedHour += ' AM';
            }

            final time = '$formattedHour:${minute.toString().padLeft(2, '0')}';

            // Schedule notification
            scheduleNotification(
                context, regimen.regimenName, regimen.dosage, time);

            // Add the regimen to the set of scheduled regimens
            scheduledRegimens.add(regimen.regimenName);
          }
        }

        return Container(
          width: SizeMg.screenWidth,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 25.0,
                  right: 25,
                ),
                child: ListView.builder(
                  itemCount: regimenList.length,
                  itemBuilder: (context, index) {
                    HistoryModel regimen = regimenList[index];
                    // Generate a random time between 8:00 AM and 10:00 PM
                    final random = Random();
                    final hour =
                        random.nextInt(15) + 8; // Random hour between 8 and 22
                    final minute =
                        random.nextInt(60); // Random minute between 0 and 59

                    // Format the hour to include "AM" or "PM"
                    String formattedHour;
                    if (hour >= 12) {
                      formattedHour =
                          (hour == 12) ? '12' : (hour - 12).toString();
                      formattedHour += ' PM';
                    } else {
                      formattedHour = (hour == 0) ? '12' : hour.toString();
                      formattedHour += ' AM';
                    }

                    final time =
                        '$formattedHour:${minute.toString().padLeft(2, '0')}';

                    return _buildRegimenTile(
                        context, regimen, reminderState, time);
                  },
                ),
              ),
              if (showButton)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: SizeMg.height(100),
                    color: AppColors.offWhite,
                    child: Padding(
                      padding: EdgeInsets.only(
                        // bottom: SizeMg.height(60.0),
                        left: SizeMg.width(10.0),
                        right: SizeMg.width(10.0),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(right: SizeMg.width(8)),
                                child: Icon(
                                  Icons.feedback_rounded,
                                  color: Colors.blue.shade200,
                                ),
                              ),
                              Flexible(
                                child: RichText(
                                  text: TextSpan(
                                    text:
                                        'Select multiple medications if you\'ll be using them together, and select them singly if you\'ll be using them separately.',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: SizeMg.text(12),
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Expanded(
                            child: PrimaryButton(
                              textSize: 18,
                              height: SizeMg.height(60),
                              buttonConfig: ButtonConfig(
                                text: 'Take med ($checkedCount)',
                                action: () {},
                              ),
                              width: SizeMg.screenWidth,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

// Inside the _buildRegimenTile method
  Widget _buildRegimenTile(
    BuildContext context,
    HistoryModel regimen,
    ReminderState state,
    String time,
  ) {
    return CheckboxListTile(
      value: state.isChecked(regimen), // Check if the regimen is checked
      onChanged: (value) {
        state.toggleChecked(regimen); // Toggle regimen checked status
      },
      title: Text(
        '${regimen.regimenName}',
        style: TextStyle(
          fontSize: SizeMg.text(20),
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${regimen.dosage}',
            style: TextStyle(
              fontSize: SizeMg.text(16),
              fontWeight: FontWeight.w400,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 20.0,
              right: 10,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.historyBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 15.0,
                  right: 15,
                  top: 8,
                  bottom: 8,
                ),
                child: Text(
                  time,
                  style: TextStyle(
                    color: AppColors.navBarColor,
                    fontSize: SizeMg.text(16),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // void scheduleNotification(
  //     BuildContext context, String regimenName, String dosage, String time) {
  //   final notificationService =
  //       Provider.of<NotificationService>(context, listen: false);
  //   final now = DateTime.now();
  //   final scheduledTime =
  //       now.add(Duration(seconds: 5)); // Example: Schedule after 5 seconds
  //   notificationService.showScheduledNotification(
  //     regimenName,
  //     dosage,
  //     scheduledTime,
  //   );
  // }
  void scheduleNotification(
      BuildContext context, String regimenName, String dosage, String time) {
    final notificationService =
        Provider.of<NotificationService>(context, listen: false);

    // Split the time string into hour, minute, and AM/PM parts
    final parts = time.split(' ');
    final timeParts = parts[0].split(':');
    var hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    // Determine whether it's AM or PM
    final isPM = parts[1] == 'PM';

    // Adjust the hour if it's PM and not already 12 PM
    if (isPM && hour != 12) {
      hour += 12;
    }

    // Get the current date
    final now = DateTime.now();

    // Construct the scheduled time
    final scheduledTime = DateTime(now.year, now.month, now.day, hour, minute);

    notificationService.showScheduledNotification(
        regimenName, dosage, scheduledTime);
  }
}

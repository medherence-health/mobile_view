import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:medherence/core/shared_widget/buttons.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

import '../../../core/model/models/history_model.dart';
import '../../../core/service/notification_service.dart';
import '../../../core/utils/color_utils.dart';
import '../../../core/utils/size_manager.dart';
import '../../dashboard_feature/view/dashboard_view.dart';
import '../view_model/reminder_view_model.dart';

class EditReminderDetails extends StatefulWidget {
  @override
  _EditReminderDetailsState createState() => _EditReminderDetailsState();
}

class _EditReminderDetailsState extends State<EditReminderDetails> {
  // dynamic time;

// Initialize timezone data

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReminderState>(
      builder: (context, reminderState, _) {
        List<HistoryModel> regimenList = reminderState.regimenList;
        int checkedCount = reminderState.getCheckedCount();
        bool showButton = checkedCount > 0;
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
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 18);
                  },
                  itemCount: regimenList.length,
                  itemBuilder: (context, index) {
                    HistoryModel regimen = regimenList[
                        index]; // Modify this as per your requirement
                    return _buildRegimenTile(
                      context,
                      regimen,
                      reminderState,
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Column(
                  children: [
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: ElevatedButton(
                          onPressed: () {
                            context
                                .read<NotificationService>()
                                .scheduleAlarmsFromSavedReminders();
                          },
                          child: Text("Set Alarm")),
                    ),
                    InkWell(
                      onTap: () {
                        // Handle select all logic here
                        reminderState.selectAll();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 25.0),
                        child: Text(
                          'Select All',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: AppColors.pillIconColor,
                            fontSize: SizeMg.text(14),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
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
                              textSize: 23,
                              height: SizeMg.height(60),
                              buttonConfig: ButtonConfig(
                                text: 'Take med ($checkedCount)',
                                action: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Pills taken successfully')),
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const DashboardView()),
                                  );
                                  setState(() {
                                    reminderState
                                        .clearCheckedItems(); // Clear checked count and uncheck all items
                                    checkedCount = 0; // Reset the checked count
                                  });
                                },
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

  Widget _buildRegimenTile(
    BuildContext context,
    HistoryModel regimen,
    ReminderState state,
  ) {
    return Container(
      width: SizeMg.screenWidth,
      decoration: BoxDecoration(
        color: AppColors.historyBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 8,
            ),
            child: Checkbox(
              value:
                  state.isChecked(regimen), // Check if the regimen is checked
              onChanged: (value) {
                state.toggleChecked(regimen); // Toggle regimen checked status
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Image.asset(
              'assets/images/pill.png',
              height: 30,
              width: 30,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${regimen.regimenName}',
                style: TextStyle(
                  fontSize: SizeMg.text(18),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${regimen.dosage}',
                style: TextStyle(
                  fontSize: SizeMg.text(14),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
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
                  regimen.time,
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
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medherence/core/shared_widget/buttons.dart';
import 'package:medherence/core/utils/date_utils.dart';
import 'package:provider/provider.dart';

import '../../../core/model/models/history_model.dart';
import '../../../core/utils/color_utils.dart';
import '../../../core/utils/size_manager.dart';
import '../view_model/reminder_view_model.dart';
import '../widget/medcoin_drop_widget.dart';

class EditReminderDetails extends StatefulWidget {
  const EditReminderDetails({super.key});

  @override
  _EditReminderDetailsState createState() => _EditReminderDetailsState();
}

class _EditReminderDetailsState extends State<EditReminderDetails> {
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
        bool allSelected = reminderState.areAllSelected();

        return SizedBox(
          width: SizeMg.screenWidth,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              if (regimenList.isEmpty)
                const Center(
                  child: SizedBox(
                    height: 250,
                    width: 300,
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Icon(
                          Icons.check_circle_outline_sharp,
                          color: AppColors.noWidgetText,
                          size: 30,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Yayy, You have taken all medications for today',
                          style: TextStyle(
                            fontSize: (18),
                            fontStyle: FontStyle.italic,
                            color: AppColors.noWidgetText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25),
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 15);
                  },
                  itemCount: regimenList.length,
                  itemBuilder: (context, index) {
                    HistoryModel regimen = regimenList[index];
                    return _buildRegimenTile(
                      context,
                      regimen,
                      reminderState,
                    );
                  },
                ),
              ),
              if (regimenList.isNotEmpty && !allSelected)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    children: [
                      const Spacer(),
                      InkWell(
                        onTap: () {
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
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: SizeMg.width(20.0),
                      right: SizeMg.width(20.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: SizeMg.width(8)),
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
                        const SizedBox(height: 10),
                        PrimaryButton(
                          height: SizeMg.height(45),
                          textSize: SizeMg.text(23),
                          buttonConfig: ButtonConfig(
                            text: 'Take med',
                            extraText: ' ($checkedCount)',
                            action: () {
                              int medhecoinEarned = checkedCount * 100;
                              reminderState.addMedcoin(medhecoinEarned);

                              // Navigator.of(context).pushAndRemoveUntil(
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             MedicationAdherenceScreen()),
                              //     (Route<dynamic> route) => false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Pills taken successfully')),
                              );
                              // Get current date and time
                              DateTime now = DateTime.now();

                              // Update history list and regimen list
                              List<HistoryModel> updatedList =
                                  regimenList.where((regimen) {
                                if (reminderState.isChecked(regimen)) {
                                  DateTime regimenTime = DateTime(
                                    regimen.date.year,
                                    regimen.date.month,
                                    regimen.date.day,
                                    regimen.time.hour,
                                    regimen.time.minute,
                                  );
                                  AdherenceStatus status;
                                  if (now.isBefore(regimenTime) ||
                                      now.isAtSameMomentAs(regimenTime)) {
                                    status = AdherenceStatus.early;
                                  } else if (now.isAfter(regimenTime) &&
                                      regimenTime.isSameDayAs(now)) {
                                    status = AdherenceStatus.late;
                                  } else {
                                    status = AdherenceStatus.missed;
                                  }

                                  regimen.status = status;

                                  reminderState.addHistory(HistoryModel(
                                    icon: regimen.icon,
                                    regimenName: regimen.regimenName,
                                    dosage: regimen.dosage,
                                    date: regimen.date,
                                    regimenDescription:
                                        regimen.regimenDescription,
                                    id: regimen.id,
                                    time: regimen.time,
                                    message: regimen.message,
                                    status: regimen.status,
                                  ));
                                  return false;
                                }
                                return true;
                              }).toList();
                              reminderState.updateRegimenList(updatedList);
                              reminderState.clearCheckedItems();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return MedCoinDropWidget(
                                    medhecoinEarned: medhecoinEarned,
                                  );
                                },
                              );
                            },
                          ),
                          width: SizeMg.screenWidth,
                        ),
                      ],
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
    bool isChecked = state.isChecked(regimen);
    return Container(
      width: SizeMg.screenWidth,
      decoration: BoxDecoration(
        color:
            isChecked ? AppColors.historyBackground : AppColors.unToggledColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 8),
            child: Checkbox(
              activeColor: isChecked ? AppColors.navBarColor : AppColors.white,
              fillColor: isChecked
                  ? MaterialStateProperty.all<Color>(AppColors.navBarColor)
                  : MaterialStateProperty.all<Color>(AppColors.white),
              side: const BorderSide(
                color: AppColors.navBarColor,
                width: 2.5,
              ),
              value: state.isChecked(regimen),
              onChanged: (value) {
                state.toggleChecked(regimen);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: Image.asset(
              'assets/images/pill.png',
              height: 28,
              width: 28,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                regimen.regimenName,
                style: TextStyle(
                  fontSize: SizeMg.text(16),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                regimen.dosage,
                style: TextStyle(
                  fontSize: SizeMg.text(12),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              bottom: 20.0,
              right: 10,
            ),
            child: FittedBox(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 15.0,
                  right: 15,
                  top: 8,
                  bottom: 0,
                ),
                child: Text(
                  DateFormat('hh:mm a').format(DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    regimen.time.hour,
                    regimen.time.minute,
                  )),
                  style: TextStyle(
                    color: AppColors.navBarColor,
                    fontSize: SizeMg.text(14),
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

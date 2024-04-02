import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constants_utils/color_utils.dart';
import '../../../core/model/models/history_model.dart';
import '../../../core/model/simulated_data/simulated_values.dart';
import '../../dashboard_feature/view/dashboard.dart';

class EditReminderScreen extends StatefulWidget {
  const EditReminderScreen({super.key});

  @override
  State<EditReminderScreen> createState() => _EditReminderScreenState();
}

class _EditReminderScreenState extends State<EditReminderScreen> {
  final List<HistoryModel> regimenList = generateSimulatedData();
  bool val = true;
  bool pillCount = false;
  String selectedSound = 'Aegean Sea'; // Default sound

  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: AppColors.white,
      width: double.infinity,
      child: Column(
        children: [
          AppBar(
            elevation: 2,
            title: const Text(
              'Edit Reminder',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DashboardView()));
              },
              icon: const Icon(CupertinoIcons.xmark,
                  color: AppColors.navBarColor),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.done,
                  color: AppColors.navBarColor,
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
          Expanded(
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Regimen description',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: AppColors.inactiveGrey,
                              ),
                            ),
                            const SizedBox(height: 20),
                            buildDetailItem(
                                'Name', regimenList.last.regimenName),
                            buildDetailItem(
                                'Medication form',
                                regimenList
                                    .last.regimenDescription.medicationForm),
                            buildDetailItem('Dosage', regimenList.last.dosage),
                            buildDetailItem('Pill Time',
                                regimenList.last.regimenDescription.pillTime),
                            buildDetailItem(
                                'Pill Frequency',
                                regimenList
                                    .last.regimenDescription.pillFrequency),
                            buildDetailItem('Duration',
                                regimenList.last.regimenDescription.duration),
                            buildDetailItem('Notes',
                                regimenList.last.regimenDescription.notes),
                          ],
                        ),
                      ),
                      const Divider(color: AppColors.inactiveGrey),
                      Padding(
                        padding: const EdgeInsets.all(
                          25,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Alarm settings',
                              style: TextStyle(
                                color: AppColors.darkGrey,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Sound',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Select Sound'),
                                          content: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 38.0),
                                            child: DropdownButton<String>(
                                              value: selectedSound,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  selectedSound = newValue!;
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog after selecting a sound
                                                });
                                              },
                                              items: <String>[
                                                'Aegean Sea',
                                                'Bird Chirping',
                                                'Wind Blowing'
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        selectedSound,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      SizedBox(width: 2),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Set Alarm',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    final TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );
                                    if (pickedTime != null &&
                                        pickedTime != selectedTime)
                                      setState(() {
                                        selectedTime = pickedTime;
                                      });
                                  },
                                  child: Text(
                                    selectedTime.format(context),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Snooze',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Switch.adaptive(
                                  activeTrackColor: Colors.green,
                                  value: val,
                                  onChanged: (bool value) {
                                    setState(() {
                                      val = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(color: AppColors.inactiveGrey),
                      Padding(
                        padding: const EdgeInsets.all(
                          25,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Pill Count',
                                  style: TextStyle(
                                    color: AppColors.darkGrey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Switch.adaptive(
                                  activeTrackColor: Colors.green,
                                  value: pillCount,
                                  onChanged: (bool value) {
                                    setState(() {
                                      pillCount = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            IgnorePointer(
                              ignoring: !pillCount,
                              child: Opacity(
                                opacity: pillCount ? 1.0 : 0.5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildPillCountItem(
                                        'Number of Pills', '0 pills'),
                                    buildPillCountItem('Start remainder at',
                                        '0 pills remaining'),
                                    buildPillCountItem('Time', '00:00 pm'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDetailItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          height: 40,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColors.progressBarFill,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.regmentColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget buildPillCountItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          height: 35,
          decoration: BoxDecoration(
            border: Border.all(width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              textAlign: TextAlign.center,
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

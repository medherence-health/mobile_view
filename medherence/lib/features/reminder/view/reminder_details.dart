import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/model/models/history_model.dart';
import '../view_model/reminder_view_model.dart';

class EditReminderDetails extends StatelessWidget {
  VoidCallback onTap;
  EditReminderDetails({required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Consumer<ReminderState>(
      builder: (context, reminderState, _) {
        List<HistoryModel> regimenList = reminderState.regimenList;
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            itemCount: regimenList.length,
            itemBuilder: (context, index) {
              HistoryModel regimen = regimenList[index];
              return _buildRegimenDetails(regimen);
            },
          ),
        );
      },
    );
  }

  Widget _buildRegimenDetails(HistoryModel regimen) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${regimen.regimenName}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${regimen.dosage}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    // Add more details as needed
                    // Switch to indicate reminder status

                    Divider(),
                  ],
                ),
              ),
              Switch(
                value: true, // Set the value based on reminder status
                onChanged: (value) {
                  // Update reminder status
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

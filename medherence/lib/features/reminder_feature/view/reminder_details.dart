import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/model/models/history_model.dart';
import '../view_model/reminder_view_model.dart';

class EditReminderDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ReminderState>(
      builder: (context, reminderState, _) {
        List<HistoryModel> regimenList = reminderState.regimenList;
        return ListView.builder(
          itemCount: regimenList.length,
          itemBuilder: (context, index) {
            HistoryModel regimen = regimenList[index];
            return _buildRegimenDetails(regimen);
          },
        );
      },
    );
  }

  Widget _buildRegimenDetails(HistoryModel regimen) {
    return Card(
      child: Container(
        height: 100,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
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
                  Switch(
                    value: true, // Set the value based on reminder status
                    onChanged: (value) {
                      // Update reminder status
                    },
                  ),
                  Divider(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

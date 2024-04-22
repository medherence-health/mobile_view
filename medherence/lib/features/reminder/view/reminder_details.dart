import 'package:flutter/material.dart';
import 'package:medherence/core/shared_widget/buttons.dart';
import 'package:provider/provider.dart';

import '../../../core/model/models/history_model.dart';
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
        return Container(
          width: SizeMg.screenWidth,
          height: MediaQuery.of(context).size.height - 20,
          child: Stack(
            children: [
              ListView.builder(
                itemCount: regimenList.length,
                itemBuilder: (context, index) {
                  HistoryModel regimen = regimenList[index];
                  return _buildRegimenTile(context, regimen, reminderState);
                },
              ),
              if (showButton)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: SizeMg.height(160.0),
                      left: SizeMg.width(10.0),
                      right: SizeMg.width(10.0),
                    ),
                    child: PrimaryButton(
                      buttonConfig: ButtonConfig(
                        text: 'Take meds ($checkedCount)',
                        action: () {},
                      ),
                      width: SizeMg.screenWidth,
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
      BuildContext context, HistoryModel regimen, ReminderState state) {
    return CheckboxListTile(
      title: Text(
        '${regimen.regimenName}',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        '${regimen.dosage}',
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      value: state.isChecked(regimen), // Check if the regimen is checked
      onChanged: (value) {
        state.toggleChecked(regimen); // Toggle regimen checked status
      },
    );
  }
}

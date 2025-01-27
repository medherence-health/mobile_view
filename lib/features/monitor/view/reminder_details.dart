import 'package:flutter/material.dart';
import 'package:medherence/core/constants/constants.dart';
import 'package:medherence/core/model/models/drug.dart';
import 'package:medherence/core/shared_widget/buttons.dart';
import 'package:medherence/features/auth/views/login_view.dart';
import 'package:medherence/features/dashboard_feature/view/dashboard_view.dart';
import 'package:medherence/features/profile/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/color_utils.dart';
import '../../../core/utils/size_manager.dart';
import '../view_model/reminder_view_model.dart';
import '../widget/medcoin_drop_widget.dart';

class EditReminderDetails extends StatefulWidget {
  final List<Drug> drugList;

  const EditReminderDetails({super.key, required this.drugList});

  @override
  _EditReminderDetailsState createState() => _EditReminderDetailsState();
}

class _EditReminderDetailsState extends State<EditReminderDetails> {
  List<Drug> drugList = [];
  List<Drug> selectedDrugList = [];

  @override
  void initState() {
    drugList = widget.drugList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReminderState>(
      builder: (context, reminderState, _) {
        List<Drug> checkedDrugList = reminderState.checkedDrugList;
        int checkedCount = reminderState.getCheckedCount(drugList);
        bool showButton = checkedCount > 0;
        bool allSelected = reminderState.areAllSelected(drugList);
        bool isAnySelected = reminderState.isAnySelected();

        return SizedBox(
          width: SizeMg.screenWidth,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              // Show message when regimenList is empty
              if (drugList.isEmpty) _buildEmptyListMessage(),
              // List of regimen items
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25),
                child: ListView.separated(
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 15),
                  itemCount: drugList.length,
                  itemBuilder: (context, index) {
                    Drug drug = drugList[index];
                    return _buildRegimenTile(
                        context, drug, reminderState, index);
                  },
                ),
              ),
              // Option to select all if not all items are selected
              if (!isAnySelected) _buildSelectAllOption(),
              // Action button section when items are selected
              if (isAnySelected) _buildActionButton(context, checkedCount),
            ],
          ),
        );
      },
    );
  }

  /// Widget for displaying a message when regimenList is empty
  Widget _buildEmptyListMessage() {
    return Center(
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
                fontSize: 18,
                fontStyle: FontStyle.italic,
                color: AppColors.noWidgetText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Widget for building each regimen tile in the list
  Widget _buildRegimenTile(
      BuildContext context, Drug drug, ReminderState state, int index) {
    bool isChecked = state.isChecked(drug, index);
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
          // Checkbox for selecting regimen item
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
              value: state.isChecked(drug, index),
              onChanged: (value) {
                state.toggleChecked(drug, index);
                if (isChecked) {
                  selectedDrugList.remove(drug);
                } else {
                  selectedDrugList.add(drug);
                }
              },
            ),
          ),
          // Pill icon for regimen
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: Image.asset(
              'assets/images/pill.png',
              height: 28,
              width: 28,
            ),
          ),
          // Regimen details: name and dosage
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                drug.drugName,
                style: TextStyle(
                  fontSize: SizeMg.text(16),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                drug.dosage,
                style: TextStyle(
                  fontSize: SizeMg.text(12),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Time of regimen
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
                  drug.timeTaken,
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

  /// Widget for displaying 'Select All' option when not all items are selected
  Widget _buildSelectAllOption() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Column(
        children: [
          Spacer(),
          InkWell(
            onTap: () {
              Provider.of<ReminderState>(context, listen: false)
                  .selectAll(drugList);
              selectedDrugList = drugList;
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
    );
  }

  /// Widget for displaying action button when items are selected
  Widget _buildActionButton(
    BuildContext context,
    int checkedCount,
  ) {
    bool _isLoading = false;

    void _handleTakeMed() async {
      setState(() {
        _isLoading = true;
      });

      // Calculate Medhecoin earned
      int medhecoinEarned = selectedDrugList.length * 100;

      try {
        // Call setMedicationActivity and wait for completion
        String result = await context
            .read<ProfileViewModel>()
            .setMedicationActivity(selectedDrugList);

        if (result == ok) {
          // Show MedCoin drop widget
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return MedCoinDropWidget(
                medhecoinEarned: medhecoinEarned,
              );
            },
          );
          // Show success feedback
          showSnackBar(context, 'Medication Taken',
              backgroundColor: Colors.green);

          // Clear checked items
          Provider.of<ReminderState>(context, listen: false)
              .clearCheckedItems();
        } else {
          showSnackBar(context, '$result', backgroundColor: Colors.red);
        }
      } catch (error) {
        // Handle error case
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to take medications: $error')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }

    void _navToCamera() async {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              GetDashboardView(dashboardIndex: 3, drugList: drugList),
        ),
      );
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeMg.width(20.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(height: 10),
            // Informational text for selected items
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
            // Button for taking medications
            _isLoading
                ? const CircularProgressIndicator() // Show loading indicator when loading
                : PrimaryButton(
                    height: SizeMg.height(45),
                    textSize: SizeMg.text(23),
                    buttonConfig: ButtonConfig(
                      text: 'Take med',
                      extraText: ' ($checkedCount)',
                      action: _navToCamera, // Call the handler function
                    ),
                    width: SizeMg.screenWidth,
                  ),
          ],
        ),
      ),
    );
  }
}

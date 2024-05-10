import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:drop_down_search_field/drop_down_search_field.dart';

import '../../../core/constants/constants.dart';
import '../../../core/utils/color_utils.dart';
import '../../../core/utils/size_manager.dart';
import '../view_model/filter_model.dart';

class FilterView extends StatefulWidget {
  FilterView({Key? key}) : super(key: key);

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  FilterViewModel model = FilterViewModel();
  @override
  Widget build(BuildContext context) {
    String formattedDate = model.formatDate(model.selectedDate);
    String secondFormattedDate = model.formatDate(model.secondSelectedDate);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Filter',
          style: TextStyle(
            fontSize: SizeMg.text(25),
            fontWeight: FontWeight.w600,
            fontFamily: "Poppins-bold.ttf",
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            color: AppColors.navBarColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.check,
              color: AppColors.navBarColor,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Status',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              Wrap(
                children: [
                  _buildStatusRadio(model, 1, 'All'),
                  _buildStatusRadio(model, 2, 'Taken'),
                  _buildStatusRadio(model, 3, 'Late'),
                  _buildStatusRadio(model, 4, 'Missed'),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Date',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildDatePicker(
                      context,
                      model,
                      'From',
                      formattedDate,
                      model.selectedDate,
                      (pickedDate) {
                        if (pickedDate != null &&
                            pickedDate != model.selectedDate)
                          model.updateSelectedDate(pickedDate);
                      },
                    ),
                  ),
                  SizedBox(width: 10), // Add some space between the pickers
                  Expanded(
                    child: _buildDatePicker(
                      context,
                      model,
                      'To',
                      secondFormattedDate,
                      model.secondSelectedDate,
                      (pickedDate) {
                        if (pickedDate != null &&
                            pickedDate != model.secondSelectedDate)
                          model.updateSecondSelectedDate(pickedDate);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Name',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              DropDownSearchFormField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: model.dropDownSearchController,
                  decoration: InputDecoration(
                    hintStyle: kFormTextDecoration.hintStyle,
                    hintText: 'Type in and select the medication',
                    filled: false,
                    fillColor: kFormTextDecoration.fillColor,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    border: kFormTextDecoration.border,
                    focusedBorder: kFormTextDecoration.focusedBorder,
                  ),
                ),
                suggestionsCallback: (pattern) {
                  return model.getSuggestions(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                transitionBuilder: (context, suggestionsBox, controller) {
                  return suggestionsBox;
                },
                onSuggestionSelected: (suggestion) {
                  model.dropDownSearchController.text = model.suggestion;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please select a medication';
                  }
                  return null;
                },
                onSaved: (value) => model.selectedMedication = value,
                displayAllSuggestionWhenTap: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusRadio(FilterViewModel model, int value, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio(
          activeColor: AppColors.navBarColor,
          value: value,
          groupValue: model.status,
          onChanged: model.setStatus,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(
      BuildContext context,
      FilterViewModel model,
      String label,
      String date,
      DateTime initialDate,
      void Function(DateTime?) onDatePicked) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 2,
              color: AppColors.darkGrey.withOpacity(0.4),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.darkGrey,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: model.selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    onDatePicked(pickedDate);
                  },
                  icon: Icon(
                    Icons.calendar_today,
                    color: AppColors.navBarColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

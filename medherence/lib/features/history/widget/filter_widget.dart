import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/constants.dart';
import '../../../core/utils/color_utils.dart';
import '../../../core/utils/size_manager.dart';
import '../view_model/filter_model.dart';

class FilterView extends StatelessWidget {
  FilterView({super.key});

  @override
  Widget build(BuildContext context) {
    final model = FilterViewModel();
    String formattedTime = model.formatTimeOfDay(model.firstTime);
    String secondFormattedTime = model.formatTimeOfDay(model.lastTime);
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
          padding: const EdgeInsets.only(
            left: 25.0,
            right: 25,
            bottom: 25,
            top: 10,
          ),
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
              Container(
                width: SizeMg.screenWidth - 25,
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: [
                    Row(
                      children: [
                        Radio(
                          value: 1,
                          groupValue: model.status,
                          onChanged: model.setStatus,
                        ),
                        Text(' All', style: TextStyle(fontSize: 16))
                      ],
                    ),
                    SizedBox(width: 5),
                    Row(
                      children: [
                        Radio(
                          value: 2,
                          groupValue: model.status,
                          onChanged: model.setStatus,
                        ),
                        Text(' Taken', style: TextStyle(fontSize: 16))
                      ],
                    ),
                    SizedBox(width: 5),
                    Row(
                      children: [
                        Radio(
                          value: 3,
                          groupValue: model.status,
                          onChanged: model.setStatus,
                        ),
                        Text(' Late', style: TextStyle(fontSize: 16))
                      ],
                    ),
                    SizedBox(width: 5),
                    Row(
                      children: [
                        Radio(
                          value: 4,
                          groupValue: model.status,
                          onChanged: model.setStatus,
                        ),
                        Text(' Missed', style: TextStyle(fontSize: 16))
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Date',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'From',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: AppColors.darkGrey.withOpacity(0.4),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  formattedTime,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.darkGrey,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    final TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: model.firstTime,
                                    );
                                    if (pickedTime != null &&
                                        pickedTime != model.firstTime)
                                      model.updateSelectedTime(pickedTime);
                                  },
                                  icon: Icon(
                                    Icons.calendar_month,
                                    color: AppColors.navBarColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'To',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: AppColors.darkGrey.withOpacity(0.4),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  secondFormattedTime,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.darkGrey,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    final TimeOfDay? secondPickedTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: model.lastTime,
                                    );
                                    if (secondPickedTime != null &&
                                        secondPickedTime != model.lastTime)
                                      model
                                          .updateSelectedTime(secondPickedTime);
                                  },
                                  icon: Icon(
                                    Icons.calendar_month,
                                    color: AppColors.navBarColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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
              DropDownSearchFormField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: model.dropDownSearchController,
                  decoration: InputDecoration(
                    hintStyle: kFormTextDecoration.hintStyle,
                    hintText: 'Type in and select the medication',
                    filled: true,
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
}

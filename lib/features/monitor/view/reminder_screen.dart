import 'package:flutter/material.dart';
import 'package:medherence/core/model/models/drug.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/color_utils.dart';
import 'reminder_details.dart';

class MedicationListScreen extends StatefulWidget {
  final List<Drug> drugList;

  const MedicationListScreen({
    Key? key,
    required this.drugList,
  }) : super(key: key);

  @override
  State<MedicationListScreen> createState() => _MedicationListScreenState();
}

class _MedicationListScreenState extends State<MedicationListScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<bool> isDoneClicked;
  List<Drug> drugList = [];

  @override
  void initState() {
    drugList = widget.drugList;

    super.initState();
    // _loadIsDoneClicked();
  }

  Future<void> _loadIsDoneClicked() async {
    isDoneClicked = _prefs.then((SharedPreferences prefs) {
      return prefs.getBool('isDoneClicked') ?? false;
    });
    setState(() {});
  }

  Future<void> _saveIsDoneClicked(bool value) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool('isDoneClicked', value);
    setState(() {
      isDoneClicked = Future.value(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Today\'s Medication',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: const SizedBox(),
      ),
      body: Container(
        color: AppColors.white,
        child: Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
              bottom: 40,
            ),
            child: EditReminderDetails(
              drugList: drugList,
            )),
      ),
    );
  }
}

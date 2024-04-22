import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/color_utils.dart';
import '../../dashboard_feature/view/dashboard_view.dart';
import 'reminder_details.dart';
import 'reminder_edit_content.dart';

class EditReminderScreen extends StatefulWidget {
  const EditReminderScreen({Key? key}) : super(key: key);

  @override
  State<EditReminderScreen> createState() => _EditReminderScreenState();
}

class _EditReminderScreenState extends State<EditReminderScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<bool> isDoneClicked;

  @override
  void initState() {
    super.initState();
    _loadIsDoneClicked();
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
    return FutureBuilder<bool>(
      future: isDoneClicked,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return Container(
          height: MediaQuery.of(context).size.height,
          color: AppColors.white,
          width: double.infinity,
          child: Stack(
            children: [
              AppBar(
                elevation: 2,
                title: snapshot.data == false
                    ? const Text(
                        'Edit Reminder',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : const Text(
                        'Reminder',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                centerTitle: true,
                leading: snapshot.data == false
                    ? IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const DashboardView()));
                        },
                        icon: const Icon(CupertinoIcons.xmark,
                            color: AppColors.navBarColor),
                      )
                    : SizedBox(),
                actions: [
                  snapshot.data == false
                      ? Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                _saveIsDoneClicked(true); // Update to true
                              },
                              icon: const Icon(
                                Icons.done,
                                color: AppColors.navBarColor,
                              ),
                            ),
                            const SizedBox(width: 20),
                          ],
                        )
                      : SizedBox(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: ListView(
                  children: [
                    snapshot.data == false
                        ? Scrollbar(
                            child: SingleChildScrollView(
                                child: EditReminderScreenContent()),
                          )
                        : EditReminderDetails(
                            onTap: () async {
                              // Update isDoneClicked value when tapped
                              _saveIsDoneClicked(false); // Update to false
                            },
                          )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

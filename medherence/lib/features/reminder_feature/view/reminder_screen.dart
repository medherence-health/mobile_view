import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants_utils/color_utils.dart';
import '../../../core/model/models/history_model.dart';
import '../../../core/model/simulated_data/simulated_values.dart';
import '../../dashboard_feature/view/dashboard.dart';
import '../view_model/reminder_view_model.dart';
import 'reminder_details.dart';
import 'reminder_edit_content.dart';

class EditReminderScreen extends StatefulWidget {
  const EditReminderScreen({Key? key}) : super(key: key);

  @override
  State<EditReminderScreen> createState() => _EditReminderScreenState();
}

class _EditReminderScreenState extends State<EditReminderScreen> {
  bool isDoneClicked = false;

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
            title: isDoneClicked == false
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
            leading: isDoneClicked == false
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
              isDoneClicked == false
                  ? Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isDoneClicked = true;
                            });
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
          !isDoneClicked
              ? Expanded(
                  child: Scrollbar(
                    child: SingleChildScrollView(
                        child: EditReminderScreenContent()),
                  ),
                )
              : EditReminderDetails()
        ],
      ),
    );
  }
}

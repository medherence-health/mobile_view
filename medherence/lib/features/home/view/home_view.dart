import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medherence/core/service/notification_service.dart';
import 'package:medherence/core/utils/size_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/color_utils.dart';
import '../../../core/model/models/history_model.dart';
import '../../../core/model/simulated_data/simulated_values.dart';
import '../../../core/shared_widget/buttons.dart';
import '../../auth/views/change_password.dart';
import '../../history/view/history_screen.dart';
import '../../medhecoin/view/medhecoin.dart';
import '../../monitor/view_model/reminder_view_model.dart';
import '../../notification/view/notification_view.dart';
import '../../notification/widget/notification_widget.dart';
import '../widget/medecoin_widget.dart';
import '../widget/progressStreak.dart';
import 'medication_details.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _showHistory = false;
  // final List<HistoryModel> _historyDataList = generateSimulatedData();
  List<dynamic> history = [];

  // Function to show the history widget
  void showHistory() {
    setState(() {
      _showHistory = true;
    });
  }

  // Function to check if password has been successfully changed
  Future<bool> isPasswordChanged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('passwordChanged') ?? false;
  }

  // Function to show password change prompt if necessary
  void checkPasswordChangePrompt() async {
    bool passwordChanged = await isPasswordChanged();
    if (!passwordChanged) {
      buildCompleteProfile();
    }
  }

  buildCompleteProfile() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            (15),
          ),
        ),
        children: [
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'Change Password',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(
            height: (20),
          ),
          const Padding(
            padding: EdgeInsets.only(
              left: 25.0,
              right: 25.0,
            ),
            child: Text(
              'There is a need for you to change your password from the default password you were given to a personal one',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: (18),
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(
              left: 15.0,
              right: 15,
            ),
            child: PrimaryButton(
              buttonConfig: ButtonConfig(
                text: 'Change Password',
                action: () {
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (context) {
                    return const ChangePassword();
                  }));
                },
                disabled: false,
              ),
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
    await Future.delayed(
      const Duration(
        seconds: 5,
      ),
    );
  }

  int progress = 1;
  String title = 'ADB'; // Initial title

  void updateProgress() {
    setState(() {
      progress++;
      // Update title based on progress
      if (progress == 1) {
        title = 'ADB';
      } else if (progress == 2) {
        title = 'Serg';
      } else if (progress == 3) {
        title = 'Lt.';
      } else {
        // Custom logic for further progress titles
        title = 'Master ${progress - 2}';
      }
    });
  }

  bool _amountChanged = false; // Add this variable

  // Function to toggle the amount changed
  void toggleAmountChanged() {
    setState(() {
      _amountChanged = !_amountChanged;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // buildHistorySheet(
      //   _historyDataList,
      //   context,
      // );
      checkPasswordChangePrompt();
      // await NotificationService(context).init();
      // context.read<NotificationService>().scheduleAlarmsFromSavedReminders();
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeMg.init(context);
    return Consumer<ReminderState>(builder: (context, reminderState, _) {
      List<HistoryModel> regimenList = reminderState.regimenList;
      int remainingMedications =
          regimenList.length - reminderState.getCheckedCount();
      return Padding(
        padding: const EdgeInsets.only(
          top: 25.0,
          right: 20,
          left: 20,
        ),
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              ListView(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: SizeMg.width(8),
                      right: SizeMg.width(8),
                      top: SizeMg.height(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Welcome, $title',
                          style: TextStyle(
                            fontSize: SizeMg.text(25),
                            fontWeight: FontWeight.w600,
                            fontFamily: "Poppins-bold.ttf",
                          ),
                        ), // Display dynamic title
                        NotificationWidget(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const NotificationScreen()));
                          },
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: SizeMg.height(10),
                      ),
                      Text(title),
                      SizedBox(
                        height: SizeMg.height(5),
                      ),
                      ProgressStreak(
                          progress: progress), // Display progress streak bar
                      SizedBox(
                        height: SizeMg.height(20),
                      ),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     // Simulate completion of an action
                      //     if (progress < 10) {
                      //       updateProgress();
                      //     }
                      //   },
                      //   child: Text('Complete Action'),
                      // ),
                      MedhecoinWidget(
                        () {
                          setState(() {
                            // Call the function to toggle the amount changed
                            toggleAmountChanged();
                          });
                        },
                        const Icon(
                          Icons.open_in_new,
                        ),
                        () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MedhecoinScreen()));
                        },
                        _amountChanged,
                      ),
                      SizedBox(
                        height: SizeMg.height(30),
                      ),
                      Text(
                        'Today\'s Medications',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: "Poppins-Bold.ttf",
                          fontSize: SizeMg.text(23),
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        height: MediaQuery.of(context).size.width,
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount:
                              remainingMedications, // the length of the data list
                          separatorBuilder: (ctx, index) {
                            return SizedBox(
                              height: SizeMg.height(3),
                            );
                          },
                          itemBuilder: (context, index) {
                            HistoryModel regimenItem = regimenList[index];
                            if (regimenList.isEmpty) {
                              return Center(
                                child: SizedBox(
                                  height: 150,
                                  width: 180,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Icon(
                                        Icons.check_circle_outline,
                                        color: AppColors.noWidgetText,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Yayy, You have taken all medications for today',
                                        style: TextStyle(
                                          fontSize: (20),
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
                            return NextRegimen(itemModel: regimenItem);
                          },
                        ),
                      ),

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Visibility(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HistoryScreen()));
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 5,
                                bottom: SizeMg.height(35.0),
                              ),
                              child: Text(
                                'View Adherence History',
                                style: TextStyle(
                                  color: AppColors.navBarColor,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Poppins-Bold.ttf",
                                  fontSize: SizeMg.text(18),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  buildHistorySheet(
    List<HistoryModel> historyList,
    BuildContext context,
  ) {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      barrierColor: Colors.transparent,
      // enableDrag: true,
      isDismissible: false,
      scrollControlDisabledMaxHeightRatio: 0.5,
      isScrollControlled: true,
      backgroundColor: AppColors.historyBackground,
      builder: (context) {
        return ColoredBox(
          color: AppColors.historyBackground,
          child: DraggableScrollableSheet(
            initialChildSize: 0.4,
            maxChildSize: 0.8,
            expand: false,
            builder: (context, scrollController) {
              if (historyList.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 10,
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 25.0),
                        child: Text(
                          'History',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          height: 150,
                          width: 180,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Icon(
                                Icons.folder_off_outlined,
                                color: AppColors.noWidgetText,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'You have no adherence history',
                                style: TextStyle(
                                  fontSize: (20),
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.noWidgetText,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 15,
                ),
                child: Stack(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 25.0),
                      child: Text(
                        'History',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Regimen',
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                'Dosage',
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                'Date',
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: historyList
                                  .length, // Use the length of your data list
                              separatorBuilder: (ctx, index) {
                                return const SizedBox(
                                  height: (13),
                                );
                              },
                              itemBuilder: (context, index) {
                                final item = historyList[index];
                                final formattedMonth =
                                    DateFormat('MMM').format(item.date);
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MedicationDetailsScreen(
                                          title: item.regimenName,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 55,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    padding: const EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15.0),
                                          child: Icon(
                                            item.icon,
                                            size: 24,
                                            color: AppColors.pillIconColor,
                                          ),
                                        ),
                                        Text(
                                          item.regimenName,
                                          style: const TextStyle(
                                            color: AppColors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          item.dosage,
                                          style: const TextStyle(
                                            color: AppColors.darkGrey,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Container(
                                          width: 45,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(
                                                (10),
                                              ),
                                              bottomRight: Radius.circular(
                                                (10),
                                              ),
                                            ),
                                            color: AppColors.mainPrimaryButton,
                                          ),
                                          // color: AppColors.green,
                                          child: Column(
                                            children: [
                                              Text(
                                                item.date.day.toString(),
                                                style: const TextStyle(
                                                  color: AppColors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                formattedMonth.toString(),
                                                style: const TextStyle(
                                                  color: AppColors.white,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    // buildHistorySheet(historyList, context),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class NextRegimen extends StatelessWidget {
  const NextRegimen({
    Key? key,
    required this.itemModel,
  }) : super(key: key);

  final HistoryModel itemModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: SizeMg.screenWidth,
        decoration: BoxDecoration(
          color: AppColors.historyBackground,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
            bottom: 5,
            left: 20,
            right: 20,
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: Image.asset(
                  'assets/images/pill.png',
                  height: 28,
                  width: 28,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    itemModel.regimenName,
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    itemModel.dosage,
                    style: const TextStyle(
                      color: AppColors.darkGrey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.alarm,
                        color: AppColors.navBarColor,
                        size: 16,
                      ),
                      SizedBox(width: 10),
                      Text(
                        DateFormat('hh:mm a').format(DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                          itemModel.time.hour,
                          itemModel.time.minute,
                        )),
                        style: TextStyle(
                          color: AppColors.navBarColor,
                          fontSize: SizeMg.text(14),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                ],
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  debugPrint('Regimen taken');
                },
                child: Text(
                  'Take',
                  style: TextStyle(
                    color: AppColors.navBarColor,
                    fontSize: SizeMg.text(15),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

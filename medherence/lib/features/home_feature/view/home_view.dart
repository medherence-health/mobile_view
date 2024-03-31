import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medherence/features/medhecoin_features/view/medhecoin.dart';

import '../../../core/constants_utils/color_utils.dart';
import '../../../core/model/models/history_model.dart';
import '../../../core/model/simulated_data/simulated_values.dart';
import '../../../core/shared_widget/buttons.dart';
import '../../auth_features/views/new_password.dart';
import '../widget/medecoin_widget.dart';
import '../widget/progressStreak.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _showHistory = false;
  final List<HistoryModel> _historyDataList = generateSimulatedData();
  List<dynamic> history = [];
  bool _passwordChangePrompted = false;

  // Function to show the history widget
  void showHistory() {
    setState(() {
      _showHistory = true;
    });
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
                    return ChangePassword();
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      buildHistorySheet(_historyDataList, context);
      // if (_passwordChangePrompted == false) {
      //   buildCompleteProfile();
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    var index = _historyDataList.length;
    final itemList = _historyDataList;
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Welcome, $title',
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Poppins-bold.ttf",
                      ),
                    ), // Display dynamic title
                    IconButton(
                      icon: Icon(
                        Icons.notifications_none_sharp,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      onPressed: () {
                        buildHistorySheet(_historyDataList, context);
                        // Handle notification button press
                      },
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(title),
                    const SizedBox(height: 5),
                    ProgressStreak(
                        progress: progress), // Display progress streak bar
                    const SizedBox(height: 20),
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
                        const Icon(
                          Icons.open_in_new,
                        ), () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MedhecoinScreen()));
                    }),
                    const SizedBox(height: 35),
                    const Text(
                      'Next Regimen',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: "Poppins-Bold.ttf",
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          height: 40,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColors.progressBarFill,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              itemList.first.regimenName,
                              style: TextStyle(
                                color: AppColors.regmentColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dosage',
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(height: 5),
                                Container(
                                  height: 40,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppColors.progressBarFill,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      itemList.first.dosage,
                                      style: TextStyle(
                                        color: AppColors.regmentColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Time',
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  height: 40,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppColors.progressBarFill,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '6:00 PM',
                                      style: TextStyle(
                                        color: AppColors.regmentColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  buildHistorySheet(List<HistoryModel> historyList, BuildContext context) {
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
                              physics: const BouncingScrollPhysics(),
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
                                return Container(
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
                                      Icon(
                                        item.icon,
                                        size: 24,
                                        color: AppColors.pillIconColor,
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

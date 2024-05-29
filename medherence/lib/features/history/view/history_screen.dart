import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/color_utils.dart';
import '../../../core/model/models/history_model.dart';
import '../../../core/model/simulated_data/simulated_values.dart';
import '../../../core/utils/size_manager.dart';
import '../../home/view/medication_details.dart';
import '../../monitor/view_model/reminder_view_model.dart';
import '../widget/filter_widget.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ReminderState _historyDataList = ReminderState();
  final FocusManager focusManager = FocusManager.instance;
  int _tabIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _tabIndex = _tabController.index;
        focusManager.primaryFocus?.unfocus();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeMg.init(context);
    return Scaffold(
      backgroundColor: AppColors.historyBackground,
      appBar: AppBar(
        backgroundColor: AppColors.historyBackground,
        title: Text(
          'History',
          style: TextStyle(
            fontSize: SizeMg.text(25),
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FilterView()));
                },
                icon: const Icon(Icons.filter_list_alt)),
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 80),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  SizeMg.radius(10),
                ),
                border: Border.all(
                  color: AppColors.navBarColor,
                  width: 2,
                ),
              ),
              width: 300,
              child: TabBar(
                dividerColor: AppColors.historyBackground,
                padding: const EdgeInsets.symmetric(
                  horizontal: (0),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.navBarColor,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: SizeMg.text(16),
                ),
                indicatorPadding: const EdgeInsets.all(0),
                indicator: BoxDecoration(
                  color: AppColors.navBarColor,
                  borderRadius: BorderRadius.circular(
                    SizeMg.radius(10),
                  ),
                  border: Border.all(
                    width: SizeMg.width(2),
                    color: AppColors.historyBackground,
                  ),
                ),
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(
                    text: 'List',
                  ),
                  Tab(
                    text: 'Analytics',
                  )
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildMedicationHistory(_historyDataList, _tabIndex),
          ),
        ],
      ),
      // TabBarView(controller: _tabController, children: [
      //
      //   // Builder(builder: builder),
      // ]),
    );
  }

  _buildMedicationHistory(ReminderState historyList, int tabIndex) {
    switch (tabIndex) {
      case 0:
        return historyListBuilder(historyList);
      case 1:
        return Builder(builder: (ctx) {
          return Center(
            child: SizedBox(
              height: SizeMg.height(350),
              width: SizeMg.width(180),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: SizeMg.height(100),
                  ),
                  const Icon(
                    Icons.folder_off_outlined,
                    color: AppColors.noWidgetText,
                  ),
                  SizedBox(
                    height: SizeMg.height(10),
                  ),
                  Text(
                    'You have no adherence analytics history',
                    style: TextStyle(
                      fontSize: SizeMg.text(20),
                      fontStyle: FontStyle.italic,
                      color: AppColors.noWidgetText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        });
      default:
        return Builder(builder: (ctx) {
          return Center(
            child: SizedBox(
              height: SizeMg.height(150),
              width: SizeMg.width(180),
              child: Column(
                children: [
                  SizedBox(
                    height: SizeMg.height(20),
                  ),
                  const Icon(
                    Icons.folder_off_outlined,
                    color: AppColors.noWidgetText,
                  ),
                  SizedBox(
                    height: SizeMg.height(10),
                  ),
                  Text(
                    'You have new adherence history',
                    style: TextStyle(
                      fontSize: SizeMg.text(20),
                      fontStyle: FontStyle.italic,
                      color: AppColors.noWidgetText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        });
    }
  }

  Builder historyListBuilder(ReminderState reminderState) {
    return Builder(builder: (ctx) {
      List<HistoryModel> historyList = reminderState.historyList;
      if (historyList.isEmpty) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeMg.width(30),
            vertical: SizeMg.height(10),
          ),
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                  height: SizeMg.height(150),
                  width: SizeMg.width(180),
                  child: Column(
                    children: [
                      SizedBox(
                        height: SizeMg.height(20),
                      ),
                      const Icon(
                        Icons.folder_off_outlined,
                        color: AppColors.noWidgetText,
                      ),
                      SizedBox(
                        height: SizeMg.height(10),
                      ),
                      Text(
                        'You have no adherence history',
                        style: TextStyle(
                          fontSize: SizeMg.text(20),
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
      return SizedBox(
        width: SizeMg.screenWidth,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeMg.width(30),
            vertical: SizeMg.height(15),
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: SizeMg.height(25)),
                child: Text(
                  'All',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: SizeMg.text(25),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: SizeMg.height(65),
                ),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: historyList.length,
                  itemBuilder: (context, index) {
                    final history = historyList[index];
                    String formattedDay = DateFormat('d').format(history.date);
                    String formattedMonth =
                        DateFormat('MMM').format(history.date);
                    Color containerColor;

                    switch (history.status) {
                      case AdherenceStatus.early:
                        containerColor = AppColors.success;
                        break;
                      case AdherenceStatus.late:
                        containerColor = AppColors.warning;
                        break;
                      case AdherenceStatus.missed:
                        containerColor = AppColors.error;
                        break;
                    }

                    return Padding(
                      padding: EdgeInsets.only(bottom: SizeMg.height(10)),
                      child: Container(
                        height: SizeMg.height(80),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.darkGrey.withOpacity(0.5),
                              offset: const Offset(0, 4),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: SizeMg.width(16),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: containerColor,
                            radius: SizeMg.width(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  formattedDay,
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: SizeMg.text(18),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  formattedMonth,
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: SizeMg.text(14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          title: Text(
                            history.regimenName,
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: SizeMg.text(18),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            '${history.dosage}, ${DateFormat.jm().format(history.time as DateTime)}',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: SizeMg.text(14),
                            ),
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: AppColors.white,
                            size: SizeMg.width(28),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // Builder historyListBuilder(List<HistoryModel> historyList) {
  //   return Builder(builder: (ctx) {
  //     if (historyList.isEmpty) {
  //       return Padding(
  //         padding: EdgeInsets.symmetric(
  //           horizontal: SizeMg.width(30),
  //           vertical: SizeMg.height(10),
  //         ),
  //         child: Stack(
  //           children: [
  //             Center(
  //               child: SizedBox(
  //                 height: SizeMg.height(150),
  //                 width: SizeMg.width(180),
  //                 child: Column(
  //                   children: [
  //                     SizedBox(
  //                       height: SizeMg.height(20),
  //                     ),
  //                     const Icon(
  //                       Icons.folder_off_outlined,
  //                       color: AppColors.noWidgetText,
  //                     ),
  //                     SizedBox(
  //                       height: SizeMg.height(10),
  //                     ),
  //                     Text(
  //                       'You have no adherence history',
  //                       style: TextStyle(
  //                         fontSize: SizeMg.text(20),
  //                         fontStyle: FontStyle.italic,
  //                         color: AppColors.noWidgetText,
  //                       ),
  //                       textAlign: TextAlign.center,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     }
  //     return SizedBox(
  //       width: SizeMg.screenWidth,
  //       height: MediaQuery.of(context).size.height,
  //       child: Padding(
  //         padding: EdgeInsets.symmetric(
  //           horizontal: SizeMg.width(30),
  //           vertical: SizeMg.height(15),
  //         ),
  //         child: Stack(
  //           children: [
  //             Padding(
  //               padding: EdgeInsets.only(top: SizeMg.height(25)),
  //               child: Text(
  //                 'All',
  //                 style: TextStyle(
  //                   color: AppColors.black,
  //                   fontSize: SizeMg.text(25),
  //                   fontWeight: FontWeight.w500,
  //                 ),
  //               ),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.only(top: 50.0),
  //               child: Column(
  //                 children: [
  //                   SizedBox(
  //                     height: SizeMg.height(20),
  //                   ),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       SizedBox(
  //                         width: SizeMg.width(20),
  //                       ),
  //                       Text(
  //                         'Regimen',
  //                         style: TextStyle(
  //                           color: AppColors.black,
  //                           fontSize: SizeMg.text(14),
  //                           fontWeight: FontWeight.w400,
  //                         ),
  //                       ),
  //                       Text(
  //                         'Dosage',
  //                         style: TextStyle(
  //                           color: AppColors.black,
  //                           fontSize: SizeMg.text(14),
  //                           fontWeight: FontWeight.w400,
  //                         ),
  //                       ),
  //                       Text(
  //                         'Date',
  //                         style: TextStyle(
  //                           color: AppColors.black,
  //                           fontSize: SizeMg.text(14),
  //                           fontWeight: FontWeight.w400,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(height: SizeMg.height(5)),
  //                   Expanded(
  //                     child: ListView.separated(
  //                       shrinkWrap: true,
  //                       physics: const BouncingScrollPhysics(),
  //                       itemCount: historyList
  //                           .length, // Use the length of your data list
  //                       separatorBuilder: (ctx, index) {
  //                         return SizedBox(
  //                           height: SizeMg.height(8),
  //                         );
  //                       },
  //                       itemBuilder: (context, index) {
  //                         final item = historyList[index];
  //                         final formattedMonth =
  //                             DateFormat('MMM').format(item.date);
  //                         return InkWell(
  //                           onTap: () {
  //                             Navigator.push(
  //                               context,
  //                               MaterialPageRoute(
  //                                 builder: (context) => MedicationDetailsScreen(
  //                                   title: item.regimenName,
  //                                 ),
  //                               ),
  //                             );
  //                           },
  //                           child: Container(
  //                             height: SizeMg.height(55),
  //                             margin: const EdgeInsets.symmetric(vertical: 5),
  //                             padding: const EdgeInsets.only(left: 10),
  //                             decoration: BoxDecoration(
  //                               color: Colors.grey[200],
  //                               borderRadius: BorderRadius.circular(
  //                                 SizeMg.radius(10),
  //                               ),
  //                             ),
  //                             child: Row(
  //                               mainAxisAlignment:
  //                                   MainAxisAlignment.spaceBetween,
  //                               children: [
  //                                 Padding(
  //                                   padding: const EdgeInsets.only(left: 15.0),
  //                                   child: Icon(
  //                                     item.icon,
  //                                     size: 24,
  //                                     color: AppColors.pillIconColor,
  //                                   ),
  //                                 ),
  //                                 Text(
  //                                   item.regimenName,
  //                                   style: TextStyle(
  //                                     color: AppColors.black,
  //                                     fontSize: SizeMg.text(16),
  //                                     fontWeight: FontWeight.w500,
  //                                   ),
  //                                 ),
  //                                 Text(
  //                                   item.dosage,
  //                                   style: TextStyle(
  //                                     color: AppColors.darkGrey,
  //                                     fontSize: SizeMg.text(13),
  //                                     fontWeight: FontWeight.w400,
  //                                   ),
  //                                 ),
  //                                 Container(
  //                                   width: SizeMg.width(35),
  //                                   decoration: BoxDecoration(
  //                                     borderRadius: BorderRadius.only(
  //                                       topRight: Radius.circular(
  //                                         SizeMg.radius(10),
  //                                       ),
  //                                       bottomRight: Radius.circular(
  //                                         SizeMg.radius(10),
  //                                       ),
  //                                     ),
  //                                     color: AppColors.mainPrimaryButton,
  //                                   ),
  //                                   // color: AppColors.green,
  //                                   child: Column(
  //                                     mainAxisAlignment:
  //                                         MainAxisAlignment.center,
  //                                     children: [
  //                                       Text(
  //                                         item.date.day.toString(),
  //                                         style: TextStyle(
  //                                           color: AppColors.white,
  //                                           fontSize: SizeMg.text(18),
  //                                           fontWeight: FontWeight.w500,
  //                                         ),
  //                                       ),
  //                                       Text(
  //                                         formattedMonth.toString(),
  //                                         style: TextStyle(
  //                                           color: AppColors.white,
  //                                           fontSize: SizeMg.text(14),
  //                                         ),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         );
  //                       },
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   });
  // }
}

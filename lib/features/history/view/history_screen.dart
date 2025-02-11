import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medherence/core/constants/constants.dart';
import 'package:medherence/core/model/models/drug.dart';
import 'package:medherence/features/history/view_model/filter_model.dart';
import 'package:medherence/features/history/widget/filter_widget.dart';
import 'package:medherence/features/profile/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';

import '../../../core/model/models/history_model.dart';
import '../../../core/utils/color_utils.dart';
import '../../../core/utils/size_manager.dart';
import '../../monitor/view_model/reminder_view_model.dart';
import '../widget/pie_widget.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // final ReminderState _historyData = ReminderState();
  final FocusManager focusManager = FocusManager.instance;
  int _tabIndex = 0;
  Map<String, List<Drug?>> groupedList = {};
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

    return Consumer<ReminderState>(builder: (context, _historyData, _) {
      final model = Provider.of<FilterViewModel>(context, listen: false);

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
                    _navigateAndReload(groupedList);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //             FilterView(idList: groupedList)));
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
              child:
                  _buildMedicationHistory(_historyData, _tabIndex, groupedList),
            ),
          ],
        ),
        // TabBarView(controller: _tabController, children: [
        //
        //   // Builder(builder: builder),
        // ]),
      );
    });
  }

  void _navigateAndReload(Map<String, List<Drug?>> list) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FilterView(idList: list)),
    );

    if (result == true) {
      setState(() {}); // Rebuild the widget to refresh UI
    }
  }

  _buildMedicationHistory(ReminderState historyState, int tabIndex,
      Map<String, List<Drug?>> groupedList) {
    switch (tabIndex) {
      case 0:
        return historyListBuilder(context, groupedList);
      case 1:
        return analyticsBuilder(historyState);
      default:
        return Builder(builder: (ctx) {
          return _buildEmptyState();
        });
    }
  }

  Widget analyticsBuilder(ReminderState reminderState) {
    return Builder(builder: (ctx) {
      List<HistoryModel> historyList = reminderState.historyList;
      // if (historyList.isEmpty) {
      //   return _buildEmptyState();
      // }

      Map<AdherenceStatus, int> adherenceData =
          aggregateAdherenceData(historyList);

      return Padding(
        padding: const EdgeInsets.all(25.0),
        child: AspectRatio(
          aspectRatio: 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min, // Use MainAxisSize.min here
            children: [
              Text(
                'All',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                // fit: FlexFit.loose,
                child: PieChartWidget(adherenceData: adherenceData),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: SizeMg.width(20),
                          height: SizeMg.height(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: AppColors.success,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Early',
                          style: TextStyle(
                              color: AppColors.darkGrey,
                              fontSize: SizeMg.text(16)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: SizeMg.width(20),
                          height: SizeMg.height(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: AppColors.warning,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Late',
                          style: TextStyle(
                              color: AppColors.darkGrey,
                              fontSize: SizeMg.text(16)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: SizeMg.width(20),
                          height: SizeMg.height(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: AppColors.error,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Missed',
                          style: TextStyle(
                              color: AppColors.darkGrey,
                              fontSize: SizeMg.text(16)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Divider(
                color: AppColors.darkGrey.withOpacity(0.2),
              ),
              buildSummary(adherenceData),
            ],
          ),
        ),
      );
    });
  }

  Widget buildSummary(Map<AdherenceStatus, int> adherenceData) {
    int totalUsed = adherenceData[AdherenceStatus.early]! +
        adherenceData[AdherenceStatus.late]!;
    int lateUsage = adherenceData[AdherenceStatus.late]!;
    int missedDays = adherenceData[AdherenceStatus.missed]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RichText(
            text: TextSpan(
                text: 'No. of days Med was used ',
                style: TextStyle(
                    fontSize: SizeMg.text(16),
                    fontWeight: FontWeight.w500,
                    color: AppColors.black),
                children: [
              TextSpan(
                text: '(late usage)',
                style: TextStyle(
                  color: AppColors.darkGrey,
                ),
              )
            ])),
        SizedBox(height: 5),
        Text(
          '$totalUsed ($lateUsage)',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.darkGrey,
          ),
        ),
        SizedBox(height: 20),
        Divider(
          color: AppColors.darkGrey.withOpacity(0.2),
        ),
        Text(
          'No. of days Med was missed',
          style: TextStyle(
            fontSize: SizeMg.text(16),
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 5),
        Text(
          '$missedDays',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.darkGrey,
          ),
        ),
        Divider(
          color: AppColors.darkGrey.withOpacity(0.2),
        ),
      ],
    );
  }

  Map<AdherenceStatus, int> aggregateAdherenceData(
      List<HistoryModel> historyList) {
    int earlyCount = 3;
    int lateCount = 4;
    int missedCount = 3;

    for (var history in historyList) {
      switch (history.status) {
        case AdherenceStatus.early:
          earlyCount++;
          break;
        case AdherenceStatus.late:
          lateCount++;
          break;
        case AdherenceStatus.missed:
          missedCount++;
          break;
      }
    }

    return {
      AdherenceStatus.early: earlyCount,
      AdherenceStatus.late: lateCount,
      AdherenceStatus.missed: missedCount,
    };
  }

  /// Returns an empty state widget when no data is available.
  Widget _buildEmptyState() {
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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget historyListBuilder(
      BuildContext context, Map<String, List<Drug?>> groupedList) {
    final model = Provider.of<FilterViewModel>(context, listen: false);

    return FutureBuilder<MedActivityResult>(
      future: context
          .watch<ProfileViewModel>()
          .getMedicationActivity(_auth.currentUser?.uid ?? "", model),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text("Error loading history"),
          );
        }

        if (!snapshot.hasData || snapshot.data!.allList.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeMg.width(30),
              vertical: SizeMg.height(10),
            ),
            child: Stack(
              children: [_buildEmptyState()],
            ),
          );
        }

        List<Drug?> drugList = snapshot.data!.allList;
        List<Drug?> historyList = drugList;

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
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 65.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: SizeMg.width(20)),
                      Text('Regimen', style: _headerTextStyle()),
                      Text('Dosage', style: _headerTextStyle()),
                      Text('Date', style: _headerTextStyle()),
                    ],
                  ),
                ),
                SizedBox(height: SizeMg.height(15)),
                Padding(
                  padding: EdgeInsets.only(top: SizeMg.height(75)),
                  child: ListView.separated(
                    separatorBuilder: (ctx, index) =>
                        SizedBox(height: SizeMg.height(5)),
                    physics: const BouncingScrollPhysics(),
                    itemCount: historyList.length,
                    itemBuilder: (context, index) {
                      final drug = historyList[index];
                      return _buildHistoryItem(drug);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  TextStyle _headerTextStyle() {
    return TextStyle(
      color: AppColors.black,
      fontSize: SizeMg.text(14),
      fontWeight: FontWeight.w400,
    );
  }

  Widget _buildHistoryItem(Drug? drug) {
    String formattedDay = formatDateTime(
        int.tryParse(drug?.timeTaken.toString() ?? "") ??
            DateTime.now().millisecondsSinceEpoch)['day']!;

    String formattedMonth = formatDateTime(
        int.tryParse(drug?.timeTaken.toString() ?? "") ??
            DateTime.now().millisecondsSinceEpoch)['month']!;

    Color containerColor = AppColors.historyBackground;

    switch (drug?.drugUsageStatus ?? "") {
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
      padding: EdgeInsets.only(bottom: SizeMg.height(5)),
      child: Container(
        height: SizeMg.height(55),
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(SizeMg.radius(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Icon(
                Icons.medication,
                size: 24,
                color: AppColors.pillIconColor,
              ),
            ),
            Text(
              drug?.drugName ?? "",
              style: TextStyle(
                color: AppColors.black,
                fontSize: SizeMg.text(16),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              drug?.dosage ?? "",
              style: TextStyle(
                color: AppColors.darkGrey,
                fontSize: SizeMg.text(13),
                fontWeight: FontWeight.w400,
              ),
            ),
            Container(
              width: SizeMg.width(35),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(SizeMg.radius(10)),
                  bottomRight: Radius.circular(SizeMg.radius(10)),
                ),
                color: containerColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    formattedDay,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: SizeMg.text(18),
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                  Text(
                    formattedMonth,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: SizeMg.text(14),
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

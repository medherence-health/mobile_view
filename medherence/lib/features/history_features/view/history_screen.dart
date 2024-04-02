import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants_utils/color_utils.dart';
import '../../../core/model/models/history_model.dart';
import '../../../core/model/simulated_data/simulated_values.dart';
import '../../home_feature/view/medication_details.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<HistoryModel> _historyDataList = generateSimulatedData();
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
    return Scaffold(
      backgroundColor: AppColors.historyBackground,
      appBar: AppBar(
        backgroundColor: AppColors.historyBackground,
        title: const Text(
          'History',
          style: TextStyle(
            fontSize: 25,
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
          IconButton(onPressed: () {}, icon: const Icon(Icons.calculate_sharp))
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 80),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  (10),
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
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: (16),
                ),
                indicatorPadding: const EdgeInsets.all(5),
                indicator: BoxDecoration(
                  color: AppColors.navBarColor,
                  borderRadius: BorderRadius.circular(
                    (10),
                  ),
                  border: Border.all(
                    width: 2,
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

  _buildMedicationHistory(List<HistoryModel> historyList, int tabIndex) {
    switch (tabIndex) {
      case 0:
        return historyListBuilder(historyList);
      case 1:
        return Builder(builder: (ctx) {
          return const Center(
            child: SizedBox(
              height: 350,
              width: 180,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
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
          );
        });
      default:
        return Builder(builder: (ctx) {
          return const Center(
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
                    'You have new adherence history',
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
        });
    }
  }

  Builder historyListBuilder(List<HistoryModel> historyList) {
    return Builder(builder: (ctx) {
      if (historyList.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 30.0,
            vertical: 10,
          ),
          child: Stack(
            children: [
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
      return SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30.0,
            vertical: 15,
          ),
          child: Stack(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 25.0),
                child: Text(
                  'All',
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
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MedicationDetailsScreen(
                                    title: item.regimenName,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 55,
                              margin: const EdgeInsets.symmetric(vertical: 5),
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
                                    padding: const EdgeInsets.only(left: 15.0),
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
        ),
      );
    });
  }
}

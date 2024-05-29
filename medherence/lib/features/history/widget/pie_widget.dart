import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/model/models/history_model.dart';
import '../../../core/utils/color_utils.dart';

class PieChartWidget extends StatelessWidget {
  final Map<AdherenceStatus, int> adherenceData;

  PieChartWidget({required this.adherenceData});

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> sections = [
      PieChartSectionData(
        color: AppColors.success,
        value: adherenceData[AdherenceStatus.early]!.toDouble(),
        title: '${adherenceData[AdherenceStatus.early]}%',
        radius: 60,
        titleStyle: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: AppColors.warning,
        value: adherenceData[AdherenceStatus.late]!.toDouble(),
        title: '${adherenceData[AdherenceStatus.late]}%',
        radius: 60,
        titleStyle: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: AppColors.error,
        value: adherenceData[AdherenceStatus.missed]!.toDouble(),
        title: '${adherenceData[AdherenceStatus.missed]}%',
        radius: 60,
        titleStyle: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ];

    return PieChart(
      PieChartData(
        sections: sections,
        centerSpaceRadius: 40,
        sectionsSpace: 2,
        borderData: FlBorderData(show: false),
      ),
    );
  }
}

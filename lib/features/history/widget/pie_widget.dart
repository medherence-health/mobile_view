import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/model/models/history_model.dart';
import '../../../core/utils/color_utils.dart';

class PieChartWidget extends StatelessWidget {
  final Map<AdherenceStatus, int> adherenceData;

  const PieChartWidget({Key? key, required this.adherenceData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double late = adherenceData[AdherenceStatus.late]?.toDouble() ?? 0;
    double early = adherenceData[AdherenceStatus.early]?.toDouble() ?? 0;
    double missed = adherenceData[AdherenceStatus.missed]?.toDouble() ?? 0;
    double total = early + late + missed;

    // Avoid division by zero
    int latePercent = total > 0 ? ((late / total) * 100).round() : 0;
    int earlyPercent = total > 0 ? ((early / total) * 100).round() : 0;
    int missedPercent = total > 0 ? ((missed / total) * 100).round() : 0;

    List<PieChartSectionData> sections = [
      PieChartSectionData(
        color: AppColors.success,
        value: early,
        title: '$earlyPercent%',
        radius: 120,
        titleStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      PieChartSectionData(
        color: AppColors.warning,
        value: late,
        title: '$latePercent%',
        radius: 120,
        titleStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      PieChartSectionData(
        color: AppColors.error,
        value: missed,
        title: '$missedPercent%',
        radius: 120,
        titleStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    ];

    return PieChart(
      PieChartData(
        sections: sections,
        centerSpaceRadius: 0,
        sectionsSpace: 0,
        borderData: FlBorderData(show: false),
      ),
    );
  }
}

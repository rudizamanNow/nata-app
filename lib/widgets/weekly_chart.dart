import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nata/controller/habit_controller.dart';
import 'package:nata/utils/colors.dart';

class WeeklyChart extends StatefulWidget {
  const WeeklyChart({super.key});

  @override
  State<WeeklyChart> createState() => _WeeklyChartState();
}

class _WeeklyChartState extends State<WeeklyChart> {
  final HabitController habitController = Get.find<HabitController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<double> barData = habitController.getDoneHabitPerDay();
      return BarChart(
        BarChartData(
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 38,
                getTitlesWidget: getTiles,
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          barGroups: showingGroups(barData),
        ),
      );
    });
  }

  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: bluishClr,
          width: 23,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 10,
            color: Colors.grey.shade300,
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> showingGroups(List<double> barData) {
    return List.generate(barData.length, (i) {
      return makeGroupData(i, barData[i]);
    });
  }

  Widget getTiles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    Widget text;

    switch (value.toInt()) {
      case 0:
        text = const Text('Mon', style: style);
        break;
      case 1:
        text = const Text('Tue', style: style);
        break;
      case 2:
        text = const Text('Wed', style: style);
        break;
      case 3:
        text = const Text('Thu', style: style);
        break;
      case 4:
        text = const Text('Fri', style: style);
        break;
      case 5:
        text = const Text('Sat', style: style);
        break;
      case 6:
        text = const Text('Sun', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardBarChart extends StatelessWidget {
  final int userCount;
  final int customerCount;
  final int leadCount;
  final int followUpCount;

  const DashboardBarChart({
    super.key,
    required this.userCount,
    required this.customerCount,
    required this.leadCount,
    required this.followUpCount,
  });

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _getMaxY(),
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                switch (value.toInt()) {
                  case 0:
                    return const Text('Users');
                  case 1:
                    return const Text('Customers');
                  case 2:
                    return const Text('Leads');
                  case 3:
                    return const Text('Follow-ups');
                  default:
                    return const Text('');
                }
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
        ),
        barGroups: [
          BarChartGroupData(x: 0, barRods: [
            BarChartRodData(toY: userCount.toDouble(), color: Colors.orange),
          ]),
          BarChartGroupData(x: 1, barRods: [
            BarChartRodData(toY: customerCount.toDouble(), color: Colors.blue),
          ]),
          BarChartGroupData(x: 2, barRods: [
            BarChartRodData(toY: leadCount.toDouble(), color: Colors.green),
          ]),
          BarChartGroupData(x: 3, barRods: [
            BarChartRodData(toY: followUpCount.toDouble(), color: Colors.red),
          ]),
        ],
      ),
    );
  }

  double _getMaxY() {
    return [userCount, customerCount, leadCount, followUpCount]
            .reduce((a, b) => a > b ? a : b)
            .toDouble() +
        5;
  }
}

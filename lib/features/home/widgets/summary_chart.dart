import 'package:flutter/material.dart';
import 'package:sales_app/core/utils/formatter.dart';
import 'package:sales_app/ui/theme/app_colors.dart';
import 'package:sales_app/ui/theme/app_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SummaryChart extends StatelessWidget {
  final List<ChartData> data;
  const SummaryChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 30.0,
            spreadRadius: 0,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
          labelStyle: AppFonts.medium.copyWith(color: Colors.black, fontSize: 12),
        ),
        primaryYAxis: NumericAxis(isVisible: false),
        legend: Legend(
          isVisible: true,
          textStyle: AppFonts.medium.copyWith(color: Colors.black, fontSize: 12),
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: [
          ColumnSeries<ChartData, String>(
            name: 'Total',
            dataSource: data,
            xValueMapper: (ChartData d, _) => d.label,
            yValueMapper: (ChartData d, _) => d.total,
            dataLabelMapper: (ChartData d, _) => Formatter.toRupiahDouble(d.total),
            color: Colors.blue,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              builder: (
                dynamic data,
                dynamic point,
                dynamic series,
                int pointIndex,
                int seriesIndex,
              ) {
                final ChartData chartData = data as ChartData;
                final profit = chartData.total;
                return Text(
                  Formatter.toRupiahDouble(profit),
                  style: AppFonts.medium.copyWith(
                    color: profit < 0 ? Colors.red : Colors.black,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
          ColumnSeries<ChartData, String>(
            name: 'Profit',
            dataSource: data,
            xValueMapper: (ChartData d, _) => d.label,
            yValueMapper: (ChartData d, _) => d.profit,
            dataLabelMapper: (ChartData d, _) => Formatter.toRupiahDouble(d.profit),
            color: Colors.green,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              builder: (
                dynamic data,
                dynamic point,
                dynamic series,
                int pointIndex,
                int seriesIndex,
              ) {
                final ChartData chartData = data as ChartData;
                final profit = chartData.profit;
                return Text(
                  Formatter.toRupiahDouble(profit),
                  style: AppFonts.medium.copyWith(
                    color: profit < 0 ? Colors.red : Colors.black,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  final String label;
  final double total;
  final double profit;

  ChartData(this.label, this.total, this.profit);
}

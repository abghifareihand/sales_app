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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: AppColors.border, width: 1.0),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 16.0,
          ),
        ],
      ),
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
          axisLine: const AxisLine(color: AppColors.border),
          labelStyle: AppFonts.medium.copyWith(color: AppColors.slate, fontSize: 11),
        ),
        primaryYAxis: const NumericAxis(isVisible: false),
        legend: Legend(
          isVisible: true,
          position: LegendPosition.top,
          alignment: ChartAlignment.center,
          textStyle: AppFonts.medium.copyWith(color: AppColors.slate, fontSize: 12),
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: [
          ColumnSeries<ChartData, String>(
            name: 'Penjualan',
            dataSource: data,
            xValueMapper: (ChartData d, _) => d.label,
            yValueMapper: (ChartData d, _) => d.total,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
            color: AppColors.primary,
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
                return Text(
                  Formatter.toRupiahDouble(chartData.total),
                  style: AppFonts.semiBold.copyWith(
                    color: AppColors.dark,
                    fontSize: 9,
                  ),
                );
              },
            ),
          ),
          ColumnSeries<ChartData, String>(
            name: 'Laba (Profit)',
            dataSource: data,
            xValueMapper: (ChartData d, _) => d.label,
            yValueMapper: (ChartData d, _) => d.profit,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
            color: AppColors.green,
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
                return Text(
                  Formatter.toRupiahDouble(chartData.profit),
                  style: AppFonts.semiBold.copyWith(
                    color: AppColors.green,
                    fontSize: 9,
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

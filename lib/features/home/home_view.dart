import 'package:provider/provider.dart';
import 'package:sales_app/core/api/auth_api.dart';
import 'package:sales_app/core/api/transaction_api.dart';
import 'package:sales_app/core/assets/assets.gen.dart';
import 'package:sales_app/core/models/transaction_summary_model.dart';
import 'package:sales_app/core/utils/formatter.dart';
import 'package:sales_app/features/base_view.dart';
import 'package:sales_app/features/home/home_view_model.dart';
import 'package:sales_app/features/home/widgets/shimmer_name.dart';
import 'package:sales_app/features/outlet/outlet_view.dart';
import 'package:sales_app/features/product/product_view.dart';
import 'package:sales_app/features/profile/profile_view.dart';
import 'package:sales_app/features/transaction/transaction_view.dart';
import 'package:sales_app/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sales_app/ui/theme/app_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
      model: HomeViewModel(
        authApi: Provider.of<AuthApi>(context),
        transactionApi: Provider.of<TransactionApi>(context),
      ),
      onModelReady: (HomeViewModel model) => model.initModel(),
      onModelDispose: (HomeViewModel model) => model.disposeModel(),
      builder: (BuildContext context, HomeViewModel model, _) {
        return Scaffold(backgroundColor: AppColors.white, body: _buildBody(context, model));
      },
    );
  }
}

Widget _buildBody(BuildContext context, HomeViewModel model) {
  return RefreshIndicator(
    onRefresh: () async {
      await model.fetchProfile();
    },
    child: ListView(
      children: [
        // Nama
        Container(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 12),
          child: Row(
            children: [
              SvgPicture.asset(Assets.svg.iconPerson.path, width: 34, height: 34),
              const SizedBox(width: 4.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerName(
                    width: 100,
                    height: 12,
                    isLoading: model.isBusy,
                    text: model.name,
                    style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  ShimmerName(
                    width: 150,
                    height: 10,
                    isLoading: model.isBusy,
                    text: model.branchName,
                    style: AppFonts.regular.copyWith(
                      color: AppColors.black,
                      fontSize: 10,
                      height: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Menu
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          crossAxisCount: 2,
          crossAxisSpacing: 24.0,
          mainAxisSpacing: 24.0,
          children: [
            menuButton(
              iconPath: Assets.svg.iconProduct.path,
              title: 'Produk',
              subtitle: 'Kelola Produk',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProductView()));
              },
            ),
            menuButton(
              iconPath: Assets.svg.iconOutlet.path,
              title: 'Outlet',
              subtitle: 'Kelola Outlet',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => OutletView()));
              },
            ),
            menuButton(
              iconPath: Assets.svg.iconTransaction.path,
              title: 'Transaksi',
              subtitle: 'Kelola Transaksi',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionView()));
              },
            ),
            menuButton(
              iconPath: Assets.svg.iconProfile.path,
              title: 'Akun',
              subtitle: 'Kelola Akun',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileView()));
              },
            ),
          ],
        ),
        // Chart Ringkasan Penjualan
        // Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 20),
        //   height: 300,
        //   child:
        //       model.transactionsSummary == null
        //           ? const Center(child: CircularProgressIndicator())
        //           : SfCartesianChart(
        //             title: ChartTitle(text: 'Ringkasan Penjualan'),
        //             primaryXAxis: CategoryAxis(labelStyle: const TextStyle(fontSize: 12)),
        //             primaryYAxis: NumericAxis(
        //               title: AxisTitle(text: 'Total Penjualan'),
        //               edgeLabelPlacement: EdgeLabelPlacement.shift,
        //               interval: 1000,
        //             ),
        //             tooltipBehavior: TooltipBehavior(enable: true),
        //             series: [
        //               // Hari Ini
        //               ColumnSeries<TransactionSummary, String>(
        //                 dataSource: [model.transactionsSummary!],
        //                 xValueMapper: (TransactionSummary data, _) => 'Hari Ini',
        //                 yValueMapper: (TransactionSummary data, _) => data.daily.total.toDouble(),
        //                 width: 0.2,
        //                 spacing: 0.4,
        //                 pointColorMapper: (_, __) => Colors.blue,
        //                 dataLabelSettings: DataLabelSettings(
        //                   isVisible: true,
        //                   labelAlignment: ChartDataLabelAlignment.top,
        //                   builder: (dynamic data, _, __, ___, ____) {
        //                     return Text(
        //                       Formatter.toRupiahDouble(data.daily.total),
        //                       style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        //                     );
        //                   },
        //                 ),
        //               ),

        //               // Minggu Ini
        //               ColumnSeries<TransactionSummary, String>(
        //                 dataSource: [model.transactionsSummary!],
        //                 xValueMapper: (TransactionSummary data, _) => 'Minggu Ini',
        //                 yValueMapper: (TransactionSummary data, _) => data.weekly.total.toDouble(),
        //                 width: 0.2,
        //                 spacing: 0.4,
        //                 pointColorMapper: (_, __) => Colors.green,
        //                 dataLabelSettings: DataLabelSettings(
        //                   isVisible: true,
        //                   labelAlignment: ChartDataLabelAlignment.top,
        //                   builder: (dynamic data, _, __, ___, ____) {
        //                     return Text(
        //                       Formatter.toRupiahDouble(data.weekly.total),
        //                       style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        //                     );
        //                   },
        //                 ),
        //               ),

        //               // Bulan Ini
        //               ColumnSeries<TransactionSummary, String>(
        //                 dataSource: [model.transactionsSummary!],
        //                 xValueMapper: (TransactionSummary data, _) => 'Bulan Ini',
        //                 yValueMapper: (TransactionSummary data, _) => data.monthly.total.toDouble(),
        //                 width: 0.2,
        //                 spacing: 0.4,
        //                 pointColorMapper: (_, __) => Colors.orange,
        //                 dataLabelSettings: DataLabelSettings(
        //                   isVisible: true,
        //                   labelAlignment: ChartDataLabelAlignment.top,
        //                   builder: (dynamic data, _, __, ___, ____) {
        //                     return Text(
        //                       Formatter.toRupiahDouble(data.monthly.total),
        //                       style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        //                     );
        //                   },
        //                 ),
        //               ),
        //             ],
        //           ),
        // ),
      ],
    ),
  );
}

class SalesData {
  final String period;
  final double amount;

  SalesData(this.period, this.amount);
}

Widget menuButton({
  required String iconPath,
  required String title,
  required String subtitle,
  required VoidCallback onPressed,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.primary.withValues(alpha: 0.1),
            ),
            width: 48,
            height: 48,
            child: SvgPicture.asset(
              iconPath,
              colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
            ),
          ),
          const SizedBox(height: 10.0),
          Text(title, style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 14)),
          Text(subtitle, style: AppFonts.medium.copyWith(color: AppColors.gray, fontSize: 12)),
        ],
      ),
    ),
  );
}

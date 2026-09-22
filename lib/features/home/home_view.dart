import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/api/auth_api.dart';
import 'package:sales_app/core/api/transaction_api.dart';
import 'package:sales_app/core/assets/assets.gen.dart';
import 'package:sales_app/core/utils/formatter.dart';
import 'package:sales_app/features/base_view.dart';
import 'package:sales_app/features/home/home_view_model.dart';
import 'package:sales_app/features/home/widgets/summary_chart.dart';
import 'package:sales_app/features/outlet/outlet_view.dart';
import 'package:sales_app/features/product/product_view.dart';
import 'package:sales_app/features/profile/profile_view.dart';
import 'package:sales_app/features/transaction/transaction_view.dart';
import 'package:sales_app/ui/theme/app_colors.dart';
import 'package:sales_app/ui/theme/app_fonts.dart';

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
        return Scaffold(
          backgroundColor: AppColors.surface,
          body: SafeArea(
            child: _buildBody(context, model),
          ),
        );
      },
    );
  }
}

Widget _buildBody(BuildContext context, HomeViewModel model) {
  return RefreshIndicator(
    color: AppColors.primary,
    onRefresh: () async {
      await model.fetchProfile();
      await model.fetchTransactionSummary();
    },
    child: ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        // ===== HERO HEADER (Web Owner Amber Style) =====
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AppColors.amberGradient,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFB45309).withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ringkasan Bisnis Terkini Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF34D399),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'RINGKASAN BISNIS TERKINI',
                      style: AppFonts.semiBold.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  // User Avatar (White card with orange initial)
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        model.name.isNotEmpty
                            ? model.name.substring(0, 1).toUpperCase()
                            : 'S',
                        style: AppFonts.bold.copyWith(
                          color: const Color(0xFFD97706),
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Name & Branch
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selamat Datang,',
                          style: AppFonts.regular.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          model.name.isNotEmpty ? model.name : 'Sales Lapangan',
                          style: AppFonts.bold.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        // Branch Chip
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.location_on_rounded,
                                size: 12,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                model.branchName.isNotEmpty
                                    ? model.branchName
                                    : 'Cabang Jakarta',
                                style: AppFonts.medium.copyWith(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // ===== SECTION TITLE =====
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Menu Utama',
              style: AppFonts.bold.copyWith(
                color: AppColors.dark,
                fontSize: 16,
              ),
            ),
            Text(
              'Akses Cepat',
              style: AppFonts.regular.copyWith(
                color: AppColors.slateLight,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // ===== 4 MAIN MENU CARDS =====
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 14.0,
          mainAxisSpacing: 14.0,
          childAspectRatio: 1.15,
          children: [
            _buildModernMenuCard(
              context: context,
              icon: Icons.inventory_2_rounded,
              svgPath: Assets.svg.iconProduct.path,
              title: 'Produk',
              subtitle: 'Katalog & Stok',
              gradientColors: [const Color(0xFFFF9F43), const Color(0xFFF59E0B)],
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductView()));
              },
            ),
            _buildModernMenuCard(
              context: context,
              icon: Icons.storefront_rounded,
              svgPath: Assets.svg.iconOutlet.path,
              title: 'Outlet',
              subtitle: 'Kelola Toko',
              gradientColors: [const Color(0xFF38BDF8), const Color(0xFF0284C7)],
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const OutletView()));
              },
            ),
            _buildModernMenuCard(
              context: context,
              icon: Icons.receipt_long_rounded,
              svgPath: Assets.svg.iconTransaction.path,
              title: 'Transaksi',
              subtitle: 'Riwayat Penjualan',
              gradientColors: [const Color(0xFF10B981), const Color(0xFF059669)],
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const TransactionView()));
              },
            ),
            _buildModernMenuCard(
              context: context,
              icon: Icons.person_rounded,
              svgPath: Assets.svg.iconProfile.path,
              title: 'Akun',
              subtitle: 'Profil & Keamanan',
              gradientColors: [const Color(0xFFA855F7), const Color(0xFF7C3AED)],
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileView()));
              },
            ),
          ],
        ),
        const SizedBox(height: 24),

        // ===== RINGKASAN STATISTIK =====
        if (model.transactionsSummary != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ringkasan Penjualan',
                style: AppFonts.bold.copyWith(
                  color: AppColors.dark,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Real-time',
                  style: AppFonts.semiBold.copyWith(
                    color: AppColors.primaryDeep,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Mini Stat Cards
          Row(
            children: [
              Expanded(
                child: _buildStatMiniCard(
                  label: 'Hari Ini',
                  total: model.transactionsSummary!.daily.total,
                  profit: model.transactionsSummary!.daily.profit,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatMiniCard(
                  label: 'Minggu Ini',
                  total: model.transactionsSummary!.weekly.total,
                  profit: model.transactionsSummary!.weekly.profit,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatMiniCard(
                  label: 'Bulan Ini',
                  total: model.transactionsSummary!.monthly.total,
                  profit: model.transactionsSummary!.monthly.profit,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Summary Chart
          SummaryChart(
            data: [
              ChartData(
                'Harian',
                model.transactionsSummary!.daily.total,
                model.transactionsSummary!.daily.profit,
              ),
              ChartData(
                'Mingguan',
                model.transactionsSummary!.weekly.total,
                model.transactionsSummary!.weekly.profit,
              ),
              ChartData(
                'Bulanan',
                model.transactionsSummary!.monthly.total,
                model.transactionsSummary!.monthly.profit,
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ],
    ),
  );
}

Widget _buildModernMenuCard({
  required BuildContext context,
  required IconData icon,
  required String svgPath,
  required String title,
  required String subtitle,
  required List<Color> gradientColors,
  required VoidCallback onPressed,
}) {
  return Container(
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(20.0),
      border: Border.all(color: AppColors.border, width: 1.0),
      boxShadow: [
        BoxShadow(
          offset: const Offset(0, 4),
          color: AppColors.black.withValues(alpha: 0.03),
          blurRadius: 14.0,
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20.0),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon Badge
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: gradientColors[0].withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: SvgPicture.asset(
                    svgPath,
                    width: 22,
                    height: 22,
                    colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppFonts.bold.copyWith(color: AppColors.dark, fontSize: 15),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppFonts.regular.copyWith(color: AppColors.slateLight, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildStatMiniCard({
  required String label,
  required double total,
  required double profit,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border, width: 1.0),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppFonts.regular.copyWith(
            color: AppColors.slateLight,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          Formatter.toRupiahDouble(total),
          style: AppFonts.bold.copyWith(
            color: AppColors.dark,
            fontSize: 12,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            const Icon(Icons.arrow_upward_rounded, size: 10, color: AppColors.green),
            Expanded(
              child: Text(
                Formatter.toRupiahDouble(profit),
                style: AppFonts.semiBold.copyWith(
                  color: AppColors.green,
                  fontSize: 9,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

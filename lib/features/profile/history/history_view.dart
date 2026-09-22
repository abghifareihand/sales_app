import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/api/history_api.dart';
import 'package:sales_app/core/utils/formatter.dart';
import 'package:sales_app/features/base_view.dart';
import 'package:sales_app/features/profile/history/history_view_model.dart';
import 'package:sales_app/features/profile/widgets/history_shimmer.dart';
import 'package:sales_app/ui/shared/custom_appbar.dart';
import 'package:sales_app/ui/theme/app_colors.dart';
import 'package:sales_app/ui/theme/app_fonts.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<HistoryViewModel>(
      model: HistoryViewModel(historyApi: Provider.of<HistoryApi>(context)),
      onModelReady: (HistoryViewModel model) => model.initModel(),
      onModelDispose: (HistoryViewModel model) => model.disposeModel(),
      builder: (BuildContext context, HistoryViewModel model, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: const CustomAppBar(title: 'Riwayat Distribusi'),
          body: _buildBody(context, model),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, HistoryViewModel model) {
    if (model.isBusy) {
      return const HistoryShimmer();
    }

    if (model.history.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.history_toggle_off_rounded,
                  size: 44,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Belum Ada Riwayat Distribusi',
                style: AppFonts.semiBold.copyWith(color: AppColors.slate800, fontSize: 17),
              ),
              const SizedBox(height: 8),
              Text(
                'Mutasi stok masuk dari cabang atau retur stok akan tercatat otomatis di sini.',
                textAlign: TextAlign.center,
                style: AppFonts.regular.copyWith(color: AppColors.slate500, fontSize: 13, height: 1.4),
              ),
            ],
          ),
        ),
      );
    }

    final inCount = model.history.where((e) => e.type == 'cabang_to_sales').length;
    final outCount = model.history.where((e) => e.type != 'cabang_to_sales').length;

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        await model.fetchHistory();
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          // Summary Header Strip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.slate200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(
                  icon: Icons.move_to_inbox_rounded,
                  color: const Color(0xFF16A34A),
                  label: 'Masuk Cabang',
                  count: inCount,
                ),
                Container(height: 28, width: 1, color: AppColors.slate200),
                _buildSummaryItem(
                  icon: Icons.outbox_rounded,
                  color: const Color(0xFFDC2626),
                  label: 'Retur Cabang',
                  count: outCount,
                ),
                Container(height: 28, width: 1, color: AppColors.slate200),
                _buildSummaryItem(
                  icon: Icons.receipt_long_rounded,
                  color: AppColors.primaryDark,
                  label: 'Total Mutasi',
                  count: model.history.length,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // History List Cards
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: model.history.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12.0),
            itemBuilder: (context, index) {
              final data = model.history[index];
              final isIncoming = data.type == 'cabang_to_sales';

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.slate200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Direction Badge Icon
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isIncoming
                            ? const Color(0xFFF0FDF4)
                            : const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isIncoming
                              ? const Color(0xFFBBF7D0)
                              : const Color(0xFFFECACA),
                        ),
                      ),
                      child: Icon(
                        isIncoming ? Icons.south_west_rounded : Icons.north_east_rounded,
                        color: isIncoming ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Main info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Type pill badge
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isIncoming
                                      ? const Color(0xFFDCFCE7)
                                      : const Color(0xFFFEE2E2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  isIncoming ? 'Terima dari Cabang' : 'Retur ke Cabang',
                                  style: TextStyle(
                                    color: isIncoming
                                        ? const Color(0xFF15803D)
                                        : const Color(0xFFB91C1C),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              // Date
                              Text(
                                Formatter.toDate(data.createdAt),
                                style: AppFonts.medium.copyWith(
                                  color: AppColors.slate400,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Product Name
                          Text(
                            data.productName,
                            style: AppFonts.semiBold.copyWith(
                              color: AppColors.slate900,
                              fontSize: 15,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),

                          // Quantity & Time Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isIncoming
                                      ? const Color(0xFFF0FDF4)
                                      : const Color(0xFFFEF2F2),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isIncoming
                                        ? const Color(0xFF86EFAC)
                                        : const Color(0xFFFCA5A5),
                                  ),
                                ),
                                child: Text(
                                  '${isIncoming ? '+' : '-'}${data.quantity} pcs',
                                  style: TextStyle(
                                    color: isIncoming
                                        ? const Color(0xFF16A34A)
                                        : const Color(0xFFDC2626),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.access_time_rounded, size: 12, color: AppColors.slate400),
                                  const SizedBox(width: 4),
                                  Text(
                                    Formatter.toTime(data.createdAt),
                                    style: AppFonts.regular.copyWith(
                                      color: AppColors.slate400,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required Color color,
    required String label,
    required int count,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              '$count',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.slate500,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

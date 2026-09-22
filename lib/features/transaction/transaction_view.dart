import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/api/transaction_api.dart';
import 'package:sales_app/core/utils/formatter.dart';
import 'package:sales_app/features/base_view.dart';
import 'package:sales_app/features/transaction/transaction-detail/transaction_detail_view.dart';
import 'package:sales_app/features/transaction/transaction_view_model.dart';
import 'package:sales_app/features/transaction/widgets/transaction_shimmer.dart';
import 'package:sales_app/ui/shared/custom_appbar.dart';
import 'package:sales_app/ui/theme/app_colors.dart';
import 'package:sales_app/ui/theme/app_fonts.dart';

class TransactionView extends StatelessWidget {
  const TransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<TransactionViewModel>(
      model: TransactionViewModel(transactionApi: Provider.of<TransactionApi>(context)),
      onModelReady: (TransactionViewModel model) => model.initModel(),
      onModelDispose: (TransactionViewModel model) => model.disposeModel(),
      builder: (BuildContext context, TransactionViewModel model, _) {
        return Scaffold(
          backgroundColor: AppColors.surface,
          appBar: const CustomAppBar(title: 'Riwayat Transaksi'),
          body: _buildBody(context, model),
        );
      },
    );
  }
}

Widget _buildBody(BuildContext context, TransactionViewModel model) {
  if (model.isBusy) {
    return const TransactionShimmer();
  }

  if (model.transactions.isEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.slateMuted),
          const SizedBox(height: 12),
          Text(
            'Belum ada transaksi tercatat',
            style: AppFonts.medium.copyWith(color: AppColors.slateLight, fontSize: 14),
          ),
        ],
      ),
    );
  }

  return RefreshIndicator(
    color: AppColors.primary,
    onRefresh: () async {
      await model.fetchTransaction();
    },
    child: ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: model.transactions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 14.0),
      itemBuilder: (context, index) {
        final transaction = model.transactions[index];
        final status = transaction.status.toLowerCase();

        Color statusColor;
        Color statusBg;
        String statusLabel;

        if (status == 'approved' || status == 'success') {
          statusColor = AppColors.green;
          statusBg = AppColors.green.withValues(alpha: 0.1);
          statusLabel = 'Disetujui';
        } else if (status == 'rejected') {
          statusColor = AppColors.red;
          statusBg = AppColors.red.withValues(alpha: 0.1);
          statusLabel = 'Ditolak';
        } else {
          statusColor = AppColors.primaryDark;
          statusBg = AppColors.primarySurface;
          statusLabel = 'Menunggu';
        }

        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border, width: 1.0),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.02),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionDetailView(transaction: transaction),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card Header: Outlet & Status
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primarySurface,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.store_rounded,
                            color: AppColors.primaryDark,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                transaction.outlet.nameOutlet,
                                style: AppFonts.bold.copyWith(
                                  color: AppColors.dark,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${transaction.outlet.name} • ${Formatter.toDate(transaction.createdAt)}',
                                style: AppFonts.regular.copyWith(
                                  color: AppColors.slateLight,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Status Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusBg,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            statusLabel,
                            style: AppFonts.semiBold.copyWith(
                              color: statusColor,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: AppColors.border, height: 1),
                    ),

                    // Items List Preview
                    Column(
                      children: transaction.items.take(3).map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.surface,
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: AppColors.border),
                                      ),
                                      child: Text(
                                        '${item.quantity}x',
                                        style: AppFonts.bold.copyWith(
                                          color: AppColors.dark,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '${item.name} (${item.provider})',
                                        style: AppFonts.medium.copyWith(
                                          color: AppColors.slate,
                                          fontSize: 12,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                Formatter.toRupiahDouble(item.subtotal),
                                style: AppFonts.semiBold.copyWith(
                                  color: AppColors.dark,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

                    if (transaction.items.length > 3) ...[
                      Text(
                        '+ ${transaction.items.length - 3} produk lainnya',
                        style: AppFonts.medium.copyWith(color: AppColors.primaryDark, fontSize: 11),
                      ),
                      const SizedBox(height: 4),
                    ],

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(color: AppColors.border, height: 1),
                    ),

                    // Card Footer: Profit & Total
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Profit chip
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.trending_up_rounded, size: 14, color: AppColors.green),
                              const SizedBox(width: 4),
                              Text(
                                'Laba ${Formatter.toRupiahDouble(transaction.profit)}',
                                style: AppFonts.semiBold.copyWith(
                                  color: AppColors.green,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Total Price
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Total Belanja',
                              style: AppFonts.regular.copyWith(
                                color: AppColors.slateLight,
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              Formatter.toRupiahDouble(transaction.total),
                              style: AppFonts.bold.copyWith(
                                color: AppColors.dark,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

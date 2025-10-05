import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/api/transaction_api.dart';
import 'package:sales_app/core/utils/formatter.dart';
import 'package:sales_app/features/base_view.dart';
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
          appBar: CustomAppBar(title: 'Transaksi'),
          backgroundColor: AppColors.white,
          body: _buildBody(context, model),
        );
      },
    );
  }
}

Widget _buildBody(BuildContext context, TransactionViewModel model) {
  if (model.isBusy) {
    return TransactionShimmer();
  }

  if (model.transactions.isEmpty) {
    return Center(
      child: Text(
        'Belum ada transaksi',
        style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 14),
      ),
    );
  }
  return RefreshIndicator(
    onRefresh: () async {
      await model.fetchTransaction();
    },
    child: ListView.separated(
      padding: EdgeInsets.all(24),
      itemCount: model.transactions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16.0),
      itemBuilder: (context, index) {
        final transaction = model.transactions[index];
        return Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gray),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.outlet.nameOutlet,
                          style: AppFonts.semiBold.copyWith(color: AppColors.black, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          transaction.outlet.name,
                          style: AppFonts.medium.copyWith(
                            color: AppColors.black.withValues(alpha: 0.5),
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        Formatter.toDate(transaction.createdAt),
                        style: AppFonts.medium.copyWith(
                          color: AppColors.black.withValues(alpha: 0.5),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        Formatter.toTime(transaction.createdAt),
                        style: AppFonts.medium.copyWith(
                          color: AppColors.black.withValues(alpha: 0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(color: AppColors.gray),

              // ISI PRODUK
              Column(
                children:
                    transaction.items.map((item) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${item.name} x${item.quantity}',
                              style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            Formatter.toRupiahDouble(item.subtotal.toDouble()),
                            style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 12),
                          ),
                        ],
                      );
                    }).toList(),
              ),

              Divider(color: AppColors.gray),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // PROFIT
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profit',
                        style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (transaction.status == 'approved' &&
                          transaction.originalProfit != null) ...[
                        Text(
                          Formatter.toRupiahDouble(transaction.originalProfit ?? 0),
                          style: AppFonts.medium.copyWith(
                            color: AppColors.black.withValues(alpha: 0.5),
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        Text(
                          Formatter.toRupiahDouble(transaction.profit),
                          style: AppFonts.semiBold.copyWith(color: AppColors.black, fontSize: 12),
                        ),
                      ] else ...[
                        Text(
                          Formatter.toRupiahDouble(transaction.profit),
                          style: AppFonts.semiBold.copyWith(color: AppColors.black, fontSize: 12),
                        ),
                      ],
                    ],
                  ),

                  // PENJUALAN / TOTAL
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Penjualan',
                        style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (transaction.status == 'approved' &&
                          transaction.originalTotal != null) ...[
                        Text(
                          Formatter.toRupiahDouble(transaction.originalTotal ?? 0),
                          style: AppFonts.medium.copyWith(
                            color: AppColors.black.withValues(alpha: 0.5),
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        Text(
                          Formatter.toRupiahDouble(transaction.total),
                          style: AppFonts.semiBold.copyWith(color: AppColors.black, fontSize: 12),
                        ),
                      ] else ...[
                        Text(
                          Formatter.toRupiahDouble(transaction.total),
                          style: AppFonts.semiBold.copyWith(color: AppColors.black, fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
}

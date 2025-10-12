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
          appBar: CustomAppBar(title: 'History Produk'),
          backgroundColor: AppColors.white,
          body: _buildBody(context, model),
        );
      },
    );
  }
}

Widget _buildBody(BuildContext context, HistoryViewModel model) {
  if (model.isBusy) {
    return HistoryShimmer();
  }

  if (model.history.isEmpty) {
    return Center(
      child: Text(
        'Belum ada history distribusi',
        style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 14),
      ),
    );
  }
  return RefreshIndicator(
    onRefresh: () async {
      await model.fetchHistory();
    },
    child: ListView.separated(
      padding: EdgeInsets.all(24),
      itemCount: model.history.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16.0),
      itemBuilder: (context, index) {
        final data = model.history[index];
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
                          data.productName,
                          style: AppFonts.semiBold.copyWith(color: AppColors.black, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Qty ${data.quantity}',
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
                        Formatter.toDate(data.createdAt),
                        style: AppFonts.medium.copyWith(
                          color: AppColors.black.withValues(alpha: 0.5),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        Formatter.toTime(data.createdAt),
                        style: AppFonts.medium.copyWith(
                          color: AppColors.black.withValues(alpha: 0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: data.type == 'cabang_to_sales' ? Color(0xffFF9F43) : Color(0xffFF0000),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  data.type == 'cabang_to_sales' ? 'Terima dari Cabang' : 'Refund ke Cabang',
                  style: AppFonts.medium.copyWith(color: AppColors.white, fontSize: 10),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

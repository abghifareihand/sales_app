import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/api/outlet_api.dart';
import 'package:sales_app/core/assets/assets.gen.dart';
import 'package:sales_app/features/base_view.dart';
import 'package:sales_app/features/outlet/add-outlet/add_outlet_view.dart';
import 'package:sales_app/features/outlet/outlet_view_model.dart';
import 'package:sales_app/features/outlet/widgets/outlet_shimmer.dart';
import 'package:sales_app/ui/shared/custom_appbar.dart';
import 'package:sales_app/ui/theme/app_colors.dart';
import 'package:sales_app/ui/theme/app_fonts.dart';

class OutletView extends StatelessWidget {
  const OutletView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<OutletViewModel>(
      model: OutletViewModel(outletApi: Provider.of<OutletApi>(context)),
      onModelReady: (OutletViewModel model) => model.initModel(),
      onModelDispose: (OutletViewModel model) => model.disposeModel(),
      builder: (BuildContext context, OutletViewModel model, _) {
        return Scaffold(
          appBar: CustomAppBar(
            title: 'Outlet',
            actions: [
              IconButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddOutletView()),
                  );
                  if (result == true) {
                    await model.fetchOutlets();
                  }
                },
                icon: Assets.svg.iconPlus.svg(),
              ),
              const SizedBox(width: 8.0),
            ],
          ),
          backgroundColor: AppColors.white,
          body: _buildBody(context, model),
        );
      },
    );
  }
}

Widget _buildBody(BuildContext context, OutletViewModel model) {
  if (model.isBusy && model.outlets.isEmpty) {
    return OutletShimmer();
  }

  if (model.outlets.isEmpty) {
    return Center(
      child: Text(
        'Belum ada outlet',
        style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 14),
      ),
    );
  }

  return RefreshIndicator(
    onRefresh: () async {
      await model.fetchOutlets();
    },
    child: GridView.builder(
      padding: EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 24,
        crossAxisSpacing: 24,
        childAspectRatio: 3 / 4,
      ),
      itemCount: model.outlets.length,
      itemBuilder: (context, index) {
        final outlet = model.outlets[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gray),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: Assets.images.imageStore.image(width: 80, height: 80),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                outlet.name ?? '-',
                style: AppFonts.medium.copyWith(
                  color: AppColors.black,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                outlet.nameOutlet ?? '-',
                style: AppFonts.medium.copyWith(
                  color: AppColors.black.withValues(alpha: 0.5),
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                outlet.addressOutlet ?? '-',
                style: AppFonts.regular.copyWith(
                  color: AppColors.black.withValues(alpha: 0.5),
                  fontSize: 10,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/api/outlet_api.dart';
import 'package:sales_app/features/base_view.dart';
import 'package:sales_app/features/outlet/add-outlet/add_outlet_view.dart';
import 'package:sales_app/features/outlet/outlet_view_model.dart';
import 'package:sales_app/features/outlet/widgets/outlet_shimmer.dart';
import 'package:sales_app/ui/shared/custom_appbar.dart';
import 'package:sales_app/ui/shared/custom_search_field.dart';
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
          backgroundColor: AppColors.surface,
          appBar: CustomAppBar(
            title: 'Daftar Outlet',
            actions: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddOutletView()),
                      );
                      if (result == true) {
                        await model.fetchOutlets();
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add_rounded, color: AppColors.white, size: 18),
                          SizedBox(width: 4),
                          Text(
                            'Tambah',
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
            ],
          ),
          body: _buildBody(context, model),
        );
      },
    );
  }
}

Widget _buildBody(BuildContext context, OutletViewModel model) {
  return RefreshIndicator(
    color: AppColors.primary,
    onRefresh: () async {
      await model.fetchOutlets();
    },
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: CustomSearchField(
            controller: model.searchController,
            hintText: 'Cari nama outlet, ID, atau alamat...',
            onChanged: model.onSearchChanged,
          ),
        ),
        Expanded(
          child: model.isBusy
              ? const OutletShimmer()
              : model.outlets.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.storefront_outlined, size: 64, color: AppColors.slateMuted),
                          const SizedBox(height: 12),
                          Text(
                            'Belum ada outlet terdaftar',
                            style: AppFonts.medium.copyWith(color: AppColors.slateLight, fontSize: 14),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: model.outlets.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final outlet = model.outlets[index];
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppColors.border, width: 1.0),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withValues(alpha: 0.02),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Store Icon Avatar
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.primarySurface,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.storefront_rounded,
                                    color: AppColors.primaryDark,
                                    size: 24,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),

                              // Store Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Outlet Name
                                        Expanded(
                                          child: Text(
                                            outlet.nameOutlet ?? '-',
                                            style: AppFonts.bold.copyWith(
                                              color: AppColors.dark,
                                              fontSize: 14,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // ID Chip
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.surface,
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(color: AppColors.border),
                                          ),
                                          child: Text(
                                            outlet.idOutlet ?? '-',
                                            style: AppFonts.semiBold.copyWith(
                                              color: AppColors.slate,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),

                                    // Owner / Contact
                                    if (outlet.name != null && outlet.name!.isNotEmpty)
                                      Row(
                                        children: [
                                          const Icon(Icons.person_outline_rounded, size: 14, color: AppColors.slateLight),
                                          const SizedBox(width: 4),
                                          Text(
                                            outlet.name!,
                                            style: AppFonts.medium.copyWith(
                                              color: AppColors.slate,
                                              fontSize: 12,
                                            ),
                                          ),
                                          if (outlet.phone != null && outlet.phone!.isNotEmpty) ...[
                                            const Text(' • ', style: TextStyle(color: AppColors.slateMuted)),
                                            Text(
                                              outlet.phone!,
                                              style: AppFonts.regular.copyWith(
                                                color: AppColors.slateLight,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    const SizedBox(height: 6),

                                    // Address
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 2),
                                          child: Icon(Icons.location_on_outlined, size: 14, color: AppColors.primary),
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            outlet.addressOutlet ?? '-',
                                            style: AppFonts.regular.copyWith(
                                              color: AppColors.slateLight,
                                              fontSize: 11,
                                              height: 1.3,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
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
        ),
      ],
    ),
  );
}

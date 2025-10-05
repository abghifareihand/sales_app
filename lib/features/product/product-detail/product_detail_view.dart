import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/api/product_api.dart';
import 'package:sales_app/core/assets/assets.gen.dart';
import 'package:sales_app/core/models/product_model.dart';
import 'package:sales_app/core/utils/formatter.dart';
import 'package:sales_app/features/base_view.dart';
import 'package:sales_app/features/product/product-detail/product_detail_view_model.dart';
import 'package:sales_app/ui/shared/custom_appbar.dart';
import 'package:sales_app/ui/shared/custom_button.dart';
import 'package:sales_app/ui/shared/custom_snackbar.dart';
import 'package:sales_app/ui/shared/custom_text_field.dart';
import 'package:sales_app/ui/theme/app_colors.dart';
import 'package:sales_app/ui/theme/app_fonts.dart';

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return BaseView<ProductDetailViewModel>(
      model: ProductDetailViewModel(product: product, productApi: Provider.of<ProductApi>(context)),
      onModelReady: (ProductDetailViewModel model) => model.initModel(),
      onModelDispose: (ProductDetailViewModel model) => model.disposeModel(),
      builder: (BuildContext context, ProductDetailViewModel model, _) {
        return Scaffold(
          appBar: CustomAppBar(
            title: 'Detail Product',
            actions: [
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    builder: (context) {
                      return AnimatedBuilder(
                        animation: model,
                        builder: (_, __) => _buildBottomSheet(context, model, product),
                      );
                    },
                  );
                },
                icon: Assets.svg.iconEdit.svg(),
              ),
              const SizedBox(width: 8.0),
            ],
          ),
          backgroundColor: AppColors.white,
          body: _buildBody(context, model, product),
        );
      },
    );
  }
}

Widget _buildBody(BuildContext context, ProductDetailViewModel model, Product product) {
  return ListView(
    padding: EdgeInsets.all(24),
    children: [
      Assets.images.imageProduct.image(width: double.infinity, height: 180),
      const SizedBox(height: 24.0),
      Text(
        product.name ?? '',
        style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 20),
      ),
      Text(
        product.description ?? '',
        style: AppFonts.regular.copyWith(color: AppColors.black, fontSize: 14),
      ),

      const SizedBox(height: 16.0),
      Text('Harga Modal', style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 16)),
      Text(
        Formatter.toRupiahDouble(product.costPrice ?? 0),
        style: AppFonts.regular.copyWith(color: AppColors.black, fontSize: 16),
      ),
      const SizedBox(height: 8.0),
      Text('Harga Jual', style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 16)),
      Text(
        Formatter.toRupiahDouble(product.sellingPrice ?? 0),
        style: AppFonts.regular.copyWith(color: AppColors.black, fontSize: 16),
      ),
      const SizedBox(height: 16.0),
      Text('Stock', style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 16)),
      Text(
        '${product.quantity}',
        style: AppFonts.regular.copyWith(color: AppColors.black, fontSize: 16),
      ),
    ],
  );
}

Widget _buildBottomSheet(BuildContext context, ProductDetailViewModel model, Product product) {
  return Padding(
    padding: EdgeInsets.only(
      left: 16,
      right: 16,
      top: 24,
      bottom: MediaQuery.of(context).viewInsets.bottom,
    ),
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Kembalikan Stock ke Cabang',
            style: AppFonts.semiBold.copyWith(color: AppColors.black, fontSize: 16),
          ),
          const SizedBox(height: 20.0),
          CustomTextField(
            controller: model.stockController,
            keyboardType: TextInputType.number,
            label: 'Stock',
            hintText: 'Masukkan Stock',
            onChanged: model.updateStock,
            errorText: model.stockError,
          ),
          const SizedBox(height: 16.0),
          CustomTextField(
            controller: model.notesController,
            textInputAction: TextInputAction.done,
            label: 'Catatan',
            hintText: 'Masukkan catatan',
          ),
          const SizedBox(height: 24.0),
          Button.filled(
            onPressed:
                model.isFormValid
                    ? () async {
                      await model.returnStock();
                      if (context.mounted) {
                        if (model.error) {
                          CustomSnackbar.showError(context, model.message);
                        }
                        if (model.success) {
                          CustomSnackbar.showSuccess(context, model.message);
                          Navigator.pop(context);
                          Navigator.of(context).pop(true);
                        }
                      }
                    }
                    : null,
            label: 'Simpan',
            isLoading: model.isBusy,
          ),
          const SizedBox(height: 24.0),
        ],
      ),
    ),
  );
}

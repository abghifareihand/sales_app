import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/api/product_api.dart';
import 'package:sales_app/core/assets/assets.gen.dart';
import 'package:sales_app/core/utils/formatter.dart';
import 'package:sales_app/features/base_view.dart';
import 'package:sales_app/features/cart/cart_view.dart';
import 'package:sales_app/features/cart/cart_view_model.dart';
import 'package:sales_app/features/product/product-detail/product_detail_view.dart';
import 'package:sales_app/features/product/product_view_model.dart';
import 'package:sales_app/features/product/widgets/product_shimmer.dart';
import 'package:sales_app/ui/shared/custom_appbar.dart';
import 'package:sales_app/ui/theme/app_colors.dart';
import 'package:sales_app/ui/theme/app_fonts.dart';

class ProductView extends StatelessWidget {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<ProductViewModel>(
      model: ProductViewModel(productApi: Provider.of<ProductApi>(context)),
      onModelReady: (ProductViewModel model) => model.initModel(),
      onModelDispose: (ProductViewModel model) => model.disposeModel(),
      builder: (BuildContext context, ProductViewModel model, _) {
        return Scaffold(
          appBar: CustomAppBar(
            title: 'Product',
            actions: [
              Consumer<CartViewModel>(
                builder: (context, cart, _) {
                  final cartCount = cart.totalItems;
                  return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const CartView()));
                    },
                    borderRadius: BorderRadius.circular(50),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.shopping_bag_outlined, color: AppColors.primary),
                        ),
                        if (cartCount > 0)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                              child: Center(
                                child: Text(
                                  '$cartCount',
                                  style: AppFonts.bold.copyWith(
                                    color: AppColors.white,
                                    fontSize: 8,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(width: 12.0),
            ],
          ),
          body: _buildBody(context, model),
        );
      },
    );
  }
}

Widget _buildBody(BuildContext context, ProductViewModel model) {
  if (model.isBusy) {
    return ProductShimmer();
  }

  if (model.products.isEmpty) {
    return Center(
      child: Text(
        'Belum ada produk',
        style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 14),
      ),
    );
  }

  return RefreshIndicator(
    onRefresh: () async {
      await model.fetchProducts();
    },
    child: GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 24,
        crossAxisSpacing: 24,
        childAspectRatio: 3 / 4,
      ),
      itemCount: model.products.length,
      itemBuilder: (context, index) {
        final product = model.products[index];
        final cart = Provider.of<CartViewModel>(context);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Card content
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () async {

                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductDetailView(product: product)),
                  );
                  if (result == true) {
                    await model.fetchProducts();
                  }
               
              },
              child: Container(
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
                      child: Center(child: Assets.images.imageProduct.image(width: 80, height: 80)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.name ?? '-',
                      style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      Formatter.toRupiahDouble(product.sellingPrice ?? 0),
                      style: AppFonts.medium.copyWith(
                        color: AppColors.black.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Stok: ${product.quantity ?? 0}',
                      style: AppFonts.regular.copyWith(
                        color: AppColors.black.withValues(alpha: 0.5),
                        fontSize: 10,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color:
                      product.quantity != null && product.quantity! > 0
                          ? AppColors.primary
                          : Colors.grey,
                ),
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 20),
                  onPressed:
                      product.quantity != null && product.quantity! > 0
                          ? () {
                            cart.addProduct(product);
                          }
                          : null,
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}

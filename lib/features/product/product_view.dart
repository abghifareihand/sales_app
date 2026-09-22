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
import 'package:sales_app/ui/shared/custom_search_field.dart';
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
          backgroundColor: AppColors.surface,
          appBar: CustomAppBar(
            title: 'Katalog Produk',
            actions: [
              Consumer<CartViewModel>(
                builder: (context, cart, _) {
                  final cartCount = cart.totalItems;
                  return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const CartView()));
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(Icons.shopping_bag_outlined, color: AppColors.dark, size: 20),
                          if (cartCount > 0)
                            Positioned(
                              top: -4,
                              right: -4,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                  color: AppColors.red,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                                child: Center(
                                  child: Text(
                                    '$cartCount',
                                    style: AppFonts.bold.copyWith(
                                      color: AppColors.white,
                                      fontSize: 9,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
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

Widget _buildBody(BuildContext context, ProductViewModel model) {
  return RefreshIndicator(
    color: AppColors.primary,
    onRefresh: () async {
      await model.fetchProducts();
    },
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: CustomSearchField(
            controller: model.searchController,
            hintText: 'Cari provider, kuota, atau produk...',
            onChanged: model.onSearchChanged,
          ),
        ),
        Expanded(
          child: model.isBusy
              ? const ProductShimmer()
              : model.products.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.inventory_2_outlined, size: 64, color: AppColors.slateMuted),
                          const SizedBox(height: 12),
                          Text(
                            'Tidak ada produk ditemukan',
                            style: AppFonts.medium.copyWith(color: AppColors.slateLight, fontSize: 14),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: model.products.length,
                      itemBuilder: (context, index) {
                        final product = model.products[index];
                        final stock = product.quantity ?? 0;
                        final isLowStock = stock <= 5;

                        return Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppColors.border, width: 1.0),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withValues(alpha: 0.03),
                                blurRadius: 10,
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
                                    builder: (_) => ProductDetailView(product: product),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Top provider & kuota tag
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Provider Chip
                                        Flexible(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: _getProviderColor(product.provider).withValues(alpha: 0.12),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              product.provider ?? '-',
                                              style: AppFonts.bold.copyWith(
                                                color: _getProviderColor(product.provider),
                                                fontSize: 10,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        // Kuota badge
                                        if (product.kuota != null && product.kuota!.isNotEmpty)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppColors.dark,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              product.kuota!,
                                              style: AppFonts.semiBold.copyWith(
                                                color: AppColors.white,
                                                fontSize: 9,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),

                                    // Image container
                                    Expanded(
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: AppColors.surface,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                          child: Assets.images.imageProduct.image(
                                            width: 64,
                                            height: 64,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),

                                    // Product Name
                                    Text(
                                      product.name ?? '-',
                                      style: AppFonts.bold.copyWith(
                                        color: AppColors.dark,
                                        fontSize: 13,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),

                                    // Category
                                    Text(
                                      product.category ?? '-',
                                      style: AppFonts.regular.copyWith(
                                        color: AppColors.slateLight,
                                        fontSize: 11,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),

                                    // Price
                                    Text(
                                      Formatter.toRupiahDouble(product.sellingPrice ?? 0),
                                      style: AppFonts.bold.copyWith(
                                        color: AppColors.primaryDark,
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),

                                    // Stock pill
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: isLowStock
                                            ? AppColors.red.withValues(alpha: 0.1)
                                            : AppColors.green.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 5,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isLowStock ? AppColors.red : AppColors.green,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Stok: $stock',
                                            style: AppFonts.semiBold.copyWith(
                                              color: isLowStock ? AppColors.red : AppColors.green,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    ),
  );
}

Color _getProviderColor(String? provider) {
  if (provider == null) return AppColors.primary;
  final p = provider.toLowerCase();
  if (p.contains('telkomsel')) return const Color(0xFFE11D48);
  if (p.contains('indosat')) return const Color(0xFFF59E0B);
  if (p.contains('xl')) return const Color(0xFF2563EB);
  if (p.contains('tri')) return const Color(0xFFEA580C);
  if (p.contains('smartfren')) return const Color(0xFFDB2777);
  return AppColors.primary;
}

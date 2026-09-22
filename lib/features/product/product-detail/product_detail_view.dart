import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/api/product_api.dart';
import 'package:sales_app/core/assets/assets.gen.dart';
import 'package:sales_app/core/models/product_model.dart';
import 'package:sales_app/core/utils/formatter.dart';
import 'package:sales_app/features/base_view.dart';
import 'package:sales_app/features/cart/cart_view.dart';
import 'package:sales_app/features/cart/cart_view_model.dart';
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

  Color _getProviderColor(String? provider) {
    final p = (provider ?? '').toLowerCase();
    if (p.contains('telkomsel') || p.contains('tsel')) return const Color(0xFFEF4444);
    if (p.contains('indosat') || p.contains('isat') || p.contains('im3')) return const Color(0xFFF59E0B);
    if (p.contains('xl')) return const Color(0xFF2563EB);
    if (p.contains('axis')) return const Color(0xFF9333EA);
    if (p.contains('smartfren')) return const Color(0xFFEC4899);
    if (p.contains('tri') || p.contains('three')) return const Color(0xFFF97316);
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ProductDetailViewModel>(
      model: ProductDetailViewModel(
        product: product,
        productApi: Provider.of<ProductApi>(context),
      ),
      onModelReady: (ProductDetailViewModel model) => model.initModel(),
      onModelDispose: (ProductDetailViewModel model) => model.disposeModel(),
      builder: (BuildContext context, ProductDetailViewModel model, _) {
        final cart = Provider.of<CartViewModel>(context);
        final inCartQty = cart.items[product.id]?.quantity ?? 0;
        final stock = product.quantity ?? 0;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: CustomAppBar(
            title: 'Detail Produk',
            actions: [
              // Cart Badge Button
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CartView()),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart_outlined, color: AppColors.slate700),
                    tooltip: 'Lihat Keranjang',
                  ),
                  if (cart.totalItems > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                        child: Text(
                          '${cart.totalItems}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 8.0),
            ],
          ),
          body: _buildBody(context, model, product, inCartQty),
          bottomNavigationBar: _buildBottomActions(context, model, product, cart, stock),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    ProductDetailViewModel model,
    Product product,
    int inCartQty,
  ) {
    final provColor = _getProviderColor(product.provider);
    final stock = product.quantity ?? 0;
    final costPrice = product.costPrice ?? 0;
    final sellingPrice = product.sellingPrice ?? 0;
    final profit = sellingPrice - costPrice;
    final profitPercent = costPrice > 0 ? ((profit / costPrice) * 100).toStringAsFixed(0) : '0';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Hero Image Container
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFFF7ED),
                  const Color(0xFFFFEDD5).withValues(alpha: 0.5),
                  AppColors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFFFE8D6)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                // Top tags row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Provider Badge
                    if (product.provider != null && product.provider!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: provColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: provColor.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: provColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              product.provider!,
                              style: TextStyle(
                                color: provColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      const SizedBox.shrink(),

                    // Category Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.slate100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.slate200),
                      ),
                      child: Text(
                        product.category ?? 'Produk',
                        style: const TextStyle(
                          color: AppColors.slate600,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Center Image with soft circle background
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFFFEDD5).withValues(alpha: 0.6),
                      ),
                    ),
                    Assets.images.imageProduct.image(width: 150, height: 150),
                  ],
                ),
                const SizedBox(height: 12),

                // Kuota tag if present
                if (product.kuota != null && product.kuota!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.wifi_tethering_rounded, size: 14, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(
                          'Kuota: ${product.kuota}',
                          style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. Product Name & Description
          Text(
            product.name ?? '-',
            style: AppFonts.bold.copyWith(
              color: AppColors.slate900,
              fontSize: 22,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            product.description ?? 'Tidak ada deskripsi produk.',
            style: AppFonts.regular.copyWith(
              color: AppColors.slate500,
              fontSize: 13,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 20),

          // 3. Pricing & Margin Overview Cards
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.slate200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    // Selling Price Card
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBEB),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFFDE68A)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.sell_outlined, size: 14, color: Color(0xFFD97706)),
                                const SizedBox(width: 4),
                                Text(
                                  'Harga Jual',
                                  style: AppFonts.medium.copyWith(
                                    color: const Color(0xFFB45309),
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              Formatter.toRupiahDouble(sellingPrice),
                              style: AppFonts.bold.copyWith(
                                color: const Color(0xFFB45309),
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Harga ke outlet',
                              style: TextStyle(
                                color: const Color(0xFFB45309).withValues(alpha: 0.8),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Cost Price Card
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.slate50,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.slate200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.receipt_long_outlined, size: 14, color: AppColors.slate600),
                                const SizedBox(width: 4),
                                Text(
                                  'Harga Modal',
                                  style: AppFonts.medium.copyWith(
                                    color: AppColors.slate600,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              Formatter.toRupiahDouble(costPrice),
                              style: AppFonts.semiBold.copyWith(
                                color: AppColors.slate800,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Modal cabang',
                              style: TextStyle(
                                color: AppColors.slate400,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Profit Strip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFBBF7D0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.trending_up_rounded, size: 16, color: Color(0xFF16A34A)),
                          const SizedBox(width: 6),
                          Text(
                            'Estimasi Margin/Profit:',
                            style: AppFonts.medium.copyWith(
                              color: const Color(0xFF166534),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            Formatter.toRupiahDouble(profit),
                            style: AppFonts.bold.copyWith(
                              color: const Color(0xFF16A34A),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF16A34A),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '+$profitPercent%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 4. Stock & Inventory Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.slate200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.inventory_2_outlined, color: AppColors.primaryDark, size: 18),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Stok Tersedia di Sales',
                              style: AppFonts.semiBold.copyWith(
                                color: AppColors.slate800,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              stock > 0 ? 'Siap dijual ke outlet mitra' : 'Stok habis, ajukan ke cabang',
                              style: AppFonts.regular.copyWith(
                                color: AppColors.slate400,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Stock badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: stock > 5
                            ? const Color(0xFFF0FDF4)
                            : (stock > 0 ? const Color(0xFFFFFBEB) : const Color(0xFFFEF2F2)),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: stock > 5
                              ? const Color(0xFFBBF7D0)
                              : (stock > 0 ? const Color(0xFFFDE68A) : const Color(0xFFFECACA)),
                        ),
                      ),
                      child: Text(
                        '$stock pcs',
                        style: TextStyle(
                          color: stock > 5
                              ? const Color(0xFF16A34A)
                              : (stock > 0 ? const Color(0xFFD97706) : const Color(0xFFDC2626)),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                if (inCartQty > 0) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.shopping_cart_checkout_rounded, size: 16, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          '$inCartQty pcs sudah ada di keranjang',
                          style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 5. Bottom Sticky Actions
  Widget _buildBottomActions(
    BuildContext context,
    ProductDetailViewModel model,
    Product product,
    CartViewModel cart,
    int stock,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
        border: const Border(
          top: BorderSide(color: Color(0xFFF1F5F9), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Button Retur Stok ke Cabang
            OutlinedButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  builder: (context) {
                    return AnimatedBuilder(
                      animation: model,
                      builder: (_, __) => _buildBottomSheet(context, model, product),
                    );
                  },
                );
              },
              icon: const Icon(Icons.assignment_return_outlined, size: 18, color: AppColors.slate700),
              label: Text(
                'Retur Cabang',
                style: AppFonts.semiBold.copyWith(color: AppColors.slate800, fontSize: 13),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                side: const BorderSide(color: AppColors.slate300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                backgroundColor: AppColors.slate50,
              ),
            ),
            const SizedBox(width: 12),

            // Button Tambah ke Keranjang
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: stock > 0 ? AppColors.amberGradient : null,
                  color: stock <= 0 ? AppColors.slate200 : null,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: stock > 0
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: ElevatedButton.icon(
                  onPressed: stock > 0
                      ? () {
                          cart.addProduct(product);
                          CustomSnackbar.showSuccess(
                            context,
                            'Berhasil menambahkan ${product.name} ke keranjang',
                          );
                        }
                      : null,
                  icon: const Icon(Icons.add_shopping_cart_rounded, color: Colors.white, size: 18),
                  label: Text(
                    stock > 0 ? '+ Tambah Keranjang' : 'Stok Habis',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Modernized Bottom Sheet for Retur Stok
  Widget _buildBottomSheet(BuildContext context, ProductDetailViewModel model, Product product) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Grab handle
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.slate300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.assignment_return_rounded, color: Color(0xFFD97706), size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kembalikan Stok ke Cabang',
                        style: AppFonts.semiBold.copyWith(color: AppColors.slate900, fontSize: 16),
                      ),
                      Text(
                        'Retur ${product.name ?? ''}',
                        style: AppFonts.regular.copyWith(color: AppColors.slate500, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Stock info banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.slate50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.slate200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Maksimal retur (stok Anda):',
                    style: TextStyle(color: AppColors.slate600, fontSize: 12),
                  ),
                  Text(
                    '${product.quantity ?? 0} pcs',
                    style: const TextStyle(
                      color: AppColors.slate900,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: model.stockController,
              keyboardType: TextInputType.number,
              label: 'Jumlah Stok yang Dikembalikan',
              hintText: 'Contoh: 2',
              onChanged: model.updateStock,
              errorText: model.stockError,
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: model.notesController,
              textInputAction: TextInputAction.done,
              label: 'Alasan / Catatan Retur',
              hintText: 'Contoh: Stok berlebih atau mendekati masa tenggang',
            ),
            const SizedBox(height: 24),

            Button.filled(
              onPressed: model.isFormValid
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
              label: 'Konfirmasi Retur ke Cabang',
              isLoading: model.isBusy,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/assets/assets.gen.dart';
import 'package:sales_app/core/utils/formatter.dart';
import 'package:sales_app/features/cart/cart_view_model.dart';
import 'package:sales_app/features/checkout/checkout_view.dart';
import 'package:sales_app/ui/shared/custom_appbar.dart';
import 'package:sales_app/ui/shared/custom_button.dart';
import 'package:sales_app/ui/shared/custom_dialog.dart';
import 'package:sales_app/ui/theme/app_colors.dart';
import 'package:sales_app/ui/theme/app_fonts.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

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
    final cart = Provider.of<CartViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Keranjang Penjualan',
        actions: [
          if (cart.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined, color: AppColors.error),
              tooltip: 'Kosongkan Keranjang',
              onPressed: () async {
                final confirm = await CustomConfirmationDialog.show(
                  context,
                  icon: Icons.delete_sweep_rounded,
                  iconColor: AppColors.error,
                  iconBgColor: const Color(0xFFFEE2E2),
                  title: 'Kosongkan Keranjang?',
                  message:
                      'Semua produk yang telah Anda pilih akan dihapus dari daftar pesanan penjualan.',
                  confirmLabel: 'Ya, Kosongkan',
                  cancelLabel: 'Batal',
                  isDestructive: true,
                );
                if (confirm == true) {
                  cart.clearCart();
                }
              },
            ),
          const SizedBox(width: 8.0),
        ],
      ),
      body: _buildBody(context, cart),
      bottomNavigationBar: _buildBottom(context, cart),
    );
  }

  Widget _buildBody(BuildContext context, CartViewModel cart) {
    if (cart.items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.shopping_cart_outlined, size: 48, color: AppColors.primary),
              ),
              const SizedBox(height: 20),
              Text(
                'Keranjang Belanja Kosong',
                style: AppFonts.semiBold.copyWith(color: AppColors.slate800, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Pilih produk dari katalog untuk mulai transaksi penjualan saat kunjungan ke outlet.',
                textAlign: TextAlign.center,
                style: AppFonts.regular.copyWith(
                  color: AppColors.slate500,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Button.filled(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.storefront_outlined, size: 18, color: Colors.white),
                label: 'Kembali ke Katalog',
                width: 220,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: cart.items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final cartItem = cart.items.values.toList()[index];
        final product = cartItem.product;
        final provColor = _getProviderColor(product.provider);

        return Container(
          padding: const EdgeInsets.all(14),
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
              // Product Thumbnail
              Container(
                width: 64,
                height: 64,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.slate50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.slate200),
                ),
                child: Assets.images.imageProduct.image(fit: BoxFit.contain),
              ),
              const SizedBox(width: 14),

              // Product Info & Stepper
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Provider & Name
                    Row(
                      children: [
                        if (product.provider != null && product.provider!.isNotEmpty) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: provColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              product.provider!,
                              style: TextStyle(
                                color: provColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                        Expanded(
                          child: Text(
                            product.name ?? '',
                            style: AppFonts.semiBold.copyWith(
                              color: AppColors.slate900,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Kuota / Category info
                    Text(
                      '${product.category ?? "Voucher"} ${product.kuota != null ? "• ${product.kuota}" : ""}',
                      style: AppFonts.regular.copyWith(color: AppColors.slate500, fontSize: 11),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),

                    // Price & Stepper Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Formatter.toRupiahDouble(
                                (product.sellingPrice ?? 0) * cartItem.quantity,
                              ),
                              style: AppFonts.bold.copyWith(color: AppColors.primary, fontSize: 15),
                            ),
                            Text(
                              '${Formatter.toRupiahDouble(product.sellingPrice ?? 0)} / pcs',
                              style: AppFonts.regular.copyWith(
                                color: AppColors.slate400,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),

                        // Quantity Stepper
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.slate50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.slate200),
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () => cart.removeProduct(product.id!),
                                borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(10),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  child: const Icon(
                                    Icons.remove_rounded,
                                    size: 18,
                                    color: AppColors.slate700,
                                  ),
                                ),
                              ),
                              Container(
                                constraints: const BoxConstraints(minWidth: 32),
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  '${cartItem.quantity}',
                                  textAlign: TextAlign.center,
                                  style: AppFonts.bold.copyWith(
                                    color: AppColors.slate900,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (cartItem.quantity < (product.quantity ?? 999)) {
                                    cart.addProduct(product);
                                  }
                                },
                                borderRadius: const BorderRadius.horizontal(
                                  right: Radius.circular(10),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  child: Icon(
                                    Icons.add_rounded,
                                    size: 18,
                                    color:
                                        cartItem.quantity < (product.quantity ?? 999)
                                            ? AppColors.primary
                                            : AppColors.slate300,
                                  ),
                                ),
                              ),
                            ],
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
    );
  }

  Widget _buildBottom(BuildContext context, CartViewModel cart) {
    if (cart.items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
        border: const Border(top: BorderSide(color: Color(0xFFF1F5F9), width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total (${cart.totalItems} item)',
                    style: AppFonts.medium.copyWith(color: AppColors.slate500, fontSize: 12),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    Formatter.toRupiahDouble(cart.totalPrice),
                    style: AppFonts.bold.copyWith(color: AppColors.slate900, fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Button.filled(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => CheckoutView(
                            cartItems: cart.items.values.toList(),
                            totalPrice: cart.totalPrice,
                          ),
                    ),
                  );
                },
                label: 'Lanjut Checkout',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

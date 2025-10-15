import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/assets/assets.gen.dart';
import 'package:sales_app/core/utils/formatter.dart';
import 'package:sales_app/features/cart/cart_view_model.dart';
import 'package:sales_app/features/checkout/checkout_view.dart';
import 'package:sales_app/ui/shared/custom_appbar.dart';
import 'package:sales_app/ui/shared/custom_button.dart';
import 'package:sales_app/ui/theme/app_colors.dart';
import 'package:sales_app/ui/theme/app_fonts.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Cart'),
      backgroundColor: AppColors.white,
      body: _buildBody(context),
      bottomNavigationBar: _buildBottom(context),
    );
  }
}

Widget _buildBody(BuildContext context) {
  final cart = Provider.of<CartViewModel>(context);
  if (cart.items.isEmpty) {
    return Center(
      child: Text(
        'Belum ada keranjang',
        style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 14),
      ),
    );
  }

  return ListView.separated(
    padding: const EdgeInsets.all(16),
    itemCount: cart.items.length,
    separatorBuilder: (_, __) => const SizedBox(height: 12),
    itemBuilder: (context, index) {
      final cartItem = cart.items.values.toList()[index];
      final product = cartItem.product;
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.gray),
        ),
        child: Row(
          children: [
            Assets.images.imageProduct.image(width: 60, height: 60),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? '',
                    style: AppFonts.semiBold.copyWith(color: AppColors.black, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    product.provider ?? '-',
                    style: AppFonts.medium.copyWith(
                      color: AppColors.black,
                      fontSize: 12,
                      height: 1.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    product.category ?? '-',
                    style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    product.kuota ?? '-',
                    style: AppFonts.medium.copyWith(
                      color: AppColors.black,
                      fontSize: 10,
                      height: 1.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Formatter.toRupiahDouble(product.sellingPrice ?? 0),
                            style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 14),
                          ),
                          Text(
                            'Sisa stok: ${product.quantity ?? 0}',
                            style: AppFonts.regular.copyWith(
                              color: AppColors.black.withValues(alpha: 0.5),
                              fontSize: 10,
                              height: 1.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              cart.removeProduct(product.id!);
                            },
                            child: Assets.svg.iconMin.svg(),
                          ),
                          SizedBox(
                            width: 48,
                            child: TextField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              controller: TextEditingController(text: cartItem.quantity.toString())
                                ..selection = TextSelection.fromPosition(
                                  TextPosition(offset: cartItem.quantity.toString().length),
                                ),
                              onChanged: (value) {
                                int qty = int.tryParse(value) ?? 1;
                                if (qty < 1) qty = 1;

                                // update state langsung
                                cart.updateQuantity(product.id!, qty);
                              },
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 8),
                              ),
                              style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 14),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              cart.addProduct(product);
                            },
                            child: Assets.svg.iconAdd.svg(),
                          ),
                        ],
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

Widget _buildBottom(BuildContext context) {
  final cart = Provider.of<CartViewModel>(context);

  if (cart.items.isEmpty) {
    return SizedBox.shrink();
  }

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: const BoxDecoration(
      color: AppColors.white,
      border: Border(top: BorderSide(color: AppColors.gray)),
    ),
    child: IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total',
                  style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 14),
                ),
                Text(
                  Formatter.toRupiahDouble(cart.totalPrice),
                  style: AppFonts.semiBold.copyWith(
                    color: AppColors.black,
                    fontSize: 16,
                    height: 0.8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 32.0),
          Expanded(
            child: Button.filled(
              onPressed:
                  cart.items.isEmpty
                      ? null
                      : () {
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
              label: 'Continue',
            ),
          ),
        ],
      ),
    ),
  );
}

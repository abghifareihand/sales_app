import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/api/outlet_api.dart';
import 'package:sales_app/core/api/transaction_api.dart';
import 'package:sales_app/core/assets/assets.gen.dart';
import 'package:sales_app/core/utils/formatter.dart';
import 'package:sales_app/features/base_view.dart';
import 'package:sales_app/features/cart/cart_view_model.dart';
import 'package:sales_app/features/checkout/checkout_view_model.dart';
import 'package:sales_app/features/home/home_view.dart';
import 'package:sales_app/ui/shared/custom_appbar.dart';
import 'package:sales_app/ui/shared/custom_button.dart';
import 'package:sales_app/ui/shared/custom_dropdown.dart';
import 'package:sales_app/ui/shared/custom_snackbar.dart';
import 'package:sales_app/ui/theme/app_colors.dart';
import 'package:sales_app/ui/theme/app_fonts.dart';

class CheckoutView extends StatelessWidget {
  final List<CartItem> cartItems;
  final double totalPrice;
  const CheckoutView({
    super.key,
    required this.cartItems,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return BaseView<CheckoutViewModel>(
      model: CheckoutViewModel(
        outletApi: Provider.of<OutletApi>(context),
        transactionApi: Provider.of<TransactionApi>(context),
        cartItems: cartItems,
      ),
      onModelReady: (CheckoutViewModel model) => model.initModel(),
      onModelDispose: (CheckoutViewModel model) => model.disposeModel(),
      builder: (BuildContext context, CheckoutViewModel model, _) {
        return Scaffold(
          appBar: CustomAppBar(title: 'Checkout'),
          backgroundColor: AppColors.white,
          body: _buildBody(context, model, cartItems),
          bottomNavigationBar: _buildBottom(context, model, totalPrice),
        );
      },
    );
  }
}

Widget _buildBody(
  BuildContext context,
  CheckoutViewModel model,
  List<CartItem> cartItems,
) {
  if (model.isBusy) {
    return Center(child: CircularProgressIndicator());
  }
  return ListView(
    padding: EdgeInsets.all(24),
    children: [
      CustomDropdown<int>(
        label: 'Pilih Outlet',
        hintText: 'Pilih Outlet',
        value: model.selectedOutlet?.id, // int
        items: model.outlets.map((e) => e.id!).toList(), // list int
        itemLabels: model.outlets.map((e) => e.nameOutlet ?? '-').toList(),
        onChanged: (int? newValue) {
          if (newValue != null) {
            final selected = model.outlets.firstWhere((e) => e.id == newValue);
            model.selectOutlet(selected);
          }
        },
      ),
      const SizedBox(height: 16.0),
      Text(
        'Total Product',
        style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 14),
      ),
      const SizedBox(height: 8.0),
      ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: cartItems.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = cartItems[index];
          // return ListTile(
          //   title: Text(item.product.name!),
          //   subtitle: Text('Harga: ${item.product.sellingPrice}'),
          //   trailing: Text('Qty: ${item.quantity}'),
          // );

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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.name ?? '',
                      style: AppFonts.semiBold.copyWith(
                        color: AppColors.black,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      Formatter.toRupiahDouble(item.product.sellingPrice ?? 0),
                      style: AppFonts.medium.copyWith(
                        color: AppColors.black,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Qty : ${item.quantity}',
                      style: AppFonts.medium.copyWith(
                        color: AppColors.black,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    ],
  );
}

Widget _buildBottom(
  BuildContext context,
  CheckoutViewModel model,
  double totalPrice,
) {
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
                  style: AppFonts.medium.copyWith(
                    color: AppColors.black,
                    fontSize: 14,
                  ),
                ),
                Text(
                  Formatter.toRupiahDouble(totalPrice),
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
                  model.selectedOutlet == null
                      ? null
                      : () async {
                        final cartViewModel = Provider.of<CartViewModel>(
                          context,
                          listen: false,
                        );
                        await model.addTransaction(cartViewModel);
                        if (context.mounted) {
                          if (model.error) {
                            CustomSnackbar.showError(context, model.message);
                          }
                          if (model.success) {
                            CustomSnackbar.showSuccess(context, model.message);
                            cartViewModel.clearCart();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const HomeView(),
                              ),
                              (route) => false,
                            );
                          }
                        }
                      },
              label: 'Checkout',
            ),
          ),
        ],
      ),
    ),
  );
}

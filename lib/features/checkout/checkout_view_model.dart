import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';
import 'package:sales_app/core/api/outlet_api.dart';
import 'package:sales_app/core/api/transaction_api.dart';
import 'package:sales_app/core/models/api_model.dart';
import 'package:sales_app/core/models/outlet_model.dart';
import 'package:sales_app/core/models/transaction_model.dart';
import 'package:sales_app/features/base_view_model.dart';
import 'package:sales_app/features/cart/cart_view_model.dart';

class CheckoutViewModel extends BaseViewModel {
  CheckoutViewModel({
    required this.outletApi,
    required this.transactionApi,
    required this.cartItems,
  });

  final OutletApi outletApi;
  final TransactionApi transactionApi;
  final List<CartItem> cartItems;

  List<Outlet> outlets = [];

  Outlet? selectedOutlet;

  @override
  Future<void> initModel() async {
    setBusy(true);
    await fetchOutlets();
    super.initModel();
    setBusy(false);
  }

  @override
  Future<void> disposeModel() async {
    super.disposeModel();
  }

  void selectOutlet(Outlet outlet) {
    selectedOutlet = outlet;
    notifyListeners();
  }

  Future<void> fetchOutlets() async {
    setBusy(true);
    try {
      final HttpResponse<OutletResponse> response = await outletApi.outlets();
      if (response.response.statusCode == 200) {
        outlets = response.data.outlets;
      }
    } on DioException catch (e) {
      final apiResponse = ApiResponse.fromJson(e.response!.data);
      setError(apiResponse.message);
    }
    setBusy(false);
  }

  Future<void> addTransaction(CartViewModel cartViewModel) async {
    setBusy(true);
    try {
      final HttpResponse<ApiResponse> response = await transactionApi
          .addTransaction(
            request: AddTransactionRequest(
              outletId: selectedOutlet!.id!,
              latitude: '-6.32028',
              longitude: '106.8032367',
              items:
                  cartItems
                      .map(
                        (e) => TransactionItemRequest(
                          productId: e.product.id!,
                          quantity: e.quantity,
                        ),
                      )
                      .toList(),
            ),
          );
      if (response.response.statusCode == 200) {
        final addTransactionResponse = response.data;
        setSuccess(addTransactionResponse.message);
    
      }
      setBusy(false);
    } on DioException catch (e) {
      final apiResponse = ApiResponse.fromJson(e.response!.data);
      setError(apiResponse.message);
      setBusy(false);
    }
  }
}

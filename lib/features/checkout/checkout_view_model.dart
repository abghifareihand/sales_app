import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';
import 'package:sales_app/core/api/outlet_api.dart';
import 'package:sales_app/core/api/transaction_api.dart';
import 'package:sales_app/core/models/api_model.dart';
import 'package:sales_app/core/models/outlet_model.dart';
import 'package:sales_app/core/models/transaction_model.dart';
import 'package:sales_app/features/base_view_model.dart';
import 'package:sales_app/features/cart/cart_view_model.dart';
import 'package:geolocator/geolocator.dart';

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

  // Minimal radius untuk checkout (meter)
  final double minDistanceMeters = 500;

  Outlet? selectedOutlet;
  double? userLatitude;
  double? userLongitude;
  String? distanceError;

  bool get isCheckoutEnabled => selectedOutlet != null && distanceError == null;

  @override
  Future<void> initModel() async {
    setBusy(true);
    await fetchOutlets();
    await fetchCurrentLocation();
    super.initModel();
    setBusy(false);
  }

  @override
  Future<void> disposeModel() async {
    super.disposeModel();
  }

  void selectOutlet(Outlet outlet) {
    selectedOutlet = outlet;
    validateDistance();
  }

  Future<void> fetchCurrentLocation() async {
    setBusy(true);
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      userLatitude = position.latitude;
      userLongitude = position.longitude;
      notifyListeners();
    } catch (e) {
      setError('Gagal mendapatkan lokasi: $e');
    }
    setBusy(false);
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

  void validateDistance() {
    if (selectedOutlet != null &&
        userLatitude != null &&
        userLongitude != null) {
      // convert string ke double
      final outletLat = double.tryParse(selectedOutlet!.latitude ?? '0') ?? 0;
      final outletLng = double.tryParse(selectedOutlet!.longitude ?? '0') ?? 0;

      final double distance = Geolocator.distanceBetween(
        userLatitude!,
        userLongitude!,
        outletLat,
        outletLng,
      );

      if (distance > minDistanceMeters) {
        distanceError = 'Lokasi kamu terlalu jauh dengan outlet';
      } else {
        distanceError = null;
      }
      notifyListeners();
    }
  }

  Future<void> addTransaction(CartViewModel cartViewModel) async {
    setBusy(true);
    try {
      final HttpResponse<ApiResponse> response = await transactionApi
          .addTransaction(
            request: AddTransactionRequest(
              outletId: selectedOutlet!.id!,
              latitude: userLatitude.toString(),
              longitude: userLongitude.toString(),
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



import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sales_app/core/api/product_api.dart';
import 'package:sales_app/core/models/api_model.dart';
import 'package:sales_app/core/models/product_model.dart';
import 'package:sales_app/features/base_view_model.dart';

class ProductViewModel extends BaseViewModel {
  ProductViewModel({required this.productApi});
  final ProductApi productApi;

  List<Product> products = [];

  @override
  Future<void> initModel() async {
    setBusy(true);
    await fetchProducts();
    super.initModel();
    setBusy(false);
  }

  @override
  Future<void> disposeModel() async {
    super.disposeModel();
  }

  Future<void> fetchProducts() async {
    setBusy(true);
    try {
      final HttpResponse<ProductResponse> response = await productApi.products();
      if (response.response.statusCode == 200) {
        products = response.data.products;
      }
    } on DioException catch (e) {
      final apiResponse = ApiResponse.fromJson(e.response!.data);
      setError(apiResponse.message);
    }
    setBusy(false);
  }
}
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sales_app/core/api/product_api.dart';
import 'package:sales_app/core/models/api_model.dart';
import 'package:sales_app/core/models/product_model.dart';
import 'package:sales_app/features/base_view_model.dart';

class ProductViewModel extends BaseViewModel {
  ProductViewModel({required this.productApi});
  final ProductApi productApi;

  final TextEditingController searchController = TextEditingController();

  List<Product> products = [];
  Timer? _debounce;

  @override
  Future<void> initModel() async {
    setBusy(true);
    await fetchProducts(); // load awal tanpa search
    super.initModel();
    setBusy(false);
  }

  @override
  Future<void> disposeModel() async {
    _debounce?.cancel();
    super.disposeModel();
  }

  /// Fungsi biasa untuk ambil produk
  Future<void> fetchProducts({String? search}) async {
    setBusy(true);
    try {
      final HttpResponse<ProductResponse> response = await productApi.products(search);
      if (response.response.statusCode == 200) {
        products = response.data.products;
      }
    } on DioException catch (e) {
      final apiResponse = ApiResponse.fromJson(e.response!.data);
      setError(apiResponse.message);
    }
    setBusy(false);
  }

  /// Fungsi versi debounced
  void onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchProducts(search: query.isEmpty ? null : query);
    });
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sales_app/core/api/product_api.dart';
import 'package:sales_app/core/models/api_model.dart';
import 'package:sales_app/core/models/product_model.dart';
import 'package:sales_app/core/models/return_stock_model.dart';
import 'package:sales_app/features/base_view_model.dart';

class ProductDetailViewModel extends BaseViewModel {
  ProductDetailViewModel({required this.product, required this.productApi});
  final ProductApi productApi;
  final Product product;

  final TextEditingController stockController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  String stock = '';
  String notes = '';
  String? stockError;
  String? notesError;

  @override
  Future<void> initModel() async {
    setBusy(true);
    super.initModel();
    setBusy(false);
  }

  @override
  Future<void> disposeModel() async {
    super.disposeModel();
  }

  void updateStock(String value) {
    stock = value;
    stockError = stock.isEmpty ? 'Stock tidak boleh kosong' : null;
    notifyListeners();
  }

  void updateNotes(String value) {
    notes = value;
    notesError = notes.isEmpty ? 'Catatan tidak boleh kosong' : null;
    notifyListeners();
  }

  bool get isFormValid => stock.isNotEmpty;

  Future<void> returnStock() async {
    setBusy(true);
    try {
      final HttpResponse<ApiResponse> response = await productApi.returnStock(
        request: ReturnStockRequest(
          stockId: product.stockId ?? 0,
          quantity: int.tryParse(stock) ?? 0,
          notes: notesController.text,
        ),
      );
      if (response.response.statusCode == 200) {
        final addOutletResponse = response.data;
        setSuccess(addOutletResponse.message);
      }
    } on DioException catch (e) {
      final apiResponse = ApiResponse.fromJson(e.response!.data);
      setError(apiResponse.message);
      setBusy(false);
    }
  }
}



import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sales_app/core/api/transaction_api.dart';
import 'package:sales_app/core/models/api_model.dart';
import 'package:sales_app/core/models/transaction_model.dart';
import 'package:sales_app/features/base_view_model.dart';

class TransactionViewModel extends BaseViewModel {
  TransactionViewModel({required this.transactionApi});

  final TransactionApi transactionApi;
  List<Transaction> transactions = [];


  @override
  Future<void> initModel() async {
    setBusy(true);
    await fetchTransaction();
    super.initModel();
    setBusy(false);
  }

  @override
  Future<void> disposeModel() async {
    super.disposeModel();
  }

  Future<void> fetchTransaction() async {
    setBusy(true);
    try {
      final HttpResponse<TransactionResponse> response = await transactionApi.transaction();
      if (response.response.statusCode == 200) {
        transactions = response.data.transactions;
      }
    } on DioException catch (e) {
      final apiResponse = ApiResponse.fromJson(e.response!.data);
      setError(apiResponse.message);
    }
    setBusy(false);
  }
}
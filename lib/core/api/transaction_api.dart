import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sales_app/core/models/api_model.dart';
import 'package:sales_app/core/models/add_transaction_model.dart';
import 'package:sales_app/core/models/transaction_model.dart';
import 'package:sales_app/core/models/transaction_summary_model.dart';

part 'transaction_api.g.dart';

@RestApi()
abstract class TransactionApi {
  factory TransactionApi(Dio dio, {String baseUrl}) = _TransactionApi;

  @POST('/api/transactions')
  Future<HttpResponse<ApiResponse>> addTransaction({
    @Body() required AddTransactionRequest request,
  });

  @GET('/api/transactions')
  Future<HttpResponse<TransactionResponse>> transaction();

  @GET('/api/transactions/summary')
  Future<HttpResponse<TransactionSummaryResponse>> transactionSummary();
}

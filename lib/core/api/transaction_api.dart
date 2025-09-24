import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sales_app/core/models/api_model.dart';
import 'package:sales_app/core/models/transaction_model.dart';

part 'transaction_api.g.dart';

@RestApi()
abstract class TransactionApi {
  factory TransactionApi(Dio dio, {String baseUrl}) = _TransactionApi;

  @POST('/api/transactions')
  Future<HttpResponse<ApiResponse>> addTransaction({
    @Body() required AddTransactionRequest request,
  });
}

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sales_app/core/models/history_model.dart';

part 'history_api.g.dart';

@RestApi()
abstract class HistoryApi {
  factory HistoryApi(Dio dio, {String baseUrl}) = _HistoryApi;

  @GET('/api/history')
  Future<HttpResponse<HistoryResponse>> history();

}

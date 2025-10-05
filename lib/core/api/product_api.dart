import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sales_app/core/models/api_model.dart';
import 'package:sales_app/core/models/product_model.dart';
import 'package:sales_app/core/models/return_stock_model.dart';

part 'product_api.g.dart';

@RestApi()
abstract class ProductApi {
  factory ProductApi(Dio dio, {String baseUrl}) = _ProductApi;

  @GET('/api/products')
  Future<HttpResponse<ProductResponse>> products();

  @POST('/api/products/return-stock')
  Future<HttpResponse<ApiResponse>> returnStock({
    @Body() required ReturnStockRequest request,
  });
}

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sales_app/core/models/add_outlet_model.dart';
import 'package:sales_app/core/models/outlet_model.dart';

part 'outlet_api.g.dart';

@RestApi()
abstract class OutletApi {
  factory OutletApi(Dio dio, {String baseUrl}) = _OutletApi;

  @GET('/api/outlets')
  Future<HttpResponse<OutletResponse>> outlets(
    @Query('search') String? search, 
  );

  @POST('/api/outlets')
  Future<HttpResponse<AddOutletResponse>> addOutlet({
    @Body() required AddOutletRequest request,
  });
}

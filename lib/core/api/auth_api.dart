import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sales_app/core/models/login_model.dart';
import 'package:sales_app/core/models/profile_model.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  @POST('/api/login')
  Future<HttpResponse<LoginResponse>> login({
    @Body() required LoginRequest request,
  });

  @GET('/api/profile')
  Future<HttpResponse<ProfileResponse>> profile();
}

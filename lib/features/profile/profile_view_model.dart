import 'package:sales_app/core/api/auth_api.dart';
import 'package:sales_app/core/models/api_model.dart';
import 'package:sales_app/core/models/profile_model.dart';
import 'package:sales_app/core/services/pref_service.dart';
import 'package:sales_app/features/base_view_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

class ProfileViewModel extends BaseViewModel {
  ProfileViewModel({required this.authApi});
  final AuthApi authApi;
  final PrefService _prefService = PrefService();

  String name = '';
  String role = '';
  User? user;

  @override
  Future<void> initModel() async {
    setBusy(true);
    await fetchProfile();
    super.initModel();
    setBusy(false);
  }

  @override
  Future<void> disposeModel() async {
    super.disposeModel();
  }

  Future<void> fetchProfile() async {
    setBusy(true);
    try {
      final HttpResponse<ProfileResponse> response = await authApi.profile();
      if (response.response.statusCode == 200) {
        final profileResponse = response.data.user;
        user = profileResponse;
      }
    } on DioException catch (e) {
      final apiResponse = ApiResponse.fromJson(e.response!.data);
      setError(apiResponse.message);
    }
    setBusy(false);
  }

  Future<void> logout() async {
    setBusy(true);
    try {
      final HttpResponse<ApiResponse> response = await authApi.logout();
      if (response.response.statusCode == 200) {
        final loginResponse = response.data;
        await _prefService.removeAll();
        setSuccess(loginResponse.message);
      }
    } on DioException catch (e) {
      final apiResponse = ApiResponse.fromJson(e.response!.data);
      setError(apiResponse.message);
      setBusy(false);
    }
  }
}

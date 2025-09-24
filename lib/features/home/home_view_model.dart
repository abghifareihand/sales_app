import 'package:sales_app/core/api/auth_api.dart';
import 'package:sales_app/core/models/api_model.dart';
import 'package:sales_app/core/models/profile_model.dart';
import 'package:sales_app/features/base_view_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel({required this.authApi});
  final AuthApi authApi;

  String name = '';
  String branchName = '';
  String branchAddress = '';

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
    try {
      final HttpResponse<ProfileResponse> response = await authApi.profile();
      if (response.response.statusCode == 200) {
        final profileResponse = response.data.user;
        name = profileResponse?.name ?? '';
        branchName = profileResponse?.branchName ?? '';
        branchAddress = profileResponse?.branchAddress ?? '';
      }
    } on DioException catch (e) {
      final apiResponse = ApiResponse.fromJson(e.response!.data);
      setError(apiResponse.message);
    }
    setBusy(false);
  }
}

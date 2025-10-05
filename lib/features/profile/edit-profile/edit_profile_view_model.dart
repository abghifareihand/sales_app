import 'package:sales_app/core/api/auth_api.dart';
import 'package:sales_app/core/models/api_model.dart';
import 'package:sales_app/core/models/profile_model.dart';
import 'package:sales_app/core/models/update_profile_model.dart';
import 'package:sales_app/features/base_view_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:retrofit/retrofit.dart';

class EditProfileViewModel extends BaseViewModel {
  EditProfileViewModel({required this.user, required this.authApi});
  final AuthApi authApi;
  final User user;

  late TextEditingController nameController;
  String name = '';
  String? nameError;

  late TextEditingController usernameController;
  String username = '';
  String? usernameError;

  late TextEditingController branchController;
  String branch = '';
  String? branchError;

  @override
  Future<void> initModel() async {
    setBusy(true);
    fetchUserData(user);
    super.initModel();
    setBusy(false);
  }

  @override
  Future<void> disposeModel() async {
    nameController.dispose();
    usernameController.dispose();
    branchController.dispose();
    super.disposeModel();
  }

  void updateName(String value) {
    name = value;
    nameError = name.isEmpty ? 'Nama tidak boleh kosong' : null;
    notifyListeners();
  }

  void updateUsername(String value) {
    username = value;
    usernameError = username.isEmpty ? 'Username tidak boleh kosong' : null;
    notifyListeners();
  }


  bool get isFormValid => name.isNotEmpty && username.isNotEmpty;

  void fetchUserData(User user) {
    // isi controller
    nameController = TextEditingController(text: user.name);
    usernameController = TextEditingController(text: user.username);
    branchController = TextEditingController(text: user.branchName);

    // isi variabel model juga
    name = user.name ?? '';
    username = user.username ?? '';
    branch = user.branchName ?? '';
  }

  Future<void> saveProfile() async {
    setBusy(true);
    try {
      final HttpResponse<ApiResponse> response = await authApi.updateProfile(
        request: UpdateProfileRequest(
          name: name,
          username: username,
        ),
      );

      if (response.response.statusCode == 200) {
        setSuccess(response.data.message);
      }
    } on DioException catch (e) {
      final apiResponse = ApiResponse.fromJson(e.response?.data);
      setError(apiResponse.message);
    }
    setBusy(false);
  }
}

import 'package:sales_app/core/api/auth_api.dart';
import 'package:sales_app/core/models/api_model.dart';
import 'package:sales_app/core/models/update_password_model.dart';
import 'package:sales_app/features/base_view_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:retrofit/retrofit.dart';

class EditPasswordViewModel extends BaseViewModel {
  EditPasswordViewModel({required this.authApi});
  final AuthApi authApi;

  final TextEditingController currentPasswordController = TextEditingController();
  String currentPassword = '';
  String? currentPasswordError;

  final TextEditingController newPasswordController = TextEditingController();
  String newPassword = '';
  String? newPasswordError;

  final TextEditingController newPasswordConfirmationController = TextEditingController();
  String newPasswordConfirmation = '';
  String? newPasswordConfirmationError;

  @override
  Future<void> initModel() async {
    setBusy(true);
    super.initModel();
    setBusy(false);
  }

  @override
  Future<void> disposeModel() async {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    newPasswordConfirmationController.dispose();
    super.disposeModel();
  }

  void updateCurrentPassword(String value) {
    currentPassword = value;
    if (currentPassword.isEmpty) {
      currentPasswordError = 'Password tidak boleh kosong';
    } else if (currentPassword.length < 6) {
      currentPasswordError = 'Password minimal 6 karakter';
    } else {
      currentPasswordError = null;
    }
    notifyListeners();
  }

  void updateNewPassword(String value) {
    newPassword = value;
    if (newPassword.isEmpty) {
      newPasswordError = 'Password baru tidak boleh kosong';
    } else if (newPassword.length < 6) {
      newPasswordError = 'Password baru minimal 6 karakter';
    } else {
      newPasswordError = null;
    }

    // Re-cek konfirmasi kalau user ubah password baru
    if (newPasswordConfirmation.isNotEmpty) {
      updateNewPasswordConfirmation(newPasswordConfirmation);
    }

    notifyListeners();
  }

  void updateNewPasswordConfirmation(String value) {
    newPasswordConfirmation = value;
    if (newPasswordConfirmation.isEmpty) {
      newPasswordConfirmationError = 'Konfirmasi password tidak boleh kosong';
    } else if (newPasswordConfirmation != newPassword) {
      newPasswordConfirmationError = 'Konfirmasi password tidak sama';
    } else {
      newPasswordConfirmationError = null;
    }
    notifyListeners();
  }

  bool get isFormValid =>
      currentPasswordError == null &&
      newPasswordError == null &&
      newPasswordConfirmationError == null &&
      currentPassword.isNotEmpty &&
      newPassword.isNotEmpty &&
      newPasswordConfirmation.isNotEmpty;

  Future<void> savePassword() async {
    setBusy(true);
    try {
      final HttpResponse<ApiResponse> response = await authApi.updatePassword(
        request: UpdatePasswordRequest(
          currentPassword: currentPassword,
          newPassword: newPassword,
          newPasswordConfirmation: newPasswordConfirmation,
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

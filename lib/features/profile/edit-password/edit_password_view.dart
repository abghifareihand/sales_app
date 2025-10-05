import 'package:sales_app/core/api/auth_api.dart';
import 'package:sales_app/features/base_view.dart';
import 'package:sales_app/features/profile/edit-password/edit_password_view_model.dart';
import 'package:sales_app/ui/shared/custom_appbar.dart';
import 'package:sales_app/ui/shared/custom_button.dart';
import 'package:sales_app/ui/shared/custom_snackbar.dart';
import 'package:sales_app/ui/shared/custom_text_field.dart';
import 'package:sales_app/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditPasswordView extends StatelessWidget {
  const EditPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<EditPasswordViewModel>(
      model: EditPasswordViewModel(authApi: Provider.of<AuthApi>(context)),
      onModelReady: (EditPasswordViewModel model) => model.initModel(),
      onModelDispose: (EditPasswordViewModel model) => model.disposeModel(),
      builder: (BuildContext context, EditPasswordViewModel model, _) {
        return Scaffold(
          appBar: CustomAppBar(title: 'Ubah Password'),
          backgroundColor: AppColors.white,
          body: _buildBody(context, model),
        );
      },
    );
  }
}

Widget _buildBody(BuildContext context, EditPasswordViewModel model) {
  return ListView(
    padding: EdgeInsets.all(20),
    children: [
      CustomTextField(
        obscureText: true,
        controller: model.currentPasswordController,
        label: 'Password Saat Ini',
        hintText: 'Masukkan Password Saat Ini',
        onChanged: model.updateCurrentPassword,
        errorText: model.currentPasswordError,
      ),
      const SizedBox(height: 16.0),
      CustomTextField(
        obscureText: true,
        controller: model.newPasswordController,
        label: 'Password Baru',
        hintText: 'Masukkan Password Baru',
        onChanged: model.updateNewPassword,
        errorText: model.newPasswordError,
      ),
      const SizedBox(height: 16.0),
      CustomTextField(
        obscureText: true,
        controller: model.newPasswordConfirmationController,
        label: 'Konfirmasi Password Baru',
        hintText: 'Masukkan Konfirmasi Password Baru',
        onChanged: model.updateNewPasswordConfirmation,
        errorText: model.newPasswordConfirmationError,
      ),
      const SizedBox(height: 24.0),
      Button.filled(
        onPressed:
            model.isFormValid
                ? () async {
                  await model.savePassword();
                  if (context.mounted) {
                    if (model.error) {
                      CustomSnackbar.showError(context, model.message);
                    }
                    if (model.success) {
                      Navigator.pop(context);
                      CustomSnackbar.showSuccess(context, model.message);
                    }
                  }
                }
                : null,
        label: 'Simpan',
        isLoading: model.isBusy,
      ),
    ],
  );
}

import 'package:sales_app/core/api/auth_api.dart';
import 'package:sales_app/core/models/profile_model.dart';
import 'package:sales_app/features/base_view.dart';
import 'package:sales_app/features/profile/edit-profile/edit_profile_view_model.dart';
import 'package:sales_app/ui/shared/custom_appbar.dart';
import 'package:sales_app/ui/shared/custom_button.dart';
import 'package:sales_app/ui/shared/custom_snackbar.dart';
import 'package:sales_app/ui/shared/custom_text_field.dart';
import 'package:sales_app/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    return BaseView<EditProfileViewModel>(
      model: EditProfileViewModel(authApi: Provider.of<AuthApi>(context), user: user),
      onModelReady: (EditProfileViewModel model) => model.initModel(),
      onModelDispose: (EditProfileViewModel model) => model.disposeModel(),
      builder: (BuildContext context, EditProfileViewModel model, _) {
        return Scaffold(
          appBar: CustomAppBar(title: 'Informasi Akun'),
          backgroundColor: AppColors.white,
          body: _buildBody(context, model),
        );
      },
    );
  }
}

Widget _buildBody(BuildContext context, EditProfileViewModel model) {
  return ListView(
    padding: EdgeInsets.all(20),
    children: [
      CustomTextField(
        controller: model.nameController,
        textCapitalization: TextCapitalization.words,
        label: 'Nama',
        hintText: 'Masukkan Nama',
        onChanged: model.updateName,
        errorText: model.nameError,
      ),
      const SizedBox(height: 16.0),
      CustomTextField(
        controller: model.usernameController,
        label: 'Username',
        hintText: 'Masukkan Username',
        onChanged: model.updateUsername,
        errorText: model.usernameError,
      ),
      const SizedBox(height: 16.0),
      CustomTextField(
        controller: model.branchController,
        label: 'Cabang',
        hintText: 'Masukkan Cabang',
        readOnly: true,
      ),
      const SizedBox(height: 24.0),
      Button.filled(
        onPressed:
            model.isFormValid
                ? () async {
                  await model.saveProfile();
                  if (context.mounted) {
                    if (model.error) {
                      CustomSnackbar.showError(context, model.message);
                    }
                    if (model.success) {
                      Navigator.of(context).pop(true);
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

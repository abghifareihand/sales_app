import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/api/auth_api.dart';
import 'package:sales_app/features/base_view.dart';
import 'package:sales_app/features/profile/edit-password/edit_password_view_model.dart';
import 'package:sales_app/ui/shared/custom_appbar.dart';
import 'package:sales_app/ui/shared/custom_button.dart';
import 'package:sales_app/ui/shared/custom_snackbar.dart';
import 'package:sales_app/ui/shared/custom_text_field.dart';
import 'package:sales_app/ui/theme/app_colors.dart';
import 'package:sales_app/ui/theme/app_fonts.dart';

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
          backgroundColor: AppColors.background,
          appBar: const CustomAppBar(title: 'Ubah Password'),
          body: _buildBody(context, model),
        );
      },
    );
  }
}

Widget _buildBody(BuildContext context, EditPasswordViewModel model) {
  return ListView(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
    children: [
      // 1. Security Header Card
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFFFF7ED),
              const Color(0xFFFFEDD5).withValues(alpha: 0.5),
              AppColors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFFE8D6)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: AppColors.amberGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.shield_outlined, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Keamanan Akun',
                    style: AppFonts.bold.copyWith(color: AppColors.slate900, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Perbarui kata sandi Anda secara berkala agar akun sales tetap aman.',
                    style: AppFonts.regular.copyWith(color: AppColors.slate500, fontSize: 12, height: 1.35),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),

      // 2. Form Container Card
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.slate200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.password_rounded, color: AppColors.primaryDark, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'Form Ubah Kata Sandi',
                  style: AppFonts.bold.copyWith(color: AppColors.slate900, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 20),

            CustomTextField(
              obscureText: true,
              controller: model.currentPasswordController,
              label: 'Password Saat Ini',
              hintText: 'Masukkan Password Saat Ini',
              prefixIcon: const Icon(Icons.lock_clock_outlined, color: AppColors.slate400, size: 20),
              onChanged: model.updateCurrentPassword,
              errorText: model.currentPasswordError,
            ),
            const SizedBox(height: 16.0),

            CustomTextField(
              obscureText: true,
              controller: model.newPasswordController,
              label: 'Password Baru',
              hintText: 'Masukkan Password Baru',
              prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.slate400, size: 20),
              onChanged: model.updateNewPassword,
              errorText: model.newPasswordError,
            ),
            const SizedBox(height: 16.0),

            CustomTextField(
              obscureText: true,
              controller: model.newPasswordConfirmationController,
              label: 'Konfirmasi Password Baru',
              hintText: 'Ulangi Password Baru',
              prefixIcon: const Icon(Icons.verified_user_outlined, color: AppColors.slate400, size: 20),
              onChanged: model.updateNewPasswordConfirmation,
              errorText: model.newPasswordConfirmationError,
            ),
            const SizedBox(height: 14),

            // Hint advice
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.slate50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.slate200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.primaryDark),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Disarankan menggunakan minimal 8 karakter dengan perpaduan huruf besar, huruf kecil, dan angka.',
                      style: AppFonts.regular.copyWith(color: AppColors.slate600, fontSize: 11, height: 1.35),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            Button.filled(
              onPressed: model.isFormValid
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
              label: 'Perbarui Password',
              isLoading: model.isBusy,
            ),
          ],
        ),
      ),
    ],
  );
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/api/auth_api.dart';
import 'package:sales_app/core/models/profile_model.dart';
import 'package:sales_app/features/base_view.dart';
import 'package:sales_app/features/profile/edit-profile/edit_profile_view_model.dart';
import 'package:sales_app/ui/shared/custom_appbar.dart';
import 'package:sales_app/ui/shared/custom_button.dart';
import 'package:sales_app/ui/shared/custom_snackbar.dart';
import 'package:sales_app/ui/shared/custom_text_field.dart';
import 'package:sales_app/ui/theme/app_colors.dart';
import 'package:sales_app/ui/theme/app_fonts.dart';

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
          backgroundColor: AppColors.background,
          appBar: const CustomAppBar(title: 'Informasi Akun'),
          body: _buildBody(context, model, user),
        );
      },
    );
  }
}

Widget _buildBody(BuildContext context, EditProfileViewModel model, User user) {
  final initial = (user.name != null && user.name!.isNotEmpty)
      ? user.name![0].toUpperCase()
      : 'S';

  return ListView(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
    children: [
      // 1. Profile Header Card
      Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
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
        child: Column(
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                gradient: AppColors.amberGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              user.name ?? '-',
              style: AppFonts.bold.copyWith(color: AppColors.slate900, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.badge_outlined, size: 13, color: AppColors.primaryDark),
                  const SizedBox(width: 5),
                  Text(
                    '${user.role ?? "Sales"} • ${user.branchName ?? "Cabang"}',
                    style: const TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
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
                  child: const Icon(Icons.edit_note_rounded, color: AppColors.primaryDark, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'Data Diri Pengguna',
                  style: AppFonts.bold.copyWith(color: AppColors.slate900, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 20),

            CustomTextField(
              controller: model.nameController,
              textCapitalization: TextCapitalization.words,
              label: 'Nama Lengkap',
              hintText: 'Masukkan Nama Lengkap',
              prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.slate400, size: 20),
              onChanged: model.updateName,
              errorText: model.nameError,
            ),
            const SizedBox(height: 16.0),

            CustomTextField(
              controller: model.usernameController,
              label: 'Username',
              hintText: 'Masukkan Username',
              prefixIcon: const Icon(Icons.alternate_email_rounded, color: AppColors.slate400, size: 20),
              onChanged: model.updateUsername,
              errorText: model.usernameError,
            ),
            const SizedBox(height: 16.0),

            CustomTextField(
              controller: model.branchController,
              label: 'Cabang Penugasan',
              hintText: 'Masukkan Cabang',
              prefixIcon: const Icon(Icons.business_outlined, color: AppColors.slate400, size: 20),
              suffixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.slate400, size: 18),
              readOnly: true,
            ),
            const SizedBox(height: 6),
            const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Text(
                '*Penugasan cabang diatur langsung oleh Admin Pusat.',
                style: TextStyle(fontSize: 11, color: AppColors.slate400),
              ),
            ),
            const SizedBox(height: 24.0),

            Button.filled(
              onPressed: model.isFormValid
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
              label: 'Simpan Perubahan',
              isLoading: model.isBusy,
            ),
          ],
        ),
      ),
    ],
  );
}

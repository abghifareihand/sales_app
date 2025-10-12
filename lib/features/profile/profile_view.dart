import 'package:sales_app/core/api/auth_api.dart';
import 'package:sales_app/core/assets/assets.gen.dart';
import 'package:sales_app/core/models/profile_model.dart';
import 'package:sales_app/features/auth/login/login_view.dart';
import 'package:sales_app/features/base_view.dart';
import 'package:sales_app/features/profile/edit-password/edit_password_view.dart';
import 'package:sales_app/features/profile/edit-profile/edit_profile_view.dart';
import 'package:sales_app/features/profile/history/history_view.dart';
import 'package:sales_app/features/profile/profile_view_model.dart';
import 'package:sales_app/features/profile/setting-printer/setting_printer_view.dart';
import 'package:sales_app/ui/shared/custom_appbar.dart';
import 'package:sales_app/ui/shared/custom_button.dart';
import 'package:sales_app/ui/shared/custom_snackbar.dart';
import 'package:sales_app/ui/theme/app_colors.dart';
import 'package:sales_app/ui/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<ProfileViewModel>(
      model: ProfileViewModel(authApi: Provider.of<AuthApi>(context)),
      onModelReady: (ProfileViewModel model) => model.initModel(),
      onModelDispose: (ProfileViewModel model) => model.disposeModel(),
      builder: (BuildContext context, ProfileViewModel model, _) {
        return Scaffold(
          appBar: CustomAppBar(title: 'Akun'),
          backgroundColor: AppColors.white,
          body: _buildBody(context, model),
        );
      },
    );
  }
}

Widget _buildBody(BuildContext context, ProfileViewModel model) {
  return ListView(
    padding: EdgeInsets.all(20),
    children: [
      ProfileHeader(isLoading: model.isBusy, user: model.user),
      const SizedBox(height: 32.0),
      Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              color: AppColors.black.withValues(alpha: 0.05),
              blurRadius: 30.0,
              spreadRadius: 0,
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Akun',
              style: AppFonts.regular.copyWith(
                color: AppColors.black.withValues(alpha: 0.5),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8.0),
            profileMenu(
              icon: Icons.person,
              title: 'Informasi Akun',
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfileView(user: model.user!)),
                );
                if (result == true) {
                  await model.fetchProfile();
                }
              },
            ),
            const SizedBox(height: 16.0),
            profileMenu(
              icon: Icons.lock_outline,
              title: 'Ubah Password',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditPasswordView()),
                );
              },
            ),
            const SizedBox(height: 16.0),
            profileMenu(
              icon: Icons.receipt_long,
              title: 'History Produk',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryView()));
              },
            ),
            const SizedBox(height: 16.0),
            Text(
              'Printer',
              style: AppFonts.regular.copyWith(
                color: AppColors.black.withValues(alpha: 0.5),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8.0),
            profileMenu(
              icon: Icons.print,
              title: 'Setting Printer',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingPrinterView()),
                );
              },
            ),
          ],
        ),
      ),
      const SizedBox(height: 24.0),
      Button.filled(
        onPressed: () async {
          await model.logout();
          if (context.mounted) {
            if (model.error) {
              CustomSnackbar.showError(context, model.message);
            }
            if (model.success) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginView()),
                (route) => false,
              );
            }
          }
        },
        label: 'Logout',
        color: Colors.red,
        isLoading: model.isBusy,
      ),
    ],
  );
}

Widget profileMenu({
  required IconData icon,
  required String title,
  required VoidCallback onPressed,
}) {
  return InkWell(
    onTap: onPressed,
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: AppColors.primary.withValues(alpha: 0.1),
          ),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
        const SizedBox(width: 12.0),
        Text(title, style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 14)),
        const Spacer(),
        const Icon(Icons.chevron_right, color: AppColors.black),
      ],
    ),
  );
}

class ProfileHeader extends StatelessWidget {
  final bool isLoading;
  final User? user;

  const ProfileHeader({super.key, required this.isLoading, this.user});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildShimmer();
    }
    return _buildContent();
  }

  Widget _buildContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.svg.iconPerson.svg(width: 120, height: 120),
          const SizedBox(height: 8.0),
          Text(
            user?.name ?? '',
            style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 14),
          ),
          Text(
            user?.branchName ?? '',
            style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return Center(
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Container(width: 140, height: 16, color: Colors.white),
            const SizedBox(height: 6),
            Container(width: 80, height: 14, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

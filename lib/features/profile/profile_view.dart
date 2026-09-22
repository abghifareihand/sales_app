import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/api/auth_api.dart';
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
import 'package:sales_app/ui/shared/custom_dialog.dart';
import 'package:sales_app/ui/shared/custom_snackbar.dart';
import 'package:sales_app/ui/theme/app_colors.dart';
import 'package:sales_app/ui/theme/app_fonts.dart';
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
          backgroundColor: AppColors.surface,
          appBar: const CustomAppBar(title: 'Akun & Profil'),
          body: _buildBody(context, model),
        );
      },
    );
  }
}

Widget _buildBody(BuildContext context, ProfileViewModel model) {
  return ListView(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    children: [
      // ===== PROFILE CARD =====
      ProfileHeader(isLoading: model.isBusy, user: model.user),
      const SizedBox(height: 24.0),

      // ===== GROUP 1: AKUN & KEAMANAN =====
      Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.02),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'PENGATURAN AKUN',
                style: AppFonts.semiBold.copyWith(
                  color: AppColors.slateMuted,
                  fontSize: 11,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            _modernProfileTile(
              icon: Icons.person_outline_rounded,
              iconColor: AppColors.primaryDark,
              iconBg: AppColors.primarySurface,
              title: 'Informasi Profil',
              subtitle: 'Nama, username, dan info kontak',
              onPressed: () async {
                if (model.user == null) return;
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfileView(user: model.user!)),
                );
                if (result == true) {
                  await model.fetchProfile();
                }
              },
            ),
            const Divider(color: AppColors.borderLight, height: 1, indent: 64),
            _modernProfileTile(
              icon: Icons.lock_outline_rounded,
              iconColor: const Color(0xFF3B82F6),
              iconBg: const Color(0xFFEFF6FF),
              title: 'Ubah Kata Sandi',
              subtitle: 'Perbarui password akun Anda',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditPasswordView()),
                );
              },
            ),
            const Divider(color: AppColors.borderLight, height: 1, indent: 64),
            _modernProfileTile(
              icon: Icons.history_rounded,
              iconColor: const Color(0xFF10B981),
              iconBg: const Color(0xFFECFDF5),
              title: 'Riwayat Distribusi',
              subtitle: 'Stok yang diterima dari cabang',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryView()));
              },
            ),
          ],
        ),
      ),
      const SizedBox(height: 16.0),

      // ===== GROUP 2: PERANGKAT =====
      Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.02),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'PERANGKAT & HARDWARE',
                style: AppFonts.semiBold.copyWith(
                  color: AppColors.slateMuted,
                  fontSize: 11,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            _modernProfileTile(
              icon: Icons.print_outlined,
              iconColor: const Color(0xFF8B5CF6),
              iconBg: const Color(0xFFF5F3FF),
              title: 'Setting Printer Bluetooth',
              subtitle: 'Konfigurasi cetak struk nota POS',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingPrinterView()),
                );
              },
            ),
          ],
        ),
      ),
      const SizedBox(height: 24.0),

      // ===== LOGOUT BUTTON =====
      Button.outlined(
        height: 50,
        borderRadius: 14,
        sideColor: AppColors.red.withValues(alpha: 0.4),
        textColor: AppColors.red,
        color: AppColors.red.withValues(alpha: 0.05),
        icon: const Icon(Icons.logout_rounded, size: 18, color: AppColors.red),
        onPressed: () async {
          final confirm = await CustomConfirmationDialog.show(
            context,
            icon: Icons.logout_rounded,
            iconColor: const Color(0xFFDC2626),
            iconBgColor: const Color(0xFFFEE2E2),
            title: 'Konfirmasi Logout',
            message: 'Apakah Anda yakin ingin keluar dari akun ini? Sesi Anda saat ini akan diakhiri.',
            confirmLabel: 'Ya, Keluar Akun',
            cancelLabel: 'Batal',
            isDestructive: true,
          );

          if (confirm != true) return;

          await model.logout();
          if (context.mounted) {
            if (model.error) {
              CustomSnackbar.showError(context, model.message);
            }
            if (model.success) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
                (route) => false,
              );
            }
          }
        },
        label: 'Keluar dari Akun',
        isLoading: model.isBusy,
      ),
      const SizedBox(height: 20),
    ],
  );
}

Widget _modernProfileTile({
  required IconData icon,
  required Color iconColor,
  required Color iconBg,
  required String title,
  required String subtitle,
  required VoidCallback onPressed,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 14.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppFonts.semiBold.copyWith(
                      color: AppColors.dark,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppFonts.regular.copyWith(
                      color: AppColors.slateLight,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.slateMuted),
          ],
        ),
      ),
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
    final initial = (user?.name != null && user!.name!.isNotEmpty)
        ? user!.name!.substring(0, 1).toUpperCase()
        : 'S';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
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
                style: AppFonts.bold.copyWith(
                  color: AppColors.white,
                  fontSize: 28,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12.0),

          // Name
          Text(
            user?.name ?? 'Nama Sales',
            style: AppFonts.bold.copyWith(color: AppColors.dark, fontSize: 17),
          ),
          const SizedBox(height: 4.0),

          // Username & Role pill
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '@${user?.username ?? 'sales'}',
                style: AppFonts.medium.copyWith(color: AppColors.slateLight, fontSize: 12),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  (user?.role ?? 'SALES').toUpperCase(),
                  style: AppFonts.bold.copyWith(
                    color: AppColors.primaryDeep,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14.0),

          // Branch Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.business_rounded, color: AppColors.primaryDark, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.branchName ?? 'Cabang Belum Di-assign',
                        style: AppFonts.bold.copyWith(color: AppColors.dark, fontSize: 12),
                      ),
                      if (user?.branchAddress != null && user!.branchAddress!.isNotEmpty)
                        Text(
                          user!.branchAddress!,
                          style: AppFonts.regular.copyWith(color: AppColors.slateLight, fontSize: 10),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/api/auth_api.dart';
import 'package:sales_app/features/auth/login/login_view_model.dart';
import 'package:sales_app/features/base_view.dart';
import 'package:sales_app/features/home/home_view.dart';
import 'package:sales_app/ui/shared/app_logo.dart';
import 'package:sales_app/ui/shared/custom_button.dart';
import 'package:sales_app/ui/shared/custom_snackbar.dart';
import 'package:sales_app/ui/shared/custom_text_field.dart';
import 'package:sales_app/ui/theme/app_colors.dart';
import 'package:sales_app/ui/theme/app_fonts.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(
      model: LoginViewModel(authApi: Provider.of<AuthApi>(context)),
      onModelReady: (LoginViewModel model) => model.initModel(),
      onModelDispose: (LoginViewModel model) => model.disposeModel(),
      builder: (BuildContext context, LoginViewModel model, _) {
        return Scaffold(
          backgroundColor: AppColors.surface,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Badge status
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primarySurface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'FIELD SALES & POS',
                            style: AppFonts.semiBold.copyWith(
                              color: AppColors.primaryDeep,
                              fontSize: 11,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Logo & Brand
                    const AppLogo(size: 72),
                    const SizedBox(height: 28),

                    // Card Container
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border, width: 1.0),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withValues(alpha: 0.04),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat Datang',
                            style: AppFonts.bold.copyWith(
                              color: AppColors.dark,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Masuk dengan akun sales yang terdaftar',
                            style: AppFonts.regular.copyWith(
                              color: AppColors.slateLight,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 20),

                          CustomTextField(
                            controller: model.usernameController,
                            label: 'Username',
                            hintText: 'Contoh: sales',
                            prefixIcon: const Icon(
                              Icons.person_outline_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            onChanged: model.updateUsername,
                            errorText: model.usernameError,
                          ),
                          const SizedBox(height: 16),

                          CustomTextField(
                            controller: model.passwordController,
                            obscureText: true,
                            label: 'Password',
                            hintText: 'Masukkan kata sandi',
                            prefixIcon: const Icon(
                              Icons.lock_outline_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            textInputAction: TextInputAction.done,
                            onChanged: model.updatePassword,
                            errorText: model.passwordError,
                          ),
                          const SizedBox(height: 24),

                          Button.filled(
                            height: 50,
                            borderRadius: 14,
                            onPressed: model.isFormValid
                                ? () async {
                                    await model.login();
                                    if (context.mounted) {
                                      if (model.error) {
                                        CustomSnackbar.showError(context, model.message);
                                      }
                                      if (model.success) {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(builder: (_) => const HomeView()),
                                        );
                                      }
                                    }
                                  }
                                : null,
                            label: 'Masuk ke Akun',
                            suffixIcon: const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            isLoading: model.isBusy,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      'Nilwansyah • Multi-Branch System',
                      style: AppFonts.medium.copyWith(
                        color: AppColors.slateMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

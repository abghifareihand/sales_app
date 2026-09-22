import 'package:flutter/material.dart';
import 'package:sales_app/features/auth/login/login_view.dart';
import 'package:sales_app/features/auth/splash/splash_view_model.dart';
import 'package:sales_app/features/base_view.dart';
import 'package:sales_app/features/home/home_view.dart';
import 'package:sales_app/ui/shared/app_logo.dart';
import 'package:sales_app/ui/theme/app_colors.dart';
import 'package:sales_app/ui/theme/app_fonts.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<SplashViewModel>(
      model: SplashViewModel(),
      onModelReady: (SplashViewModel model) async {
        await model.initModel();

        if (context.mounted) {
          if (!model.hasPermission) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Permission lokasi dibutuhkan!')));
          }
          if (model.hasToken) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeView()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginView()),
            );
          }
        }
      },
      onModelDispose: (SplashViewModel model) => model.disposeModel(),
      builder: (BuildContext context, SplashViewModel model, _) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: AppColors.amberGradient,
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  // Center Branding
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Pill badge from web
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF34D399),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'MULTI-BRANCH MANAGEMENT',
                                style: AppFonts.semiBold.copyWith(
                                  color: Colors.white,
                                  fontSize: 10,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Logo on Radiant Amber Background
                        const AppLogo(size: 88, isLightOnDark: true),
                        const SizedBox(height: 40),

                        // Sleek White Spinner
                        const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom Slogan
                  Positioned(
                    bottom: 24,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Text(
                          'Efisien, Cepat & Akurat.',
                          style: AppFonts.semiBold.copyWith(
                            color: Colors.white,
                            fontSize: 13,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Enterprise Stock & POS System',
                          style: AppFonts.regular.copyWith(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

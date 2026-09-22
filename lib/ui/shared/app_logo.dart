import 'package:flutter/material.dart';
import 'package:sales_app/ui/theme/app_colors.dart';
import 'package:sales_app/ui/theme/app_fonts.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool isLightOnDark;

  const AppLogo({
    super.key,
    this.size = 64,
    this.showText = true,
    this.isLightOnDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final emblem = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: isLightOnDark
            ? null
            : const LinearGradient(
                colors: [Color(0xFFFFB269), Color(0xFFFF9F43), Color(0xFFD97706)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        color: isLightOnDark ? AppColors.white : null,
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [
          BoxShadow(
            color: (isLightOnDark ? AppColors.black : AppColors.primaryDark)
                .withValues(alpha: isLightOnDark ? 0.15 : 0.35),
            blurRadius: size * 0.35,
            offset: Offset(0, size * 0.15),
          ),
        ],
        border: Border.all(
          color: isLightOnDark
              ? AppColors.white.withValues(alpha: 0.9)
              : AppColors.white.withValues(alpha: 0.25),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Text(
          'SI',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: size * 0.44,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.0,
            color: isLightOnDark ? AppColors.primaryDark : AppColors.white,
          ),
        ),
      ),
    );

    if (!showText) return emblem;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        emblem,
        SizedBox(height: size * 0.2),
        Text(
          'SALES INVENTORY',
          style: AppFonts.bold.copyWith(
            fontSize: size * 0.26,
            letterSpacing: 1.2,
            color: isLightOnDark ? AppColors.white : AppColors.dark,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Enterprise Mobile POS',
          style: AppFonts.medium.copyWith(
            fontSize: size * 0.16,
            color: isLightOnDark
                ? AppColors.white.withValues(alpha: 0.8)
                : AppColors.slateLight,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sales_app/ui/theme/app_colors.dart';
import 'package:sales_app/ui/theme/app_fonts.dart';

enum ButtonStyleType { filled, outlined }

class Button extends StatelessWidget {
  const Button.filled({
    super.key,
    required this.onPressed,
    required this.label,
    this.style = ButtonStyleType.filled,
    this.color = AppColors.primary,
    this.gradient,
    this.sideColor = AppColors.primary,
    this.textColor = Colors.white,
    this.width = double.infinity,
    this.height = 48.0,
    this.borderRadius = 14.0,
    this.icon,
    this.suffixIcon,
    this.disabled = false,
    this.fontSize = 14.0,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.padding,
    this.isLoading = false,
  });

  const Button.outlined({
    super.key,
    required this.onPressed,
    required this.label,
    this.style = ButtonStyleType.outlined,
    this.color = Colors.white,
    this.gradient,
    this.textColor = AppColors.primary,
    this.sideColor = AppColors.primary,
    this.width = double.infinity,
    this.height = 48.0,
    this.borderRadius = 14.0,
    this.icon,
    this.suffixIcon,
    this.disabled = false,
    this.fontSize = 14.0,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.padding,
    this.isLoading = false,
  });

  final Function()? onPressed;
  final String label;
  final ButtonStyleType style;
  final Color color;
  final Gradient? gradient;
  final Color textColor;
  final Color sideColor;
  final double? width;
  final double height;
  final double borderRadius;
  final Widget? icon;
  final Widget? suffixIcon;
  final bool disabled;
  final double fontSize;
  final MainAxisAlignment mainAxisAlignment;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final content =
        isLoading
            ? SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.2, color: textColor),
            )
            : Row(
              mainAxisAlignment: mainAxisAlignment,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[icon!, const SizedBox(width: 8)],
                Flexible(
                  child: Text(
                    label,
                    style: AppFonts.semiBold.copyWith(color: textColor, fontSize: fontSize),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                if (suffixIcon != null) ...[const SizedBox(width: 8), suffixIcon!],
              ],
            );

    if (style == ButtonStyleType.outlined) {
      return SizedBox(
        height: height,
        width: width,
        child: OutlinedButton(
          onPressed: (isLoading || disabled) ? null : onPressed,
          style: OutlinedButton.styleFrom(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
            backgroundColor: color,
            side: BorderSide(color: disabled ? AppColors.border : sideColor, width: 1.2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
          ),
          child: content,
        ),
      );
    }

    // Filled / Gradient Button
    final isInteractive = !isLoading && !disabled && onPressed != null;
    final effectiveGradient =
        gradient ??
        (color == AppColors.primary
            ? (isInteractive
                ? AppColors.amberGradient
                : LinearGradient(
                  colors: [
                    const Color(0xFFB45309).withValues(alpha: 0.5),
                    const Color(0xFFFF9F43).withValues(alpha: 0.5),
                  ],
                ))
            : null);

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: effectiveGradient,
        color: effectiveGradient == null ? (disabled ? AppColors.border : color) : null,
        boxShadow:
            (isInteractive && color == AppColors.primary)
                ? [
                  BoxShadow(
                    color: const Color(0xFFB45309).withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ]
                : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: isInteractive ? onPressed : null,
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
            child: Center(child: content),
          ),
        ),
      ),
    );
  }
}

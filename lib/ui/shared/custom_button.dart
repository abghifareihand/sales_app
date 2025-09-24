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
    this.sideColor = AppColors.primary,
    this.textColor = Colors.white,
    this.width = double.infinity,
    this.height = 48.0,
    this.borderRadius = 12.0,
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
    this.textColor = AppColors.primary,
    this.sideColor = AppColors.primary,
    this.width = double.infinity,
    this.height = 48.0,
    this.borderRadius = 12.0,
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
    return SizedBox(
      height: height,
      width: width,
      child:
          style == ButtonStyleType.filled
              ? ElevatedButton(
                onPressed: isLoading ? null : onPressed,
                style: ElevatedButton.styleFrom(
                  padding: padding,
                  backgroundColor: color,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
                ),
                child:
                    isLoading
                        ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2, color: textColor),
                        )
                        : Text(
                          label,
                          style: AppFonts.semiBold.copyWith(color: textColor, fontSize: fontSize),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
              )
              : OutlinedButton(
                onPressed: isLoading ? null : onPressed,
                style: OutlinedButton.styleFrom(
                  padding: padding,
                  backgroundColor: color,
                  side: BorderSide(color: sideColor),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
                ),
                child:
                    isLoading
                        ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2, color: textColor),
                        )
                        : Text(
                          label,
                          style: AppFonts.semiBold.copyWith(color: textColor, fontSize: fontSize),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
              ),
    );
  }
}

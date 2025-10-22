import 'package:flutter/material.dart';
import 'package:sales_app/ui/theme/app_colors.dart';
import 'package:sales_app/ui/theme/app_fonts.dart';

class CustomSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String)? onChanged;

  const CustomSearchField({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      cursorColor: AppColors.primary,
      style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 14),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search, color: AppColors.gray),
        hintText: hintText,
        hintStyle: AppFonts.medium.copyWith(color: AppColors.gray, fontSize: 14),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: AppColors.gray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: AppColors.gray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}

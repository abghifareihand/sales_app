import 'package:flutter/material.dart';
import 'package:sales_app/ui/theme/app_colors.dart';
import 'package:sales_app/ui/theme/app_fonts.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final List<String> itemLabels;
  final String label;
  final String hintText;
  final bool showLabel;
  final ValueChanged<T?>? onChanged;
  final bool enabled;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.itemLabels,
    required this.label,
    required this.hintText,
    this.onChanged,
    this.showLabel = true,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) ...[
          Text(
            label,
            style: AppFonts.medium.copyWith(
              color: AppColors.black,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8.0),
        ],
        const SizedBox(height: 6.0),
        DropdownButtonFormField<T>(
          icon: const Icon(Icons.expand_more, color: AppColors.primary),
          dropdownColor: AppColors.white,
          value: items.contains(value) ? value : null,
          onChanged: enabled ? onChanged : null,
          hint: Text(
            hintText,
            style: AppFonts.medium.copyWith(
              color: AppColors.gray,
              fontSize: 14,
            ),
          ),
          items: List.generate(items.length, (index) {
            final label =
                index < itemLabels.length
                    ? itemLabels[index]
                    : items[index].toString();
            return DropdownMenuItem<T>(value: items[index], child: Text(label));
          }),
          style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 14),
          decoration: InputDecoration(
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
            hintText: value == null ? hintText : null,
            hintStyle: AppFonts.medium.copyWith(
              color: AppColors.gray,
              fontSize: 14,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 14,
            ),
          ),
        ),
      ],
    );
  }
}

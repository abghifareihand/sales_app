import 'package:flutter/material.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:sales_app/ui/theme/app_colors.dart';


class MenuPrinterContent extends StatelessWidget {
  final BluetoothInfo data;
  final bool isSelected;
  const MenuPrinterContent({
    super.key,
    required this.data,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      decoration: BoxDecoration(
        border: Border.all(
            width: isSelected ? 4.0 : 1.0,
            color: isSelected ? AppColors.primary : AppColors.gray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Name : ${data.name}',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'macAddress: ${data.macAdress}',
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

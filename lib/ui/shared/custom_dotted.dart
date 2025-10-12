import 'package:flutter/material.dart';

class DottedDivider extends StatelessWidget {
  final double height;
  final double dashWidth;
  final Color color;

  const DottedDivider({
    super.key,
    this.height = 1,
    this.dashWidth = 4,
    this.color = Colors.black26,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dashCount = (constraints.maxWidth / (2 * dashWidth)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: height,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}
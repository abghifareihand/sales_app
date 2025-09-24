import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerName extends StatelessWidget {
  final double width;
  final double height;
  final bool isLoading;
  final String? text;
  final TextStyle? style;

  const ShimmerName({
    super.key,
    required this.width,
    required this.height,
    required this.isLoading,
    this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          width: width,
          height: height,
          color: Colors.white,
        ),
      );
    } else {
      return Text(
        text ?? '',
        style: style,
      );
    }
  }
}

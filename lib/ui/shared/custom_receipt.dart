import 'dart:math';
import 'package:flutter/material.dart';

class ClipShadowPath extends StatelessWidget {
  const ClipShadowPath({
    super.key,
    required this.shadow,
    required this.clipper,
    required this.child,
  });

  final Shadow shadow;
  final CustomClipper<Path> clipper;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ClipShadowShadowPainter(
        clipper: clipper,
        shadow: shadow,
      ),
      child: ClipPath(clipper: clipper, child: child),
    );
  }
}

class _ClipShadowShadowPainter extends CustomPainter {
  _ClipShadowShadowPainter({required this.shadow, required this.clipper});

  final Shadow shadow;
  final CustomClipper<Path> clipper;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = shadow.toPaint();
    final Path clipPath = clipper.getClip(size).shift(shadow.offset);
    canvas.drawPath(clipPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ReceiptClipper extends CustomClipper<Path> {
  final double arcOnSize = 18;
  final double arcOffSize = 8;

  @override
  Path getClip(Size size) {
    final Path path = Path();
    if (size.width <= 0 || size.height <= 0) {
      return path;
    }
    final int totalPair = size.width ~/ (arcOnSize + arcOffSize);
    final double padding = size.width - ((totalPair * (arcOnSize + arcOffSize)) - arcOffSize);
    final double start = padding / 2;
    path
      ..lineTo(start, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width - start, size.height);

    for (double i = size.width - start; i > start; i -= arcOnSize + arcOffSize) {
      final Rect rect = Rect.fromLTWH(i - arcOnSize, size.height - 0.5 * arcOnSize, arcOnSize, arcOnSize);
      path.arcTo(rect, 2 * pi, -pi, false);
    }
    path
      ..lineTo(0, size.height)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

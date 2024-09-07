import 'package:flutter/material.dart';
import 'dart:math';

class Ring extends StatelessWidget {
  final Color outerColor;
  final Color innerColor;
  final int amount;
  final int goal;
  final double size;
  final double minInnerSize;

  const Ring({
    Key key,
     this.outerColor,
     this.innerColor,
     this.amount,
     this.goal,
    this.size = 200,
    this.minInnerSize = 0.1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _RingPainter(
            outerColor: outerColor,
            innerColor: innerColor,
            amount: amount,
            goal: goal,
            minInnerSize: minInnerSize,
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final Color outerColor;
  final Color innerColor;
  final int amount;
  final int goal;
  final double minInnerSize;

  _RingPainter({
     this.outerColor,
     this.innerColor,
     this.amount,
     this.goal,
     this.minInnerSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Calculate the progress
    double progress = (amount / goal).clamp(0.0, 1.0);
    
    // Apply minimum inner size only when amount is greater than zero
    double innerRadius;
    if (amount > 0) {
      innerRadius = radius * max(progress, minInnerSize);
    } else {
      innerRadius = 0;
    }

    // Draw outer circle (ring)
    final outerPaint = Paint()
      ..color = outerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius - innerRadius;
    
    canvas.drawCircle(center, radius - (radius - innerRadius) / 2, outerPaint);

    // Draw inner circle only if it's not transparent and has a radius greater than zero
    if (innerColor != Colors.transparent && innerRadius > 0) {
      final innerPaint = Paint()
        ..color = innerColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, innerRadius, innerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
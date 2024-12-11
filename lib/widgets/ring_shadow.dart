import 'package:flutter/material.dart';

class ShadowRing extends StatelessWidget {
  final double internalDiameter;
  final double ringWidth;
  final Color color;

  const ShadowRing({
    Key key,
    this.internalDiameter,
    this.ringWidth,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        // height: 0.0,
        child: CustomPaint(
          painter: RingPainter(internalDiameter, ringWidth, color),
          // child: Container(
          //   color: ,
          // ),
        ),
      ),
    );
  }
}

class RingPainter extends CustomPainter {
  double _internalDiameter;
  double _ringWidth;
  Color color;

  RingPainter(this._internalDiameter, this._ringWidth, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _ringWidth
      ..strokeCap = StrokeCap.round;

    // canvas.drawCircle(
    //     Offset(size.width / 2, size.height / 2), _internalDiameter / 2, paint);

    var outerDiameter = _internalDiameter + _ringWidth;
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), outerDiameter / 2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

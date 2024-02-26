import 'package:flutter/material.dart';

class Ring extends StatelessWidget {
  final Color color;
  final Color color1;
  final int amount;
  final int goal;

  const Ring({this.color, this.color1, this.amount, this.goal});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        // height: 0.0,
        child: CustomPaint(
          painter: _RingPainter(
            color: color,
            color1: color1,
            amount: amount,
            goal: goal,
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final Color color;
  final Color color1;
  final int amount;
  final int goal;

  _RingPainter({
    this.color,
    this.color1,
    this.amount,
    this.goal,
  });

  double sw1 = 65.2;
  double firstRad = 31.0;
  double sw2 = 53.0;
  double secondRad = 90.0;

  double sw1ReducFac = 2.5;
  double firstRadIncFac = 1.233;

  double v1 = 5;
  double v2 = 2.5;

  double engSw1;
  double engFirstRad = 0;
  double engSw2;
  double engSecondRad = 0;

  num _firstRingPerc;
  num _scndRingPerc;

  // bool _showFirstRing;
  // bool _showSecondRing;

  _calcPrgrs(amount, goal, caller) {
    var val = amount * 100;
    var perc = val / goal;
    if (perc < 5) {
      if (caller == 0) return sw1;
      if (caller == 1) return firstRad;
    }
    _firstRingPerc = perc * 2;
    var step1 = (_firstRingPerc * 26.08) / 100;
    var step1b = (_firstRingPerc * 26.4) / 100;
    var step2 = step1 * sw1ReducFac;
    var step2b = step1b * firstRadIncFac;
    engSw1 = sw1 - step2;
    engFirstRad = firstRad + step2b;
    if (caller == 0) return engSw1;
    if (caller == 1) return engFirstRad;
  }

  _calcSecondPrgrs({amount, goal, caller}) {
    var _val = amount * 100;
    var _perc = _val / goal;
    if (_perc < 50) {
      if (caller == 0) return sw2;
      if (caller == 1) return secondRad;
    }
    var _temp = _perc - 50;
    _scndRingPerc = _temp * 2;
    var _step1 = (_scndRingPerc * 21.2) / 100;
    var _step1b = (_scndRingPerc * 20) / 100;
    var _step2 = _step1 * 2.5;
    var _step2b = _step1b * 1.25;
    engSw2 = sw2 - _step2;
    engSecondRad = secondRad + _step2b;
    if (caller == 0) return engSw2;
    if (caller == 1) return engSecondRad;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = _calcPrgrs(amount, goal, 0)
      ..style = PaintingStyle.stroke;

    final paint1 = Paint()
      ..color = color1
      ..strokeWidth = _calcSecondPrgrs(amount: amount, goal: goal, caller: 0)
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);

    if (engFirstRad < 63.0)
      canvas.drawCircle(center, _calcPrgrs(amount, goal, 1), paint);
    if (engSecondRad < 115)
      canvas.drawCircle(center,
          _calcSecondPrgrs(amount: amount, goal: goal, caller: 1), paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

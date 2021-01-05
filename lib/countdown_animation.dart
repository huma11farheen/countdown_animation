library countdown_animation;

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class CountDownAnimation extends StatefulWidget {
  final int totalDivisions;
  final CountController controller;
  final Alignment alignment;
  final Color progressColor;
  final Color backgroundColor;
  final Size size;
  final Widget child;
  final double strokeWidth;
  final EdgeInsetsGeometry padding;
  const CountDownAnimation({
    Key key,
    @required this.totalDivisions,
    @required this.controller,
    this.alignment = Alignment.center,
    this.progressColor = Colors.red,
    this.backgroundColor = Colors.grey,
    @required this.size,
    @required this.child,
    this.strokeWidth = 5.0,
    this.padding = EdgeInsets.zero,
  })  : assert(size != null),
        super(key: key);

  @override
  _CountDownAnimationState createState() => _CountDownAnimationState();
}

class _CountDownAnimationState extends State<CountDownAnimation>
    with TickerProviderStateMixin {
  AnimationController countDownAnimationController;
  double _percentage;
  double _nextPercentage;
  int _number;

  @override
  void dispose() {
    countDownAnimationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _number = widget.totalDivisions;
    super.initState();
    _percentage = 0.0;
    _nextPercentage = 0.0;
    _initAnimationController();
  }

  void _initAnimationController() {
    countDownAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addListener(
        () {
          setState(() {
            _percentage = lerpDouble(
              _percentage,
              _nextPercentage,
              countDownAnimationController.value,
            );
          });
        },
      );
  }

  Widget _countDownView() {
    return CustomPaint(
      child: Center(
        child: widget.child,
      ),
      foregroundPainter: _CountDownPainter(
        strokeWidth: widget.strokeWidth,
        defaultCircleColor: widget.backgroundColor,
        percentageCompletedCircleColor: widget.progressColor,
        completedPercentage: _percentage,
        number: _number,
      ),
    );
  }

  void _changeProgress(int number) {
    setState(() {
      _number = number;
      _percentage = _nextPercentage;

      _nextPercentage += 100 / widget.totalDivisions;
      if (_nextPercentage > 100.0) {
        _percentage = 0.0;
        _nextPercentage = 0.0;
      }
      countDownAnimationController.forward(from: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.controller?.addListener(_changeProgress);
    return Container(
      padding: widget.padding,
      alignment: widget.alignment,
      child: AnimatedBuilder(
        animation: countDownAnimationController,
        builder: (context, child) {
          return SizedBox.fromSize(
            size: widget.size,
            child: _countDownView(),
          );
        },
      ),
    );
  }
}

class _CountDownPainter extends CustomPainter {
  Color defaultCircleColor;
  Color percentageCompletedCircleColor;
  double completedPercentage;
  final double strokeWidth;

  int number;

  _CountDownPainter({
    @required this.strokeWidth,
    @required this.defaultCircleColor,
    @required this.percentageCompletedCircleColor,
    @required this.completedPercentage,
    @required this.number,
  });

  Paint getPaint(Color color) {
    return Paint()
      ..color = color
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final defaultCirclePaint = (number != 0)
        ? getPaint(defaultCircleColor)
        : getPaint(percentageCompletedCircleColor);
    final progressCirclePaint = getPaint(percentageCompletedCircleColor);
    final coverUpCirclePaint = getPaint(Colors.white);

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);

    canvas.drawCircle(center, radius, defaultCirclePaint);

    final arcAngle1 = 2 * pi * (completedPercentage / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      arcAngle1,
      false,
      coverUpCirclePaint,
    );

    final arcAngle2 = 2 * pi * (completedPercentage / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      arcAngle2,
      false,
      progressCirclePaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter painter) {
    return false;
  }
}

typedef CountListener = void Function(int count);

class CountController {
  CountListener _listener;

  void trigger(int number) {
    if (_listener != null) {
      _listener(number);
    }
  }

  void addListener(CountListener listener) {
    _listener = listener;
  }

  void dispose() {
    _listener = null;
  }
}

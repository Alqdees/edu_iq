// ignore_for_file: file_names
import 'package:flutter/material.dart';

class CircularProgressIndicatorButton extends StatelessWidget {
  final double progress;

  const CircularProgressIndicatorButton({required this.progress, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(60, 60), 
      painter: _CircularProgressIndicatorPainter(progress: progress),
      child: Container(
        width: 65,
        height: 65,
        alignment: Alignment.center,
        child: const Icon(Icons.arrow_forward_ios, color: Colors.blueGrey),
      ),
    );
  }
}

class _CircularProgressIndicatorPainter extends CustomPainter {
  final double progress;

  _CircularProgressIndicatorPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundCircle = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    Paint progressCircle = Paint()
      ..color = Colors.blueGrey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = (size.width / 2) - 5;

    canvas.drawCircle(center, radius, backgroundCircle);
    double arcAngle = 2 * 3.141592653589793 * progress;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        -3.141592653589793 / 2, arcAngle, false, progressCircle);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

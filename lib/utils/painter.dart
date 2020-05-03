import 'package:flutter/material.dart';

class ContainerPainter extends CustomPainter {
  final double tlFactor, trFactor, blFactor, brFactor;
  Color color;

  ContainerPainter(
      {@required this.color,
      @required this.tlFactor,
      @required this.trFactor,
      @required this.blFactor,
      @required this.brFactor});
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();
    Path mainBg = Path();
    mainBg.addRRect(RRect.fromLTRBAndCorners(
      0,
      0,
      width,
      height,
      topLeft: Radius.circular(width * tlFactor),
      topRight: Radius.circular(width * trFactor),
      bottomLeft: Radius.circular(width * blFactor),
      bottomRight: Radius.circular(width * brFactor),
    ));
    mainBg.close();
    paint.color = color;
    canvas.drawPath(mainBg, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

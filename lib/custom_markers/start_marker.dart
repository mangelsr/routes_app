part of 'custom_marker.dart';

class StartMarkerPainter extends CustomPainter {
  final double circleBackRadius = 20;
  final double circleWhiteRadius = 7;

  final int minutes;

  StartMarkerPainter(this.minutes);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.black;

    canvas.drawCircle(
      Offset(this.circleBackRadius, size.height - this.circleBackRadius),
      this.circleBackRadius,
      paint,
    );

    paint.color = Colors.white;
    canvas.drawCircle(
      Offset(this.circleBackRadius, size.height - this.circleBackRadius),
      this.circleWhiteRadius,
      paint,
    );

    // Drawing shadow
    final Path path = Path();
    path.moveTo(40, 20);
    path.lineTo(size.width - 10, 20);
    path.lineTo(size.width - 10, 100);
    path.lineTo(40, 100);
    canvas.drawShadow(path, Colors.black87, 10, false);

    // White box
    canvas.drawRect(Rect.fromLTWH(40, 20, size.width - 55, 80), paint);

    // Black box
    paint.color = Colors.black;
    canvas.drawRect(Rect.fromLTWH(40, 20, 70, 80), paint);

    // Draw text

    // minute number text
    TextSpan textSpan = TextSpan(
        style: TextStyle(
            color: Colors.white, fontSize: 30, fontWeight: FontWeight.w400),
        text: '$minutes');
    TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: 70, minWidth: 70);
    textPainter.paint(canvas, Offset(40, 35));

    // min
    textSpan = TextSpan(
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
        text: 'min');
    textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: 70, minWidth: 70);
    textPainter.paint(canvas, Offset(40, 67));

    // my location
    textSpan = TextSpan(
        style: TextStyle(
            color: Colors.black, fontSize: 22, fontWeight: FontWeight.w400),
        text: 'My location');
    textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: size.width - 130);
    textPainter.paint(canvas, Offset(160, 50));
  }

  @override
  bool shouldRepaint(StartMarkerPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(StartMarkerPainter oldDelegate) => false;
}

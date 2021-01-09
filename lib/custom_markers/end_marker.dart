part of 'custom_marker.dart';

class EndMarkerPainter extends CustomPainter {
  final double circleBackRadius = 20;
  final double circleWhiteRadius = 7;

  final String description;
  final double distance;

  EndMarkerPainter(this.description, this.distance);

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
    path.moveTo(0, 20);
    path.lineTo(size.width - 10, 20);
    path.lineTo(size.width - 10, 100);
    path.lineTo(0, 100);
    canvas.drawShadow(path, Colors.black87, 10, false);

    // White box
    canvas.drawRect(Rect.fromLTWH(0, 20, size.width - 10, 80), paint);

    // Black box
    paint.color = Colors.black;
    canvas.drawRect(Rect.fromLTWH(0, 20, 70, 80), paint);

    // Draw text

    // minute number text
    TextSpan textSpan = TextSpan(
        style: TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.w400),
        text: '$distance');
    TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: 70, minWidth: 70);
    textPainter.paint(canvas, Offset(0, 35));

    // Km
    textSpan = TextSpan(
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
        text: 'Km');
    textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: 70, minWidth: 70);
    textPainter.paint(canvas, Offset(0, 70));

    // my location
    textSpan = TextSpan(
        style: TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.w400,
        ),
        text: '$description');
    textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      maxLines: 2,
      ellipsis: '...',
    )..layout(minWidth: size.width - 10 - 70, maxWidth: size.width - 10 - 70);
    textPainter.paint(canvas, Offset(70, 30));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

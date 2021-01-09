part of 'helpers.dart';

Future<BitmapDescriptor> getStartMarkerIcon(int duration) async {
  final StartMarkerPainter startMarker =
      StartMarkerPainter((duration / 60).floor());
  return await _gettMarkerIcon(startMarker);
}

Future<BitmapDescriptor> getEndtMarkerIcon(
    String description, double distance) async {
  final EndMarkerPainter endtMarker = EndMarkerPainter(description, distance);
  return await _gettMarkerIcon(endtMarker);
}

Future<BitmapDescriptor> _gettMarkerIcon(CustomPainter customPainter) async {
  final ui.PictureRecorder recorder = ui.PictureRecorder();
  final ui.Canvas canvas = ui.Canvas(recorder);
  final ui.Size size = ui.Size(350, 150);
  customPainter.paint(canvas, size);
  final ui.Picture picture = recorder.endRecording();
  final ui.Image image =
      await picture.toImage(size.width.toInt(), size.height.toInt());
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.fromBytes(byteData.buffer.asUint8List());
}

import 'package:flutter/material.dart';
import 'package:routes_app/custom_markers/custom_marker.dart';

class TestMarkerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 350,
          height: 150,
          // color: Colors.red,
          child: CustomPaint(
            painter: EndMarkerPainter('Alamos de la Atarazana', 10.5),
          ),
        ),
      ),
    );
  }
}

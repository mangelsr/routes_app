import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:routes_app/helpers/helpers.dart';
import 'package:routes_app/pages/gps_access_page.dart';
import 'package:routes_app/pages/home_page.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (await Geolocator.isLocationServiceEnabled()) {
        Navigator.pushReplacementNamed(context, 'home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: this.checkGPSLocation(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Text(snapshot.data),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          }
        },
      ),
    );
  }

  Future checkGPSLocation(BuildContext context) async {
    final gpsPermission = await Permission.location.isGranted;
    final activeGps = await Geolocator.isLocationServiceEnabled();

    if (gpsPermission && activeGps) {
      Navigator.pushReplacement(context, fadeInNavigation(context, HomePage()));
      return '';
    } else if (!gpsPermission) {
      Navigator.pushReplacement(
          context, fadeInNavigation(context, GPSAccessPage()));
      return 'Give location access';
    } else {
      return 'Turn GPS on';
    }
  }
}

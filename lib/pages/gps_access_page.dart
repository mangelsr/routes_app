import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class GPSAccessPage extends StatefulWidget {
  @override
  _GPSAccessPageState createState() => _GPSAccessPageState();
}

class _GPSAccessPageState extends State<GPSAccessPage> with WidgetsBindingObserver {

  bool asking = false;

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
    if (state == AppLifecycleState.resumed && !asking) {
      if (await Permission.location.isGranted) {
        Navigator.pushReplacementNamed(context, 'loading');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('GPS is mandatory for the app'),
            MaterialButton(
              child: Text(
                'Solicitar Acceso',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              shape: StadiumBorder(),
              elevation: 0,
              color: Colors.black,
              splashColor: Colors.transparent,
              onPressed: () async {
                asking = true;
                final status = await  Permission.location.request();
                await this.gpsAccess(status);
                asking = false;
              }
            )
          ],
        ),
      ),
    );
  }

  Future gpsAccess(PermissionStatus status) async {
    switch (status) {
      case PermissionStatus.granted:
        await Navigator.pushReplacementNamed(context, 'loading');
        break;
      case PermissionStatus.undetermined:
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
        openAppSettings();
        break;
    }
  }
}

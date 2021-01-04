part of 'helpers.dart';

void loadingAler(BuildContext context) {
  if (Platform.isAndroid) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Please wait'),
        content: Text('Loading route'),
      ),
    );
  } else {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text('Please wait'),
              content: CupertinoActivityIndicator(),
            ));
  }
}

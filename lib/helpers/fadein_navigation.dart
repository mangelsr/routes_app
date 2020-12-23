part of 'helpers.dart';

fadeInNavigation(BuildContext context, Widget page) {
  return PageRouteBuilder(
    pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) =>
        page,
    transitionDuration: Duration(milliseconds: 300),
    transitionsBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation, Widget child) =>
        FadeTransition(
      child: child,
      opacity: Tween<double>(begin: 0.0, end: 1.0)
          .animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
    ),
  );
}

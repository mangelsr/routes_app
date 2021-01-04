part of 'widgets.dart';

class FollowLocationBtn extends StatelessWidget {
  const FollowLocationBtn({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapBloc = context.watch<MapBloc>();

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
            icon: Icon(
              mapBloc.state.followLocation
                  ? Icons.directions_run
                  : Icons.accessibility_new,
              color: Colors.black87,
            ),
            onPressed: () {
              mapBloc.add(OnToggleFollow());
            }),
      ),
    );
  }
}

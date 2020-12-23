part of 'widgets.dart';

class LocationBtn extends StatelessWidget {
  const LocationBtn({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final mapBloc = context.watch<MapBloc>();
    final myLocationBloc = context.watch<MyLocationBloc>();

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
            icon: Icon(
              Icons.my_location,
              color: Colors.black87,
            ),
            onPressed: () {
              final destiny = myLocationBloc.state.location;
              mapBloc.moveCamera(destiny);
            }
          ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:overheard_flutter_app/constants/colorset.dart';
import 'package:overheard_flutter_app/constants/fontsizeset.dart';
import 'package:overheard_flutter_app/constants/stringset.dart';
import 'package:overheard_flutter_app/ui/feed/bloc/feed.bloc.dart';
import 'package:overheard_flutter_app/ui/feed/bloc/feed.event.dart';
import 'package:overheard_flutter_app/ui/feed/repository/feed.repository.dart';

import 'bloc/feed.state.dart';

class LocationScreen extends StatefulWidget {
  Position position;
  LocationScreen({required this.position});
  @override
  State<LocationScreen> createState() => LocationScreenState();
}

class LocationScreenState extends State<LocationScreen> {

  // final _key = GlobalKey<GoogleMapStateBase>();
  late FeedBloc feedBloc;

  @override
  void initState(){
    super.initState();
    feedBloc = new FeedBloc(feedRepository: FeedRepository());
  }

  @override
  Widget build(BuildContext context) {
    // GeoCoord currentLocation = widget.position != null ? GeoCoord(widget.position.latitude, widget.position.longitude) : GeoCoord(40.688841, -74.044015);

    return new BlocListener(
      bloc: feedBloc,
      listener: (context, state){
        if(state is FeedLocationGetDoneState){
          // double lat = currentLocation.latitude;
          // double lng = currentLocation.longitude;
          // Navigator.of(context).pop({
          //   'location': 'Location($lat, $lng)',
          //   'lat': currentLocation.latitude.toString(),
          //   'lng': currentLocation.longitude.toString()
          // });
        }
      },
      child: Scaffold(
        appBar: CupertinoNavigationBar(
          middle: Text(
            locationPickerAppBarTitle,
            style: TextStyle(
                fontSize: appBarTitleFontSize,
                color: primaryWhiteTextColor
            ),
            textScaleFactor: 1.0,
          )
        ),
        body: Stack(
          children: [
            // GoogleMap(
            //   key: _key,
            //   onTap: (location) async {
            //     GoogleMap.of(_key).clearMarkers();
            //     setState(() {
            //       widget.position = Position.fromMap({
            //         'latitude': location.latitude,
            //         'longitude': location.longitude
            //       });
            //       currentLocation = location;
            //       GoogleMap.of(_key).addMarker(Marker(currentLocation));
            //     });
            //   },
            //   initialZoom: 12,
            //   initialPosition: currentLocation,
            //   mapType: MapType.terrain,
            //   markers: {
            //     Marker(currentLocation)
            //   },
            // ),
            BlocBuilder<FeedBloc, FeedState>(
              bloc: feedBloc,
              builder: (context, state){
                return GestureDetector(
                  onTap: (){
                    // Navigator.of(context).pop({
                    //   'lat': currentLocation.latitude.toString(),
                    //   'lng': currentLocation.longitude.toString()
                    // });
                    //feedBloc..add(GetLocationEvent(lat: currentLocation.latitude, lng: currentLocation.longitude));
                  },
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 40,
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: gradientEnd,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: 1,
                            color: primaryWhiteTextColor
                        ),
                      ),
                      child: Center(
                        child: Text(
                          SaveButtonText,
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              color: primaryWhiteTextColor,
                              fontSize: primaryButtonFontSize
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
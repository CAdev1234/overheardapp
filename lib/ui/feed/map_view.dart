import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:overheard/constants/colorset.dart';
import 'package:overheard/constants/fontsizeset.dart';
import 'package:overheard/constants/stringset.dart';
import 'package:overheard/ui/feed/bloc/feed_bloc.dart';
// import 'package:overheard/ui/feed/bloc/feed.event.dart';
import 'package:overheard/ui/feed/repository/feed.repository.dart';
import 'package:overheard/utils/ui_elements.dart';

import 'bloc/feed_state.dart';
import 'bloc/feed_event.dart';

class LocationScreen extends StatefulWidget {
  Position position;
  double zoomVal = 14.4746;
  LocationScreen({Key? key, required this.position}) : super(key: key);
  @override
  State<LocationScreen> createState() => LocationScreenState();
}

class LocationScreenState extends State<LocationScreen> {

  // final _key = GlobalKey<GoogleMapStateBase>();
  late FeedBloc feedBloc;
  Completer<GoogleMapController> _mapController = Completer();
  late Set<Marker> _currentMarker;
  late CameraPosition _currentLocation;

  @override
  void initState(){
    super.initState();
    feedBloc = FeedBloc(feedRepository: FeedRepository());
  }

  @override
  Widget build(BuildContext context) {
    // GeoCoord currentLocation = widget.position != null ? GeoCoord(widget.position.latitude, widget.position.longitude) : GeoCoord(40.688841, -74.044015);
    CameraPosition _currentLocation = CameraPosition(
      target: widget.position != null ? LatLng(widget.position.latitude, widget.position.longitude) : const LatLng(40.688841, -74.044015),
      zoom: widget.zoomVal,
    );
    _currentMarker = <Marker>{Marker(markerId: const MarkerId('current_marker'), position: _currentLocation.target)};
    return BlocListener(
      bloc: feedBloc,
      listener: (context, state){
        if(state is FeedLocationGetDoneState){
          double lat = _currentLocation.target.latitude;
          double lng = _currentLocation.target.longitude;
          Navigator.of(context).pop({
            'location': 'Location($lat, $lng)',
            'lat': lat.toString(),
            'lng': lng.toString()
          });
        }else if (state is FeedLocationGetFailState) {
          showToast(locationPickErrorText, gradientEnd, gravity: ToastGravity.CENTER);
          return;
        }
      },
      child: Scaffold(
        appBar: const CupertinoNavigationBar(
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
            GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: _currentLocation,
              onMapCreated: (GoogleMapController controller) {
                _mapController.complete(controller);
              },
              compassEnabled: true,
              markers: _currentMarker,
              onTap: (loc) async {
                setState(() {
                  widget.position = Position.fromMap({
                    'latitude': loc.latitude,
                    'longitude': loc.longitude
                  });
                  _currentLocation = CameraPosition(
                    target: loc,
                    zoom: widget.zoomVal,
                  );
                  _currentMarker = <Marker>{Marker(markerId: MarkerId(GlobalKey().toString()), position: loc)};
                });
              },

            ),
            BlocBuilder<FeedBloc, FeedState>(
              bloc: feedBloc,
              builder: (context, state){
                return GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop({
                      'lat': _currentLocation.target.latitude.toString(),
                      'lng': _currentLocation.target.longitude.toString()
                    });
                    feedBloc.add(GetLocationEvent(lat: _currentLocation.target.latitude, lng: _currentLocation.target.longitude));
                  },
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 40,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: gradientEnd,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: 1,
                            color: primaryWhiteTextColor
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          saveButtonText,
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

  @override
  void dispose() {
    super.dispose();
  }
}
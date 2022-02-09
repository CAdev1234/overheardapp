import 'dart:async';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:overheard_flutter_app/constants/colorset.dart';
import 'package:overheard_flutter_app/constants/fontsizeset.dart';
import 'package:overheard_flutter_app/constants/numericalset.dart';
import 'package:overheard_flutter_app/constants/stringset.dart';
import 'package:overheard_flutter_app/ui/community/bloc/community.bloc.dart';
import 'package:overheard_flutter_app/ui/community/bloc/community.event.dart';
import 'package:overheard_flutter_app/ui/community/bloc/community.state.dart';
import 'package:overheard_flutter_app/ui/community/models/community_model.dart';
import 'package:overheard_flutter_app/ui/community/repository/community.repository.dart';
import 'package:overheard_flutter_app/ui/community/submit_community.dart';
import 'package:overheard_flutter_app/ui/components/pagination.dart';
import 'package:overheard_flutter_app/ui/home/bloc/home.bloc.dart';
import 'package:overheard_flutter_app/ui/home/home.dart';
import 'package:overheard_flutter_app/ui/home/repository/home.repository.dart';
import 'package:overheard_flutter_app/utils/ui_elements.dart';
import 'package:location/location.dart';

class CommunityScreen extends StatefulWidget{
  @override
  CommunityScreenState createState() {
    return new CommunityScreenState();
  }

}

class CommunityScreenState extends State<CommunityScreen>{

  late CommunityBloc communityBloc;
  late TextEditingController searchController;
  late BuildContext context;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Timer timer;

  Set<Marker> markers = Set();
  late BitmapDescriptor pinLocationIcon;
  late BitmapDescriptor pinSelectedLocationIcon;

  @override
  void initState(){
    super.initState();
    setCustomMapPin();
    communityBloc = new CommunityBloc(communityRepository: CommunityRepository());
    communityBloc..add(FetchCommunityEvent());
    searchController = new TextEditingController();
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/community_marker.png');
    pinSelectedLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/community_marker_selected.png');
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return BlocListener(
      bloc: communityBloc,
      listener: (context, state){
        if(state is CommunityDoneState) {
          markers.clear();
          communityBloc.fetchedCommunities.forEach((community) {
            markers.add(
                Marker(
                  markerId: MarkerId(community.name as String),
                  position: LatLng(community.lat as double, community.lng as double),
                  infoWindow: InfoWindow(
                    title: community.name,
                    snippet: "Lat: ${community.lat}, Lng: ${community.lng}"
                  ),
                  icon: pinLocationIcon,
                  onTap: () {
                    setState(() {
                      communityBloc.joinedCommunity = community.id;
                      updateMarkers(communityBloc.joinedCommunity as int);
                    });
                  }
                )
            );
          });
        }
        else if(state is CommunityConfirmedState){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BlocProvider(
            create: (context) => HomeBloc(homeRepository: HomeRepository()),
            child: HomeScreen(),
          )));
        }
        else if(state is CommunityConfirmFailedState){
          showToast(communityConfirmFailedText, gradientStart, gravity: ToastGravity.CENTER);
        }
      },
      child: Container(
        decoration: primaryBoxDecoration,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: CupertinoNavigationBar(
            middle: Text(
              nearestCommunityAppBarTitle,
              style: TextStyle(
                  fontSize: appBarTitleFontSize,
                  color: primaryWhiteTextColor
              ),
              textScaleFactor: 1.0,
            ),
            trailing: GestureDetector(
              onTap: (){
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BlocProvider(
                  create: (context) => HomeBloc(homeRepository: HomeRepository()),
                  child: HomeScreen(),
                )));
              },
              child: Container(
                width: 50,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    SkipButtonText,
                    style: TextStyle(
                        color: primaryWhiteTextColor,
                        fontSize: primaryButtonMiddleFontSize
                    ),
                    textScaleFactor: 1.0,
                  ),
                ),
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          body: BlocBuilder<CommunityBloc, CommunityState>(
            bloc: communityBloc,
            builder: (context, state){
              return SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 10
                    ),
                    /// Search Form
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width - 10 * 2,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                              textSelectionHandleColor: Colors.transparent,
                              primaryColor: Colors.transparent,
                              scaffoldBackgroundColor:Colors.transparent,
                              bottomAppBarColor: Colors.transparent
                          ),
                          child: TextField(
                            controller: searchController,
                            onChanged: (value){
                              communityBloc.resetBloc();
                              communityBloc.searchKey = searchController.text;
                              try
                              {
                                if(timer != null) {
                                  timer.cancel();
                                }
                                timer = new Timer(new Duration(seconds: 1), () => {
                                  communityBloc..add(CommunityResetEvent())
                                });
                              }
                              catch(exception)
                              {
                                print(exception.toString());
                              }
                            },
                            cursorColor: primaryPlaceholderTextColor,
                            textAlign: TextAlign.start,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: primaryWhiteTextColor),
                              hintText: searchPlaceholder,
                              prefixIcon: Icon(Icons.search, color: primaryWhiteTextColor),
                              suffixIcon: searchController.text.length > 0 ?
                              GestureDetector(
                                onTap: (){
                                  searchController.text = "";
                                  communityBloc.resetBloc();
                                  communityBloc.searchKey = searchController.text;
                                  communityBloc..add(CommunityResetEvent());
                                },
                                child: Icon(Icons.cancel, color: primaryWhiteTextColor),
                              ):
                              SizedBox.shrink(),
                              contentPadding: EdgeInsets.only(
                                bottom: 40 / 2,  // HERE THE IMPORTANT PART
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                            style: TextStyle(
                                color: primaryWhiteTextColor,
                                fontSize: primaryTextFieldFontSize
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    /// Community List
                    Expanded(
                      child: state is CommunityLoadingState ?
                      Center(child: CupertinoActivityIndicator()) :
                      GoogleMap(
                        onTap: (location) async {
                          setState(() {

                          });
                        },
                        initialCameraPosition: communityBloc.currentPosition == null ?
                          CameraPosition(target: LatLng(40.688841, -74.044015), zoom: 11) :
                          CameraPosition(target: LatLng(communityBloc.currentPosition.latitude, communityBloc.currentPosition.longitude), zoom: 11),
                        mapType: MapType.normal,
                        markers: markers,
                      )
                      /*RefreshIndicator(
                        child: PaginationList<CommunityModel>(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(
                            left: 5,
                            right: 5,
                          ),
                          itemBuilder: (BuildContext context, CommunityModel community) {
                            return GestureDetector(
                              onTap: (){
                                setState(() {
                                  communityBloc.joinedCommunity = community.id;
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                                margin: EdgeInsets.only(top: 3, bottom: 3),
                                decoration: BoxDecoration(
                                    color: primaryWhiteTextColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    /// Avatar
                                    Container(
                                      width: 50,
                                      height: 50,
                                      child: CircularProfileAvatar(
                                        '',
                                        child: Image.asset(
                                          'assets/images/community_icon.png',
                                        ),
                                        backgroundColor: Colors.transparent,
                                        borderColor: Colors.transparent,
                                        elevation: 2,
                                        radius: 50,
                                      ),
                                    ),
                                    SizedBox(width: 20,),
                                    /// Author name part
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context).size.width - 150,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    community.name,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: primaryWhiteTextColor,
                                                        fontSize: primaryFeedAuthorFontSize
                                                    ),
                                                    textScaleFactor: 1.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    /// Function Button
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        width: 40,
                                        height: 30,
                                        alignment: Alignment.center,
                                        child: communityBloc.joinedCommunity == community.id ?
                                        Icon(FontAwesomeIcons.check, color: primaryWhiteTextColor, size: 15,):
                                        Text(''),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          onPageLoading: CupertinoActivityIndicator(),
                          onLoading: CupertinoActivityIndicator(),
                          pageFetch: communityBloc.pageFetch,
                          onError: (dynamic error) => Center(
                            child: Text('Getting Communities Failed'),
                          ),
                          initialData: <CommunityModel>[],
                          onEmpty: Center(
                            child: Text(
                              noCommunityFountText,
                              style: TextStyle(
                                  color: primaryWhiteTextColor,
                                  fontSize: primaryButtonFontSize
                              ),
                            ),
                          ),
                        ),
                        onRefresh: () async {
                          await Future.delayed(
                            Duration(milliseconds: 1000),
                          );
                          communityBloc.resetBloc();
                          communityBloc.add(FetchCommunityEvent());
                          return;
                        },
                      ),*/
                    )
                  ],
                ),
              );
            },
          ),
          bottomNavigationBar: BlocBuilder<CommunityBloc, CommunityState>(
            bloc: communityBloc,
            builder: (context, state){
              return Container(
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        Location location = new Location();

                        bool _serviceEnabled;
                        PermissionStatus _permissionGranted;
                        LocationData _locationData;

                        _serviceEnabled = await location.serviceEnabled();
                        if (!_serviceEnabled) {
                          _serviceEnabled = await location.requestService();
                          if (!_serviceEnabled) {
                            showToast(locationPermissionDeniedErrorText, gradientStart.withOpacity(0.8), gravity: ToastGravity.CENTER);
                            return;
                          }
                        }

                        _permissionGranted = await location.hasPermission();
                        if (_permissionGranted == PermissionStatus.denied) {
                          _permissionGranted = await location.requestPermission();
                          if (_permissionGranted != PermissionStatus.granted) {
                            showToast(locationPermissionDeniedErrorText, gradientStart.withOpacity(0.8), gravity: ToastGravity.CENTER);
                            return;
                          }
                        }
                        if(communityBloc.joinedCommunity != null){
                          communityBloc..add(CommunityConfirmEvent());
                        }
                        else{
                          showToast(joinedCommunityEmptyErrorText, gradientStart.withOpacity(0.8), gravity: ToastGravity.CENTER);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(bottom: 10, top: 10),
                        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.2, right: MediaQuery.of(context).size.width * 0.2, bottom: 10),
                        width: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(
                            color: gradientStart.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                                color: primaryWhiteTextColor
                            )
                        ),
                        child: state is CommunityConfirmLoadingState ?
                          CupertinoActivityIndicator():
                          Text(
                            confirmButtonText,
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: primaryWhiteTextColor,
                                fontSize: primaryButtonFontSize
                            ),
                          ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => BlocProvider(
                          create: (context) => CommunityBloc(communityRepository: CommunityRepository()),
                          child: SubmitCommunityScreen(),
                        )));
                      },
                      child: Container(
                        padding: EdgeInsets.only(bottom: 10, top: 10),
                        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.2, right: MediaQuery.of(context).size.width * 0.2, bottom: 10),
                        width: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(
                            color: gradientStart.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                                color: primaryWhiteTextColor
                            )
                        ),
                        child: Text(
                          submitCommunityButtonText,
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: primaryWhiteTextColor,
                              fontSize: primaryButtonFontSize
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void updateMarkers(int communityId) {
    markers.clear();
    for(int i = 0; i < communityBloc.fetchedCommunities.length; i++) {
      if(communityBloc.fetchedCommunities[i].id == communityBloc.joinedCommunity) {
        markers.add(
            Marker(
                markerId: MarkerId(communityBloc.fetchedCommunities[i].name as String),
                position: LatLng(communityBloc.fetchedCommunities[i].lat as double, communityBloc.fetchedCommunities[i].lng as double),
                infoWindow: InfoWindow(
                    title: communityBloc.fetchedCommunities[i].name,
                    snippet: "Lat: ${communityBloc.fetchedCommunities[i].lat}, Lng: ${communityBloc.fetchedCommunities[i].lng}"
                ),
                icon: pinSelectedLocationIcon,
                onTap: () {
                  setState(() {
                    communityBloc.joinedCommunity = communityBloc.fetchedCommunities[i].id;
                    updateMarkers(communityBloc.joinedCommunity as int);
                  });
                }
            )
        );
      }
      else {
        markers.add(
            Marker(
                markerId: MarkerId(communityBloc.fetchedCommunities[i].name as String),
                position: LatLng(communityBloc.fetchedCommunities[i].lat as double, communityBloc.fetchedCommunities[i].lng as double),
                infoWindow: InfoWindow(
                    title: communityBloc.fetchedCommunities[i].name,
                    snippet: "Lat: ${communityBloc.fetchedCommunities[i].lat}, Lng: ${communityBloc.fetchedCommunities[i].lng}"
                ),
                icon: pinLocationIcon,
                onTap: () {
                  setState(() {
                    communityBloc.joinedCommunity = communityBloc.fetchedCommunities[i].id;
                    updateMarkers(communityBloc.joinedCommunity as int);
                  });
                }
            )
        );
      }
    }
  }
}
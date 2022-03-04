import 'dart:async';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:overheard/constants/colorset.dart';
import 'package:overheard/constants/fontsizeset.dart';
import 'package:overheard/constants/stringset.dart';
import 'package:overheard/ui/community/bloc/community_bloc.dart';
import 'package:overheard/ui/community/bloc/community_event.dart';
import 'package:overheard/ui/community/bloc/community_state.dart';
import 'package:overheard/ui/community/models/community_model.dart';
import 'package:overheard/ui/community/repository/community.repository.dart';
import 'package:overheard/ui/community/submit_community.dart';
import 'package:overheard/ui/components/pagination.dart';
import 'package:overheard/ui/home/bloc/home_bloc.dart';
import 'package:overheard/ui/home/home.dart';
import 'package:overheard/ui/home/repository/home.repository.dart';
import 'package:overheard/utils/ui_elements.dart';
import 'package:location/location.dart';

class CommunityScreen extends StatefulWidget{
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  CommunityScreenState createState() {
    return CommunityScreenState();
  }

}

class CommunityScreenState extends State<CommunityScreen>{

  late CommunityBloc communityBloc;
  late TextEditingController searchController;
  late BuildContext context;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Timer timer;

  Set<Marker> markers = {};
  late BitmapDescriptor pinLocationIcon;
  late BitmapDescriptor pinSelectedLocationIcon;

  @override
  void initState(){
    super.initState();
    setCustomMapPin();
    communityBloc = CommunityBloc(communityRepository: CommunityRepository());
    communityBloc.add(const FetchCommunityEvent());
    searchController = TextEditingController();
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/community_marker.png');
    pinSelectedLocationIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/community_marker_selected.png');
  }

  Widget searchInputWidget() {
    return Center(
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
              // textSelectionHandleColor: Colors.transparent,
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
                timer = Timer(const Duration(seconds: 1), () => {
                  communityBloc.add(const CommunityResetEvent())
                });
              }
              catch(exception)
              {
                // print(exception.toString());
              }
            },
            cursorColor: primaryPlaceholderTextColor,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: const TextStyle(color: primaryWhiteTextColor),
              hintText: searchPlaceholder,
              prefixIcon: const Icon(Icons.search, color: primaryWhiteTextColor),
              suffixIcon: searchController.text.isNotEmpty ?
              GestureDetector(
                onTap: (){
                  searchController.text = "";
                  communityBloc.resetBloc();
                  communityBloc.searchKey = searchController.text;
                  communityBloc.add(const CommunityResetEvent());
                },
                child: const Icon(Icons.cancel, color: primaryWhiteTextColor),
              ):
              const SizedBox.shrink(),
              contentPadding: const EdgeInsets.only(
                bottom: 40 / 2,  // HERE THE IMPORTANT PART
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
            ),
            style: const TextStyle(
                color: primaryWhiteTextColor,
                fontSize: primaryTextFieldFontSize
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return BlocListener(
      bloc: communityBloc,
      listener: (context, state){
        if(state is CommunityDoneState) {
          markers.clear();
          for (var community in communityBloc.fetchedCommunities) {
            markers.add(
                Marker(
                  markerId: MarkerId(community.name ?? ''),
                  position: LatLng(community.lat!, community.lng!),
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
          }
          
        }
        else if(state is CommunityConfirmedState){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BlocProvider(
            create: (context) => HomeBloc(homeRepository: HomeRepository()),
            child: const HomeScreen(),
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
            middle: const Text(
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
                  child: const HomeScreen(),
                )));
              },
              child: const SizedBox(
                width: 50,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    skipButtonText,
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
                    const SizedBox(
                        height: 10
                    ),
                    /// Search Form
                    searchInputWidget(),
                    const SizedBox(height: 10),
                    /// Community List
                    Expanded(
                      child: state is CommunityLoadingState ?
                      const Center(child: CupertinoActivityIndicator()) :
                      // GoogleMap(
                      //   onTap: (location) async {
                      //     setState(() {

                      //     });
                      //   },
                      //   initialCameraPosition: communityBloc.currentPosition == null ?
                      //     const CameraPosition(target: LatLng(40.688841, -74.044015), zoom: 11) :
                      //     CameraPosition(target: LatLng(communityBloc.currentPosition!.latitude, communityBloc.currentPosition!.longitude), zoom: 11),
                      //   mapType: MapType.normal,
                      //   markers: markers,
                      // ),
                      RefreshIndicator(
                        child: PaginationList<CommunityModel>(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          prefix: const [],
                          padding: const EdgeInsets.only(
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
                                    const SizedBox(width: 20),
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
                                                    community.name as String,
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
                                        Icon(Icons.check, color: primaryWhiteTextColor, size: 15,):
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
                              noCommunityFoundText,
                              style: TextStyle(
                                  color: primaryWhiteTextColor,
                                  fontSize: primaryButtonFontSize
                              ),
                            ),
                          ),
                        ),
                        onRefresh: () async {
                          await Future.delayed(
                            const Duration(milliseconds: 1000),
                          );
                          communityBloc.resetBloc();
                          communityBloc.add(const FetchCommunityEvent());
                          return;
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          ),
          bottomNavigationBar: BlocBuilder<CommunityBloc, CommunityState>(
            bloc: communityBloc,
            builder: (context, state){
              return SizedBox(
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        Location location = Location();

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
                          communityBloc.add(const CommunityConfirmEvent());
                        }
                        else{
                          showToast(joinedCommunityEmptyErrorText, gradientStart.withOpacity(0.8), gravity: ToastGravity.CENTER);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 10, top: 10),
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
                          const CupertinoActivityIndicator():
                          const Text(
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
                          child: const SubmitCommunityScreen(),
                        )));
                      },
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 10, top: 10),
                        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.2, right: MediaQuery.of(context).size.width * 0.2, bottom: 10),
                        width: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(
                            color: gradientStart.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                                color: primaryWhiteTextColor
                            )
                        ),
                        child: const Text(
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
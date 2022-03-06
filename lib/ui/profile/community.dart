import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

// import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:overheard/constants/colorset.dart';
import 'package:overheard/constants/fontsizeset.dart';
import 'package:overheard/constants/stringset.dart';
import 'package:overheard/ui/community/models/community_model.dart';
import 'package:overheard/ui/components/pagination.dart';
import 'package:overheard/ui/profile/repository/profile.repository.dart';

import 'bloc/profile_bloc.dart';
import 'bloc/profile_event.dart';
import 'bloc/profile_state.dart';

class EditCommunityScreen extends StatefulWidget{
  const EditCommunityScreen({Key? key}) : super(key: key);

  @override
  EditCommunityScreenState createState() {
    return EditCommunityScreenState();
  }

}

class EditCommunityScreenState extends State<EditCommunityScreen>{
  late ProfileBloc profileBloc;
  late TextEditingController searchController;
  late BuildContext context;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Timer timer;
  Set<Marker> markers = {};
  late BitmapDescriptor pinLocationIcon;
  late BitmapDescriptor pinSelectedLocationIcon;
  int? communityId;

  @override
  void initState(){
    super.initState();
    setCustomMapPin();
    profileBloc = ProfileBloc(profileRepository: ProfileRepository());
    profileBloc.add(const FetchCommunityEvent());
    searchController = TextEditingController();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  void setCustomMapPin() async {
    int markerWidth = 100;
    final Uint8List activeIcon = await getBytesFromAsset('assets/images/community_marker.png', markerWidth);
    pinLocationIcon = BitmapDescriptor.fromBytes(activeIcon);
    final Uint8List nonActiveIcon = await getBytesFromAsset('assets/images/community_marker_selected.png', markerWidth);
    pinSelectedLocationIcon = BitmapDescriptor.fromBytes(nonActiveIcon);
    // pinLocationIcon = await BitmapDescriptor.fromAssetImage(
    //     const ImageConfiguration(devicePixelRatio: 2.5, size: Size(10, 20)),
    //     'assets/images/community_marker.png');
    // pinSelectedLocationIcon = await BitmapDescriptor.fromAssetImage(
    //     const ImageConfiguration(devicePixelRatio: 2.5, size: Size(10, 20)),
    //     'assets/images/community_marker_selected.png');
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: profileBloc,
      listener: (context, state){
        if(state is CommunityConfirmedState){
          setState(() {
            profileBloc.initState();
            profileBloc.searchKey = searchController.text;
            profileBloc.add(const FetchCommunityEvent());
          });
        }
        else if(state is CommunityConfirmFailedState){

        }
        else if(state is CommunityDoneState) {
          markers.clear();
          List<Marker> result = [];
          for (var community in profileBloc.fetchedCommunities) {
            if(community.id == profileBloc.joinedCommunity) {
              result.add(
                  Marker(
                      markerId: MarkerId(community.name!),
                      position: LatLng(community.lat!, community.lng!),
                      infoWindow: InfoWindow(
                          title: community.name,
                          snippet: "Lat: ${community.lat}, Lng: ${community.lng}"
                      ),
                      icon: pinSelectedLocationIcon,
                      onTap: () {
                        setState(() {
                          profileBloc.joinedCommunity = community.id!;
                          updateMarkers(profileBloc.joinedCommunity);
                          communityId = community.id!;
                        });
                      }
                  )
              );
              setState(() {
                markers = result.toSet();
              });
            }
            else {
              result.add(
                  Marker(
                      markerId: MarkerId(community.name!),
                      position: LatLng(community.lat!, community.lng!),
                      infoWindow: InfoWindow(
                          title: community.name,
                          snippet: "Lat: ${community.lat}, Lng: ${community.lng}"
                      ),
                      icon: pinLocationIcon,
                      onTap: () {
                        setState(() {
                          profileBloc.joinedCommunity = community.id!;
                          updateMarkers(profileBloc.joinedCommunity);
                          communityId = community.id!;
                        });
                      }
                  )
              );
              setState(() {
                markers = result.toSet();
              });
            }
          }
        }
      },
      child: Container(
        decoration: primaryBoxDecoration,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: CupertinoNavigationBar(
            middle: const Text(
              communityAppBarTitle,
              style: TextStyle(
                  fontSize: appBarTitleFontSize,
                  color: primaryWhiteTextColor
              ),
              textScaleFactor: 1.0,
            ),
            trailing: GestureDetector(
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                    content: const Text(
                      joinToAnotherCommunityContent,
                      style: TextStyle(
                          fontSize: primaryButtonMiddleFontSize,
                          color: primaryBlueTextColor
                      ),
                      textScaleFactor: 1.0,
                    ),
                    actions: [
                      CupertinoDialogAction(
                          isDefaultAction: true,
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: const Text(
                            cancelButtonText,
                            style: TextStyle(
                                color: primaryBlueTextColor,
                                fontSize: primaryButtonMiddleFontSize
                            ),
                          )
                      ),
                      CupertinoDialogAction(
                          isDefaultAction: true,
                          onPressed: (){
                            Navigator.pop(context);
                            /// Join to Another Community
                            if(profileBloc.joinedCommunity != null){
                              profileBloc.add(const CommunityConfirmEvent());
                            }
                          },
                          child: const Text(
                            acceptTermsAgreeButtonText,
                            style: TextStyle(
                                color: primaryBlueTextColor,
                                fontSize: primaryButtonMiddleFontSize
                            ),
                          )
                      )
                    ],
                  ),
                );
              },
              child: const SizedBox(
                width: 50,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    doneButtonText,
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
          body: BlocBuilder<ProfileBloc, ProfileState>(
            bloc: profileBloc,
            builder: (context, state){
              return SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10,),
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
                              // textSelectionHandleColor: Colors.transparent,
                              primaryColor: Colors.transparent,
                              scaffoldBackgroundColor:Colors.transparent,
                              bottomAppBarColor: Colors.transparent
                          ),
                          child: TextField(
                            onChanged: (value){
                              profileBloc.initState();
                              profileBloc.searchKey = searchController.text;
                              try
                              {
                                // if(timer != null) {
                                //   timer.cancel();
                                // }
                                timer = Timer(const Duration(seconds: 1), () => {
                                  profileBloc..add(const FetchCommunityEvent())
                                });
                              }
                              catch(exception)
                              {
                                // print(exception.toString());
                              }
                            },
                            controller: searchController,
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
                                  setState(() {
                                    searchController.text = "";
                                    profileBloc.initState();
                                    profileBloc.searchKey = searchController.text;
                                    profileBloc.add(const FetchCommunityEvent());
                                  });
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
                    ),
                    const SizedBox(height: 10,),
                    Expanded(
                        child: state is CommunityLoadingState ? const Center(child: CupertinoActivityIndicator(),):
                        GoogleMap(
                          onTap: (location) async {
                            setState(() {

                            });
                          },
                          initialCameraPosition: profileBloc.currentPosition == null ?
                          const CameraPosition(target: LatLng(40.688841, -74.044015), zoom: 11) :
                          CameraPosition(target: LatLng(profileBloc.currentPosition!.latitude, profileBloc.currentPosition!.longitude), zoom: 11),
                          mapType: MapType.normal,
                          markers: markers,
                        )
                        // Container(
                        //   child: PaginationList<CommunityModel>(
                        //     shrinkWrap: true,
                        //     prefix: const [],
                        //     physics: const BouncingScrollPhysics(),
                        //     padding: const EdgeInsets.only(
                        //       left: 5,
                        //       right: 5,
                        //     ),
                        //     itemBuilder: (BuildContext context, CommunityModel community) {
                        //       return Container(
                        //         padding: const EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
                        //         child: Row(
                        //           mainAxisSize: MainAxisSize.max,
                        //           children: [
                        //             SizedBox(
                        //               width: 50,
                        //               height: 50,
                        //               child: CircularProfileAvatar(
                        //                 '',
                        //                 child: Image.asset(
                        //                   'assets/images/community_icon.png',
                        //                 ),
                        //                 backgroundColor: Colors.transparent,
                        //                 borderColor: Colors.transparent,
                        //                 elevation: 2,
                        //                 radius: 50,
                        //               ),
                        //             ),
                        //             const SizedBox(width: 20,),
                        //             /// Community name part
                        //             Expanded(
                        //               child: Column(
                        //                 children: [
                        //                   SizedBox(
                        //                     width: MediaQuery.of(context).size.width - 150,
                        //                     child: Row(
                        //                       mainAxisAlignment: MainAxisAlignment.start,
                        //                       children: [
                        //                         Flexible(
                        //                           child: Text(
                        //                             community.name!,
                        //                             overflow: TextOverflow.ellipsis,
                        //                             style: const TextStyle(
                        //                                 color: primaryWhiteTextColor,
                        //                                 fontSize: primaryFeedAuthorFontSize
                        //                             ),
                        //                             textScaleFactor: 1.0,
                        //                           ),
                        //                         ),
                        //                       ],
                        //                     ),
                        //                   ),
                        //                   const SizedBox(height: 5,),
                        //                   SizedBox(
                        //                     width: MediaQuery.of(context).size.width - 150,
                        //                     child: Row(
                        //                       mainAxisAlignment: MainAxisAlignment.start,
                        //                       children: [
                        //                         Flexible(
                        //                           child: Text(
                        //                             community.participants.toString() + ' participants',
                        //                             overflow: TextOverflow.ellipsis,
                        //                             style: const TextStyle(
                        //                                 color: primaryWhiteTextColor,
                        //                                 fontSize: primaryFeedAuthorFontSize - 3
                        //                             ),
                        //                             textScaleFactor: 1.0,
                        //                           ),
                        //                         ),
                        //                       ],
                        //                     ),
                        //                   )
                        //                 ],
                        //               ),
                        //             ),
                        //             /// Join Button
                        //             Align(
                        //               alignment: Alignment.centerRight,
                        //               child: GestureDetector(
                        //                 onTap: (){
                        //                   showDialog(
                        //                     context: context,
                        //                     builder: (BuildContext context) => CupertinoAlertDialog(
                        //                       content: const Text(
                        //                         joinToAnotherCommunityContent,
                        //                         style: TextStyle(
                        //                             fontSize: primaryButtonMiddleFontSize,
                        //                             color: primaryBlueTextColor
                        //                         ),
                        //                         textScaleFactor: 1.0,
                        //                       ),
                        //                       actions: [
                        //                         CupertinoDialogAction(
                        //                             isDefaultAction: true,
                        //                             onPressed: (){
                        //                               Navigator.pop(context);
                        //                             },
                        //                             child: const Text(
                        //                               cancelButtonText,
                        //                               style: TextStyle(
                        //                                   color: primaryBlueTextColor,
                        //                                   fontSize: primaryButtonMiddleFontSize
                        //                               ),
                        //                             )
                        //                         ),
                        //                         CupertinoDialogAction(
                        //                             isDefaultAction: true,
                        //                             onPressed: (){
                        //                               Navigator.pop(context);
                        //                               /// Join to Another Community
                        //                               profileBloc.joinedCommunity = community.id;
                        //                               if(profileBloc.joinedCommunity != null){
                        //                                 profileBloc.add(const CommunityConfirmEvent());
                        //                               }
                        //                             },
                        //                             child: const Text(
                        //                               acceptTermsAgreeButtonText,
                        //                               style: TextStyle(
                        //                                   color: primaryBlueTextColor,
                        //                                   fontSize: primaryButtonMiddleFontSize
                        //                               ),
                        //                             )
                        //                         )
                        //                       ],
                        //                     ),
                        //                   );
                        //                 },
                        //                 child: Container(
                        //                   width: 70,
                        //                   height: 30,
                        //                   alignment: Alignment.center,
                        //                   child: Text(
                        //                     community.id == profileBloc.userModel.community_id ? joinedButtonText : joinButtonText,
                        //                     textScaleFactor: 1.0,
                        //                     style: const TextStyle(
                        //                         color: primaryWhiteTextColor,
                        //                         fontSize: primaryButtonMiddleFontSize
                        //                     ),
                        //                   ),
                        //                   decoration: BoxDecoration(
                        //                     borderRadius: BorderRadius.circular(5),
                        //                     border: Border.all(
                        //                       color: Colors.white,
                        //                       width: 1,
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ),
                        //             )
                        //           ],
                        //         ),
                        //       );
                        //     },
                        //     pageFetch: profileBloc.pageFetchCommunity(),
                        //     onError: (dynamic error) => const Center(
                        //       child: Text('Something Went Wrong'),
                        //     ),
                        //     initialData: const <CommunityModel>[],
                        //     onLoading: const CupertinoActivityIndicator(),
                        //     onPageLoading: const CupertinoActivityIndicator(),
                        //     onEmpty: const Center(
                        //       child: Text(
                        //         noCommunityFoundText,
                        //         style: TextStyle(
                        //             color: primaryWhiteTextColor,
                        //             fontSize: primaryButtonFontSize
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // )
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

  void updateMarkers(int? communityId) {
    markers.clear();
    for(int i = 0; i < profileBloc.fetchedCommunities.length; i++) {
      if(profileBloc.fetchedCommunities[i].id == profileBloc.joinedCommunity) {
        markers.add(
            Marker(
                markerId: MarkerId(profileBloc.fetchedCommunities[i].name!),
                position: LatLng(profileBloc.fetchedCommunities[i].lat!, profileBloc.fetchedCommunities[i].lng!),
                infoWindow: InfoWindow(
                    title: profileBloc.fetchedCommunities[i].name,
                    snippet: "Lat: ${profileBloc.fetchedCommunities[i].lat}, Lng: ${profileBloc.fetchedCommunities[i].lng}"
                ),
                icon: pinSelectedLocationIcon,
                onTap: () {
                  setState(() {
                    profileBloc.joinedCommunity = profileBloc.fetchedCommunities[i].id!;
                    updateMarkers(profileBloc.joinedCommunity);
                  });
                }
            )
        );
      }
      else {
        markers.add(
            Marker(
                markerId: MarkerId(profileBloc.fetchedCommunities[i].name!),
                position: LatLng(profileBloc.fetchedCommunities[i].lat!, profileBloc.fetchedCommunities[i].lng!),
                infoWindow: InfoWindow(
                    title: profileBloc.fetchedCommunities[i].name,
                    snippet: "Lat: ${profileBloc.fetchedCommunities[i].lat}, Lng: ${profileBloc.fetchedCommunities[i].lng}"
                ),
                icon: pinLocationIcon,
                onTap: () {
                  setState(() {
                    profileBloc.joinedCommunity = profileBloc.fetchedCommunities[i].id!;
                    updateMarkers(profileBloc.joinedCommunity);
                  });
                }
            )
        );
      }
    }
  }
}
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overheard/constants/colorset.dart';
import 'package:overheard/constants/fontsizeset.dart';
import 'package:overheard/constants/stringset.dart';
import 'package:overheard/ui/auth/models/user_model.dart';
import 'package:overheard/ui/community/bloc/community_bloc.dart';
import 'package:overheard/ui/community/community.dart';
import 'package:overheard/ui/community/repository/community.repository.dart';
import 'package:overheard/ui/profile/bloc/profile_bloc.dart';
import 'package:overheard/ui/profile/bloc/profile_event.dart';
import 'package:overheard/ui/profile/bloc/profile_state.dart';
import 'package:overheard/ui/profile/crop_photo.dart';
import 'package:overheard/ui/profile/repository/profile.repository.dart';
import 'package:overheard/utils/ui_elements.dart';
import 'package:location/location.dart';

class CompleteProfileScreen extends StatefulWidget{
  final UserModel user;
  const CompleteProfileScreen({Key? key, required this.user}) : super(key: key);
  @override
  CompleteProfileScreenState createState() {
    return CompleteProfileScreenState();
  }

}

class CompleteProfileScreenState extends State<CompleteProfileScreen>{
  late ProfileBloc profileBloc;

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController bioController;

  @override
  void initState(){
    super.initState();
    profileBloc = ProfileBloc(profileRepository: ProfileRepository());
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    bioController = TextEditingController();

    firstNameController.text = widget.user.firstname ?? '';
    lastNameController.text = widget.user.lastname ?? '';
    bioController.text = widget.user.bio ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: profileBloc,
      listener: (context, state) async {
        if(state is ProfileUpdateDoneState){
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

          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BlocProvider(
            create: (context) => CommunityBloc(communityRepository: CommunityRepository()),
            child: const CommunityScreen(),
          )));
        }
        else if(state is ProfileUpdateFailedState){

        }
      },
      child: Container(
        decoration: primaryBoxDecoration,
        child: Scaffold(
          appBar: const CupertinoNavigationBar(
            middle: Text(
              completeProfileAppBarTitle,
              style: TextStyle(
                  fontSize: appBarTitleFontSize,
                  color: primaryWhiteTextColor
              ),
              textScaleFactor: 1.0,
            ),
          ),
          backgroundColor: Colors.transparent,
          body: BlocBuilder<ProfileBloc, ProfileState>(
            bloc: profileBloc,
            builder: (context, state){
              return SafeArea(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        /// Avatar part
                        CircularProfileAvatar(
                          'assets/images/user_avatar.png',
                          child: widget.user.avatar == null && profileBloc.avatarImageFile == null ?
                            Image.asset(
                              'assets/images/user_avatar.png',
                            ) 
                            :
                            profileBloc.avatarImageFile != null ? 
                              Image.file(profileBloc.avatarImageFile!)
                              :
                              CachedNetworkImage(
                                imageUrl: widget.user.avatar!,
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                ),
                                placeholder: (context, url) => const CupertinoActivityIndicator(),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                          backgroundColor: Colors.transparent,
                          borderColor: Colors.transparent,
                          elevation: 2,
                          radius: 50,
                        ),
                        const SizedBox(height: 10),
                        /// Change Avatar Button
                        GestureDetector(
                          onTap: (){
                            showCupertinoModalPopup(
                                context: context,
                                builder: (context) => CupertinoActionSheet(
                                  actions: [
                                    CupertinoActionSheetAction(
                                      child: const Text(
                                          takePhotoText,
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontSize: primaryButtonFontSize
                                          ),
                                          textScaleFactor: 1.0,
                                      ),
                                      onPressed: () async {
                                        XFile image = await ImagePicker().pickImage(source: ImageSource.camera) as XFile;
                                        if(image != null){
                                          // final croppedImage = await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BlocProvider(
                                          //   create: (context) => ProfileBloc(profileRepository: ProfileRepository()),
                                          //   child: CropPhotoScreen(image: image.path),
                                          // )));
                                          setState(() {
                                            profileBloc.avatarImageFile ?? File('assets/images/user_avatar.png');
                                            // if(croppedImage == null){
                                            //   profileBloc.avatarImageFile = null;
                                            // }
                                            // else{
                                            //   profileBloc.avatarImageFile = croppedImage;
                                            // }
                                          });
                                        }
                                      },
                                    ),
                                    CupertinoActionSheetAction(
                                      child: const Text(
                                          chooseFromLibraryText,
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontSize: primaryButtonFontSize
                                          ),
                                          textScaleFactor: 1.0,
                                      ),
                                      onPressed: () async {
                                        XFile image = await ImagePicker().pickImage(source: ImageSource.gallery) as XFile;
                                        if(image != null){
                                          final croppedImage = await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BlocProvider(
                                            create: (context) => ProfileBloc(profileRepository: ProfileRepository()),
                                            child: CropPhotoScreen(image: image.path),
                                          )));
                                          setState(() {
                                            // profileBloc.avatarImageFile ?? File('assets/images/user_avatar.png');
                                            if(croppedImage == null){
                                              profileBloc.avatarImageFile = null;
                                            }
                                            else{
                                              profileBloc.avatarImageFile = croppedImage;
                                            }
                                          });
                                        }
                                      },
                                    )
                                  ],
                                  cancelButton: CupertinoActionSheetAction(
                                    child: const Text(
                                        CancelButtonText,
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontSize: primaryButtonFontSize
                                        ),
                                        textScaleFactor: 1.0,
                                    ),
                                    onPressed: (){
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                )
                            );
                          },
                          child: const Text(
                              uploadPhotoText,
                              style: TextStyle(
                                  color: primaryWhiteTextColor,
                                  fontSize: primaryTextFieldFontSize
                              ),
                              textScaleFactor: 1.0,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                                // textSelectionHandleColor: Colors.white,
                                primaryColor: primaryDividerColor,
                                scaffoldBackgroundColor:Colors.white,
                                // accentColor: Colors.white,
                                dividerColor: Colors.white,
                                hintColor: Colors.white
                            ),
                            child: TextField(
                              controller: firstNameController,
                              cursorColor: primaryPlaceholderTextColor,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  hintText: firstNamePlaceholder,
                                  hintStyle: TextStyle(color: primaryWhiteTextColor),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  )
                              ),
                              style: const TextStyle(
                                  color: primaryWhiteTextColor,
                                  fontSize: primaryTextFieldFontSize
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                                // textSelectionHandleColor: Colors.white,
                                primaryColor: primaryDividerColor,
                                scaffoldBackgroundColor:Colors.white,
                                // accentColor: Colors.white,
                                dividerColor: Colors.white,
                                hintColor: Colors.white
                            ),
                            child: TextField(
                              controller: lastNameController,
                              cursorColor: primaryPlaceholderTextColor,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  hintText: lastNamePlaceholder,
                                  hintStyle: TextStyle(color: primaryWhiteTextColor),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  )
                              ),
                              style: const TextStyle(
                                  color: primaryWhiteTextColor,
                                  fontSize: primaryTextFieldFontSize
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                                // textSelectionHandleColor: Colors.white,
                                primaryColor: primaryDividerColor,
                                scaffoldBackgroundColor:Colors.white,
                                // accentColor: Colors.white,
                                dividerColor: Colors.white,
                                hintColor: Colors.white
                            ),
                            child: TextField(
                              controller: bioController,
                              cursorColor: primaryPlaceholderTextColor,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  hintText: bioPlaceholder,
                                  hintStyle: TextStyle(color: primaryWhiteTextColor),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  )
                              ),
                              style: const TextStyle(
                                  color: primaryWhiteTextColor,
                                  fontSize: primaryTextFieldFontSize
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: MergeSemantics(
                            child: ListTile(
                              title: const Text(
                                  verifiedReporterRequestText,
                                  style: TextStyle(
                                    color: primaryWhiteTextColor,
                                    fontSize: primaryButtonMiddleFontSize + 1
                                  ),
                              ),
                              trailing: Transform.scale(
                                scale: 0.9,
                                child: CupertinoSwitch(
                                  trackColor: Colors.white.withOpacity(0.6),
                                  activeColor: gradientStart.withOpacity(0.8),
                                  value: profileBloc.verifiedReporterRequested,
                                  onChanged: (bool value) {
                                    setState(() {
                                      profileBloc.verifiedReporterRequested = value;
                                    });
                                  },
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  profileBloc.verifiedReporterRequested = !profileBloc.verifiedReporterRequested;
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          bottomNavigationBar: BlocBuilder<ProfileBloc, ProfileState>(
            bloc: profileBloc,
            builder: (context, state){
              return GestureDetector(
                onTap: (){
                  if(firstNameController.text == ""){
                    Scaffold.of(context).showSnackBar(getSnackBar(context, firstNameEmptyErrorText));
                    return;
                  }
                  if(lastNameController.text == ""){
                    Scaffold.of(context).showSnackBar(getSnackBar(context, lastNameEmptyErrorText));
                    return;
                  }
                  if(bioController.text == ""){
                    Scaffold.of(context).showSnackBar(getSnackBar(context, bioEmptyErrorText));
                    return;
                  }

                  profileBloc.add(ProfileCompleteEvent(
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      userName: null,
                      phonenumber: null,
                      email: null,
                      bio: bioController.text,
                      reporter_request: profileBloc.verifiedReporterRequested
                  ));
                },
                child: Container(
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                  margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.2, right: MediaQuery.of(context).size.width * 0.2, bottom: 10),
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                      color: gradientStart.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                          color: primaryWhiteTextColor
                      )
                  ),
                  child: state is ProfileLoadingState?
                  const CupertinoActivityIndicator():
                  const Text(
                    profileCompleteText,
                    textScaleFactor: 1.0,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: primaryWhiteTextColor,
                        fontSize: primaryButtonFontSize
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
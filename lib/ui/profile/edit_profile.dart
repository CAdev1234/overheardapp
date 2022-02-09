import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overheard_flutter_app/constants/colorset.dart';
import 'package:overheard_flutter_app/constants/fontsizeset.dart';
import 'package:overheard_flutter_app/constants/stringset.dart';
import 'package:overheard_flutter_app/ui/profile/bloc/profile.event.dart';
import 'package:overheard_flutter_app/ui/profile/repository/profile.repository.dart';
import 'package:overheard_flutter_app/utils/ui_elements.dart';

import 'bloc/profile.bloc.dart';
import 'bloc/profile.state.dart';
import 'crop_photo.dart';

class EditProfileScreen extends StatefulWidget{
  @override
  EditProfileScreenState createState() {
    return new EditProfileScreenState();
  }

}

class EditProfileScreenState extends State<EditProfileScreen> {
  late ProfileBloc profileBloc;

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController userNameController;
  late TextEditingController emailController;
  late TextEditingController phoneNumberController;
  late TextEditingController bioController;

  @override
  void initState() {
    super.initState();
    profileBloc = ProfileBloc(profileRepository: ProfileRepository());
    profileBloc.add(ProfileFetchEvent());
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    userNameController = TextEditingController();
    emailController = TextEditingController();
    phoneNumberController = TextEditingController();
    bioController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: profileBloc,
      listener: (context, state) {
        if(state is ProfileLoadDoneState){
          firstNameController.text = state.userModel!.firstname!;
          lastNameController.text = state.userModel!.lastname!;
          userNameController.text = state.userModel!.name!;
          emailController.text = state.userModel!.email!;
          phoneNumberController.text = state.userModel!.phonenumber!;
          bioController.text = state.userModel!.bio!;
        }
        else if(state is ProfileUpdateDoneState){
          Navigator.of(context).pop(true);
        }
        else if(state is ProfileUpdateFailedState){

        }
      },
      child: Container(
        decoration: primaryBoxDecoration,
        child: Scaffold(
          appBar: CupertinoNavigationBar(
            middle: Text(
              editProfileAppBarTitle,
              style: TextStyle(
                  fontSize: appBarTitleFontSize,
                  color: primaryWhiteTextColor
              ),
              textScaleFactor: 1.0,
            ),
            trailing: GestureDetector(
              onTap: (){
                if(firstNameController.text == null || firstNameController.text == ""){
                  Scaffold.of(context).showSnackBar(getSnackBar(context, firstNameEmptyErrorText));
                  return;
                }
                if(lastNameController.text == null || lastNameController.text == ""){
                  Scaffold.of(context).showSnackBar(getSnackBar(context, lastNameEmptyErrorText));
                  return;
                }
                if(userNameController.text == null || userNameController.text == ""){
                  Scaffold.of(context).showSnackBar(getSnackBar(context, usernameEmptyErrorText));
                  return;
                }
                if(emailController.text == null || emailController.text == ""){
                  Scaffold.of(context).showSnackBar(getSnackBar(context, emailEmptyErrorText));
                  return;
                }
                if(bioController.text == null || bioController.text == ""){
                  Scaffold.of(context).showSnackBar(getSnackBar(context, bioEmptyErrorText));
                  return;
                }
                if(!EmailValidator.validate(emailController.text)){
                  Scaffold.of(context).showSnackBar(getSnackBar(context, invalidEmailErrorText));
                  return;
                }

                profileBloc.add(ProfileCompleteEvent(
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    userName: userNameController.text,
                    email: emailController.text,
                    phonenumber: phoneNumberController.text,
                    bio: bioController.text,
                    reporter_request: false
                ));
              },
              child: Container(
                width: 50,
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    DoneButtonText,
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
            builder: (context, state) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: Center(
                    child: state is ProfileLoadingState ?
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: const Center(
                        child: CupertinoActivityIndicator(),
                      ),
                    ):
                    state is ProfileLoadDoneState?
                    Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      /// Avatar
                      CircularProfileAvatar(
                        '',
                        child: profileBloc.userModel.avatar == null && profileBloc.avatarImageFile == null ?
                        Image.asset(
                          'assets/images/user_avatar.png',
                        ) :
                        profileBloc.avatarImageFile != null?
                        Image.file(profileBloc.avatarImageFile!):
                        CachedNetworkImage(
                          imageUrl: profileBloc.userModel.avatar!,
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
                      GestureDetector(
                        onTap: () {
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
                                      XFile image = await ImagePicker().pickImage(
                                          source: ImageSource.camera) as XFile;

                                      if(image != null){
                                        final croppedImage = await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BlocProvider(
                                          create: (context) => ProfileBloc(profileRepository: ProfileRepository()),
                                          child: CropPhotoScreen(image: image.path),
                                        )));
                                        setState(() {
                                          if(croppedImage == null){
                                            profileBloc.avatarImageFile = null;
                                          }
                                          else{
                                            profileBloc.avatarImageFile = croppedImage;
                                          }
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
                                      XFile image = await ImagePicker().pickImage(
                                          source: ImageSource.gallery) as XFile;
                                      if(image != null){
                                        final croppedImage = await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BlocProvider(
                                          create: (context) => ProfileBloc(profileRepository: ProfileRepository()),
                                          child: CropPhotoScreen(image: image.path),
                                        )));
                                        setState(() {
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
                          changeProfilePhotoText,
                          style: TextStyle(
                              color: primaryWhiteTextColor,
                              fontSize: primaryTextFieldFontSize
                          ),
                          textScaleFactor: 1.0,
                        ),
                      ),
                      const SizedBox(height: 20),
                      /// First Name Input Field
                      Container(
                        width: MediaQuery.of(context).size.width - 20 * 2,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: 120,
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    firstNamePlaceholder,
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        color: primaryWhiteTextColor,
                                        fontSize: primaryTextFieldFontSize
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                    // textSelectionHandleColor: Colors.transparent,
                                    primaryColor: Colors.transparent,
                                    scaffoldBackgroundColor:Colors.transparent,
                                    bottomAppBarColor: Colors.transparent
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextField(
                                    controller: firstNameController,
                                    cursorColor: primaryPlaceholderTextColor,
                                    textAlign: TextAlign.left,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                        bottom: 40 / 2,  // HERE THE IMPORTANT PART
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
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
                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
                      /// Last Name Input Field
                      Container(
                        width: MediaQuery.of(context).size.width - 20 * 2,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: 120,
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    lastNamePlaceholder,
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        color: primaryWhiteTextColor,
                                        fontSize: primaryTextFieldFontSize
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                    // textSelectionHandleColor: Colors.transparent,
                                    primaryColor: Colors.transparent,
                                    scaffoldBackgroundColor:Colors.transparent,
                                    bottomAppBarColor: Colors.transparent
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextField(
                                    controller: lastNameController,
                                    cursorColor: primaryPlaceholderTextColor,
                                    textAlign: TextAlign.left,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                        bottom: 40 / 2,  // HERE THE IMPORTANT PART
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
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
                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
                      /// User Name Input Field
                      Container(
                        width: MediaQuery.of(context).size.width - 20 * 2,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: 120,
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    usernamePlaceholder,
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        color: primaryWhiteTextColor,
                                        fontSize: primaryTextFieldFontSize
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                    // textSelectionHandleColor: Colors.transparent,
                                    primaryColor: Colors.transparent,
                                    scaffoldBackgroundColor:Colors.transparent,
                                    bottomAppBarColor: Colors.transparent
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextField(
                                    controller: userNameController,
                                    cursorColor: primaryPlaceholderTextColor,
                                    textAlign: TextAlign.left,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                        bottom: 40 / 2,  // HERE THE IMPORTANT PART
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
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
                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
                      /// Email Input Field
                      Container(
                        width: MediaQuery.of(context).size.width - 20 * 2,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: 120,
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    emailPlaceholder,
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        color: primaryWhiteTextColor,
                                        fontSize: primaryTextFieldFontSize
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                    // textSelectionHandleColor: Colors.transparent,
                                    primaryColor: Colors.transparent,
                                    scaffoldBackgroundColor:Colors.transparent,
                                    bottomAppBarColor: Colors.transparent
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextField(
                                    controller: emailController,
                                    cursorColor: primaryPlaceholderTextColor,
                                    textAlign: TextAlign.left,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                        bottom: 40 / 2,  // HERE THE IMPORTANT PART
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
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
                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
                      /// Phone Input Field
                      Container(
                        width: MediaQuery.of(context).size.width - 20 * 2,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: 120,
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    phonePlaceholder,
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        color: primaryWhiteTextColor,
                                        fontSize: primaryTextFieldFontSize
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                    // textSelectionHandleColor: Colors.transparent,
                                    primaryColor: Colors.transparent,
                                    scaffoldBackgroundColor:Colors.transparent,
                                    bottomAppBarColor: Colors.transparent
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextField(
                                    controller: phoneNumberController,
                                    cursorColor: primaryPlaceholderTextColor,
                                    textAlign: TextAlign.left,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                        bottom: 40 / 2,  // HERE THE IMPORTANT PART
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
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
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      /// Bio Input Field
                      Container(
                        width: MediaQuery.of(context).size.width - 20 * 2,
                        height: 200,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: 120,
                              padding: const EdgeInsets.only(top: 10),
                              child: const Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    bioPlaceholder,
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        color: primaryWhiteTextColor,
                                        fontSize: primaryTextFieldFontSize
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 200,
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                      // textSelectionHandleColor: Colors.transparent,
                                      primaryColor: Colors.transparent,
                                      scaffoldBackgroundColor:Colors.transparent,
                                      bottomAppBarColor: Colors.transparent
                                  ),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: TextField(
                                      controller: bioController,
                                      maxLines: null,
                                      cursorColor: primaryPlaceholderTextColor,
                                      textAlign: TextAlign.left,
                                      keyboardType: TextInputType.text,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(
                                          bottom: 40 / 2,  // HERE THE IMPORTANT PART
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  ): const SizedBox.shrink(),
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
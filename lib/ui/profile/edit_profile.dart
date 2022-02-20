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
import 'package:overheard_flutter_app/ui/profile/bloc/profile_event.dart';
import 'package:overheard_flutter_app/ui/profile/repository/profile.repository.dart';
import 'package:overheard_flutter_app/utils/ui_elements.dart';

import 'bloc/profile_bloc.dart';
import 'bloc/profile_state.dart';
import 'crop_photo.dart';

class EditProfileScreen extends StatefulWidget{
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  EditProfileScreenState createState() {
    return EditProfileScreenState();
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

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    profileBloc = ProfileBloc(profileRepository: ProfileRepository());
    profileBloc.add(const ProfileFetchEvent());
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
          bioController.text = state.userModel!.bio!;
          phoneNumberController.text = state.userModel!.phonenumber!;
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
          key: scaffoldKey,
          appBar: CupertinoNavigationBar(
            middle: const Text(
              editProfileAppBarTitle,
              style: TextStyle(
                  fontSize: appBarTitleFontSize,
                  color: primaryWhiteTextColor
              ),
              textScaleFactor: 1.0,
            ),
            trailing: GestureDetector(
              onTap: (){
                if(firstNameController.text == ""){
                  // Scaffold.of(context).showSnackBar(getSnackBar(context, firstNameEmptyErrorText));
                  showToast(firstNameEmptyErrorText, gradientStart);
                  return;
                }
                if(lastNameController.text == ""){
                  // Scaffold.of(context).showSnackBar(getSnackBar(context, lastNameEmptyErrorText));
                  showToast(lastNameEmptyErrorText, gradientStart);
                  return;
                }
                if(userNameController.text == ""){
                  // Scaffold.of(context).showSnackBar(getSnackBar(context, usernameEmptyErrorText));
                  showToast(usernameEmptyErrorText, gradientStart);
                  return;
                }
                if(emailController.text == ""){
                  // Scaffold.of(context).showSnackBar(getSnackBar(context, emailEmptyErrorText));
                  // ScaffoldMessenger.of(context).showSnackBar(getSnackBar(context, emailEmptyErrorText));
                  showToast(emailEmptyErrorText, gradientStart);
                  return;
                }
                if(bioController.text == ""){
                  // Scaffold.of(context).showSnackBar(getSnackBar(context, bioEmptyErrorText));
                  showToast(bioEmptyErrorText, gradientStart);
                  return;
                }
                if(!EmailValidator.validate(emailController.text)){
                  // Scaffold.of(context).showSnackBar(getSnackBar(context, invalidEmailErrorText));
                  showToast(invalidEmailErrorText, gradientStart);
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
              child: const SizedBox(
                width: 50,
                child: Align(
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
                    SizedBox(
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
                                      XFile image = await ImagePicker().pickImage(source: ImageSource.camera) as XFile;
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
                            const SizedBox(
                              width: 120,
                              child: Align(
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
                            const SizedBox(
                              width: 120,
                              child: Align(
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
                            const SizedBox(
                              width: 120,
                              child: Align(
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
                            const SizedBox(
                              width: 120,
                              child: Align(
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
                            const SizedBox(
                              width: 120,
                              child: Align(
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
                              child: SizedBox(
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
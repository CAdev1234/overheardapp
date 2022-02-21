import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/constants/colorset.dart';
import 'package:overheard/constants/fontsizeset.dart';
import 'package:overheard/constants/stringset.dart';
import 'package:overheard/ui/profile/repository/profile.repository.dart';
import 'package:overheard/utils/simple_image_crop/simple_image_crop.dart';

import 'bloc/profile_bloc.dart';
import 'bloc/profile_state.dart';

class CropPhotoScreen extends StatefulWidget{
  final image;

  const CropPhotoScreen({Key? key, required this.image}) : super(key: key);
  @override
  CropPhotoScreenState createState() {
    return CropPhotoScreenState();
  }

}

class CropPhotoScreenState extends State<CropPhotoScreen>{
  late ProfileBloc profileBloc;
  final cropKey = GlobalKey<ImgCropState>();

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController bioController;

  @override
  void initState(){
    super.initState();
    profileBloc = ProfileBloc(profileRepository: ProfileRepository());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: profileBloc,
      listener: (context, state){

      },
      child: Container(
        decoration: primaryBoxDecoration,
        child: Scaffold(
          appBar: CupertinoNavigationBar(
            leading: GestureDetector(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  CancelButtonText,
                  style: TextStyle(
                    color: primaryWhiteTextColor,
                    fontSize: primaryButtonMiddleFontSize
                  ),
                  textScaleFactor: 1.0,
                ),
              ),
            ),
            middle: const Text(
              cropPhotoAppBarTitle,
              style: TextStyle(
                  fontSize: appBarTitleFontSize,
                  color: primaryWhiteTextColor
              ),
              textScaleFactor: 1.0,
            ),
            trailing: GestureDetector(
              onTap: () async {
                final crop = cropKey.currentState;
                final croppedFile = await crop!.cropCompleted(File(widget.image!), preferredSize: 500);
                Navigator.of(context).pop(croppedFile);
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
            builder: (context, state){
              return SafeArea(
                child: ImgCrop(
                  key: cropKey,
                  chipRadius: 100,
                  chipRatio: 1,
                  maximumScale: 3,
                  image: FileImage(File(widget.image)),
                  // handleSize: 0.0,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
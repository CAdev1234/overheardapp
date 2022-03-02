import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/constants/colorset.dart';
import 'package:overheard/constants/fontsizeset.dart';
import 'package:overheard/constants/stringset.dart';
import 'package:overheard/ui/profile/bloc/profile_bloc.dart';
import 'package:overheard/ui/profile/bloc/profile_event.dart';
import 'package:overheard/ui/profile/repository/profile.repository.dart';
import 'package:overheard/utils/ui_elements.dart';

import 'bloc/profile_state.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() {
    return _ChangePasswordScreenState();
  }
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

  late ProfileBloc profileBloc;
  late TextEditingController oldPasswordController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;

  @override
  void initState() {
    super.initState();
    profileBloc = ProfileBloc(profileRepository: ProfileRepository());
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: profileBloc,
      listener: (context, state){
        if(state is PasswordChangedState){
          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        bloc: profileBloc,
        builder: (context, state){
          return Container(
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
                      cancelButtonText,
                      style: TextStyle(
                          color: primaryWhiteTextColor,
                          fontSize: primaryButtonMiddleFontSize
                      ),
                      textScaleFactor: 1.0,
                    ),
                  ),
                ),
                middle: const Text(
                  changePasswordText,
                  style: TextStyle(
                      fontSize: appBarTitleFontSize,
                      color: primaryWhiteTextColor
                  ),
                  textScaleFactor: 1.0,
                ),
                trailing: GestureDetector(
                  onTap: () async {
                    if(oldPasswordController.text == ""){
                      showToast(passwordEmptyErrorText, gradientStart);
                      return;
                    }
                    if(newPasswordController.text == ""){
                      showToast(passwordEmptyErrorText, gradientStart);
                      return;
                    }
                    if(confirmPasswordController.text == ""){
                      showToast(passwordEmptyErrorText, gradientStart);
                      return;
                    }
                    if(newPasswordController.text != confirmPasswordController.text){
                      showToast(passwordMismatchErrorText, gradientStart);
                    }
                    profileBloc.add(ChangePasswordEvent(oldPassword: oldPasswordController.text, newPassword: newPasswordController.text));
                  },
                  child: const SizedBox(
                    width: 50,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        saveButtonText,
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
              body: SafeArea(
                child: Center(
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30,),
                          /// Old password field
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width - 10 * 2,
                              height: 40,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(left: 20, right: 20),
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
                                  controller: oldPasswordController,
                                  cursorColor: primaryPlaceholderTextColor,
                                  textAlign: TextAlign.start,
                                  keyboardType: TextInputType.text,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(color: primaryWhiteTextColor),
                                    hintText: oldPasswordHintText,
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
                          const SizedBox(height: 10,),

                          /// New password field
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width - 10 * 2,
                              height: 40,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(left: 20, right: 20),
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
                                  controller: newPasswordController,
                                  cursorColor: primaryPlaceholderTextColor,
                                  textAlign: TextAlign.start,
                                  keyboardType: TextInputType.text,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(color: primaryWhiteTextColor),
                                    hintText: newPasswordHintText,
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
                          const SizedBox(height: 10,),

                          /// Confirm password field
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width - 10 * 2,
                              height: 40,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(left: 20, right: 20),
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
                                  controller: confirmPasswordController,
                                  cursorColor: primaryPlaceholderTextColor,
                                  textAlign: TextAlign.start,
                                  keyboardType: TextInputType.text,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(color: primaryWhiteTextColor),
                                    hintText: confirmPasswordPlaceholder,
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
                          const SizedBox(height: 10,),
                        ],
                      ),
                      state is PasswordChangingState ? const CupertinoActivityIndicator() : const SizedBox.shrink()
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
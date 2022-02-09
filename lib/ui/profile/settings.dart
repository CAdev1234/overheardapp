import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard_flutter_app/constants/colorset.dart';
import 'package:overheard_flutter_app/constants/fontsizeset.dart';
import 'package:overheard_flutter_app/constants/stringset.dart';
import 'package:overheard_flutter_app/ui/auth/about_us.dart';
import 'package:overheard_flutter_app/ui/auth/bloc/auth.bloc.dart';
import 'package:overheard_flutter_app/ui/auth/faq.dart';
import 'package:overheard_flutter_app/ui/auth/privacypolicy.dart';
import 'package:overheard_flutter_app/ui/auth/repository/auth.repository.dart';
import 'package:overheard_flutter_app/ui/auth/signin.dart';
import 'package:overheard_flutter_app/ui/auth/termsofuse.dart';
import 'package:overheard_flutter_app/ui/profile/blocked_users.dart';
import 'package:overheard_flutter_app/ui/profile/change_password.dart';
import 'package:overheard_flutter_app/ui/profile/repository/profile.repository.dart';

import 'bloc/profile.bloc.dart';
import 'bloc/profile.state.dart';

class SettingScreen extends StatefulWidget{
  @override
  SettingScreenState createState() {
    return new SettingScreenState();
  }

}

class SettingScreenState extends State<SettingScreen>{
  late ProfileBloc profileBloc;
  @override
  void initState(){
    super.initState();
    profileBloc = new ProfileBloc(profileRepository: ProfileRepository());
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
          appBar: const CupertinoNavigationBar(
            middle: Text(
              SettingsText,
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
                        /// Privacy Text
                        Container(
                          height: 40,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: primaryWhiteTextColor.withOpacity(0.2),
                            border: const Border(
                              bottom: BorderSide(width: 0.4, color: primaryWhiteTextColor)
                            )
                          ),
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              privacyText,
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                color: primaryPlaceholderTextColor,
                                fontSize: primaryTextFieldFontSize - 2
                              ),
                            ),
                          ),
                        ),
                        /// Change Password Text
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => BlocProvider(
                              create: (context) => ProfileBloc(profileRepository: ProfileRepository()),
                              child: ChangePasswordScreen(),
                            )));
                          },
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: primaryWhiteTextColor.withOpacity(0.2),
                                border: const Border(
                                    bottom: BorderSide(width: 0.4, color: primaryWhiteTextColor)
                                )
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    changePasswordText,
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        color: primaryWhiteTextColor,
                                        fontSize: primaryTextFieldFontSize
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: primaryWhiteTextColor,
                                  size: 15,
                                )
                              ],
                            ),
                          ),
                        ),
                        /// Add Email
                       /* GestureDetector(
                          onTap: (){

                          },
                          child: Container(
                            height: 50,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: primaryWhiteTextColor.withOpacity(0.2),
                                border: Border(
                                    bottom: BorderSide(width: 0.4, color: primaryWhiteTextColor)
                                )
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    addEmailText,
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        color: primaryWhiteTextColor,
                                        fontSize: primaryTextFieldFontSize
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: primaryWhiteTextColor,
                                  size: 15,
                                )
                              ],
                            ),
                          ),
                        ),*/
                        /// Blocked User
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => BlocProvider(
                              create: (context) => ProfileBloc(profileRepository: ProfileRepository()),
                              child: BlockedUserScreen(),
                            )));
                          },
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: primaryWhiteTextColor.withOpacity(0.2),
                                border: const Border(
                                    bottom: BorderSide(width: 0.4, color: primaryWhiteTextColor)
                                )
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    blockedUserText,
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        color: primaryWhiteTextColor,
                                        fontSize: primaryTextFieldFontSize
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: primaryWhiteTextColor,
                                  size: 15,
                                )
                              ],
                            ),
                          ),
                        ),
                        /// My Payments
                        /*GestureDetector(
                          onTap: (){

                          },
                          child: Container(
                            height: 50,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: primaryWhiteTextColor.withOpacity(0.2),
                                border: Border(
                                    bottom: BorderSide(width: 0.4, color: primaryWhiteTextColor)
                                )
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    myPaymentsText,
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        color: primaryWhiteTextColor,
                                        fontSize: primaryTextFieldFontSize
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: primaryWhiteTextColor,
                                  size: 15,
                                )
                              ],
                            ),
                          ),
                        ),
                        /// Notifications
                        GestureDetector(
                          onTap: (){

                          },
                          child: Container(
                            height: 50,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: primaryWhiteTextColor.withOpacity(0.2),
                                border: Border(
                                    bottom: BorderSide(width: 0.4, color: primaryWhiteTextColor)
                                )
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    notificationText,
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        color: primaryWhiteTextColor,
                                        fontSize: primaryTextFieldFontSize
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: primaryWhiteTextColor,
                                  size: 15,
                                )
                              ],
                            ),
                          ),
                        ),*/

                        /// About App Text
                        Container(
                          height: 40,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: primaryWhiteTextColor.withOpacity(0.2),
                              border: const Border(
                                  bottom: BorderSide(width: 0.4, color: primaryWhiteTextColor)
                              )
                          ),
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              aboutAppText,
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: primaryPlaceholderTextColor,
                                  fontSize: primaryTextFieldFontSize - 2
                              ),
                            ),
                          ),
                        ),
                        /// Terms and Conditions
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => BlocProvider(
                              create: (context) => AuthBloc(authRepository: AuthRepository()),
                              child: TermsOfUseScreen(),
                            )));
                          },
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: primaryWhiteTextColor.withOpacity(0.2),
                                border: const Border(
                                    bottom: BorderSide(width: 0.4, color: primaryWhiteTextColor)
                                )
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    termsAndConditionsText,
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        color: primaryWhiteTextColor,
                                        fontSize: primaryTextFieldFontSize
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: primaryWhiteTextColor,
                                  size: 15,
                                )
                              ],
                            ),
                          ),
                        ),
                        /// Privacy Policy
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => BlocProvider(
                              create: (context) => AuthBloc(authRepository: AuthRepository()),
                              child: PrivacyPolicyScreen(),
                            )));
                          },
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: primaryWhiteTextColor.withOpacity(0.2),
                                border: const Border(
                                    bottom: BorderSide(width: 0.4, color: primaryWhiteTextColor)
                                )
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    privacyPolicyText,
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        color: primaryWhiteTextColor,
                                        fontSize: primaryTextFieldFontSize
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: primaryWhiteTextColor,
                                  size: 15,
                                )
                              ],
                            ),
                          ),
                        ),
                        /// About Us
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => BlocProvider(
                              create: (context) => AuthBloc(authRepository: AuthRepository()),
                              child: AboutUsScreen(),
                            )));
                          },
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: primaryWhiteTextColor.withOpacity(0.2),
                                border: const Border(
                                    bottom: BorderSide(width: 0.4, color: primaryWhiteTextColor)
                                )
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    aboutUsText,
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        color: primaryWhiteTextColor,
                                        fontSize: primaryTextFieldFontSize
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: primaryWhiteTextColor,
                                  size: 15,
                                )
                              ],
                            ),
                          ),
                        ),
                        /// Contact us
                        /*GestureDetector(
                          onTap: (){

                          },
                          child: Container(
                            height: 50,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: primaryWhiteTextColor.withOpacity(0.2),
                                border: Border(
                                    bottom: BorderSide(width: 0.4, color: primaryWhiteTextColor)
                                )
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    contactUsText,
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        color: primaryWhiteTextColor,
                                        fontSize: primaryTextFieldFontSize
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: primaryWhiteTextColor,
                                  size: 15,
                                )
                              ],
                            ),
                          ),
                        ),*/
                        /*/// FAQ
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => BlocProvider(
                              create: (context) => AuthBloc(authRepository: AuthRepository()),
                              child: FaqScreen(),
                            )));
                          },
                          child: Container(
                            height: 50,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: primaryWhiteTextColor.withOpacity(0.2),
                                border: Border(
                                    bottom: BorderSide(width: 0.4, color: primaryWhiteTextColor)
                                )
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    faqText,
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        color: primaryWhiteTextColor,
                                        fontSize: primaryTextFieldFontSize
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: primaryWhiteTextColor,
                                  size: 15,
                                )
                              ],
                            ),
                          ),
                        ),*/

                        const SizedBox(height: 20),
                        /// Logout
                        GestureDetector(
                          onTap: () async {
                            var logout = await profileBloc.logout();
                            if(logout != null && logout){

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                        create: (context) => AuthBloc(authRepository: AuthRepository()),
                                        child: SignInScreen(),
                                      )
                                  ),
                                  ModalRoute.withName("/Signin")
                              );
                            }
                          },
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: primaryWhiteTextColor.withOpacity(0.2),
                                border: const Border(
                                    top: BorderSide(width: 0.4, color: primaryWhiteTextColor),
                                    bottom: BorderSide(width: 0.4, color: primaryWhiteTextColor)
                                )
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    logoutText,
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        color: primaryWhiteTextColor,
                                        fontSize: primaryTextFieldFontSize,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
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
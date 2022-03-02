import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/constants/colorset.dart';
import 'package:overheard/constants/fontsizeset.dart';
import 'package:overheard/constants/stringset.dart';
import 'package:overheard/ui/auth/about_us.dart';
import 'package:overheard/ui/auth/bloc/auth_bloc.dart';
import 'package:overheard/ui/auth/faq.dart';
// import 'package:overheard/ui/auth/faq.dart';
import 'package:overheard/ui/auth/privacypolicy.dart';
import 'package:overheard/ui/auth/repository/auth.repository.dart';
import 'package:overheard/ui/auth/signin.dart';
import 'package:overheard/ui/auth/termsofuse.dart';
import 'package:overheard/ui/components/glassmorphism.dart';
import 'package:overheard/ui/profile/blocked_users.dart';
import 'package:overheard/ui/profile/change_password.dart';
import 'package:overheard/ui/profile/repository/profile.repository.dart';

import 'bloc/profile_bloc.dart';
import 'bloc/profile_state.dart';

class SettingScreen extends StatefulWidget{
  const SettingScreen({Key? key}) : super(key: key);

  @override
  SettingScreenState createState() {
    return SettingScreenState();
  }

}

class SettingScreenState extends State<SettingScreen>{
  late ProfileBloc profileBloc;
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
          appBar: const CupertinoNavigationBar(
            middle: Text(
              settingsText,
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
                          decoration: const BoxDecoration(
                            border: Border(
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
                              child: const ChangePasswordScreen(),
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
                        GestureDetector(
                          onTap: (){

                          },
                          child: Glassmorphism(
                            blur: 20, 
                            opacity: 0.2, 
                            borderRadius: 0, 
                            child: Container(
                              height: 50,
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(width: 0.4, color: primaryWhiteTextColor)
                                )
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
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
                          )
                        ),
                        /// Blocked User
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => BlocProvider(
                              create: (context) => ProfileBloc(profileRepository: ProfileRepository()),
                              child: const BlockedUserScreen(),
                            )));
                          },
                          child: Glassmorphism(
                            blur: 20, 
                            opacity: 0.2, 
                            borderRadius: 0, 
                            child: Container(
                              height: 50,
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  border: Border(
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
                          )
                        ),
                        /// My Payments
                        GestureDetector(
                          onTap: (){

                          },
                          child: Glassmorphism(
                            blur: 20, 
                            opacity: 0.2, 
                            borderRadius: 0, 
                            child: Container(
                              height: 50,
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(width: 0.4, color: primaryWhiteTextColor)
                                  )
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
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
                          )
                        ),

                        /// Notifications
                        GestureDetector(
                          onTap: (){

                          },
                          child: Glassmorphism(
                            blur: 20,
                            opacity: 0.2,
                            borderRadius: 0,
                            child: Container(
                              height: 50,
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(width: 0.4, color: primaryWhiteTextColor)
                                  )
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
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
                          )
                        ),

                        /// About App Text
                        Container(
                          height: 40,
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              border: Border(
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
                              child: const TermsOfUseScreen(),
                            )));
                          },
                          child: Glassmorphism(
                            blur: 20, 
                            opacity: 0.2, 
                            borderRadius: 0, 
                            child: Container(
                              height: 50,
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  border: Border(
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
                          )
                        ),
                        /// Privacy Policy
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => BlocProvider(
                              create: (context) => AuthBloc(authRepository: AuthRepository()),
                              child: const PrivacyPolicyScreen(),
                            )));
                          },
                          child: Glassmorphism(
                            blur: 20, 
                            opacity: 0.2, 
                            borderRadius: 0, 
                            child: Container(
                              height: 50,
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  border: Border(
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
                          )
                        ),
                        /// About Us
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => BlocProvider(
                              create: (context) => AuthBloc(authRepository: AuthRepository()),
                              child: const AboutUsScreen(),
                            )));
                          },
                          child: Glassmorphism(
                            blur: 20, 
                            opacity: 0.2, 
                            borderRadius: 0, 
                            child: Container(
                              height: 50,
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  border: Border(
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
                          )
                        ),
                        /// Contact us
                        GestureDetector(
                          onTap: (){

                          },
                          child: Glassmorphism(
                            blur: 20, 
                            opacity: 0.2, 
                            borderRadius: 0, 
                            child: Container(
                              height: 50,
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(width: 0.4, color: primaryWhiteTextColor)
                                  )
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
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
                          )
                        ),
                        /// FAQ
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => BlocProvider(
                              create: (context) => AuthBloc(authRepository: AuthRepository()),
                              child: const FaqScreen(),
                            )));
                          },
                          child: Glassmorphism(
                            blur: 20, 
                            opacity: 0.2, 
                            borderRadius: 0, 
                            child: Container(
                              height: 50,
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(width: 0.4, color: primaryWhiteTextColor)
                                  )
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
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
                          )
                        ),

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
                                        child: const SignInScreen(),
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
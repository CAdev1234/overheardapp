import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:overheard_flutter_app/constants/colorset.dart';
import 'package:overheard_flutter_app/constants/fontsizeset.dart';
import 'package:overheard_flutter_app/constants/stringset.dart';
import 'package:overheard_flutter_app/ui/auth/bloc/auth.bloc.dart';
import 'package:overheard_flutter_app/ui/auth/privacypolicy.dart';
import 'package:overheard_flutter_app/ui/auth/repository/auth.repository.dart';
import 'package:overheard_flutter_app/ui/auth/termsofuse.dart';
import 'package:overheard_flutter_app/utils/ui_elements.dart';
import 'dart:io' show Platform;

import 'bloc/auth.event.dart';
import 'bloc/auth.state.dart';

class SignUpScreen extends StatefulWidget{
  @override
  SignUpScreenState createState() {
    return new SignUpScreenState();
  }

}

class SignUpScreenState extends State<SignUpScreen>{

  late AuthBloc authBloc;
  late TextEditingController emailController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  @override
  void initState(){
    super.initState();
    authBloc = new AuthBloc(authRepository: AuthRepository());
    emailController = new TextEditingController();
    usernameController = new TextEditingController();
    passwordController = new TextEditingController();
    confirmPasswordController = new TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: authBloc,
      listener: (context, state){
        if(state is SignUpSuccessState){
          showToast(signUpSuccessText, gradientStart);
        }
        else if(state is SignUpFailedState){
          showToast(signUpFailedText, gradientStart);
        }
      },
      child: Container(
        decoration: primaryBoxDecoration,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: BlocBuilder<AuthBloc, AuthState>(
            bloc: authBloc,
            builder: (context, state){
              return SafeArea(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              image: DecorationImage(
                                  image: AssetImage('assets/images/logo.png',),
                                  fit: BoxFit.cover
                              )
                          ),
                        ),
                        Text(
                          appName,
                          style: TextStyle(
                              color: primaryWhiteTextColor,
                              fontSize: splashFontSize,
                              letterSpacing: 4,
                              fontWeight: FontWeight.bold
                          ),
                          textScaleFactor: 1.0,
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        Container(
                          padding: EdgeInsets.only(left: 30, right: 30),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                                textSelectionHandleColor: Colors.white,
                                primaryColor: primaryDividerColor,
                                scaffoldBackgroundColor:Colors.white,
                                accentColor: Colors.white,
                                dividerColor: Colors.white,
                                hintColor: Colors.white
                            ),
                            child: TextField(
                              controller: emailController,
                              cursorColor: primaryPlaceholderTextColor,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  hintText: emailPlaceholder,
                                  hintStyle: TextStyle(color: primaryWhiteTextColor),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  )
                              ),
                              style: TextStyle(
                                  color: primaryWhiteTextColor,
                                  fontSize: primaryTextFieldFontSize
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 30, right: 30),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                                textSelectionHandleColor: Colors.white,
                                primaryColor: primaryDividerColor,
                                scaffoldBackgroundColor:Colors.white,
                                accentColor: Colors.white,
                                dividerColor: Colors.white,
                                hintColor: Colors.white
                            ),
                            child: TextField(
                              controller: usernameController,
                              cursorColor: primaryPlaceholderTextColor,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  hintText: usernamePlaceholder,
                                  hintStyle: TextStyle(color: primaryWhiteTextColor),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  )
                              ),
                              style: TextStyle(
                                  color: primaryWhiteTextColor,
                                  fontSize: primaryTextFieldFontSize
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 30, right: 30),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                                textSelectionHandleColor: Colors.white,
                                primaryColor: primaryDividerColor,
                                scaffoldBackgroundColor:Colors.white,
                                accentColor: Colors.white
                            ),
                            child: TextField(
                              controller: passwordController,
                              cursorColor: primaryPlaceholderTextColor,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: passwordPlaceholder,
                                hintStyle: TextStyle(color: primaryWhiteTextColor),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              style: TextStyle(
                                  color: primaryWhiteTextColor,
                                  fontSize: primaryTextFieldFontSize
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 30, right: 30),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                                textSelectionHandleColor: Colors.white,
                                primaryColor: primaryDividerColor,
                                scaffoldBackgroundColor:Colors.white,
                                accentColor: Colors.white
                            ),
                            child: TextField(
                              controller: confirmPasswordController,
                              cursorColor: primaryPlaceholderTextColor,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: confirmPasswordPlaceholder,
                                hintStyle: TextStyle(color: primaryWhiteTextColor),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              style: TextStyle(
                                  color: primaryWhiteTextColor,
                                  fontSize: primaryTextFieldFontSize
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: (){
                            if(emailController.text == null || emailController.text == ""){
                              Scaffold.of(context).showSnackBar(getSnackBar(context, emailEmptyErrorText));
                              return;
                            }
                            if(usernameController.text == null || usernameController.text == ""){
                              Scaffold.of(context).showSnackBar(getSnackBar(context, usernameEmptyErrorText));
                              return;
                            }
                            if(passwordController.text == null || passwordController.text == ""){
                              Scaffold.of(context).showSnackBar(getSnackBar(context, passwordEmptyErrorText));
                              return;
                            }
                            if(passwordController.text != confirmPasswordController.text){
                              Scaffold.of(context).showSnackBar(getSnackBar(context, passwordMismatchErrorText));
                              return;
                            }
                            if(!EmailValidator.validate(emailController.text)){
                              Scaffold.of(context).showSnackBar(getSnackBar(context, invalidEmailErrorText));
                              return;
                            }
                            authBloc..add(SignUpEvent(
                                email: emailController.text,
                                userName: usernameController.text,
                                password: passwordController.text
                            ));
                            /// Terms and Conditions Agreement Alert
                            /*showDialog(
                              context: context,
                              builder: (BuildContext context) => new CupertinoAlertDialog(
                                title: Padding(
                                  padding: EdgeInsetsDirectional.only(bottom: 10),
                                  child: new Text(
                                    acceptTermsAlertTitle,
                                    style: TextStyle(
                                      fontSize: primaryButtonFontSize,
                                      color: primaryBlueTextColor
                                    ),
                                    textScaleFactor: 1.0,
                                  ),
                                ),
                                content: new Text(
                                    acceptTermsAlertContent,
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
                                      child: new Text(
                                          CancelButtonText,
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
                                      },
                                      child: new Text(
                                          acceptTermsAgreeButtonText,
                                          style: TextStyle(
                                              color: primaryBlueTextColor,
                                              fontSize: primaryButtonMiddleFontSize
                                          ),
                                      )
                                  )
                                ],
                              ),
                            );*/
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            width: MediaQuery.of(context).size.width * 0.7,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: primaryWhiteTextColor,
                                border: Border.all(
                                    color: primaryWhiteTextColor,
                                    width: 1
                                )
                            ),
                            child: state is LoadingState ?
                            CupertinoActivityIndicator():
                            Text(
                              signUpText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: gradientEnd,
                                  fontSize: primaryButtonFontSize,
                                  fontWeight: FontWeight.bold
                              ),
                              textScaleFactor: 1.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 20),
                            GestureDetector(
                              onTap: (){
                                authBloc..add(FacebookSignUpEvent());
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                        color: primaryWhiteTextColor,
                                        width: 3
                                    )
                                ),
                                child: Icon(
                                  FontAwesomeIcons.facebookF,
                                  color: primaryWhiteTextColor,
                                ),
                              ),
                            ),
                            Platform.isIOS ? GestureDetector(
                              onTap: (){
                                authBloc..add(AppleSignUpEvent());
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                        color: primaryWhiteTextColor,
                                        width: 3
                                    )
                                ),
                                child: Icon(
                                  FontAwesomeIcons.apple,
                                  color: primaryWhiteTextColor,
                                ),
                              ),
                            ): SizedBox.shrink(),
                            GestureDetector(
                              onTap: (){
                                authBloc..add(TwitterSignUpEvent());
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                        color: primaryWhiteTextColor,
                                        width: 3
                                    )
                                ),
                                child: Icon(
                                  FontAwesomeIcons.twitter,
                                  color: primaryWhiteTextColor,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                          ],
                        ),
                        SizedBox(height: 40),
                        Container(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  haveAccount,
                                  style: TextStyle(
                                      color: primaryWhiteTextColor,
                                      fontSize: primaryTextFieldFontSize
                                  ),
                                  textScaleFactor: 1.0,
                                ),
                                SizedBox(width: 5,),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    signInText,
                                    style: TextStyle(
                                        fontSize: primaryButtonFontSize,
                                        color: primaryWhiteTextColor,
                                        fontWeight: FontWeight.bold
                                    ),
                                    textScaleFactor: 1.0,
                                  ),
                                )
                              ],
                            )
                        ),
                        SizedBox(height: 10),
                        Container(
                            padding: EdgeInsets.only(bottom: 20, left: 40, right: 40),
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              direction: Axis.horizontal,
                              children: [
                                Text(
                                  'By Clicking ',
                                  style: TextStyle(
                                      color: primaryWhiteTextColor,
                                      fontSize: smallTextFontSize
                                  ),
                                  textScaleFactor: 1.0,
                                ),
                                Text(
                                  signUpText,
                                  style: TextStyle(
                                      color: primaryWhiteTextColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: smallTextFontSize
                                  ),
                                  textScaleFactor: 1.0,
                                ),
                                Text(
                                  ' you agree to our  ',
                                  style: TextStyle(
                                      color: primaryWhiteTextColor,
                                      fontSize: smallTextFontSize + 1
                                  ),
                                  textScaleFactor: 1.0,
                                ),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => BlocProvider(
                                      create: (context) => AuthBloc(authRepository: AuthRepository()),
                                      child: TermsOfUseScreen(),
                                    )));
                                  },
                                  child: Text(
                                    termsOfUse,
                                    style: TextStyle(
                                        fontSize: smallTextFontSize + 1,
                                        color: primaryWhiteTextColor,
                                        fontWeight: FontWeight.bold
                                    ),
                                    textScaleFactor: 1.0,
                                  ),
                                ),
                                Text(
                                  ' and ',
                                  style: TextStyle(
                                      color: primaryWhiteTextColor,
                                      fontSize: smallTextFontSize
                                  ),
                                  textScaleFactor: 1.0,
                                ),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => BlocProvider(
                                      create: (context) => AuthBloc(authRepository: AuthRepository()),
                                      child: PrivacyPolicyScreen(),
                                    )));
                                  },
                                  child: Text(
                                    privacyPolicy,
                                    style: TextStyle(
                                        fontSize: smallTextFontSize + 1,
                                        color: primaryWhiteTextColor,
                                        fontWeight: FontWeight.bold
                                    ),
                                    textScaleFactor: 1.0,
                                  ),
                                )
                              ],
                            )
                        ),
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
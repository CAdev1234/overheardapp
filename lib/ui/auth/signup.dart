import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:overheard/constants/colorset.dart';
import 'package:overheard/constants/fontsizeset.dart';
import 'package:overheard/constants/stringset.dart';
import 'package:overheard/ui/auth/bloc/auth_bloc.dart';
import 'package:overheard/ui/auth/privacypolicy.dart';
import 'package:overheard/ui/auth/repository/auth.repository.dart';
import 'package:overheard/ui/auth/termsofuse.dart';
import 'package:overheard/utils/ui_elements.dart';
import 'dart:io' show Platform;

import 'bloc/auth_event.dart';
import 'bloc/auth_state.dart';

class SignUpScreen extends StatefulWidget{
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  SignUpScreenState createState() {
    return SignUpScreenState();
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
    authBloc = AuthBloc(authRepository: AuthRepository());
    emailController = TextEditingController();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: authBloc,
      listener: (context, state){
        // if(state is SignUpSuccessState){
        //   showToast(signUpSuccessText, gradientStart, gravity: ToastGravity.CENTER);
        // }
        // else if(state is SignUpFailedState){
        //   showToast(signUpFailedText, gradientEnd, gravity: ToastGravity.BOTTOM);
        // }
      },
      child: Container(
        decoration: primaryBoxDecoration,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: BlocBuilder<AuthBloc, AuthState>(
            // bloc: authBloc,
            builder: (context, state){
              return SafeArea(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              image: const DecorationImage(
                                  image: AssetImage('assets/images/logo.png',),
                                  fit: BoxFit.cover
                              )
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
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
                              controller: emailController,
                              cursorColor: primaryPlaceholderTextColor,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                  hintText: emailPlaceholder,
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
                              controller: usernameController,
                              cursorColor: primaryPlaceholderTextColor,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  hintText: usernamePlaceholder,
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
                                // accentColor: Colors.white
                            ),
                            child: TextField(
                              controller: passwordController,
                              cursorColor: primaryPlaceholderTextColor,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: passwordPlaceholder,
                                hintStyle: TextStyle(color: primaryWhiteTextColor),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
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
                                // accentColor: Colors.white
                            ),
                            child: TextField(
                              controller: confirmPasswordController,
                              cursorColor: primaryPlaceholderTextColor,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: confirmPasswordPlaceholder,
                                hintStyle: TextStyle(color: primaryWhiteTextColor),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              style: const TextStyle(
                                  color: primaryWhiteTextColor,
                                  fontSize: primaryTextFieldFontSize
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: (){
                            if(emailController.text == ""){
                              showToast(emailEmptyErrorText, gradientEnd);
                              return;
                            }
                            if(usernameController.text == ""){
                              showToast(usernameEmptyErrorText, gradientEnd);
                              return;
                            }
                            if(passwordController.text == ""){
                              showToast(passwordEmptyErrorText, gradientEnd);
                              return;
                            }
                            if(passwordController.text != confirmPasswordController.text){
                              showToast(passwordMismatchErrorText, gradientEnd);
                              return;
                            }
                            if(!EmailValidator.validate(emailController.text)){
                              showToast(invalidEmailErrorText, gradientEnd);
                              return;
                            }
                            // authBloc.add(SignUpEvent(
                            //     email: emailController.text,
                            //     userName: usernameController.text,
                            //     password: passwordController.text
                            // ));
                            context.read<AuthBloc>().add(SignUpEvent(email: emailController.text, name: usernameController.text, password: passwordController.text));
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
                            padding: const EdgeInsets.all(12),
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
                            const CupertinoActivityIndicator():
                            const Text(
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
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 20),
                            GestureDetector(
                              onTap: (){
                                authBloc.add(const FacebookSignUpEvent());
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                        color: primaryWhiteTextColor,
                                        width: 3
                                    )
                                ),
                                child: const Icon(
                                  FontAwesomeIcons.facebookF,
                                  color: primaryWhiteTextColor,
                                ),
                              ),
                            ),
                            Platform.isIOS ? GestureDetector(
                              onTap: (){
                                authBloc.add(const AppleSignUpEvent());
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                        color: primaryWhiteTextColor,
                                        width: 3
                                    )
                                ),
                                child: const Icon(
                                  FontAwesomeIcons.apple,
                                  color: primaryWhiteTextColor,
                                ),
                              ),
                            ): const SizedBox.shrink(),
                            GestureDetector(
                              onTap: (){
                                authBloc.add(const TwitterSignUpEvent());
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                        color: primaryWhiteTextColor,
                                        width: 3
                                    )
                                ),
                                child: const Icon(
                                  FontAwesomeIcons.twitter,
                                  color: primaryWhiteTextColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Container(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  haveAccount,
                                  style: TextStyle(
                                      color: primaryWhiteTextColor,
                                      fontSize: primaryTextFieldFontSize
                                  ),
                                  textScaleFactor: 1.0,
                                ),
                                const SizedBox(width: 5,),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
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
                        const SizedBox(height: 10),
                        Container(
                            padding: const EdgeInsets.only(bottom: 20, left: 40, right: 40),
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              direction: Axis.horizontal,
                              children: [
                                const Text(
                                  'By Clicking ',
                                  style: TextStyle(
                                      color: primaryWhiteTextColor,
                                      fontSize: smallTextFontSize
                                  ),
                                  textScaleFactor: 1.0,
                                ),
                                const Text(
                                  signUpText,
                                  style: TextStyle(
                                      color: primaryWhiteTextColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: smallTextFontSize
                                  ),
                                  textScaleFactor: 1.0,
                                ),
                                const Text(
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
                                      child: const TermsOfUseScreen(),
                                    )));
                                  },
                                  child: const Text(
                                    termsOfUse,
                                    style: TextStyle(
                                        fontSize: smallTextFontSize + 1,
                                        color: primaryWhiteTextColor,
                                        fontWeight: FontWeight.bold
                                    ),
                                    textScaleFactor: 1.0,
                                  ),
                                ),
                                const Text(
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
                                      child: const PrivacyPolicyScreen(),
                                    )));
                                  },
                                  child: const Text(
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
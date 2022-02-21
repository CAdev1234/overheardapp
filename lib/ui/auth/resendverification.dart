import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:overheard/constants/colorset.dart';
import 'package:overheard/constants/fontsizeset.dart';
import 'package:overheard/constants/stringset.dart';
import 'package:overheard/ui/auth/bloc/auth_bloc.dart';
import 'package:overheard/ui/auth/bloc/auth_event.dart';
import 'package:overheard/ui/auth/repository/auth.repository.dart';
import 'package:overheard/utils/ui_elements.dart';

import 'bloc/auth_state.dart';

class ResendVerificationScreen extends StatefulWidget{
  const ResendVerificationScreen({Key? key}) : super(key: key);

  @override
  ResendVerificationScreenState createState() {
    return ResendVerificationScreenState();
  }

}

class ResendVerificationScreenState extends State<ResendVerificationScreen>{

  late AuthBloc authBloc;
  late TextEditingController emailController;

  @override
  void initState(){
    super.initState();
    authBloc = AuthBloc(authRepository: AuthRepository());
    emailController = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: authBloc,
      listener: (context, state){
        if(state is VerifySuccessState){

        }
        else if(state is VerifyFailedState){

        }
      },
      child: Container(
        decoration: primaryBoxDecoration,
        child: Scaffold(
          appBar: const CupertinoNavigationBar(
            middle: Text(
              resendVerificationAppBarTitle,
              style: TextStyle(
                fontSize: appBarTitleFontSize,
                color: primaryWhiteTextColor
              ),
              textScaleFactor: 1.0,
            ),
          ),
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
                        const SizedBox(height: 20),
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
                              decoration: InputDecoration(
                                  hintText: emailPlaceholder,
                                  hintStyle: TextStyle(color: primaryWhiteTextColor.withOpacity(0.8)),
                                  enabledBorder: const UnderlineInputBorder(
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
                        const SizedBox(
                          height: 20,
                        ),
                      GestureDetector(
                        onTap: (){
                          if(emailController.text == ''){
                            showToast(emailEmptyErrorText, gradientStart);
                            return;
                          }
                          if(!EmailValidator.validate(emailController.text)){
                            showToast(invalidEmailErrorText, gradientStart);
                            return;
                          }
                          authBloc.add(EmailVerifyResendEvent(email: emailController.text));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: primaryWhiteTextColor,
                              border: Border.all(
                                  color: primaryWhiteTextColor,
                                  width: 1
                              )
                          ),
                          child: const Text(
                            resendVerificationText,
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
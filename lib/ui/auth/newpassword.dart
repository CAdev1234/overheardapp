import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard_flutter_app/constants/colorset.dart';
import 'package:overheard_flutter_app/constants/fontsizeset.dart';
import 'package:overheard_flutter_app/constants/stringset.dart';
import 'package:overheard_flutter_app/ui/auth/repository/auth.repository.dart';
import 'package:overheard_flutter_app/ui/auth/signin.dart';
import 'package:overheard_flutter_app/utils/ui_elements.dart';

import 'bloc/auth_bloc.dart';
import 'bloc/auth_event.dart';
import 'bloc/auth_state.dart';

class NewPasswordScreen extends StatefulWidget {
  final String email;
  final String token;
  const NewPasswordScreen({Key? key, required this.email, required this.token}) : super(key: key);

  @override
  _NewPasswordScreenState createState() {
    return _NewPasswordScreenState();
  }
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  late AuthBloc authBloc;
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;

  @override
  void initState() {
    super.initState();
    authBloc = AuthBloc(authRepository: AuthRepository());
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
      bloc: authBloc,
      listener: (context, state){
        if(state is SignInSuccessState){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BlocProvider(
            create: (context) => AuthBloc(authRepository: AuthRepository()),
            child: const SignInScreen(),
          )));
        }
      },
      child: Container(
        decoration: primaryBoxDecoration,
        child: Scaffold(
          appBar: const CupertinoNavigationBar(
            middle: Text(
              newPasswordAppBarTitle,
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
                              controller: newPasswordController,
                              cursorColor: primaryPlaceholderTextColor,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              decoration: InputDecoration(
                                  hintText: newPasswordHintText,
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
                        const SizedBox(height: 10,),
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
                              controller: confirmPasswordController,
                              cursorColor: primaryPlaceholderTextColor,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              decoration: InputDecoration(
                                  hintText: confirmPasswordPlaceholder,
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
                            if(newPasswordController.text == ""){
                              Scaffold.of(context).showSnackBar(getSnackBar(context, passwordEmptyErrorText));
                              return;
                            }
                            if(confirmPasswordController.text == ""){
                              Scaffold.of(context).showSnackBar(getSnackBar(context, passwordMismatchErrorText));
                              return;
                            }
                            if(confirmPasswordController.text != newPasswordController.text){
                              Scaffold.of(context).showSnackBar(getSnackBar(context, passwordMismatchErrorText));
                              return;
                            }
                            authBloc.add(ResetPasswordEvent(email: widget.email, token: widget.token, password: newPasswordController.text));
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
                            child: state is LoadingState ? const CupertinoActivityIndicator() :
                            const Text(
                              resetPasswordText,
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
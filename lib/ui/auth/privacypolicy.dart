import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/constants/colorset.dart';
import 'package:overheard/constants/fontsizeset.dart';
import 'package:overheard/constants/stringset.dart';
import 'package:overheard/ui/auth/repository/auth.repository.dart';

import 'bloc/auth_bloc.dart';
import 'bloc/auth_state.dart';

class PrivacyPolicyScreen extends StatefulWidget{
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  PrivacyPolicyScreenState createState() {
    return PrivacyPolicyScreenState();
  }

}

class PrivacyPolicyScreenState extends State<PrivacyPolicyScreen>{

  late AuthBloc authBloc;

  @override
  void initState(){
    super.initState();
    authBloc = AuthBloc(authRepository: AuthRepository());
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: authBloc,
      listener: (context, state){

      },
      child: Container(
        decoration: primaryBoxDecoration,
        child: Scaffold(
          appBar: const CupertinoNavigationBar(
            middle: Text(
              privacyPolicy,
              style: TextStyle(
                  fontSize: appBarTitleFontSize,
                  color: primaryWhiteTextColor
              ),
              textScaleFactor: 1.0,
            ),
          ),
          backgroundColor: primaryMixedBackgroundColor,
          body: BlocBuilder<AuthBloc, AuthState>(
            bloc: authBloc,
            builder: (context, state){
              return SafeArea(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            privacyPolicyContent,
                            style: TextStyle(
                                color: primaryBlueTextColor,
                                fontSize: primaryTextFieldFontSize
                            ),
                          ),
                        )
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
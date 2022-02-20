import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard_flutter_app/constants/colorset.dart';
import 'package:overheard_flutter_app/constants/fontsizeset.dart';
import 'package:overheard_flutter_app/constants/stringset.dart';
import 'package:overheard_flutter_app/ui/auth/repository/auth.repository.dart';

import 'bloc/auth_bloc.dart';
import 'bloc/auth_state.dart';

class TermsOfUseScreen extends StatefulWidget{
  const TermsOfUseScreen({Key? key}) : super(key: key);

  @override
  TermsOfUseScreenState createState() {
    return TermsOfUseScreenState();
  }

}

class TermsOfUseScreenState extends State<TermsOfUseScreen>{

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
              termsOfUse,
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
                            termsOfUse_Content,
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
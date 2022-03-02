import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/constants/colorset.dart';
import 'package:overheard/constants/fontsizeset.dart';
import 'package:overheard/constants/stringset.dart';
import 'package:overheard/ui/auth/repository/auth.repository.dart';

import 'bloc/auth_bloc.dart';
import 'bloc/auth_state.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  _AboutUsScreenState createState() {
    return _AboutUsScreenState();
  }
}

class _AboutUsScreenState extends State<AboutUsScreen> {

  late AuthBloc authBloc;

  @override
  void initState() {
    super.initState();
    authBloc = AuthBloc(authRepository: AuthRepository());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      // cubit: authBloc,
      bloc: authBloc,
      listener: (context, state){

      },
      child: Container(
        decoration: primaryBoxDecoration,
        child: Scaffold(
          appBar: const CupertinoNavigationBar(
            middle: Text(
              aboutUsText,
              style: TextStyle(
                  fontSize: appBarTitleFontSize,
                  color: primaryWhiteTextColor
              ),
              textScaleFactor: 1.0,
            ),
          ),
          backgroundColor: primaryMixedBackgroundColor,
          body: BlocBuilder<AuthBloc, AuthState>(
            // cubit: authBloc,
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
                            aboutUsContent,
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
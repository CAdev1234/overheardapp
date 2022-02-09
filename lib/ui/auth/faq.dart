import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard_flutter_app/constants/colorset.dart';
import 'package:overheard_flutter_app/constants/fontsizeset.dart';
import 'package:overheard_flutter_app/constants/stringset.dart';
import 'package:overheard_flutter_app/ui/auth/repository/auth.repository.dart';

import 'bloc/auth.bloc.dart';
import 'bloc/auth.state.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  _FaqScreenState createState() {
    return _FaqScreenState();
  }
}

class _FaqScreenState extends State<FaqScreen> {
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
      bloc: authBloc,
      listener: (context, state){

      },
      child: Container(
        decoration: primaryBoxDecoration,
        child: Scaffold(
          appBar: const CupertinoNavigationBar(
            middle: Text(
              faqText,
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
                            faq_Content,
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
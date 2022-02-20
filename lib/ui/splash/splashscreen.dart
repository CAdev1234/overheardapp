import 'dart:async';

// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:overheard_flutter_app/constants/colorset.dart';
import 'package:overheard_flutter_app/constants/fontsizeset.dart';
import 'package:overheard_flutter_app/constants/stringset.dart';
import 'package:overheard_flutter_app/ui/auth/bloc/auth_bloc.dart';
import 'package:overheard_flutter_app/ui/auth/bloc/auth_event.dart';
import 'package:overheard_flutter_app/ui/auth/bloc/auth_state.dart';
import 'package:overheard_flutter_app/ui/auth/repository/auth.repository.dart';
import 'package:overheard_flutter_app/ui/auth/signin.dart';
import 'package:overheard_flutter_app/ui/community/bloc/community_bloc.dart';
import 'package:overheard_flutter_app/ui/community/community.dart';
import 'package:overheard_flutter_app/ui/community/repository/community.repository.dart';
import 'package:overheard_flutter_app/ui/home/bloc/home_bloc.dart';
import 'package:overheard_flutter_app/ui/home/home.dart';
import 'package:overheard_flutter_app/ui/home/repository/home.repository.dart';
import 'package:overheard_flutter_app/ui/profile/bloc/profile_bloc.dart';
import 'package:overheard_flutter_app/ui/profile/complete_profile.dart';
import 'package:overheard_flutter_app/ui/profile/repository/profile.repository.dart';
import 'package:overheard_flutter_app/utils/ui_elements.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>{

  late Timer timer;
  late AuthBloc authBloc;

  @override
  void initState(){
    super.initState();
    authBloc = AuthBloc(authRepository: AuthRepository());
    // authBloc.add(const SignInWithTokenEvent());
    startTime();
  }

  startTime() async {
    var _duration = const Duration(seconds: 5);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getBool(isFirstLogin) != null && prefs.getBool(isFirstLogin)!){
      timer = Timer(_duration, navigationToIntro);
    }
    else{
      timer = Timer(_duration, navigationToSignIn);
    }
    return timer;
  }

  void navigationToSignIn() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BlocProvider(
      create: (context) => AuthBloc(authRepository: AuthRepository()),
      child: const SignInScreen(),
    )));
  }

  void navigationToIntro() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const SignInScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: authBloc,
      listener: (context, state) async {
        if(state is SignInSuccessState){
          if(state.isFirstLogin){
            timer.cancel();
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BlocProvider(
              create: (context) => ProfileBloc(profileRepository: ProfileRepository()),
              child: CompleteProfileScreen(user: state.userModel),
            )));
          }
          else{
            timer.cancel();
            if(state.userModel.community_id == null){

              Location location = Location();

              bool _serviceEnabled;
              PermissionStatus _permissionGranted;
              LocationData _locationData;

              _serviceEnabled = await location.serviceEnabled();
              if (!_serviceEnabled) {
                _serviceEnabled = await location.requestService();
                if (!_serviceEnabled) {
                  showToast(locationPermissionDeniedErrorText, gradientStart.withOpacity(0.8), gravity: ToastGravity.CENTER);
                  return;
                }
              }

              _permissionGranted = await location.hasPermission();
              if (_permissionGranted == PermissionStatus.denied) {
                _permissionGranted = await location.requestPermission();
                if (_permissionGranted != PermissionStatus.granted) {
                  showToast(locationPermissionDeniedErrorText, gradientStart.withOpacity(0.8), gravity: ToastGravity.CENTER);
                  return;
                }
              }

              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BlocProvider(
                create: (context) => CommunityBloc(communityRepository: CommunityRepository()),
                child: const CommunityScreen(),
              )));
            }
            else{
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BlocProvider(
                create: (context) => HomeBloc(homeRepository: HomeRepository()),
                child: const HomeScreen(),
              )));
            }
          }
        }
      },
      child: Container(
        decoration: primaryBoxDecoration,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        image: const DecorationImage(
                            image: AssetImage('assets/images/logo.png',),
                            fit: BoxFit.cover
                        )
                    ),
                  ),
                  const Text(
                    appName,
                    style: TextStyle(
                        color: primaryWhiteTextColor,
                        fontSize: splashFontSize,
                        letterSpacing: 4,
                        fontWeight: FontWeight.bold
                    ),
                    textScaleFactor: 1.0,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
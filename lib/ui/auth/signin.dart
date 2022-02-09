import 'dart:async';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';
import 'package:overheard_flutter_app/constants/colorset.dart';
import 'package:overheard_flutter_app/constants/fontsizeset.dart';
import 'package:overheard_flutter_app/constants/stringset.dart';
import 'package:overheard_flutter_app/ui/auth/bloc/auth.bloc.dart';
import 'package:overheard_flutter_app/ui/auth/bloc/auth.event.dart';
import 'package:overheard_flutter_app/ui/auth/repository/auth.repository.dart';
import 'package:overheard_flutter_app/ui/auth/resendverification.dart';
import 'package:overheard_flutter_app/ui/auth/resetpassword.dart';
import 'package:overheard_flutter_app/ui/auth/signup.dart';
import 'package:overheard_flutter_app/ui/community/bloc/community.bloc.dart';
import 'package:overheard_flutter_app/ui/community/community.dart';
import 'package:overheard_flutter_app/ui/community/repository/community.repository.dart';
import 'package:overheard_flutter_app/ui/home/bloc/home.bloc.dart';
import 'package:overheard_flutter_app/ui/home/home.dart';
import 'package:overheard_flutter_app/ui/home/repository/home.repository.dart';
import 'package:overheard_flutter_app/ui/profile/bloc/profile.bloc.dart';
import 'package:overheard_flutter_app/ui/profile/complete_profile.dart';
import 'package:overheard_flutter_app/ui/profile/repository/profile.repository.dart';
import 'package:overheard_flutter_app/utils/ui_elements.dart';
import 'package:location/location.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:io' show Platform;

import '../../main.dart';
import 'bloc/auth.state.dart';
import 'newpassword.dart';

class SignInScreen extends StatefulWidget{
  @override
  SignInScreenState createState() {
    return SignInScreenState();
  }

}
enum UniLinksType { string, uri }

class SignInScreenState extends State<SignInScreen>{

  late AuthBloc authBloc;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  late StreamSubscription _sub;
  String? _initialLink;
  Uri? _initialUri;
  String? _latestLink = 'Unknown';
  Uri? _latestUri;
  late BuildContext context;

  @override
  void initState(){
    super.initState();
    initPlatformState();
    authBloc = AuthBloc(authRepository: AuthRepository());
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  final UniLinksType _type = UniLinksType.string;


  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (_type == UniLinksType.string) {
      await initPlatformStateForStringUniLinks();
    } else {
      await initPlatformStateForUriUniLinks();
    }
  }

  /// An implementation using a [String] link
  Future<void> initPlatformStateForStringUniLinks() async {
    // Attach a listener to the links stream
    
    _sub = linkStream.listen((String? link) {
      if (!mounted) return;
      setState(() {
        _latestLink = link ?? 'Unknown';
        _latestUri = null;
        try {
          if (link != null) _latestUri = Uri.parse(link);
        } on FormatException {}
      });
    }, onError: (Object err) {
      if (!mounted) return;
      setState(() {
        _latestLink = 'Failed to get latest link: $err.';
        _latestUri = null;
      });
    });

    // Attach a second listener to the stream
    linkStream.listen((String? link) {
      if(link!.contains('email/verify')){
        String parameter = link.substring(link.indexOf('email/verify') - 1);
        authBloc.add(EmailVerifyEvent(parameter: parameter));
      }
      else if(link.contains('password/reset')){
        Uri uri = Uri.parse(link);
        String token = uri.queryParameters['token'] as String;
        String email = uri.queryParameters['email'] as String;
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BlocProvider(
          create: (context) => AuthBloc(authRepository: AuthRepository()),
          child: NewPasswordScreen(token: token, email: email,),
        )));
      }
    }, onError: (Object err) {
      print('got err: $err');
    });

    // Get the latest link
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _initialLink = await getInitialLink();
      print('initial link: $_initialLink');
      if (_initialLink != null) _initialUri = Uri.parse(_initialLink as String);
    } on PlatformException {
      _initialLink = 'Failed to get initial link.';
      _initialUri = null;
    } on FormatException {
      _initialLink = 'Failed to parse the initial link as Uri.';
      _initialUri = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _latestLink = _initialLink;
      _latestUri = _initialUri;
    });
  }

  /// An implementation using the [Uri] convenience helpers
  Future<void> initPlatformStateForUriUniLinks() async {
    // Attach a listener to the Uri links stream
    _sub = uriLinkStream.listen((Uri? uri) {
      if (!mounted) return;
      setState(() {
        _latestUri = uri;
        _latestLink = uri?.toString() ?? 'Unknown';
      });
    }, onError: (Object err) {
      if (!mounted) return;
      setState(() {
        _latestUri = null;
        _latestLink = 'Failed to get latest link: $err.';
      });
    });

    // Attach a second listener to the stream
    uriLinkStream.listen((Uri? uri) {
      print('got uri: ${uri?.path} ${uri?.queryParametersAll}');
    }, onError: (Object err) {
      print('got err: $err');
    });

    // Get the latest Uri
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _initialUri = await getInitialUri();
      print('initial uri: ${_initialUri?.path}'
          ' ${_initialUri?.queryParametersAll}');
      _initialLink = _initialUri?.toString();
    } on PlatformException {
      _initialUri = null;
      _initialLink = 'Failed to get initial uri.';
    } on FormatException {
      _initialUri = null;
      _initialLink = 'Bad parse the initial link as Uri.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _latestUri = _initialUri;
      _latestLink = _initialLink;
    });
  }


  @override
  Widget build(BuildContext context) {
    this.context = context;
    return BlocListener(
      bloc: authBloc,
      listener: (context, state) async {
        if(state is SignInSuccessState) {
          Location location = new Location();
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

          if(state.isFirstLogin){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BlocProvider(
              create: (context) => ProfileBloc(profileRepository: ProfileRepository()),
              child: CompleteProfileScreen(user: state.userModel,),
            )));
          }
          else{
            if(state.userModel.community_id == null){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BlocProvider(
                create: (context) => CommunityBloc(communityRepository: CommunityRepository()),
                child: CommunityScreen(),
              )));
            }
            else{
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BlocProvider(
                create: (context) => HomeBloc(homeRepository: HomeRepository()),
                child: HomeScreen(),
              )));
            }
          }
        }
        else if(state is VerifySuccessState){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BlocProvider(
            create: (context) => AuthBloc(authRepository: AuthRepository()),
            child: SignInScreen(),
          )));
        }
        else if(state is VerifyFailedState){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => BlocProvider(
            create: (context) => AuthBloc(authRepository: AuthRepository()),
            child: ResendVerificationScreen(),
          )));
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
                        SizedBox(height: MediaQuery.of(context).size.height * 0.08),
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
                        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
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
                                  suffixIcon: GestureDetector(
                                    onTap: (){
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => BlocProvider(
                                        create: (context) => AuthBloc(authRepository: AuthRepository()),
                                        child: ResetPassword(),
                                      )));
                                    },
                                    child: Container(
                                      width: 150,
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        forgotYourPassword,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: primaryWhiteTextColor,
                                            fontSize: smallTextFontSize
                                        ),
                                        textScaleFactor: 1.0,
                                      ),
                                    ),
                                  )
                              ),
                              style: TextStyle(
                                  color: primaryWhiteTextColor,
                                  fontSize: primaryTextFieldFontSize
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: (){
                            if(emailController.text == null || emailController.text == ""){
                              Scaffold.of(context).showSnackBar(getSnackBar(context, emailEmptyErrorText));
                              return;
                            }
                            if(passwordController.text == null || passwordController.text == ""){
                              Scaffold.of(context).showSnackBar(getSnackBar(context, passwordEmptyErrorText));
                              return;
                            }
                            if(!EmailValidator.validate(emailController.text)){
                              Scaffold.of(context).showSnackBar(getSnackBar(context, invalidEmailErrorText));
                              return;
                            }
                            authBloc..add(SignInEvent(email: emailController.text, password: passwordController.text));
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width * 0.7,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: primaryWhiteTextColor,
                                border: Border.all(
                                    color: primaryWhiteTextColor,
                                    width: 1
                                )
                            ),
                            child: state is LoadingState?
                            CupertinoActivityIndicator() :
                            Text(
                              signInText,
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
                        SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 20),
                            GestureDetector(
                              onTap: (){
                                authBloc..add(FacebookSignInEvent());
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
                                authBloc..add(AppleSignInEvent());
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
                                authBloc..add(TwitterSignInEvent());
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
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          bottomNavigationBar: Container(
              padding: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    noAccount,
                    style: TextStyle(
                        color: primaryWhiteTextColor,
                        fontSize: primaryTextFieldFontSize
                    ),
                    textScaleFactor: 1.0,
                  ),
                  SizedBox(width: 5,),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => BlocProvider(
                        create: (context) => AuthBloc(authRepository: AuthRepository()),
                        child: SignUpScreen(),
                      )));
                    },
                    child: Text(
                      signUpText,
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
        ),
      ),
    );
  }

}
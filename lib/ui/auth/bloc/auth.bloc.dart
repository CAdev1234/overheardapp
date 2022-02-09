import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_icons/flutter_icons.dart';
import 'package:overheard_flutter_app/constants/colorset.dart';
// import 'package:overheard_flutter_app/constants/stringset.dart';
import 'package:overheard_flutter_app/ui/auth/bloc/auth.event.dart';
import 'package:overheard_flutter_app/ui/auth/bloc/auth.state.dart';
import 'package:overheard_flutter_app/ui/auth/models/user_model.dart';
import 'package:overheard_flutter_app/ui/auth/repository/auth.repository.dart';
import 'package:overheard_flutter_app/utils/ui_elements.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
  final AuthRepository authRepository;

  String uid = "";
  String email = "";
  String source = "";

  AuthBloc({required this.authRepository}) : super(null as AuthState);

  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if(event is SignInEvent) {
      yield* _mapSignInToState(event);
    }
    else if(event is SignUpEvent){
      yield* _mapSignUpToState(event);
    }
    else if(event is EmailVerifyEvent){
      // yield* _mapEmailVerifyToState(event);
    }
    else if(event is EmailVerifyResendEvent){
      // yield* _mapEmailVerifyResendToState(event);
    }
    else if(event is FacebookSignInEvent){
      // yield* _mapFacebookSignInToState(event);
    }
    else if(event is FacebookSignUpEvent){
      // yield* _mapFacebookSignUpToState(event);
    }
    else if(event is TwitterSignInEvent){
      // yield* _mapTwitterSignInToState(event);
    }
    else if(event is TwitterSignUpEvent){
      // yield* _mapTwitterSignUpToState(event);
    }
    else if(event is AppleSignInEvent){
      // yield* _mapAppleSignInToState(event);
    }
    else if(event is AppleSignUpEvent){
      // yield* _mapAppleSignUpToState(event);
    }
    else if(event is SignInWithTokenEvent){
      // yield* _mapSignInWithTokenToState(event);
    }
    else if(event is RestorePasswordEvent){
      // yield* _mapRestorePasswordToState(event);
    }
    else if(event is ResetPasswordEvent){
      // yield* _mapResetPasswordToState(event);
    }
  }

  Stream<AuthState> _mapSignInToState(SignInEvent event) async* {
    yield const LoadingState();
    String email = event.email;
    String password = event.password;
    var credential = {
      'email': email,
      'password': password
    };
    var response = await authRepository.signInWithEmail(credential);
    if(response == null) {
      showToast("SignIn Failed", gradientStart);
      yield const SignInFailedState();
      return;
    }
    else if(response['status'] && response['user'] != null && response['user']['id'] != null){
      UserModel user = UserModel.fromJson(response['user']);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('AccessToken', response['access_token']);
      if(user.firstname == null || user.firstname == ""){
        yield SignInSuccessState(isFirstLogin: true, userModel: user);
        return;
      }
      else{
        yield SignInSuccessState(isFirstLogin: false, userModel: user);
        return;
      }
    }
    else{
      showToast(response['message'], gradientStart);
      yield const SignInFailedState();
      return;
    }
    // yield SignInFailedState();
  }

  // Stream<AuthState> _mapSignInWithTokenToState(SignInWithTokenEvent event) async* {
  //   var prefs = await SharedPreferences.getInstance();
  //   var accessToken = prefs.getString('AccessToken');
  //   if(accessToken == null){
  //     return;
  //   }

  //   var response = await authRepository.signInWithToken();
  //   if(response == null) {
  //     yield SignInFailedState();
  //   }
  //   else if(!response['status']) {
  //     showToast(response['message'], gradientStart);
  //     yield SignInFailedState();
  //   }
  //   else if(response['user']['id'] != null || response['user']['id'] == ""){
  //     UserModel user = UserModel.fromJson(response['user']);
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     prefs.setString('AccessToken', response['access_token']);
  //     if(user.firstname == null || user.lastname == null){
  //       yield SignInSuccessState(isFirstLogin: true, userModel: user);
  //     }
  //     else{
  //       yield SignInSuccessState(isFirstLogin: false, userModel: user);
  //     }
  //   }
  //   else{
  //     yield SignInFailedState();
  //   }
  //   yield SignInFailedState();
  // }

  Stream<AuthState> _mapSignUpToState(SignUpEvent event) async* {
    yield const LoadingState();
    String email = event.email;
    String username = event.userName;
    String password = event.password;
    var credential = {
      'email': email,
      'name': username,
      'password': password
    };
    var result = await authRepository.signUpWithEmail(credential);
    if(result!['status']){
      showToast(result['message'], gradientStart);
      yield const SignUpSuccessState();
      return;
    }
    else{
      showToast(result['message'], gradientStart);
      yield const SignUpFailedState();
      return;
    }
  }

  // Stream<AuthState> _mapEmailVerifyToState(EmailVerifyEvent emailVerifyEvent) async* {
  //   yield LoadingState();
  //   String parameter = emailVerifyEvent.parameter;
  //   var result = await authRepository.emailVerify(parameter);
  //   if(result['status']){
  //     showToast(result['message'], gradientStart);
  //     yield VerifySuccessState();
  //     return;
  //   }
  //   else{
  //     showToast(result['message'], gradientStart);
  //     yield VerifyFailedState();
  //     return;
  //   }
  // }

  // Stream<AuthState> _mapEmailVerifyResendToState(EmailVerifyResendEvent emailVerifyResendEvent) async* {
  //   yield LoadingState();
  //   String email = emailVerifyResendEvent.email;
  //   var result = await authRepository.emailVerifyResend(email);
  //   if(result['status']){
  //     showToast(result['message'], gradientStart);
  //     yield VerifySuccessState();
  //     return;
  //   }
  //   else{
  //     showToast(result['message'], gradientStart);
  //     yield VerifyFailedState();
  //     return;
  //   }
  // }

  // Stream<AuthState> _mapFacebookSignInToState(FacebookSignInEvent facebookSignInEvent) async* {
  //   yield LoadingState();
  //   var result = await authRepository.signInWithFaceBook();
  //   if(result == null){
  //     yield LoginFailedState();
  //   }
  //   else if(result == Map()){
  //     yield LoginCancelledState();
  //   }
  //   else if(result == null){
  //     yield LoginFailedState();
  //   }
  //   else{
  //     String uid = result['userid'];
  //     String name = result['name'];
  //     String firstName = result['first_name'];
  //     String lastName = result['last_name'];
  //     String email = result['email'];
  //     String avatar = result['picture']['data']['url'];
  //     String token = result['token'];
  //     String authSource = profileSourceFacebook;
  //     var credential = {
  //       'firebaseUID': uid,
  //       'email': email,
  //       'name': name,
  //       'Firebasetoken': token
  //     };
  //     var response = await authRepository.signInWithFirebase(credential);
  //     try{
  //       if(response['user']['id'] != null){
  //         SharedPreferences prefs = await SharedPreferences.getInstance();
  //         UserModel user = UserModel.fromJson(response['user']);
  //         prefs.setString('AccessToken', response['access_token']);
  //         if(user.firstname == null){
  //           yield SignInSuccessState(isFirstLogin: true, userModel: user);
  //         }
  //         else{
  //           yield SignInSuccessState(isFirstLogin: false, userModel: user);
  //         }
  //       }
  //       else{
  //         yield SignInFailedState();
  //       }
  //     }
  //     catch(exception){
  //       yield SignInFailedState();
  //     }

  //     yield SignInFailedState();
  //   }
  // }

  // Stream<AuthState> _mapFacebookSignUpToState(FacebookSignUpEvent facebookSignUpEvent) async* {
  //   yield LoadingState();
  //   var result = await authRepository.signInWithFaceBook();
  //   if(result == null){
  //     yield LoginFailedState();
  //   }
  //   else if(result == Map()){
  //     yield LoginCancelledState();
  //   }
  //   else if(result == null){
  //     yield LoginFailedState();
  //   }
  //   else{
  //     String uid = result['userid'];
  //     String name = result['name'];
  //     String firstName = result['first_name'];
  //     String lastName = result['last_name'];
  //     String email = result['email'];
  //     String avatar = result['picture']['data']['url'];
  //     String token = result['token'];
  //     String authSource = profileSourceFacebook;

  //     var credential = {
  //       'firebaseUID': uid,
  //       'email': email,
  //       'name': name,
  //       'avatar': avatar
  //     };
  //     bool _result = await authRepository.signUPWithFirebase(credential);
  //     if(_result){
  //       yield SignUpSuccessState();
  //     }
  //     else{
  //       yield SignUpFailedState();
  //     }
  //   }
  // }

  // Stream<AuthState> _mapTwitterSignInToState(TwitterSignInEvent twitterSignInEvent) async* {
  //   yield LoadingState();
  //   var result = await authRepository.signInWithTwitter();

  //   if(result == null){
  //     yield LoginFailedState();
  //   }
  //   else if(result == Map()){
  //     yield LoginCancelledState();
  //   }
  //   else if(result == null){
  //     yield LoginFailedState();
  //   }
  //   else{
  //     String uid = result['userid'];
  //     String name = result['name'];
  //     String email = result['email'];
  //     String avatar = result['profile_image_url'];
  //     String token = result['token'];

  //     var credential = {
  //       'firebaseUID': uid,
  //       'email': email,
  //       'name': name,
  //       'Firebasetoken': token
  //     };
  //     var response = await authRepository.signInWithFirebase(credential);
  //     try{
  //       if(response['user']['id'] != null){
  //         SharedPreferences prefs = await SharedPreferences.getInstance();
  //         UserModel user = UserModel.fromJson(response['user']);
  //         prefs.setString('AccessToken', response['access_token']);
  //         if(user.firstname == null){
  //           yield SignInSuccessState(isFirstLogin: true, userModel: user);
  //         }
  //         else{
  //           yield SignInSuccessState(isFirstLogin: false, userModel: user);
  //         }
  //       }
  //       else{
  //         yield SignInFailedState();
  //       }
  //     }
  //     catch(exception){
  //       yield SignInFailedState();
  //     }

  //     yield SignInFailedState();
  //   }

  // }

  // Stream<AuthState> _mapTwitterSignUpToState(TwitterSignUpEvent twitterSignUpEvent) async* {
  //   yield LoadingState();
  //   var result = await authRepository.signInWithTwitter();
  //   if(result == null){
  //     yield LoginFailedState();
  //   }
  //   else if(result == Map()){
  //     yield LoginCancelledState();
  //   }
  //   else if(result == null){
  //     yield LoginFailedState();
  //   }
  //   else{
  //     String uid = result['userid'];
  //     String name = result['name'];
  //     String email = result['email'];
  //     String avatar = result['profile_image_url'];
  //     String token = result['token'];
  //     String authSource = profileSourceFacebook;

  //     var credential = {
  //       'firebaseUID': uid,
  //       'email': email,
  //       'name': name,
  //       'avatar': avatar
  //     };
  //     bool _result = await authRepository.signUPWithFirebase(credential);
  //     if(_result){
  //       yield SignUpSuccessState();
  //     }
  //     else{
  //       yield SignUpFailedState();
  //     }
  //   }
  // }

  // Stream<AuthState> _mapAppleSignInToState(AppleSignInEvent appleSignInEvent) async* {
  //   yield LoadingState();
  //   var result = await authRepository.signInWithTwitter();

  //   if(result == null){
  //     yield LoginFailedState();
  //   }
  //   else if(result == Map()){
  //     yield LoginCancelledState();
  //   }
  //   else if(result == null){
  //     yield LoginFailedState();
  //   }
  //   else{
  //     String uid = result['userid'];
  //     String name = result['name'];
  //     String email = result['email'];
  //     String avatar = result['profile_image_url'];
  //     String token = result['token'];

  //     var credential = {
  //       'firebaseUID': uid,
  //       'email': email,
  //       'name': name,
  //       'Firebasetoken': token
  //     };
  //     var response = await authRepository.signInWithFirebase(credential);
  //     try{
  //       if(response['user']['id'] != null){
  //         SharedPreferences prefs = await SharedPreferences.getInstance();
  //         UserModel user = UserModel.fromJson(response['user']);
  //         prefs.setString('AccessToken', response['access_token']);
  //         if(user.firstname == null){
  //           yield SignInSuccessState(isFirstLogin: true, userModel: user);
  //         }
  //         else{
  //           yield SignInSuccessState(isFirstLogin: false, userModel: user);
  //         }
  //       }
  //       else{
  //         yield SignInFailedState();
  //       }
  //     }
  //     catch(exception){
  //       yield SignInFailedState();
  //     }

  //     yield SignInFailedState();
  //   }

  // }

  // Stream<AuthState> _mapAppleSignUpToState(AppleSignUpEvent appleSignUpEvent) async* {
  //   yield LoadingState();
  //   var result = await authRepository.signInWithApple();
  //   if(result == null){
  //     yield LoginFailedState();
  //   }
  //   else{
  //     String uid = result['userid'];
  //     String name = result['name'];
  //     String email = result['email'];
  //     String avatar = result['profile_image_url'];
  //     String token = result['token'];
  //     String authSource = profileSourceFacebook;

  //     var credential = {
  //       'firebaseUID': uid,
  //       'email': email,
  //       'name': name,
  //       'avatar': avatar
  //     };
  //     bool _result = await authRepository.signUPWithFirebase(credential);
  //     if(_result){
  //       yield SignUpSuccessState();
  //     }
  //     else{
  //       yield SignUpFailedState();
  //     }
  //   }
  // }

  // Stream<AuthState> _mapRestorePasswordToState(RestorePasswordEvent restorePasswordEvent) async* {
  //   yield LoadingState();
  //   var params = {
  //     'email': restorePasswordEvent.email
  //   };
  //   var result = await authRepository.restorePasswordRequest(params);
  //   if(result){
  //     showToast('Password Reset Email has been sent', gradientStart);
  //     yield SignInSuccessState();
  //   }
  //   else{
  //     yield LoginFailedState();
  //   }
  // }

  // Stream<AuthState> _mapResetPasswordToState(ResetPasswordEvent resetPasswordEvent) async* {
  //   yield LoadingState();
  //   var params = {
  //     'email': resetPasswordEvent.email,
  //     'password': resetPasswordEvent.password,
  //     'password_confirmation': resetPasswordEvent.password,
  //     'token': resetPasswordEvent.token
  //   };
  //   var result = await authRepository.resetPasswordRequest(params);
  //   if(result != null && result['status']){
  //     showToast(result['message'], gradientStart);
  //     yield SignInSuccessState();
  //     return;
  //   }
  //   else if(result == null){
  //     showToast('Network Error', gradientStart);
  //     yield LoginFailedState();
  //     return;
  //   }
  //   else{
  //     showToast(result['message'], gradientStart);
  //     yield LoginFailedState();
  //   }
  // }
}
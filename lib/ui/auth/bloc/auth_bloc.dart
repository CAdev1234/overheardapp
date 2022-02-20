import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_icons/flutter_icons.dart';
import 'package:overheard_flutter_app/constants/colorset.dart';
import 'package:overheard_flutter_app/constants/stringset.dart';
import 'package:overheard_flutter_app/ui/auth/bloc/auth_state.dart';
import 'package:overheard_flutter_app/ui/auth/bloc/auth_event.dart';
import 'package:overheard_flutter_app/ui/auth/models/user_model.dart';
import 'package:overheard_flutter_app/ui/auth/repository/auth.repository.dart';
import 'package:overheard_flutter_app/utils/ui_elements.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
  final AuthRepository authRepository;

  String uid = "";
  String email = "";
  String source = "";

  AuthBloc({required this.authRepository}) : super(null as AuthState) {
    on<AuthEvent>(
      (event, emit) {
        if (event is SignUpEvent) {_mapSignUpToState(event);}
        else if (event is SignInEvent) {_mapSignInToState(event);}
        else if (event is SignInWithTokenEvent) {_mapSignInWithTokenToState(event);}
        else if (event is RestorePasswordEvent) {_mapRestorePasswordToState(event);}
        else if (event is EmailVerifyEvent) {_mapEmailVerifyToState(event);}
        else if (event is EmailVerifyResendEvent) {_mapEmailVerifyResendToState(event);}
        else if (event is ResetPasswordEvent) {_mapResetPasswordToState(event);}
        else if (event is FacebookSignInEvent) {_mapFacebookSignInToState(event);}
        else if (event is FacebookSignUpEvent) {_mapFacebookSignUpToState(event);}
        else if (event is TwitterSignInEvent) {_mapTwitterSignInToState(event);}
        else if (event is TwitterSignUpEvent) {_mapTwitterSignUpToState(event);}
      },
    );
  }

  @override
  Future<void> close() async {
    super.close();
  }


  // Stream<AuthState> mapEventToState(AuthEvent event) async* {
  //   if(event is SignInEvent) {
  //     yield* _mapSignInToState(event);
  //   }
  //   else if(event is SignUpEvent){
  //     yield* _mapSignUpToState(event);
  //   }
  //   else if(event is EmailVerifyEvent){
  //     yield* _mapEmailVerifyToState(event);
  //   }
  //   else if(event is EmailVerifyResendEvent){
  //     yield* _mapEmailVerifyResendToState(event);
  //   }
  //   else if(event is FacebookSignInEvent){
  //     yield* _mapFacebookSignInToState(event);
  //   }
  //   else if(event is FacebookSignUpEvent){
  //     yield* _mapFacebookSignUpToState(event);
  //   }
  //   else if(event is TwitterSignInEvent){
  //     yield* _mapTwitterSignInToState(event);
  //   }
  //   else if(event is TwitterSignUpEvent){
  //     yield* _mapTwitterSignUpToState(event);
  //   }
  //   else if(event is AppleSignInEvent){
  //     yield* _mapAppleSignInToState(event);
  //   }
  //   else if(event is AppleSignUpEvent){
  //     yield* _mapAppleSignUpToState(event);
  //   }
  //   else if(event is SignInWithTokenEvent){
  //     yield* _mapSignInWithTokenToState(event);
  //   }
  //   else if(event is RestorePasswordEvent){
  //     yield* _mapRestorePasswordToState(event);
  //   }
  //   else if(event is ResetPasswordEvent){
  //     yield* _mapResetPasswordToState(event);
  //   }
  // }

  void _mapSignInToState(SignInEvent event) async {
    emit(const LoadingState());
    String email = event.email;
    String password = event.password;
    var credential = {
      'email': email,
      'password': password
    };
    var response = await authRepository.signInWithEmail(credential);
    if(response == null) {
      showToast("SignIn Failed", gradientStart);
      emit(const SignInFailedState());
      return;
    }
    
    else if(response['status'] && response['user'] != null && response['user']['id'] != null){
      UserModel user = UserModel.fromJson(response['user']);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('AccessToken', response['access_token']);
      if(user.firstname == null || user.firstname == ""){
        emit(SignInSuccessState(isFirstLogin: true, userModel: user));
        return;
      }
      else{
        emit(SignInSuccessState(isFirstLogin: false, userModel: user));
        return;
      }
    }
    else{
      showToast(response['message'], gradientStart);
      emit(const SignInFailedState());
      return;
    }
    // yield const SignInFailedState();
    // emit(SignInFailedState());
  }

  void _mapSignInWithTokenToState(SignInWithTokenEvent event) async {
    var prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString('AccessToken');
    if(accessToken == null){
      return;
    }

    var response = await authRepository.signInWithToken();
    if(response == null) {
      emit(const SignInFailedState());
      return;
    }
    else if(!response['status']) {
      showToast(response['message'], gradientStart);
      emit(const SignInFailedState());
      return;
    }
    else if(response['user']['id'] != null || response['user']['id'] == ""){
      // UserModel user = UserModel.fromJson(response['user']);
      UserModel user = UserModel.fromJson(response['user']);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('AccessToken', response['access_token']);
      if(user.firstname == null || user.lastname == null){
        emit(SignInSuccessState(isFirstLogin: true, userModel: user));
        return;
      }
      else{
        emit(SignInSuccessState(isFirstLogin: false, userModel: user));
        return;
      }
    }
    else{
      emit(const SignInFailedState());
      return;
    }
  }

  void _mapSignUpToState(SignUpEvent event) async {
    emit(const LoadingState());
    String email = event.email;
    String name = event.name;
    String password = event.password;
    var credential = {
      'email': email,
      'name': name,
      'password': password
    };
    var result = await authRepository.signUpWithEmail(credential);
    
    if(result!['status']){
      showToast(result['message'], gradientStart);
      emit(const SignUpSuccessState());
      return;
    }
    else{
      showToast(result['message'], gradientStart);
      emit(const SignUpFailedState());
      return;
    }
  }

  void _mapEmailVerifyToState(EmailVerifyEvent emailVerifyEvent) async {
    emit(const LoadingState());
    String parameter = emailVerifyEvent.parameter;
    var result = await authRepository.emailVerify(parameter);
    if(result!['status']){
      showToast(result['message'], gradientStart);
      emit(const VerifySuccessState());
      return;
    }
    else{
      showToast(result['message'], gradientStart);
      emit(const VerifyFailedState());
      return;
    }
  }

  void _mapEmailVerifyResendToState(EmailVerifyResendEvent emailVerifyResendEvent) async {
    emit(const LoadingState());
    String email = emailVerifyResendEvent.email;
    var result = await authRepository.emailVerifyResend(email);
    if(result!['status']){
      showToast(result['message'], gradientStart);
      emit(const VerifySuccessState());
      return;
    }
    else{
      showToast(result['message'], gradientStart);
      emit(const VerifyFailedState());
      return;
    }
  }

  void _mapFacebookSignInToState(FacebookSignInEvent facebookSignInEvent) async {
    emit(const LoadingState());
    var result = await authRepository.signInWithFaceBook();
    if(result == null){
      emit(const LoginFailedState());
      return;
    }
    else if(result.isEmpty){
      emit(const LoginCancelledState());
      return;
    }
    else{
      String name = result['name'];
      List nameList = name.split(' ');
      String uid = result['id'];
      String firstName = nameList[0];
      String lastName = nameList[1];
      String email = result['email'];
      String avatar = result['picture']['data']['url'];
      String token = result['token'];
      String authSource = profileSourceFacebook;
      var credential = {
        'firebaseUID': uid,
        'email': email,
        'name': name,
        'Firebasetoken': token
      };
      var response = await authRepository.signInWithFirebase(credential);
      try{
        if(response['user']['id'] != null){
          SharedPreferences prefs = await SharedPreferences.getInstance();
          UserModel user = UserModel.fromJson(response['user']);
          prefs.setString('AccessToken', response['access_token']);
          if(user.firstname == null){
            emit(SignInSuccessState(isFirstLogin: true, userModel: user));
          }
          else{
            emit(SignInSuccessState(isFirstLogin: false, userModel: user));
          }
        }
        else{
          emit(const SignInFailedState());
        }
      }
      catch(exception){
        emit(const SignInFailedState());
      }
      emit(const SignInFailedState());
    }
  }

  void _mapFacebookSignUpToState(FacebookSignUpEvent facebookSignUpEvent) async {
    emit(const LoadingState());
    var result = await authRepository.signInWithFaceBook();
    if(result == null){
      emit(const LoginFailedState());
      return;
    }
    else if(result.isEmpty){
      emit(const LoginCancelledState());
      return;
    }
    else{
      String uid = result['id'];
      String name = result['name'];
      List nameList = name.split(' ');
      String firstName = nameList[0];
      String lastName = nameList[1];
      String email = result['email'];
      String avatar = result['picture']['data']['url'];
      String token = result['token'];
      String authSource = profileSourceFacebook;

      var credential = {
        'firebaseUID': uid,
        'email': email,
        'name': name,
        'avatar': avatar
      };
      bool _result = await authRepository.signUpWithFirebase(credential);
      if(_result){
        emit(const SignUpSuccessState());
      }
      else{
        emit(const SignUpFailedState());
      }
    }
  }

  void _mapTwitterSignInToState(TwitterSignInEvent twitterSignInEvent) async {
    emit(const LoadingState());
    var result = await authRepository.signInWithTwitter();

    if(result == null){
      emit(const LoginFailedState());
      return;
    }
    else if(result.isEmpty){
      emit(const LoginCancelledState());
      return;
    }
    else{
      String uid = result['userid'];
      String name = result['name'];
      String email = result['email'];
      String avatar = result['profile_image_url'];
      String token = result['token'];

      var credential = {
        'firebaseUID': uid,
        'email': email,
        'name': name,
        'Firebasetoken': token
      };
      var response = await authRepository.signInWithFirebase(credential);
      try{
        if(response['user']['id'] != null){
          SharedPreferences prefs = await SharedPreferences.getInstance();
          UserModel user = UserModel.fromJson(response['user']);
          prefs.setString('AccessToken', response['access_token']);
          if(user.firstname == null){
            emit(SignInSuccessState(isFirstLogin: true, userModel: user));
          }
          else{
            emit(SignInSuccessState(isFirstLogin: false, userModel: user));
          }
        }
        else{
          emit(const SignInFailedState());
        }
      }
      catch(exception){
        emit(const SignInFailedState());
      }

      emit(const SignInFailedState());
    }

  }

  void _mapTwitterSignUpToState(TwitterSignUpEvent twitterSignUpEvent) async {
    emit(const LoadingState());
    var result = await authRepository.signInWithTwitter();
    if(result == null){
      emit(const LoginFailedState());
    }
    else if(result == Map()){
      emit(const LoginCancelledState());
    }
    else if(result == null){
      emit(const LoginFailedState());
    }
    else{
      String uid = result['userid'];
      String name = result['name'];
      String email = result['email'];
      String avatar = result['profile_image_url'];
      String token = result['token'];
      String authSource = profileSourceFacebook;

      var credential = {
        'firebaseUID': uid,
        'email': email,
        'name': name,
        'avatar': avatar
      };
      bool _result = await authRepository.signUpWithFirebase(credential);
      if(_result){
        emit(const SignUpSuccessState());
      }
      else{
        emit(const SignUpFailedState());
      }
    }
  }

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

  void _mapRestorePasswordToState(RestorePasswordEvent restorePasswordEvent) async {
    emit(const LoadingState());
    var params = {
      'email': restorePasswordEvent.email
    };
    var result = await authRepository.restorePasswordRequest(params);
    if(result){
      showToast('Password Reset Email has been sent', gradientStart);
      // emit(SignInSuccessState(isFirstLogin: false, userModel: user));
    }
    else{
      emit(const LoginFailedState());
    }
  }

  void _mapResetPasswordToState(ResetPasswordEvent resetPasswordEvent) async {
    emit(const LoadingState());
    var params = {
      'email': resetPasswordEvent.email,
      'password': resetPasswordEvent.password,
      'password_confirmation': resetPasswordEvent.password,
      'token': resetPasswordEvent.token
    };
    var result = await authRepository.resetPasswordRequest(params);
    if(result != null && result['status']){
      showToast(result['message'], gradientStart);
      // emit(SignInSuccessState(isFirstLogin: false, userModel: user));
      return;
    }
    else if(result == null){
      showToast('Network Error', gradientStart);
      emit(const LoginFailedState());
      return;
    }
    else{
      showToast(result['message'], gradientStart);
      emit(const LoginFailedState());
    }
  }
}
import 'package:equatable/equatable.dart';
import 'package:overheard_flutter_app/ui/auth/models/user_model.dart';

abstract class AuthState extends Equatable{
  AuthState();
}

class LoadingState extends AuthState {
  LoadingState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => "LoadingState SigningIn State";
}

class SignInSuccessState extends AuthState {
  final bool isFirstLogin;
  final UserModel userModel;
  SignInSuccessState({required this.isFirstLogin, required this.userModel}) : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => "SignIn Success State";
}

class SignInFailedState extends AuthState {
  SignInFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => "SignIn Failed State";
}

class SignUpSuccessState extends AuthState {
  SignUpSuccessState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => "SignUp Success State";
}


class VerifySuccessState extends AuthState {
  VerifySuccessState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => "Verify Success State";
}

class VerifyFailedState extends AuthState {
  VerifyFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => "Verify Failed State";
}

class SignUpFailedState extends AuthState {
  SignUpFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => "SignUp Failed State";
}

class LoginFailedState extends AuthState {
  LoginFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => "Login Failed State";
}

class LoginCancelledState extends AuthState {
  LoginCancelledState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Login Cancelled State';
}
import 'package:equatable/equatable.dart';
import 'package:overheard_flutter_app/ui/auth/models/user_model.dart';

abstract class AuthState extends Equatable{
  const AuthState();
}

class InitState extends AuthState {
  const InitState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => "Auth Init State";
}

class LoadingState extends AuthState {
  const LoadingState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => "LoadingState SigningIn State";
}

class SignInSuccessState extends AuthState {
  final bool isFirstLogin;
  final UserModel userModel;
  const SignInSuccessState({required this.isFirstLogin, required this.userModel}) : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => "SignIn Success State";
}

class SignInFailedState extends AuthState {
  const SignInFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => "SignIn Failed State";
}

class SignUpSuccessState extends AuthState {
  const SignUpSuccessState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => "SignUp Success State";
}


class VerifySuccessState extends AuthState {
  const VerifySuccessState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => "Verify Success State";
}

class VerifyFailedState extends AuthState {
  const VerifyFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => "Verify Failed State";
}

class SignUpFailedState extends AuthState {
  const SignUpFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => "SignUp Failed State";
}

class LoginFailedState extends AuthState {
  const LoginFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => "Login Failed State";
}

class LoginCancelledState extends AuthState {
  const LoginCancelledState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Login Cancelled State';
}
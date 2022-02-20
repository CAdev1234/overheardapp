import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable{
  const AuthEvent();

  List<Object> get pros => [];
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;
  const SignInEvent({required this.email, required this.password}) : super();

  @override
  List<Object> get props => [];
}

class SignInWithTokenEvent extends AuthEvent {
  const SignInWithTokenEvent() : super();

  @override
  List<Object> get props => [];
}

class EmailVerifyEvent extends AuthEvent {
  final String parameter;
  const EmailVerifyEvent({required this.parameter}) : super();

  @override
  List<Object> get props => [];
}

class EmailVerifyResendEvent extends AuthEvent {
  final String email;
  const EmailVerifyResendEvent({required this.email}) : super();

  @override
  List<Object> get props => [];
}

class SignUpEvent extends AuthEvent {
  final String email;
  final String name;
  final String password;
  const SignUpEvent({required this.email, required this.name, required this.password}) : super();

  @override
  List<Object> get props => [];
}

class FacebookSignInEvent extends AuthEvent {
  const FacebookSignInEvent() : super();

  @override
  List<Object> get props => [];
}

class FacebookSignUpEvent extends AuthEvent {
  const FacebookSignUpEvent() : super();

  @override
  List<Object> get props => [];
}

class TwitterSignInEvent extends AuthEvent {
  const TwitterSignInEvent() : super();

  @override
  List<Object> get props => [];
}

class TwitterSignUpEvent extends AuthEvent {
  const TwitterSignUpEvent() : super();

  @override
  List<Object> get props => [];
}

class AppleSignInEvent extends AuthEvent {
  const AppleSignInEvent() : super();

  @override
  List<Object> get props => [];
}

class AppleSignUpEvent extends AuthEvent {
  const AppleSignUpEvent() : super();

  @override
  List<Object> get props => [];
}

class RestorePasswordEvent extends AuthEvent {
  final String email;
  const RestorePasswordEvent({required this.email}) : super();

  @override
  List<Object> get props => [];
}

class ResetPasswordEvent extends AuthEvent {
  final String email;
  final String token;
  final String password;
  const ResetPasswordEvent({required this.email, required this.token, required this.password}) : super();

  @override
  List<Object> get props => [];
}
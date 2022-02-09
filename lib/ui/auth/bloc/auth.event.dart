import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class AuthEvent extends Equatable{
  AuthEvent();

  @override
  List<Object> get pros => [];
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;
  SignInEvent({required this.email, required this.password}) : super();

  List<Object> get props => [];
}

class SignInWithTokenEvent extends AuthEvent {
  SignInWithTokenEvent() : super();

  @override
  List<Object> get props => [];
}

class EmailVerifyEvent extends AuthEvent {
  final String parameter;
  EmailVerifyEvent({required this.parameter}) : super();

  @override
  List<Object> get props => [];
}

class EmailVerifyResendEvent extends AuthEvent {
  final String email;
  EmailVerifyResendEvent({required this.email}) : super();

  @override
  List<Object> get props => [];
}

class SignUpEvent extends AuthEvent {
  final String email;
  final String userName;
  final String password;
  SignUpEvent({required this.email, required this.userName, required this.password}) : super();

  List<Object> get props => [];
}

class FacebookSignInEvent extends AuthEvent {
  FacebookSignInEvent() : super();

  @override
  List<Object> get props => [];
}

class FacebookSignUpEvent extends AuthEvent {
  FacebookSignUpEvent() : super();

  @override
  List<Object> get props => [];
}

class TwitterSignInEvent extends AuthEvent {
  TwitterSignInEvent() : super();

  @override
  List<Object> get props => [];
}

class TwitterSignUpEvent extends AuthEvent {
  TwitterSignUpEvent() : super();

  @override
  List<Object> get props => [];
}

class AppleSignInEvent extends AuthEvent {
  AppleSignInEvent() : super();

  @override
  List<Object> get props => [];
}

class AppleSignUpEvent extends AuthEvent {
  AppleSignUpEvent() : super();

  @override
  List<Object> get props => [];
}

class RestorePasswordEvent extends AuthEvent {
  final String email;
  RestorePasswordEvent({required this.email}) : super();

  @override
  List<Object> get props => [];
}

class ResetPasswordEvent extends AuthEvent {
  final String email;
  final String token;
  final String password;
  ResetPasswordEvent({required this.email, required this.token, required this.password}) : super();

  @override
  List<Object> get props => [];
}
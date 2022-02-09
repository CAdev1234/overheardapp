import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable{
  ProfileEvent();

  @override
  List<Object> get pros => [];
}

class ProfileFetchEvent extends ProfileEvent{
  final int? user_id;
  ProfileFetchEvent({this.user_id}) : super();

  @override
  List<Object> get props => [];
}

class ProfileCompleteEvent extends ProfileEvent {
  final String firstName;
  final String lastName;
  final String? userName;
  final String? email;
  final String? phonenumber;
  final String bio;
  final bool reporter_request;
  ProfileCompleteEvent({required this.firstName, required this.lastName, this.userName, this.email, this.phonenumber, required this.bio, required this.reporter_request}) : super();

  @override
  List<Object> get props => [];
}

class ProfileFollowEvent extends ProfileEvent {
  final int user_id;

  ProfileFollowEvent({required this.user_id}) : super();

  @override
  List<Object> get props => [];
}

class ProfileBlockEvent extends ProfileEvent {
  final int user_id;

  ProfileBlockEvent({required this.user_id}) : super();

  @override
  List<Object> get props => [];
}

class FetchCommunityEvent extends ProfileEvent {
  FetchCommunityEvent(): super();

  @override
  List<Object> get props => [];
}

class CommunityResetEvent extends ProfileEvent {
  CommunityResetEvent() : super();

  @override
  List<Object> get props => [];
}

class CommunityConfirmEvent extends ProfileEvent {
  CommunityConfirmEvent() : super();

  @override
  List<Object> get props => [];
}

class FollowerFetchEvent extends ProfileEvent {
  final int selectedIndex;
  FollowerFetchEvent({required this.selectedIndex}) : super();

  @override
  List<Object> get props => [];
}

class FetchBlockedUsersEvent extends ProfileEvent {
  FetchBlockedUsersEvent() : super();

  @override
  List<Object> get props => [];
}

class LogoutEvent extends ProfileEvent{
  LogoutEvent() : super();

  @override
  List<Object> get props => [];
}

class ChangePasswordEvent extends ProfileEvent {
  final String oldPassword;
  final String newPassword;

  ChangePasswordEvent({required this.oldPassword, required this.newPassword}) : super();

  @override
  List<Object> get props => [];
}
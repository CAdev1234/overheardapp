import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable{
  const ProfileEvent();

  List<Object> get pros => [];
}

class ProfileFetchEvent extends ProfileEvent{
  final int? user_id;
  const ProfileFetchEvent({this.user_id}) : super();

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
  const ProfileCompleteEvent({required this.firstName, required this.lastName, this.userName, this.email, this.phonenumber, required this.bio, required this.reporter_request}) : super();

  @override
  List<Object> get props => [];
}

class ProfileFollowEvent extends ProfileEvent {
  final int user_id;

  const ProfileFollowEvent({required this.user_id}) : super();

  @override
  List<Object> get props => [];
}

class ProfileBlockEvent extends ProfileEvent {
  final int user_id;

  const ProfileBlockEvent({required this.user_id}) : super();

  @override
  List<Object> get props => [];
}

class FetchCommunityEvent extends ProfileEvent {
  const FetchCommunityEvent(): super();

  @override
  List<Object> get props => [];
}

class CommunityResetEvent extends ProfileEvent {
  const CommunityResetEvent() : super();

  @override
  List<Object> get props => [];
}

class CommunityConfirmEvent extends ProfileEvent {
  const CommunityConfirmEvent() : super();

  @override
  List<Object> get props => [];
}

class FollowerFetchEvent extends ProfileEvent {
  final int selectedIndex;
  const FollowerFetchEvent({required this.selectedIndex}) : super();

  @override
  List<Object> get props => [];
}

class FetchBlockedUsersEvent extends ProfileEvent {
  const FetchBlockedUsersEvent() : super();

  @override
  List<Object> get props => [];
}

class LogoutEvent extends ProfileEvent{
  const LogoutEvent() : super();

  @override
  List<Object> get props => [];
}

class ChangePasswordEvent extends ProfileEvent {
  final String oldPassword;
  final String newPassword;

  const ChangePasswordEvent({required this.oldPassword, required this.newPassword}) : super();

  @override
  List<Object> get props => [];
}
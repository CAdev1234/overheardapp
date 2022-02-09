import 'package:equatable/equatable.dart';
import 'package:overheard_flutter_app/ui/auth/models/user_model.dart';

abstract class ProfileState extends Equatable{
  ProfileState();
}

class ProfileLoadingState extends ProfileState {
  ProfileLoadingState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Profile Loading State';
}

class ProfileLoadDoneState extends ProfileState {
  final UserModel? userModel;
  ProfileLoadDoneState({this.userModel}) : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Profile Load Done State';
}

class ProfileLoadFailedState extends ProfileState {
  ProfileLoadFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Profile Load Failed State';
}

class ProfileUpdateDoneState extends ProfileState {
  ProfileUpdateDoneState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Profile Update Success';
}

class ProfileUpdateFailedState extends ProfileState {
  ProfileUpdateFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Profile Update Failed';
}

class ProfileFollowingState extends ProfileState {
  ProfileFollowingState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Profile Following State';
}

class ProfileFollowDoneState extends ProfileState {
  ProfileFollowDoneState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Profile Follow Done State';
}

class ProfileFollowFailedState extends ProfileState {
  ProfileFollowFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Profile Follow Failed State';
}

class CommunityConfirmLoadingState extends ProfileState {
  CommunityConfirmLoadingState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Community Confirm Loading State';
}

class CommunityConfirmedState extends ProfileState {
  CommunityConfirmedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Community Confirmed State';
}

class CommunityConfirmFailedState extends ProfileState {
  CommunityConfirmFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Community Confirm Failed State';
}

class CommunityLoadingState extends ProfileState {
  CommunityLoadingState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => "Community Loading State";
}

class CommunityDoneState extends ProfileState {
  CommunityDoneState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Community Loading Done State';
}

class CommunityLoadFailedState extends ProfileState {
  CommunityLoadFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Community Loading Failed State';
}

class FollowerFetchingState extends ProfileState {
  FollowerFetchingState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Followers Fetching Event';
}

class FollowerFetchDoneState extends ProfileState {
  FollowerFetchDoneState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Followers Fetch Done';
}

class FollowerFetchFailedState extends ProfileState {
  FollowerFetchFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Follower Fetch Failed';
}

class FollowingFetchingState extends ProfileState {
  FollowingFetchingState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Followings Fetching Event';
}

class FollowingFetchDoneState extends ProfileState {
  FollowingFetchDoneState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Followings Fetch Done';
}

class FollowingFetchFailedState extends ProfileState {
  FollowingFetchFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Following Fetch Failed';
}

class PasswordChangingState extends ProfileState {
  PasswordChangingState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Password Changing State';
}

class PasswordChangedState extends ProfileState {
  PasswordChangedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Password Changed State';
}

class PasswordChangeFailedState extends ProfileState {
  PasswordChangeFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Password Change Failed State';
}
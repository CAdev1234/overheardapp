import 'package:equatable/equatable.dart';
import 'package:overheard_flutter_app/ui/auth/models/user_model.dart';

abstract class ProfileState extends Equatable{
  const ProfileState();
}

class ProfileLoadingState extends ProfileState {
  const ProfileLoadingState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Profile Loading State';
}

class ProfileLoadDoneState extends ProfileState {
  final UserModel? userModel;
  const ProfileLoadDoneState({this.userModel}) : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Profile Load Done State';
}

class ProfileLoadFailedState extends ProfileState {
  const ProfileLoadFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Profile Load Failed State';
}

class ProfileUpdateDoneState extends ProfileState {
  const ProfileUpdateDoneState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Profile Update Success';
}

class ProfileUpdateFailedState extends ProfileState {
  const ProfileUpdateFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Profile Update Failed';
}

class ProfileFollowingState extends ProfileState {
  const ProfileFollowingState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Profile Following State';
}

class ProfileFollowDoneState extends ProfileState {
  const ProfileFollowDoneState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Profile Follow Done State';
}

class ProfileFollowFailedState extends ProfileState {
  const ProfileFollowFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Profile Follow Failed State';
}

class CommunityConfirmLoadingState extends ProfileState {
  const CommunityConfirmLoadingState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Community Confirm Loading State';
}

class CommunityConfirmedState extends ProfileState {
  const CommunityConfirmedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Community Confirmed State';
}

class CommunityConfirmFailedState extends ProfileState {
  const CommunityConfirmFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Community Confirm Failed State';
}

class CommunityLoadingState extends ProfileState {
  const CommunityLoadingState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => "Community Loading State";
}

class CommunityDoneState extends ProfileState {
  const CommunityDoneState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Community Loading Done State';
}

class CommunityLoadFailedState extends ProfileState {
  const CommunityLoadFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Community Loading Failed State';
}

class FollowerFetchingState extends ProfileState {
  const FollowerFetchingState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Followers Fetching Event';
}

class FollowerFetchDoneState extends ProfileState {
  const FollowerFetchDoneState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Followers Fetch Done';
}

class FollowerFetchFailedState extends ProfileState {
  const FollowerFetchFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Follower Fetch Failed';
}

class FollowingFetchingState extends ProfileState {
  const FollowingFetchingState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Followings Fetching Event';
}

class FollowingFetchDoneState extends ProfileState {
  const FollowingFetchDoneState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Followings Fetch Done';
}

class FollowingFetchFailedState extends ProfileState {
  const FollowingFetchFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Following Fetch Failed';
}

class PasswordChangingState extends ProfileState {
  const PasswordChangingState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Password Changing State';
}

class PasswordChangedState extends ProfileState {
  const PasswordChangedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Password Changed State';
}

class PasswordChangeFailedState extends ProfileState {
  const PasswordChangeFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Password Change Failed State';
}
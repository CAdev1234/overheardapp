import 'package:equatable/equatable.dart';

abstract class CommunityState extends Equatable{
  CommunityState();
}

class CommunityLoadingState extends CommunityState {
  CommunityLoadingState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => "Community Loading State";
}

class CommunityDoneState extends CommunityState {
  CommunityDoneState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Community Loading Done State';
}

class CommunityLoadFailedState extends CommunityState {
  CommunityLoadFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Community Loading Failed State';
}

class CommunityConfirmLoadingState extends CommunityState {
  CommunityConfirmLoadingState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Community Confirm Loading State';
}

class CommunityConfirmedState extends CommunityState {
  CommunityConfirmedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Community Confirmed State';
}

class CommunityConfirmFailedState extends CommunityState {
  CommunityConfirmFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Community Confirm Failed State';
}
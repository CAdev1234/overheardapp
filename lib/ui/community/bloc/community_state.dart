import 'package:equatable/equatable.dart';

abstract class CommunityState extends Equatable{
  const CommunityState();
}

class CommunityLoadingState extends CommunityState {
  const CommunityLoadingState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => "Community Loading State";
}

class CommunityDoneState extends CommunityState {
  const CommunityDoneState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Community Loading Done State';
}

class CommunityLoadFailedState extends CommunityState {
  const CommunityLoadFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Community Loading Failed State';
}

class CommunityConfirmLoadingState extends CommunityState {
  const CommunityConfirmLoadingState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Community Confirm Loading State';
}

class CommunityConfirmedState extends CommunityState {
  const CommunityConfirmedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Community Confirmed State';
}

class CommunityConfirmFailedState extends CommunityState {
  const CommunityConfirmFailedState() : super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Community Confirm Failed State';
}
import 'package:equatable/equatable.dart';

abstract class CommunityEvent extends Equatable{
  CommunityEvent();

  @override
  List<Object> get pros => [];
}

class FetchCommunityEvent extends CommunityEvent {
  FetchCommunityEvent(): super();

  @override
  List<Object> get props => [];
}

class CommunityResetEvent extends CommunityEvent {
  CommunityResetEvent() : super();

  @override
  List<Object> get props => [];
}

class CommunityConfirmEvent extends CommunityEvent {
  CommunityConfirmEvent() : super();

  @override
  List<Object> get props => [];
}

class CommunitySubmitEvent extends CommunityEvent {
  final double lat;
  final double lng;
  final String name;
  CommunitySubmitEvent({required this.lat, required this.lng, required this.name}) : super();

  @override
  List<Object> get props => [];
}

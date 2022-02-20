import 'package:equatable/equatable.dart';

abstract class CommunityEvent extends Equatable{
  const CommunityEvent();

  List<Object> get pros => [];
}

class FetchCommunityEvent extends CommunityEvent {
  const FetchCommunityEvent(): super();

  @override
  List<Object> get props => [];
}

class CommunityResetEvent extends CommunityEvent {
  const CommunityResetEvent() : super();

  @override
  List<Object> get props => [];
}

class CommunityConfirmEvent extends CommunityEvent {
  const CommunityConfirmEvent() : super();

  @override
  List<Object> get props => [];
}

class CommunitySubmitEvent extends CommunityEvent {
  final double lat;
  final double lng;
  final String name;
  const CommunitySubmitEvent({required this.lat, required this.lng, required this.name}) : super();

  @override
  List<Object> get props => [];
}

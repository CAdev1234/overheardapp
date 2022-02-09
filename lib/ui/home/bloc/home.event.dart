import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable{
  HomeEvent();

  @override
  List<Object> get pros => [];
}

class ChangeTabIndexEvent extends HomeEvent {
  final int tabIndex;
  ChangeTabIndexEvent({required this.tabIndex});

  @override
  // TODO: implement props
  List<Object> get props => [];
}

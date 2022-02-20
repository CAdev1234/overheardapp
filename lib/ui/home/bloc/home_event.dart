import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable{
  const HomeEvent();

  List<Object> get pros => [];
}

class ChangeTabIndexEvent extends HomeEvent {
  final int tabIndex;
  const ChangeTabIndexEvent({required this.tabIndex});

  @override
  List<Object> get props => [];
}

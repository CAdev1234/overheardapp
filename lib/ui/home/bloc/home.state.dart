import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable{
  HomeState();
}

class TabIndexState extends HomeState {
  final int tabIndex;

  TabIndexState({required this.tabIndex});

  @override
  // TODO: implement props
  List<Object> get props => [];

  @override
  String toString() => 'Tab Index Changed State';
}
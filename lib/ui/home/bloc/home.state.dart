import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable{
  const HomeState();
}

class TabIndexState extends HomeState {
  final int tabIndex;

  const TabIndexState({required this.tabIndex});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Tab Index Changed State';
}
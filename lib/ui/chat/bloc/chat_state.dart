import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ChatState extends Equatable{
  const ChatState();
}

class ChatItemFetchingState extends ChatState {
  const ChatItemFetchingState({Key? key}): super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Chat Page Loading Start State';
}

class ChatItemFetchDoneState extends ChatState {
  const ChatItemFetchDoneState({Key? key}): super();

  @override
  List<Object> get props => [];
  @override
  String toString() => 'Chat Page Loading Success State';
}
class ChatItemFetchFailedState extends ChatState {
  const ChatItemFetchFailedState({Key? key}): super();

  @override
  List<Object> get props => [];
  @override
  String toString() => 'Chat Page Loading Failed State';
}


class ChatContactFetchingState extends ChatState {
  const ChatContactFetchingState({Key? key}): super();
  @override
  List<Object> get props => [];
  @override
  String toString() => 'Chat Contact Fetching State for Chat Create Page';
}
class ChatContactFetchDoneState extends ChatState {
  const ChatContactFetchDoneState({Key? key}): super();
  @override
  List<Object> get props => [];
  @override
  String toString() => 'Chat Contact Fetching Done State for Chat Create Page';
}


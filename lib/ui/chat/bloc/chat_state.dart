import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ChatState extends Equatable{
  const ChatState();
}

class ChatInitState extends ChatState {
  const ChatInitState({Key? key}): super();
  @override
  List<Object> get props => [];
  @override
  String toString() => 'Chat state for null safety';
}

// chat page
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

// create page
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
class ChatContactFetchFailState extends ChatState {
  const ChatContactFetchFailState({Key? key}): super();
  @override
  List<Object> get props => [];
  @override
  String toString() => 'Chat Contact Fetching Fail State for Chat Create page';
}

// chat board page
class ChatMessageFetchingState extends ChatState {
  const ChatMessageFetchingState({Key? key}): super();
  @override
  List<Object> get props => [];
  @override
  String toString() => 'Chat Message Fetching State for Chart Board Page';
}
class ChatMessageFetchDoneState extends ChatState {
  const ChatMessageFetchDoneState({Key? key}): super();
  @override
  List<Object> get props => [];
  @override
  String toString() => 'Chat Message Fetching Done State for Chart Board Page';
}
class ChatMessageFetchFailState extends ChatState {
  const ChatMessageFetchFailState({Key? key}): super();
  @override
  List<Object> get props => [];
  @override
  String toString() => 'Chat Message Fetching Fail State for Chart Board Page';
}

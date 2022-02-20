import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ChatEvent extends Equatable{
  const ChatEvent();

  List<Object> get pros => [];
}

class ChatItemFetchingEvent extends ChatEvent {
  const ChatItemFetchingEvent({Key? key}): super();

  @override
  List<Object> get props => [];
}
class ChatItemFetchDoneEvent extends ChatEvent {
  const ChatItemFetchDoneEvent({Key? key}): super();

  @override
  List<Object> get props => [];
}
class ChatItemFetchFailedEvent extends ChatEvent {
  const ChatItemFetchFailedEvent({Key? key}): super();

  @override
  List<Object> get props => [];
}

class ChatContactFetchingEvent extends ChatEvent {
  const ChatContactFetchingEvent({Key? key}): super();
  @override
  List<Object> get props => [];
}

class ChatCreateEvent extends ChatEvent {
  const ChatCreateEvent({Key? key}):super();

  @override
  List<Object> get props => [];
}

class LoadSuccessEvent extends ChatEvent {
  const LoadSuccessEvent({Key? key}): super();

  @override
  List<Object> get props => [];
}

class LoadFailedEvent extends ChatEvent {
  const LoadFailedEvent({Key? key}): super();

  @override
  List<Object> get props => [];
}
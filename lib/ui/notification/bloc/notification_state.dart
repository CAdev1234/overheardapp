import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class NotificationState extends Equatable{
  const NotificationState();
}

class NotificationFetchingState extends NotificationState {
  const NotificationFetchingState({Key? key}): super();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Notification Fetching State';
}
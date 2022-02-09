import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard_flutter_app/ui/notification/repository/notification.repository.dart';
import 'notification.event.dart';
import 'notification.state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState>{
  final NotificationRepository notificationRepository;

  NotificationBloc({required this.notificationRepository}) : super(null as NotificationState);

  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }
}
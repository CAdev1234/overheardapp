import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/ui/notification/repository/notification.repository.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState>{
  final NotificationRepository notificationRepository;

  NotificationBloc({required this.notificationRepository}) : super(null as NotificationState) {
    on<NotificationEvent>(
      (event, emit) {

      }
    );

    @override
    Future<void> close() async {
      super.close();
    }
  }

}
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard_flutter_app/ui/chat/bloc/chat.event.dart';
import 'package:overheard_flutter_app/ui/chat/bloc/chat.state.dart';
import 'package:overheard_flutter_app/ui/chat/repository/chat.repository.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState>{
  final ChatRepository chatRepository;

  ChatBloc({required this.chatRepository}) : super(null as ChatState);

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }
}
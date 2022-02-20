import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard_flutter_app/ui/chat/bloc/chat_event.dart';
import 'package:overheard_flutter_app/ui/chat/bloc/chat_state.dart';
import 'package:overheard_flutter_app/ui/chat/models/ChatMessageModel.dart';
import 'package:overheard_flutter_app/ui/chat/repository/chat.repository.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState>{
  final ChatRepository chatRepository;

  ChatBloc({required this.chatRepository}) : super(null as ChatState) {
    on<ChatEvent>(
      (event, emit) {
        if (event is ChatItemFetchingEvent) {
          emit(const ChatItemFetchingState());
          Future.delayed(const Duration(microseconds: 1000));
          emit(const ChatItemFetchDoneState());
        }
        // else if (event is ChatItemFetchDoneEvent) {_mapChatItemFetchDoneEventToState(event);}
        else if (event is ChatContactFetchingEvent) {emit(const ChatContactFetchDoneState());}
      }
    );
    // on<ChatLoadingEvent>();
    // on<ChatContactFetchingEvent>(_mapChatContactFetchingEventToState);
  }

  @override
  Future<void> close() async {
    super.close();
  }


  // void _mapChatItemFetchDoneEventToState(ChatItemFetchDoneEvent event) async {
  //   emit(const ChatItemFetchDoneState());
  // }
  // void _mapChatCreateEventToState(ChatCreateEvent event, Emitter<ChatState> emit) async {
  //   emit(const ChatLoadingState());
  // }

  Future<List<ChatMessageModel>> pageFetch(int offset) async {
    return [];
  }
}
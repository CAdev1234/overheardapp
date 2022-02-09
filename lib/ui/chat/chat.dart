import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard_flutter_app/constants/colorset.dart';
import 'package:overheard_flutter_app/constants/fontsizeset.dart';
import 'package:overheard_flutter_app/constants/stringset.dart';
import 'package:overheard_flutter_app/ui/chat/bloc/chat.bloc.dart';
import 'package:overheard_flutter_app/ui/chat/bloc/chat.state.dart';
import 'package:overheard_flutter_app/ui/chat/repository/chat.repository.dart';

class ChatScreen extends StatefulWidget{
  @override
  ChatScreenState createState() {
    // TODO: implement createState
    return new ChatScreenState();
  }

}

class ChatScreenState extends State<ChatScreen>{
  late ChatBloc chatBloc;

  @override
  void initState(){
    super.initState();
    chatBloc = new ChatBloc(chatRepository: ChatRepository());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: chatBloc,
      listener: (context, state){

      },
      child: Container(
        decoration: primaryBoxDecoration,
        child: Scaffold(
          appBar: const CupertinoNavigationBar(
            middle: Text(
              'Chat',
              style: TextStyle(
                  fontSize: appBarTitleFontSize,
                  color: primaryWhiteTextColor
              ),
              textScaleFactor: 1.0,
            ),
          ),
          backgroundColor: Colors.transparent,
          body: BlocBuilder<ChatBloc, ChatState>(
            bloc: chatBloc,
            builder: (context, state){
              return SafeArea(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('chat')
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
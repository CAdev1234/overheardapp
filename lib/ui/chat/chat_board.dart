import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard_flutter_app/constants/colorset.dart';
import 'package:overheard_flutter_app/constants/fontsizeset.dart';
import 'package:overheard_flutter_app/constants/stringset.dart';
import 'package:overheard_flutter_app/ui/chat/bloc/chat_bloc.dart';
import 'package:overheard_flutter_app/ui/chat/models/ChatMessageModel.dart';
import 'package:overheard_flutter_app/ui/chat/repository/chat.repository.dart';
import 'package:overheard_flutter_app/ui/components/chat_input.dart';
import 'package:overheard_flutter_app/ui/components/pagination.dart';

class ChatBoardScreen extends StatefulWidget {
  const ChatBoardScreen({Key? key});

  @override
  ChatBoardScreenState createState() {
    return ChatBoardScreenState();
  }
}

class ChatBoardScreenState extends State<ChatBoardScreen> {
  late ChatBloc chatBloc;
  late TextEditingController inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    chatBloc = ChatBloc(chatRepository: ChatRepository());
  }

  WidgetBuilder mediaDialogWidget(BuildContext context){
  return (context) => CupertinoActionSheet(
    actions: [
      CupertinoActionSheetAction(
        child: const Text(
          'Photo/Video',
          style: TextStyle(
              color: primaryColor,
              fontSize: primaryButtonFontSize
          ),
          textScaleFactor: 1.0,
        ),
        onPressed: () async {

        },
      ),
    ],
    cancelButton: CupertinoActionSheetAction(
      child: const Text(
        CancelButtonText,
        style: TextStyle(
            color: primaryColor,
            fontSize: primaryButtonFontSize
        ),
        textScaleFactor: 1.0,
      ),
      onPressed: (){
        Navigator.of(context).pop();
      },
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: chatBloc,
      listener: (context, state) {

      },
      child: Container(
        decoration: primaryBoxDecoration,
        child: Scaffold(
          appBar: CupertinoNavigationBar(
            middle: Column(
              children: const [
                Text(
                  "User One",
                  style: TextStyle(
                      fontSize: appBarTitleFontSize,
                      color: primaryWhiteTextColor
                  ),
                  textScaleFactor: 1.0,
                ),
                Text(
                  "online",
                  style: TextStyle(fontSize: appBarTitleFontSize - 3, color: primaryWhiteTextColor, fontWeight: FontWeight.w400),
                )
              ],
            ),
            trailing: const CircleAvatar(
              backgroundColor: primaryWhiteTextColor,
              radius: 15,
            ),
          ),
          backgroundColor: Colors.transparent,
          body: BlocBuilder(
            bloc: chatBloc,
            builder: (context, state){
              return SafeArea(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            // color: Colors.yellow ,
                            child: RefreshIndicator(
                              child: PaginationList<ChatMessageModel>(
                                physics: const BouncingScrollPhysics(),
                                prefix: const [],
                                itemBuilder: (BuildContext context, ChatMessageModel chatMsg) {
                                  return Container(height: 50, width: 100, color: Colors.green,);
                                },
                                onError: (dynamic error) => const Center(
                                  child: Text('Something Went Wrong'),
                                ),
                                onEmpty: const SizedBox(
                                  child: Text(
                                    noMessageText,
                                    style: TextStyle(color: primaryWhiteTextColor),
                                  ),
                                ),
                                pageFetch: chatBloc.pageFetch,

                              ),
                              onRefresh: () async {
                                await Future.delayed(
                                  const Duration(milliseconds: 100),
                                );
                                return;
                              }
                            ),
                          )
                        ),
                        SizedBox(height: 50,)
                      ],
                    ),
                    // typing area
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(top: BorderSide(color: Colors.white38)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: const CircleAvatar(
                                radius: 16,
                                backgroundColor: primaryColor,
                                child: Icon(Icons.add, size: appBarTitleFontSize + 10, color: primaryWhiteTextColor,),
                              )
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ChatInput()
                            )
                          ],
                        ),
                      )
                    ),
                    
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
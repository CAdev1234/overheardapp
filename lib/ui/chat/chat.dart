import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/constants/colorset.dart';
import 'package:overheard/constants/fontsizeset.dart';
import 'package:overheard/constants/stringset.dart';
import 'package:overheard/ui/chat/bloc/chat_bloc.dart';
import 'package:overheard/ui/chat/bloc/chat_state.dart';
import 'package:overheard/ui/chat/chat_board.dart';
import 'package:overheard/ui/chat/create.dart';
import 'package:overheard/ui/chat/models/ChatMessageModel.dart';
import 'package:overheard/ui/chat/models/ChatModel.dart';
import 'package:overheard/ui/chat/repository/chat.repository.dart';
import 'package:overheard/ui/components/custom_cupertino_alert.dart';
import 'package:overheard/ui/components/glassmorphism.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'bloc/chat_event.dart';

class ChatScreen extends StatefulWidget{
  const ChatScreen({Key? key}) : super(key: key);

  @override
  ChatScreenState createState() {
    return ChatScreenState();
  }

}

class ChatScreenState extends State<ChatScreen>{
  late ChatBloc chatBloc;
  
  TextEditingController searchController = TextEditingController();
  late List<ChatModel> chatList;

  @override
  void initState(){
    super.initState();
    chatList = chatListSample;
    chatBloc = ChatBloc(chatRepository: ChatRepository());
    chatBloc.add(const ChatItemFetchingEvent());
  }

  Future<void> showChatItemDelModalHandler() {
    return showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CustomCupertinoAlert(
        title: deleteChatAlertTitle, 
        content: deleteChatAlertContent, 
        noBtnText: CancelButtonText, 
        yesBtnText: confirmButtonText,
        onNoAction: (){Navigator.pop(context);},
        onYesAction: (){},
      )
    );
  }

  Widget customAppBarWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            chatText,
            style: TextStyle(color: primaryWhiteTextColor, fontWeight: FontWeight.bold, fontSize: headingFontSize),
            textScaleFactor: 1.0,
          ),
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => BlocProvider(
                  create: (context) => ChatBloc(chatRepository: ChatRepository()),
                  child: const ChatCreateScreen(),
                )));
              },
              child: const Icon(Icons.edit, size: 25, color: Colors.white),
            )
        ],
      ),
    );
  }

  Widget searchInputWidget(BuildContext context) {
    return Center(
      child: Glassmorphism(
        blur: 20, 
        opacity: 0.2, 
        borderRadius: 10, 
        child: Container(
          width: MediaQuery.of(context).size.width - 5 * 2,
          height: 40,
          alignment: Alignment.center,
          child: Theme(
            data: Theme.of(context).copyWith(
                // textSelectionHandleColor: Colors.transparent,
                primaryColor: Colors.transparent,
                scaffoldBackgroundColor:Colors.transparent,
                bottomAppBarColor: Colors.transparent
            ),
            child: TextField(
              controller: searchController,
              onChanged: (value){},
              cursorColor: primaryPlaceholderTextColor,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: const TextStyle(color: primaryWhiteTextColor),
                hintText: searchPlaceholder,
                prefixIcon: const Icon(Icons.search, color: primaryWhiteTextColor),
                suffixIcon: searchController.text.isNotEmpty ?
                GestureDetector(
                  onTap: (){
                    
                  },
                  child: const Icon(Icons.cancel, color: primaryWhiteTextColor),
                ):
                const Text(''),
                contentPadding: const EdgeInsets.only(
                  bottom: 40 / 2,  // HERE THE IMPORTANT PART
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
              ),
              style: const TextStyle(
                  color: primaryWhiteTextColor,
                  fontSize: primaryTextFieldFontSize
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget chatItemWidget(BuildContext context, int idx, ChatModel chatModel) {
    return Slidable(
      key: ValueKey(idx),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            // An action can be bigger than the others.
            onPressed: (context) => {},
            backgroundColor: gradientStart,
            foregroundColor: Colors.white,
            // icon: Icons.archive,
            label: blockButtonText,
          ),
          SlidableAction(
            onPressed: (context) => {showChatItemDelModalHandler()},
            backgroundColor: gradientEnd,
            foregroundColor: Colors.white,
            label: deleteText,
          ),
        ],
      ),
      child: Glassmorphism(
        blur: 20, 
        opacity: 0.2, 
        borderRadius: 0, 
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: primaryWhiteTextColor,
                radius: 25,
                child: chatModel.isBlocked ? Stack(
                  children: const [
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Icon(Icons.lock, color: gradientStart, size: primaryFeedAuthorFontSize,),
                    )
                  ],
                )
                :
                const SizedBox.shrink(),
              ),
              const SizedBox(width: 10,),
              Expanded(
                child: SizedBox(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "User $idx",
                            style: const TextStyle(color: primaryWhiteTextColor, fontSize: primaryFeedAuthorFontSize, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Text("02/16/2022", style: TextStyle(fontSize: primaryFeedAuthorFontSize - 3, color: primaryWhiteTextColor),)
                        ],
                      ),
                      const SizedBox(height: 5,),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              child: Text(
                                lastMsg.text,
                                style: const TextStyle(fontSize: primaryFeedAuthorFontSize - 3, color: primaryWhiteTextColor),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ) 
                          ),
                          const SizedBox(width: 10,),
                          lastMsg.messageStatus == MessageStatus.notView ? 
                          const CircleAvatar(
                            backgroundColor: gradientEnd,
                            radius: 15,
                            child: Text(
                              "12",
                              style: TextStyle(fontSize: primaryFeedAuthorFontSize - 3, color: primaryWhiteTextColor, fontWeight: FontWeight.w600), 
                            ),
                          )
                          :
                          const SizedBox(width: 50,)
                          
                        ],
                      )
                    ],
                  ),
                )
              ),
            ]
          ), 
        ) 
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: chatBloc,
      listener: (context, state) {
        if (state is ChatItemFetchDoneState) {print('fech done state');}
      },
      child: Container(
        decoration: primaryBoxDecoration,
        child: Scaffold( 
          backgroundColor: Colors.transparent,
          body: BlocBuilder(
            bloc: chatBloc,
            builder: (context, state) {
              return SafeArea(
                child: Center(
                  child: Column(
                    children: [
                      customAppBarWidget(context),
                      searchInputWidget(context),
                      const SizedBox(height: 10,),
                      Expanded(
                        child: state is ChatItemFetchingState ?
                        const CupertinoActivityIndicator()
                        :
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: chatList.length,
                            itemBuilder: (context, idx) => GestureDetector(
                              onTap: () {},
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => BlocProvider(
                                        create: (context) => ChatBloc(chatRepository: ChatRepository()),
                                        child: const ChatBoardScreen(),
                                      )));
                                    },
                                    child: chatItemWidget(context, idx, chatList[idx]),
                                  ),
                                  const SizedBox(height: 5,)
                                ],
                              ),
                            )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        ),
      ),
    );
  }
}
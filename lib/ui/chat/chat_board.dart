import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:laravel_echo/laravel_echo.dart';
import 'package:overheard/ui/components/glassmorphism.dart';
import 'package:overheard/utils/ui_elements.dart';
import 'package:overheard/constants/colorset.dart';
import 'package:overheard/constants/fontsizeset.dart';
import 'package:overheard/constants/stringset.dart';
import 'package:overheard/ui/chat/bloc/chat_bloc.dart';
import 'package:overheard/ui/chat/bloc/chat_event.dart';
import 'package:overheard/ui/chat/bloc/chat_state.dart';
import 'package:overheard/ui/chat/models/ChatMessageModel.dart';
import 'package:overheard/ui/chat/repository/chat.repository.dart';
import 'package:overheard/ui/components/chat_bubble.dart';
import 'package:overheard/ui/components/chat_input.dart';
import 'package:overheard/ui/components/pagination.dart';

class ChatBoardScreen extends StatefulWidget {
  const ChatBoardScreen({Key? key});

  @override
  ChatBoardScreenState createState() {
    return ChatBoardScreenState();
  }
}

class ChatBoardScreenState extends State<ChatBoardScreen> {
  late ChatBloc chatBloc;
  late List<ChatMessageModel> msgLi;
  late TextEditingController inputController = TextEditingController();
  bool enableShowcase = false;
  late List keyList;
  late TextEditingController chatInputController;


  @override
  void initState() {
    super.initState();
    chatInputController = TextEditingController();
    msgLi = demoChatMessage;
    keyList = List.generate(msgLi.length, (index) => GlobalKey());
    chatBloc = ChatBloc(chatRepository: ChatRepository());
    chatBloc.add(const ChatMessageFetchingEvent());

    
  }

  void initSocket() {
    IO.Socket socket = IO.io(SOCKET_URL);
    socket.onConnect((data) {
      print('Socket connected');
      socket.emit('connect_res_msg', 'connection success');
    });
    socket.on('event', (data) => print(data));
    socket.onDisconnect((_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));
  }

  // Future<void> initPusher() async {
  //   final PusherOptions options = PusherOptions(
  //     host: BASE_ROUTE,
  //     wsPort: 6001,
  //     // wssPort: 6001,
  //     encrypted: false
  //   );
  //   PusherClient pusher;
  //   pusher = PusherClient(
  //     '12345', 
  //     options, 
  //     enableLogging: true,
  //     autoConnect: false
  //   );
  //   pusher.connect();

  //   pusher.onConnectionStateChange((state) {
  //     print("previousState: ${state!.previousState}, currentState: ${state.currentState}");
  //   });

  //   pusher.onConnectionError((error) {
  //       print("error: ${error!.message}");
  //   });
  //   Echo echo = Echo(
  //     broadcaster: EchoBroadcasterType.Pusher,
  //     client: pusher
  //   );
  //   echo.channel('chat')
  //       .listen('chat_started', (Map<String, dynamic> message) {
  //         print(message);
  //       })
  //       .listenForWhisper('typing', (Map<String, dynamic> user) {

  //       });
  //   // Channel channel = pusher.subscribe("private-orders");
  //   // channel.bind("order-status-updated", (PusherEvent? event) {
  //   //   print(event!.data);
  //   // });

  //   // pusher.unsubscribe("private-orders");
  //   // pusher.disconnect();

       
  // }

  void showShowcaseHandler(BuildContext context, int idx) {
    setState(() {
      enableShowcase = true;
    });
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => ShowCaseWidget.of(context)!.startShowCase(
        [keyList[idx]]
      )
    );
  }

  void closeShowcaseHandler() {
    setState(() {
      enableShowcase = false;
    });
  }

  void msgShowcaseHandler(String text, ChatMessageModel msg) {
    closeShowcaseHandler();
    if (text == resendText) {

    }else if (text == deleteText) {

    }else if (text == copyText) {
      FlutterClipboard.copy(msg.text).then(( value ) => showToast(copyClipboard, gradientStart));
    }
  }

  void sendMessageHandler() {
    if (chatInputController.text.isEmpty) {
      showToast(msgTextEmptyErrorText, gradientStart);
    }else if (chatInputController.text.length > 300) {
      showToast(wrong300ErrorText, gradientStart);
    }
  }

  

  Widget chatBoardBodyWidget(BuildContext context, Object? state) {
    return Expanded(
        child: state is ChatMessageFetchingState ?
        const CupertinoActivityIndicator() :
        RefreshIndicator(
          child: PaginationList<ChatMessageModel>(
            physics: const BouncingScrollPhysics(),
            prefix: const [],
            shrinkWrap: true,
            itemBuilder: (context, chatMsg) {
              return Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      chatMsg.isMine ? const Spacer() : const SizedBox.shrink(),
                      enableShowcase ? 
                      Showcase.withWidget(
                        key: keyList[msgLi.indexWhere((element) => element == chatMsg)],
                        width: 200,
                        height: 30,
                        overlayPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3),
                        disableAnimation: true,
                        animationDuration: const Duration(microseconds: 0),
                        child: GestureDetector(
                          child: ChatBubble(
                            text: chatMsg.text,
                            date: chatMsg.createdAt,
                            color: chatMsg.isMine ? gradientStart : gradientEnd,
                            isSender: chatMsg.isMine,
                            status: chatMsg.messageStatus,
                            textStyle: const TextStyle(
                              color: primaryWhiteTextColor,
                              fontSize: postContentFontSize
                            ),
                          ),
                        ),
                        container: SizedBox(
                          width: 200,
                          height: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              chatMsg.messageStatus == MessageStatus.notSent ? GestureDetector(
                                onTap: () {msgShowcaseHandler(resendText, chatMsg);},
                                child: Row(
                                  children: const [
                                    Expanded(
                                      child: Glassmorphism(
                                        blur: 20,
                                        opacity: 0.2,
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                          child: Text(
                                            resendText,
                                            style: TextStyle(
                                              color: primaryWhiteTextColor,
                                              fontSize: postContentFontSize + 2,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        )
                                      )
                                    )
                                  ],
                                )
                              ) : const SizedBox.shrink(),
                              chatMsg.messageStatus == MessageStatus.notSent ? const SizedBox(height: 5) : const SizedBox.shrink(),
                              chatMsg.messageStatus == MessageStatus.notSent ? GestureDetector(
                                onTap: () {msgShowcaseHandler(deleteText, chatMsg);},
                                child: Row(
                                  children: const [
                                    Expanded(
                                      child: Glassmorphism(
                                        blur: 20,
                                        opacity: 0.2,
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                          child: Text(
                                            deleteText,
                                            style: TextStyle(
                                              color: primaryWhiteTextColor,
                                              fontSize: postContentFontSize + 2,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        )
                                      )
                                    )
                                  ],
                                )
                              ) : const SizedBox.shrink(),
                              chatMsg.messageStatus != MessageStatus.notSent ? GestureDetector(
                                onTap: () {msgShowcaseHandler(copyText, chatMsg);},
                                child: Row(
                                  children: const [
                                    Expanded(
                                      child: Glassmorphism(
                                        blur: 20,
                                        opacity: 0.2,
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                          child: Text(
                                            copyText,
                                            style: TextStyle(
                                              color: primaryWhiteTextColor,
                                              fontSize: postContentFontSize + 2,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        )
                                      )
                                    )
                                  ],
                                )
                              ) : const SizedBox.shrink(),
                            ],
                          ),
                        )
                      )
                      :
                      GestureDetector(
                        onLongPress: () => {showShowcaseHandler(context, msgLi.indexWhere((element) => element == chatMsg))},
                        child: ChatBubble(
                          text: chatMsg.text,
                          date: chatMsg.createdAt,
                          color: chatMsg.isMine ? gradientStart : gradientEnd,
                          isSender: chatMsg.isMine,
                          status: chatMsg.messageStatus,
                          tail: chatMsg.messageType == ChatMessageType.text,
                          textStyle: const TextStyle(
                            color: primaryWhiteTextColor,
                            fontSize: postContentFontSize
                          ),
                        ),
                      ),
                      
                      chatMsg.isMine && chatMsg.messageStatus == MessageStatus.notSent ? const Icon(Icons.info, size: 20, color: primaryBackgroundColor,) : const SizedBox.shrink(),
                      const SizedBox(width: 10),
                    ],
                  )
                ],
              );
            },
            onError: (dynamic error) => const Center(
              child: Text('Something Went Wrong'),
            ),
            onEmpty: Column(
              children: const [
                SizedBox(height: 30),
                Text(
                  noMessageText,
                  style: TextStyle(color: primaryWhiteTextColor),
                )
              ],
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
      );
  }

  Widget mediaDialogWidget(BuildContext context){
    return CupertinoActionSheet(
    actions: [
      CupertinoActionSheetAction(
        child: const Text(
          photoVideoText,
          style: TextStyle(
              color: primaryColor,
              fontSize: primaryButtonFontSize
          ),
          textScaleFactor: 1.0,
        ),
        onPressed: () async {
          Navigator.of(context).pop();
          // XFile file = await ImagePicker().
        },
      ),
      
    ],
    cancelButton: CupertinoActionSheetAction(
      child: const Text(
        cancelButtonText,
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
            )
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
                        const SizedBox(height: 20),
                        ShowCaseWidget(
                          onFinish: () {closeShowcaseHandler();},
                          builder: Builder(
                            builder: (context) {
                              return chatBoardBodyWidget(context, state);
                            },
                          )
                        ),
                        
                        const SizedBox(height: 50,)
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
                              onTap: () {
                                showCupertinoModalPopup(
                                  context: context, 
                                  builder: (context) => mediaDialogWidget(context)
                                );
                              },
                              child: const CircleAvatar(
                                radius: 16,
                                backgroundColor: primaryColor,
                                child: Icon(Icons.add, size: appBarTitleFontSize + 10, color: primaryWhiteTextColor,),
                              )
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ChatInput(
                                controller: chatInputController,
                                suffixIconClick: () {sendMessageHandler();}
                              )
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
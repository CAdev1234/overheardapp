import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:overheard_flutter_app/constants/colorset.dart';
import 'package:overheard_flutter_app/constants/fontsizeset.dart';
import 'package:overheard_flutter_app/constants/stringset.dart';
import 'package:overheard_flutter_app/ui/auth/models/user_model.dart';
import 'package:overheard_flutter_app/ui/chat/bloc/chat.bloc.dart';
import 'package:overheard_flutter_app/ui/chat/chat.dart';
import 'package:overheard_flutter_app/ui/chat/repository/chat.repository.dart';
import 'package:overheard_flutter_app/ui/feed/bloc/feed.bloc.dart';
import 'package:overheard_flutter_app/ui/feed/create.dart';
import 'package:overheard_flutter_app/ui/feed/feed.dart';
import 'package:overheard_flutter_app/ui/feed/repository/feed.repository.dart';
import 'package:overheard_flutter_app/ui/home/bloc/home.bloc.dart';
import 'package:overheard_flutter_app/ui/home/repository/home.repository.dart';
import 'package:overheard_flutter_app/ui/notification/bloc/notification.bloc.dart';
import 'package:overheard_flutter_app/ui/notification/notification.dart';
import 'package:overheard_flutter_app/ui/notification/repository/notification.repository.dart';
import 'package:overheard_flutter_app/ui/profile/bloc/profile.bloc.dart';
import 'package:overheard_flutter_app/ui/profile/profile.dart';
import 'package:overheard_flutter_app/ui/profile/repository/profile.repository.dart';

import 'bloc/home.state.dart';

class HomeScreen extends StatefulWidget{
  final UserModel? userModel;
  HomeScreen({this.userModel});
  @override
  HomeScreenState createState() {
    return new HomeScreenState();
  }

}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin
{
  late HomeBloc homeBloc;
  List<Widget> pages = [];
  late TabController tabController;
  int tabIndex = 0;
  int oldIndex = 0;

  @override
  void initState(){
    super.initState();
    homeBloc = HomeBloc(homeRepository: HomeRepository());
    tabController = TabController(length: 5, vsync: this);

    /// Adding Feed UI
    pages.add(
        BlocProvider(
          create: (context) => FeedBloc(feedRepository: FeedRepository()),
          child: FeedScreen(),
        )
    );
    /// Adding Chat UI
    /*pages.add(
        BlocProvider(
          create: (context) => ChatBloc(chatRepository: ChatRepository()),
          child: ChatScreen(),
        )
    );*/
    /// Adding Create Post UI
    pages.add(
        BlocProvider(
          create: (context) => FeedBloc(feedRepository: FeedRepository()),
          child: CreateScreen(),
        )
    );
    /// Adding Notification UI
    /*pages.add(
        BlocProvider(
          create: (context) => NotificationBloc(notificationRepository: NotificationRepository()),
          child: NotificationScreen(),
        )
    );*/
    /// Adding Profile UI
    pages.add(
        BlocProvider(
          create: (context) => ProfileBloc(profileRepository: ProfileRepository()),
          child: ProfileScreen(isMine: true,),
        )
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: homeBloc,
      listener: (context, state){
        
      },
      child: BlocProvider<HomeBloc>(
        create: (context) => homeBloc,
        child: Container(
          decoration: primaryBoxDecoration,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: BlocBuilder<HomeBloc, HomeState>(
              bloc: homeBloc,
              builder: (context, state){
                return SafeArea(
                  child: pages[tabIndex],
                );
              },
            ),
            bottomNavigationBar: CupertinoTabBar(
              currentIndex: tabIndex,
              activeColor: primaryWhiteTextColor,
              inactiveColor: primaryWhiteTextColor.withOpacity(0.7),
              backgroundColor: primaryWhiteTextColor.withOpacity(0.2),
              onTap: (int index) async {
                if(index != 1){
                  setState(() {
                    tabIndex = index;
                    oldIndex = index;
                  });
                }
                else{
                  setState(() {
                    tabIndex = 1;
                  });
                  HomeScreenState state = this;
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => BlocProvider(
                    create: (context) => FeedBloc(feedRepository: FeedRepository()),
                    child: CreateScreen(),
                  )));
                  setState(() {
                    tabIndex = oldIndex;
                  });
                  /*showCupertinoModalPopup(
                      context: context,
                      builder: (context) => CupertinoActionSheet(
                        actions: [
                          CupertinoActionSheetAction(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          tabIndex = 1;
                                        });
                                        var updated = await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BlocProvider(
                                          create: (context) => FeedBloc(feedRepository: FeedRepository()),
                                          child: CreateScreen(),
                                        )));
                                        setState(() {
                                          tabIndex = oldIndex;
                                        });
                                      },
                                      child: Container(
                                        width: createPostButtonWidth,
                                        padding: EdgeInsets.only(top: 15, bottom: 15),
                                        decoration: BoxDecoration(
                                          color: gradientStart.withOpacity(0.8),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Column(
                                          children: [
                                            Icon(FontAwesome.feed, color: primaryWhiteTextColor, size: 17,),
                                            SizedBox(height: 10,),
                                            Text(
                                              feedPostText,
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                color: primaryWhiteTextColor,
                                                fontSize: createPostPopupFontSize
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    GestureDetector(
                                      onTap: (){

                                      },
                                      child: Container(
                                        width: createPostButtonWidth,
                                        padding: EdgeInsets.only(top: 15, bottom: 15),
                                        decoration: BoxDecoration(
                                          color: gradientStart.withOpacity(0.8),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Column(
                                          children: [
                                            Icon(MaterialIcons.streetview, color: primaryWhiteTextColor, size: 17,),
                                            SizedBox(height: 10,),
                                            Text(
                                              liveStreamPostText,
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                  color: primaryWhiteTextColor,
                                                  fontSize: createPostPopupFontSize
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            onPressed: (){},
                          )
                        ],
                        cancelButton: CupertinoActionSheetAction(
                          child: Icon(Ionicons.ios_close, color: gradientStart,),
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                        ),
                      )
                  );*/
                }
              },
              items: const <BottomNavigationBarItem> [
                BottomNavigationBarItem(
                  label: feedBottomButtonText,
                  // title: Text(
                  //   feedBottomButtonText,
                  //   style: TextStyle(
                  //     fontSize: bottomNavBarFontSize,
                  //     color: primaryWhiteTextColor
                  //   ),
                  // ),
                  icon: Icon(FontAwesome.feed),
                ),
                /*BottomNavigationBarItem(
                  title: Text(
                    chatBottomButtonText,
                    style: TextStyle(
                        fontSize: bottomNavBarFontSize,
                        color: primaryWhiteTextColor
                    ),
                  ),
                  icon: Icon(MaterialIcons.chat),
                ),*/
                BottomNavigationBarItem(
                  // title: Text(
                  //   createPostBottomButtonText,
                  //   style: TextStyle(
                  //       fontSize: bottomNavBarFontSize,
                  //       color: primaryWhiteTextColor
                  //   ),
                  // ),
                  label: createPostBottomButtonText,
                  icon: Icon(MaterialCommunityIcons.post_outline),
                ),
                /*BottomNavigationBarItem(
                  title: Text(
                    notificationsBottomButtonText,
                    style: TextStyle(
                        fontSize: bottomNavBarFontSize,
                        color: primaryWhiteTextColor
                    ),
                  ),
                  icon: Icon(Ionicons.ios_notifications),
                ),*/
                BottomNavigationBarItem(
                  // title: Text(
                  //   profileBottomButtonText,
                  //   style: TextStyle(
                  //       fontSize: bottomNavBarFontSize,
                  //       color: primaryWhiteTextColor
                  //   ),
                  // ),
                  label: profileBottomButtonText,
                  icon: Icon(AntDesign.profile),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
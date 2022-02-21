import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:overheard/constants/colorset.dart';
// import 'package:overheard/constants/fontsizeset.dart';
import 'package:overheard/constants/stringset.dart';
import 'package:overheard/ui/auth/models/user_model.dart';
import 'package:overheard/ui/chat/bloc/chat_bloc.dart';
import 'package:overheard/ui/chat/chat.dart';
import 'package:overheard/ui/chat/repository/chat.repository.dart';
// import 'package:overheard/ui/chat/bloc/chat.bloc.dart';
// import 'package:overheard/ui/chat/chat.dart';
// import 'package:overheard/ui/chat/repository/chat.repository.dart';
import 'package:overheard/ui/feed/bloc/feed_bloc.dart';
import 'package:overheard/ui/feed/create.dart';
import 'package:overheard/ui/feed/feed.dart';
import 'package:overheard/ui/feed/repository/feed.repository.dart';
import 'package:overheard/ui/home/bloc/home_bloc.dart';
import 'package:overheard/ui/home/repository/home.repository.dart';
import 'package:overheard/ui/notification/bloc/notification_bloc.dart';
import 'package:overheard/ui/notification/notification.dart';
import 'package:overheard/ui/notification/repository/notification.repository.dart';
// import 'package:overheard/ui/notification/bloc/notification.bloc.dart';
// import 'package:overheard/ui/notification/notification.dart';
// import 'package:overheard/ui/notification/repository/notification.repository.dart';
import 'package:overheard/ui/profile/bloc/profile_bloc.dart';
import 'package:overheard/ui/profile/profile.dart';
import 'package:overheard/ui/profile/repository/profile.repository.dart';

import 'bloc/home_event.dart';
import 'bloc/home_state.dart';

class HomeScreen extends StatefulWidget{
  final UserModel? userModel;
  // ignore: use_key_in_widget_constructors
  const HomeScreen({this.userModel});
  @override
  HomeScreenState createState() {
    return HomeScreenState();
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
          child: const FeedScreen(),
        )
    );
    /// Adding Chat UI
    pages.add(
        BlocProvider(
          create: (context) => ChatBloc(chatRepository: ChatRepository()),
          child: const ChatScreen(),
        )
    );
    /// Adding Create Post UI
    pages.add(
        BlocProvider(
          create: (context) => FeedBloc(feedRepository: FeedRepository()),
          child: const CreateScreen(),
        )
    );
    /// Adding Notification UI
    pages.add(
        BlocProvider(
          create: (context) => NotificationBloc(notificationRepository: NotificationRepository()),
          child: const NotificationScreen(),
        )
    );
    /// Adding Profile UI
    pages.add(
        BlocProvider(
          create: (context) => ProfileBloc(profileRepository: ProfileRepository()),
          child: const ProfileScreen(isMine: true,),
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
      listener: (context, state){},
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
              inactiveColor: primaryWhiteTextColor.withOpacity(0.4),
              backgroundColor: primaryWhiteTextColor.withOpacity(0.2),
              onTap: (int index) async {
                setState(() {
                  tabIndex = index;
                });
              },
              items: const <BottomNavigationBarItem> [
                BottomNavigationBarItem(
                  label: feedBottomButtonText,
                  icon: Icon(FontAwesome.feed),
                ),
                BottomNavigationBarItem(
                  label: chatBottomButtonText,
                  icon: Icon(MaterialIcons.chat),
                ),
                BottomNavigationBarItem(
                  label: createPostBottomButtonText,
                  icon: Icon(MaterialCommunityIcons.post_outline),
                ),
                BottomNavigationBarItem(
                  label: notificationsBottomButtonText,
                  icon: Icon(Ionicons.ios_notifications),
                ),
                BottomNavigationBarItem(
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
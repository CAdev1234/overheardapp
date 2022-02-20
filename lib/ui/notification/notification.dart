import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard_flutter_app/constants/colorset.dart';
import 'package:overheard_flutter_app/constants/fontsizeset.dart';
// import 'package:overheard_flutter_app/constants/stringset.dart';
import 'package:overheard_flutter_app/ui/notification/bloc/notification_bloc.dart';
import 'package:overheard_flutter_app/ui/notification/repository/notification.repository.dart';

import 'bloc/notification_state.dart';

class NotificationScreen extends StatefulWidget{
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  NotificationScreenState createState() {
    return NotificationScreenState();
  }

}

class NotificationScreenState extends State<NotificationScreen>{
  late NotificationBloc notificationBloc;

  @override
  void initState(){
    super.initState();
    notificationBloc = NotificationBloc(notificationRepository: NotificationRepository());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: notificationBloc,
      listener: (context, state){

      },
      child: Container(
        decoration: primaryBoxDecoration,
        child: Scaffold(
          appBar: const CupertinoNavigationBar(
            middle: Text(
              'Notifications',
              style: TextStyle(
                  fontSize: appBarTitleFontSize,
                  color: primaryWhiteTextColor
              ),
              textScaleFactor: 1.0,
            ),
          ),
          backgroundColor: Colors.transparent,
          body: BlocBuilder<NotificationBloc, NotificationState>(
            bloc: notificationBloc,
            builder: (context, state){
              return SafeArea(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('notifications')
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
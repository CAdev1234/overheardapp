import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:overheard_flutter_app/constants/colorset.dart';
import 'package:overheard_flutter_app/ui/splash/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(const OverheardApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
}



class OverheardApp extends StatefulWidget{
  const OverheardApp({Key? key}) : super(key: key);

  @override
  OverheardAppState createState() => OverheardAppState();
}

class OverheardAppState extends State<OverheardApp> {

  @override
  void initState(){
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      color: primaryColor,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      theme: CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: CupertinoDynamicColor(
            color: gradientStart,
            darkColor: gradientStart,
            highContrastColor: gradientStart,
            darkHighContrastColor: gradientStart,
            elevatedColor: gradientStart,
            darkElevatedColor: gradientStart,
            highContrastElevatedColor: gradientStart,
            darkHighContrastElevatedColor: gradientStart
        ),
        barBackgroundColor: CupertinoDynamicColor(
            color: gradientStart,
            darkColor: gradientStart,
            highContrastColor: gradientStart,
            darkHighContrastColor: gradientStart,
            elevatedColor: gradientStart,
            darkElevatedColor: gradientStart,
            highContrastElevatedColor: gradientStart,
            darkHighContrastElevatedColor: gradientStart
        ),
        scaffoldBackgroundColor: primaryBackgroundColor,
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(
            color: primaryWhiteTextColor
          ),
          primaryColor: CupertinoDynamicColor(
              color: primaryWhiteTextColor,
              darkColor: primaryWhiteTextColor,
              highContrastColor: primaryWhiteTextColor,
              darkHighContrastColor: primaryWhiteTextColor,
              elevatedColor: primaryWhiteTextColor,
              darkElevatedColor: primaryWhiteTextColor,
              highContrastElevatedColor: primaryWhiteTextColor,
              darkHighContrastElevatedColor: primaryWhiteTextColor
          )
        )
      ),
      home: SplashScreen(),
    );
  }
}

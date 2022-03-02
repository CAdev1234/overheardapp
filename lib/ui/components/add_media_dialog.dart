import 'package:flutter/cupertino.dart';
import 'package:overheard/constants/colorset.dart';
import 'package:overheard/constants/fontsizeset.dart';
import 'package:overheard/constants/stringset.dart';

WidgetBuilder mediaAddingRequestDialog(BuildContext context){
  return (context) => CupertinoActionSheet(
    actions: [
      CupertinoActionSheetAction(
        child: const Text(
          takePhotoText,
          style: TextStyle(
              color: primaryColor,
              fontSize: primaryButtonFontSize
          ),
          textScaleFactor: 1.0,
        ),
        onPressed: () async {

        },
      ),
      CupertinoActionSheetAction(
        child: const Text(
          chooseFromLibraryText,
          style: TextStyle(
              color: primaryColor,
              fontSize: primaryButtonFontSize
          ),
          textScaleFactor: 1.0,
        ),
        onPressed: () async {

        },
      )
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
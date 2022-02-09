import 'package:flutter/cupertino.dart';
import 'package:overheard_flutter_app/constants/colorset.dart';
import 'package:overheard_flutter_app/constants/fontsizeset.dart';
import 'package:overheard_flutter_app/constants/stringset.dart';

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
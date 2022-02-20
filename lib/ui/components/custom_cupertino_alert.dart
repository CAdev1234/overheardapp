import 'package:flutter/cupertino.dart';
import 'package:overheard_flutter_app/constants/colorset.dart';
import 'package:overheard_flutter_app/constants/fontsizeset.dart';

class CustomCupertinoAlert extends StatelessWidget {
  final String title;
  final String content;
  final String noBtnText;
  final String yesBtnText;
  final void Function() onNoAction;
  final void Function() onYesAction;
  const CustomCupertinoAlert({
    Key? key,
    required this.title,
    required this.content,
    required this.noBtnText,
    required this.yesBtnText,
    required this.onNoAction,
    required this.onYesAction
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Padding(
        padding: const EdgeInsetsDirectional.only(bottom: 10),
        child: Text(
          title,
          style: const TextStyle(
              fontSize: primaryButtonFontSize,
              color: primaryBlueTextColor
          ),
          textScaleFactor: 1.0,
        ),
      ),
      content: Text(
        content,
        style: const TextStyle(
            fontSize: primaryButtonMiddleFontSize,
            color: primaryBlueTextColor
        ),
        textScaleFactor: 1.0,
      ),
      actions: [
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: (){onNoAction();},
            child: Text(
              noBtnText,
              style: const TextStyle(
                  color: primaryBlueTextColor,
                  fontSize: primaryButtonMiddleFontSize
              ),
            )
        ),
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: (){onYesAction();},
            child: Text(
              yesBtnText,
              style: const TextStyle(
                  color: primaryBlueTextColor,
                  fontSize: primaryButtonMiddleFontSize
              ),
            )
        )
      ],
    );
  }
}
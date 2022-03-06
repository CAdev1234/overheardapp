import 'package:flutter/material.dart';
import 'package:overheard/constants/colorset.dart';
import 'package:overheard/ui/components/glassmorphism.dart';

class ChatInput extends StatelessWidget{

  void Function() suffixIconClick;
  TextEditingController controller;
  ChatInput({Key? key, required this.suffixIconClick, required this.controller}) : super(key: key);
  
  

  @override
  Widget build(BuildContext context) {
    return Glassmorphism(
      blur: 20, 
      opacity: 0.2, 
      borderRadius: const BorderRadius.all(Radius.circular(90)), 
      child: Container(
        height: 40,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 10, right: 5),
        decoration: const BoxDecoration(
          // color: Colors.white,
          // border: Border.all(color: Colors.white),
          // borderRadius: const BorderRadius.all(Radius.circular(90))
        ),
        child: TextField(
          controller: controller,
          style: const TextStyle(fontSize: 16, color: Colors.white),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Placeholder",
            hintStyle: const TextStyle(color: Colors.white38, fontSize: 16),
            suffixIcon: SizedBox(
              child: GestureDetector(
                onTap: () {suffixIconClick();},
                child: const CircleAvatar(
                  radius: 16,
                  backgroundColor: primaryColor,
                  child: Icon(Icons.arrow_upward, color: Colors.white),
                ),
              ),
            ),
            suffixIconConstraints: const BoxConstraints(maxWidth: 40)
          ),

        ),
      )
    );
  }
}
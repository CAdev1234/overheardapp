import 'dart:ui';
import 'package:flutter/material.dart';


class Glassmorphism extends StatelessWidget {
  
  final double blur;
  final double opacity;
  final Widget child;
  final double borderRadius;

  const Glassmorphism({
    Key? key, 
    required this.blur, 
    required this.opacity,
    required this.borderRadius, 
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(opacity),
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius)
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  


}
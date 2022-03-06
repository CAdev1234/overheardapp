import 'dart:ui';
import 'package:flutter/material.dart';


class Glassmorphism extends StatelessWidget {
  
  final double blur;
  final double opacity;
  final Widget child;
  final BorderRadius borderRadius;

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
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(opacity),
            borderRadius: borderRadius,
          ),
          child: child,
        ),
      ),
    );
  }

  


}
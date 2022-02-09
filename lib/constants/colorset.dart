import 'package:flutter/material.dart';


/// Theme Related Color sets
const Color primaryColor = Color(0xFF297FCA);
const Color primaryBackgroundColor = Colors.yellow;
const Color primaryMixedBackgroundColor = Color(0xFFE4F1FD);

const Color primaryDividerColor = Color(0xFFF1F8FE);
const Color primaryButtonColor = Color(0xFF3FA2F7);

const Color gradientStart = Color(0xFF6252D7);
const Color gradientEnd = Color(0xFFCC40BD);

const BoxDecoration primaryBoxDecoration = BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [gradientStart, gradientEnd]
    )
);

/// Theme Related Text Color sets
const Color primaryWhiteTextColor = Colors.white;
const Color primaryBlueTextColor = Color(0xFF297FCA);
const Color primaryPlaceholderTextColor = Color(0xFF94BFE4);
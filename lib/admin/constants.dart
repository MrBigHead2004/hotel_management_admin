import 'package:flutter/material.dart';

const primaryColor = Color.fromARGB(255, 75, 170, 255);

// dark mode
const darkPrimaryBgColor = Colors.black;
const darkSecondaryBgColor = Color.fromARGB(255, 24, 24, 24);
const darkTertiaryBgColor = Color.fromARGB(255, 32, 32, 32);
// padding
const defaultPadding = 8.0;

// corner radius
const defaultCornerRadius = 16.0;

// color function to get text color based on selection
Color getElementColor(bool isSelected, bool isDarkMode) {
  if (isSelected) {
    return isDarkMode ? Colors.white : Colors.black;
  } else {
    return isDarkMode ? Colors.white24 : Colors.black54;
  }
}
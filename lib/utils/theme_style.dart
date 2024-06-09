import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nata/utils/colors.dart';

class Themes {
  static final light = ThemeData(
    colorScheme: const ColorScheme.light(
      background: Color(0xfffFFFFF)
    ),
    primaryColor: primaryClr,
    brightness: Brightness.light,
  );

  static final dark = ThemeData(
    colorScheme: const ColorScheme.dark(
      background: Colors.black
    ),
    primaryColor: darkGreyClr,
    brightness: Brightness.dark,
  );
}

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Get.isDarkMode ? Colors.grey[400] : Colors.grey,
  ));
}

TextStyle get headingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Get.isDarkMode ? Colors.white : Colors.black,
  ));
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Get.isDarkMode ? Colors.white : Colors.black,
  ));
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Get.isDarkMode ? Colors.grey[100] : Colors.grey[600],
  ));
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kmainFontColor = Color.fromRGBO(19, 61, 95, 1);
const Color kfirstSuggestionBoxColor = Color.fromRGBO(165, 231, 244, 1);
const Color ksecondSuggestionBoxColor = Color.fromRGBO(157, 202, 235, 1);
const Color kthirdSuggestionBoxColor = Color.fromRGBO(162, 238, 239, 1);
const Color kassistantCircleColor = Color.fromRGBO(209, 243, 249, 1);
const Color kborderColor = Color.fromRGBO(200, 200, 200, 1);
const Color kBlack = Colors.black;
const Color kWhite = Colors.white;

const Color kLPrimaryColor = Color.fromARGB(255, 167, 19, 24);
const Color kLFeature1Color = Color.fromARGB(255, 255, 231, 233);
const Color kLFeature2Color = Color.fromARGB(255, 255, 217, 222);
const Color kLFeature3Color = Color.fromARGB(255, 255, 198, 203);

const Color kDPrimaryColor = Color.fromARGB(255, 27, 3, 138);
const Color kDFeature1Color = Color.fromARGB(255, 75, 108, 255);
const Color kDFeature2Color = Color.fromARGB(255, 40, 79, 255);
const Color kDFeature3Color = Color.fromARGB(255, 14, 58, 255);

//const Color kLFeature2Color = Color.fromARGB(255, 255, 217, 222);
//const Color kLFeature3Color = Color.fromARGB(255, 255, 198, 203);

double? kheight;
double? kwidth;

ThemeData lightMode = ThemeData(
  //useMaterial3: true,
  fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
  brightness: Brightness.light,
  primaryColor: Color.fromARGB(255, 167, 19, 24),
  colorScheme: ColorScheme.light(
    background: Colors.white,
    primary: Color.fromARGB(255, 167, 19, 24),
  ),
);

ThemeData darkMode = ThemeData(
  //useMaterial3: true,
  fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
  brightness: Brightness.dark,
  primaryColor: Color.fromARGB(255, 27, 3, 138),
  colorScheme: ColorScheme.dark(
      background: Colors.black, primary: Color.fromARGB(255, 27, 3, 138)),
);

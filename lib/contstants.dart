import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

// A class to hold all global constants for the project.
// The private constructor `_()` prevents instantiation of this utility class.
class AppConstants {
  AppConstants._(); // Private constructor

  // --- Colors ---
  static const Color primaryColor = Color.fromARGB(255, 0, 57, 2);
  static const Color secondaryColor = Color.fromARGB(150, 0, 100, 0);
  static const Color tertiaryColor = Color.fromARGB(150, 0, 200, 0);
  static const Color transGColor = Color.fromARGB(150, 0, 30, 0);
  // Using getters instead of static variables for dynamic colors (as it first need to fully initialize before assigning it)
  static Color get blackColorP7 => Colors.black.withAlpha((255 * 0.7).round());
  static Color get blackColorP5 => Colors.black.withAlpha((255 * 0.5).round());
  static Color get blackColorP3 => Colors.black.withAlpha((255 * 0.3).round());
  static Color get whiteColorP9 => Colors.white.withAlpha((255 * 0.9).round());
  static Color get whiteColorP5 => Colors.white.withAlpha((255 * 0.5).round());

  static const Color accentColor = Colors.lightBlueAccent;
  static const Color textColor = Colors.black87;
  static const Color errorColor = Colors.red;

  // --- Specific Text Styles (from your example) ---
  static TextStyle appBarTextStyle = GoogleFonts.playfairDisplay(
    fontWeight: FontWeight.bold,
    fontSize: 25.sp,
    wordSpacing: 5,
    color: Colors.white,
  );

  static final ThemeData customSelectionTheme = ThemeData.light().copyWith(
      textSelectionTheme: TextSelectionThemeData(
    selectionColor: tertiaryColor,
    selectionHandleColor: secondaryColor,
    cursorColor: secondaryColor,
  ));

  static const TextStyle sendButtonTextStyle = TextStyle(
    color: AppConstants.accentColor, // Reusing accentColor constant
    fontWeight: FontWeight.bold,
    fontSize: 18.0,
  );

  // General text styles can also live here
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppConstants.textColor,
  );

  // --- Input Decorations (from your example) ---
  static const InputDecoration messageTextFieldDecoration = InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    hintText: 'Type your message here...',
    border: InputBorder.none,
  );

  static const InputDecoration textFieldDecoration = InputDecoration(
    hintText: 'Enter a value',
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
  );

  // --- Box Decorations (from your example) ---
  static const BoxDecoration messageContainerDecoration = BoxDecoration(
    border: Border(
      top: BorderSide(
          color: AppConstants.accentColor, width: 2.0), // Reusing accentColor
    ),
  );

  // --- Padding & Margins ---
  static const EdgeInsets defaultPadding = EdgeInsets.all(16.0);
  static const double borderRadius = 10.0;
  static const double iconSize = 24.0;

  // --- Durations & Animation ---
  static const Duration animationDuration = Duration(milliseconds: 300);

  // --- App Specific Strings ---
  static const String appTitle = 'Flash Chat'; // Updated title for example
  static const String welcomeMessage = 'Welcome to Flash Chat!';
}

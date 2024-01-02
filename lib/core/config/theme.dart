import 'package:flutter/material.dart';
import '../utilities/constants/app_color.dart';

class AppTheme {
  static final darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'SF Pro',
    scaffoldBackgroundColor: const Color(0xFF1F1F1F),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.purple,
      secondary: const Color(0xff2e2f33),
      background: const Color(0xFF1F1F1F),
      surface: const Color(0xff31343b),
    ),

    listTileTheme: const ListTileThemeData(
      titleTextStyle: TextStyle(
        inherit: true,
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontFamily: 'SF Pro',
        fontSize: 15.0,
      ),
    ),
    primaryColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1F1F1F),
      foregroundColor: Colors.white,
    ),
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: AppColor.primaryColor,
      selectionHandleColor: AppColor.primaryColor,
    ),
    filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(backgroundColor: AppColor.primaryColor)),
    textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: AppColor.primaryColor)),
    textTheme: const TextTheme(
      bodySmall: TextStyle(
        inherit: true,
        color: Colors.white,
        fontFamily: 'SF Pro',
      ),
      bodyMedium: TextStyle(
        inherit: true,
        color: Colors.white,
        fontFamily: 'SF Pro',
      ),
      bodyLarge: TextStyle(
        inherit: true,
        color: Colors.white,
        fontFamily: 'SF Pro',
      ),
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: Colors.white,
      dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.deepPurple;
        }
        return Colors.transparent;
      },
      ),
    ),
  );

  static final lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'SF Pro',
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.purple,
      background: Colors.white,
      secondary: const Color(0xfff2f5fc),
      surface: const Color(0xffeff3fc),
    ),
    primaryColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xffffffff),
      foregroundColor: Colors.black,
    ),
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: AppColor.primaryColor,
      selectionHandleColor: AppColor.primaryColor,
    ),

    listTileTheme: const ListTileThemeData(
      titleTextStyle: TextStyle(
        inherit: true,
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontFamily: 'SF Pro',
        fontSize: 15.0,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColor.primaryColor,
      ),
    ),
    textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: AppColor.primaryColor)),
    textTheme: const TextTheme(
      bodySmall: TextStyle(
        inherit: true,
        color: Colors.black,
        fontFamily: 'SF Pro',
      ),
      bodyMedium: TextStyle(
        inherit: true,
        color: Colors.black,
        fontFamily: 'SF Pro',
      ),
      bodyLarge: TextStyle(
        inherit: true,
        color: Colors.black,
        fontFamily: 'SF Pro',
      ),
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: Colors.white,
      dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.deepPurple;
        }
        return Colors.transparent;
      },
      ),
    ),
  );
}

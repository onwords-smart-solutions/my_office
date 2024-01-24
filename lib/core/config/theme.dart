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
      onSurface: Colors.white,
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
      surfaceTintColor: Colors.transparent,
      backgroundColor: Color(0xFF1F1F1F),
      foregroundColor: Colors.white,
    ),
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: AppColor.primaryColor,
      selectionHandleColor: AppColor.primaryColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple.shade300)),
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
    timePickerTheme: TimePickerThemeData(
      elevation: 0.5,
      backgroundColor: const Color(0xff2e2f33),
      dayPeriodColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected) ? AppColor.primaryColor : Colors.black54,
      ),
      dayPeriodTextColor: Colors.white,
      hourMinuteColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected) ? AppColor.primaryColor : Colors.black54,
      ),
      hourMinuteTextColor: Colors.white,
      dialHandColor: AppColor.primaryColor,
      dialBackgroundColor: Colors.black54,
      dialTextColor: Colors.white,
      helpTextStyle: const TextStyle(fontSize: 14, color: Colors.white),
      entryModeIconColor: AppColor.primaryColor,
    ),
    datePickerTheme: DatePickerThemeData(
      weekdayStyle: const TextStyle(color: Colors.white),
      headerForegroundColor: Colors.white,
      dayForegroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
      todayForegroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
      backgroundColor: const Color(0xff31343b),
      elevation: .5,
      yearForegroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
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
      surfaceTintColor: Colors.transparent,
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
    elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple.shade300)),
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
    timePickerTheme: TimePickerThemeData(
      elevation: 0.5,
      backgroundColor: const Color(0xfff2f5fc),
      dayPeriodColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected) ? AppColor.primaryColor : Colors.white,
      ),
      dayPeriodTextColor: Colors.black,
      hourMinuteColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected) ? AppColor.primaryColor : Colors.white,
      ),
      hourMinuteTextColor: Colors.black,
      dialHandColor: AppColor.primaryColor,
      dialBackgroundColor: Colors.white,
      dialTextColor: Colors.black,
      helpTextStyle: const TextStyle(fontSize: 14, color: Colors.black),
      entryModeIconColor: AppColor.primaryColor,
    ),
    datePickerTheme: DatePickerThemeData(
      headerForegroundColor: Colors.black,
      backgroundColor: AppColor.backGroundColor,
      elevation: .5,
      yearForegroundColor: MaterialStateColor.resolveWith((states) => Colors.black),
    ),
  );
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_office/features/user/domain/entity/user_entity.dart';

import '../../../features/home/presentation/view/home_menu_item.dart';
import '../../../features/home/data/model/staff_access_model.dart';
import '../constants/app_color.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<StaffAccessModel> allAccess;
  final UserEntity staffInfo;

  CustomSearchDelegate({
    required this.allAccess,
    required this.staffInfo,
  });

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor == const Color(0xFF1F1F1F) ?
    ThemeData(
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
      hintColor: Theme.of(context).primaryColor.withOpacity(.4),
      inputDecorationTheme: const InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
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
          fontWeight: FontWeight.w500,
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
    ) :
    ThemeData(
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
      hintColor: Theme.of(context).primaryColor.withOpacity(.4),
      inputDecorationTheme: const InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
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
          fontWeight: FontWeight.w500,
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

  @override
  List<Widget>? buildActions(BuildContext context) {
    return query.isEmpty
        ? []
        : [
            IconButton(
              onPressed: () => query = '',
              icon: const Icon(
                CupertinoIcons.clear_circled_solid,
              ),
            ),
          ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, query),
      icon: const Icon(
        Icons.arrow_back_ios_new_rounded,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _resultItems(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _resultItems(context);
  }

  Widget _resultItems(BuildContext context) {
    final searchedItems = allAccess
        .where((element) =>
            element.title.toLowerCase().contains(query.trim().toLowerCase()),)
        .toList();
    return searchedItems.isEmpty
        ? Center(
            child: Text(
              'No result found for "$query"',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
          )
        : GridView.builder(
            itemCount: searchedItems.length,
            shrinkWrap: true,
            padding: const EdgeInsets.all(10.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 15.0,
              mainAxisSpacing: 30,
            ),
            itemBuilder: (BuildContext context, int index) {
              return HomeMenuItem(
                title: searchedItems[index].title,
                image: searchedItems[index].image,
                staff: staffInfo,
              );
            },
          );
  }
}

import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/core/utilities/constants/app_color.dart';
import 'package:my_office/features/attendance/presentation/provider/attendance_provider.dart';
import 'package:my_office/features/attendance/presentation/view/attendance_punch_screen.dart';
import 'package:provider/provider.dart';

import '../../../../core/utilities/constants/app_main_template.dart';
import '../../../home/presentation/view_model/custom_punch_model.dart';

class AttendanceScreen extends StatefulWidget {
  final String userId;
  final String staffName;

  const AttendanceScreen({
    Key? key,
    required this.userId,
    required this.staffName,
  }) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final List<String> _dropDown = [
    'All',
    "Present",
    'Absentees',
    'Late Entry',
    "ID Tap",
    'Proxy',
  ];

  ///notifiers
  final ValueNotifier<List<CustomPunchModel>> _punchingDetails =
  ValueNotifier([]);
  final ValueNotifier<List<CustomPunchModel>> _sortedList = ValueNotifier([]);
  final ValueNotifier<DateTime> _selectedDate = ValueNotifier(DateTime.now());
  final ValueNotifier<String> _sortOption = ValueNotifier('All');
  final ValueNotifier<bool> _isLoading = ValueNotifier(true);

  @override
  void initState() {
    final attendanceProvider = Provider.of<AttendanceProvider>(context,listen: false);
    attendanceProvider.getPunchingTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      subtitle: 'Punching Time',
      templateBody: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: _punchingTimeBody(),
      ),
      bgColor: AppColor.backGroundColor,
    );
  }

  Widget _punchingTimeBody() {
    return Column(
      children: [
        ValueListenableBuilder(
          valueListenable: _isLoading,
          builder: (ctx, isLoading, child) {
            return isLoading
                ? const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Fetching data',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 5.0),
                CircleAvatar(
                  child: SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                    ),
                  ),
                ),
              ],
            )
                : Column(
              children: [
                //search bar and total count
                _search(),
                // head section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //date picker
                    ValueListenableBuilder(
                      valueListenable: _selectedDate,
                      builder: (ctx, date, child) {
                        return TextButton.icon(
                          onPressed: _showDatePicker,
                          icon: const Icon(Icons.calendar_month_rounded),
                          label: Text(formatDate(date)),
                        );
                      },
                    ),
                    //total
                    ValueListenableBuilder(
                      valueListenable: _sortedList,
                      builder: (ctx, sortedList, child) {
                        return Row(
                          children: [
                            Text(
                              'Total : ${sortedList.length}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 17.0,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    //sorter
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 20.0),
                      child: PopupMenuButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        position: PopupMenuPosition.under,
                        elevation: 10,
                        itemBuilder: (ctx) => List.generate(
                          _dropDown.length,
                              (i) {
                            return PopupMenuItem(
                              child: Text(
                                _dropDown[i],
                                style: const TextStyle(fontSize: 16),
                              ),
                              onTap: () {
                                _sortOption.value = _dropDown[i];
                                if (_dropDown[i] == 'All') {
                                  _sortedList.value =
                                      _punchingDetails.value;
                                } else if (_dropDown[i] == 'Present') {
                                  _sortedList.value = _punchingDetails
                                      .value
                                      .where(
                                        (element) =>
                                    element.checkInTime != null,
                                  )
                                      .toList();
                                } else if (_dropDown[i] == 'Absentees') {
                                  _sortedList.value = _punchingDetails
                                      .value
                                      .where(
                                        (element) =>
                                    element.checkInTime == null,
                                  )
                                      .toList();
                                } else if (_dropDown[i] == 'Late Entry') {
                                  _sortedList.value =
                                      _punchingDetails.value
                                          .where(
                                            (element) =>
                                        (element.checkInTime !=
                                            null) &&
                                            (element.checkInTime!
                                                .difference(
                                              DateTime(
                                                element
                                                    .checkInTime!
                                                    .year,
                                                element
                                                    .checkInTime!
                                                    .month,
                                                element
                                                    .checkInTime!
                                                    .day,
                                                09,
                                                00,
                                              ),
                                            )
                                                .inMinutes >
                                                10),
                                      )
                                          .toList();
                                } else if (_dropDown[i] == 'ID Tap') {
                                  _sortedList.value = _punchingDetails
                                      .value
                                      .where(
                                        (element) =>
                                    (!element.isProxy) &&
                                        element.checkInTime != null,
                                  )
                                      .toList();
                                } else if (_dropDown[i] == 'Proxy') {
                                  _sortedList.value = _punchingDetails
                                      .value
                                      .where((element) => element.isProxy)
                                      .toList();
                                }
                              },
                            );
                          },
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(CupertinoIcons.sort_down),
                            ValueListenableBuilder(
                              valueListenable: _sortOption,
                              builder: (ctx, sort, child) {
                                return Text(
                                  sort,
                                  style: const TextStyle(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        //list view
        Expanded(child: _entryList()),
      ],
    );
  }

  Widget _search() {
    final attendanceProvider = Provider.of<AttendanceProvider>(context,listen: false);
    return Row(
      children: [
        Flexible(
          child: CupertinoSearchTextField(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.grey.withOpacity(.3),
            ),
            onSubmitted: (value) => _sortedList.value = _punchingDetails.value
                .where(
                  (element) => element.name
                  .toLowerCase()
                  .contains(value.trim().toLowerCase()),
            )
                .toList(),
            onChanged: (value) => _sortedList.value = _punchingDetails.value
                .where(
                  (element) => element.name
                  .toLowerCase()
                  .contains(value.trim().toLowerCase()),
            )
                .toList(),
            padding: const EdgeInsets.all(10.0),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColor.primaryColor,
            ),
            suffixIcon: const Icon(
              CupertinoIcons.xmark_circle_fill,
              color: Colors.grey,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: AppColor.primaryColor,
            ),
          ),
        ),
        IconButton(
          onPressed: () => attendanceProvider.printScreen(),
          icon: const Icon(Icons.print_rounded),
        ),
      ],
    );
  }

  Widget _entryList() {
    return ValueListenableBuilder(
      valueListenable: _sortOption,
      builder: (ctx, sortOption, child) {
        return ValueListenableBuilder(
          valueListenable: _punchingDetails,
          builder: (ctx, punchingList, child) {
            return ValueListenableBuilder(
              valueListenable: _isLoading,
              builder: (ctx, loading, child) {
                return (loading && punchingList.isEmpty)
                    ? Center(
                  child:
                  Lottie.asset('assets/animations/new_loading.json'),
                )
                    : ValueListenableBuilder(
                  valueListenable: _sortedList,
                  builder: (ctx, sortedList, child) {
                    sortedList.sort((a, b) => a.name.compareTo(b.name));

                    return sortedList.isEmpty
                        ? const Center(
                      child: Text(
                        'No details found',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                        ),
                      ),
                    )
                        : ListView.builder(
                      itemCount: sortedList.length,
                      itemBuilder: (ctx, index) {
                        return AttendancePunchItem(
                          punchDetail: sortedList[index],
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  _showDatePicker() async {
    final attendanceProvider = Provider.of<AttendanceProvider>(context,listen: false);
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate.value,
      firstDate: DateTime(2023),
      lastDate: DateTime(2200),
    );
    if (date == null) return;
    _selectedDate.value = date;
    attendanceProvider.getPunchingTime();
  }
}

/// date formatter
String formatDate(DateTime date) => DateFormat.yMMMd().format(date);

String duration(DateTime start, DateTime end) {
  final diff = end.difference(start);
  int hours = diff.inHours;
  int minutes = diff.inMinutes % 60;

  return '${hours}h ${minutes}m';
}
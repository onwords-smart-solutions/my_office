import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/models/staff_entry_model.dart';
import 'package:my_office/tl_check_screen/punch_item.dart';
import 'package:shimmer/shimmer.dart';
import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import '../models/custom_punching_model.dart';
import '../util/main_template.dart';

class CheckEntryScreen extends StatefulWidget {
  final String userId;
  final String staffName;

  const CheckEntryScreen({Key? key, required this.userId, required this.staffName}) : super(key: key);

  @override
  State<CheckEntryScreen> createState() => _CheckEntryScreenState();
}

class _CheckEntryScreenState extends State<CheckEntryScreen> {
  final List<String> _dropDown = ['All', "Present", 'Absentees', 'Late Entry', "ID Tap", 'Proxy'];

  ///notifiers
  final ValueNotifier<List<CustomPunchModel>> _punchingDetails = ValueNotifier([]);
  final ValueNotifier<List<CustomPunchModel>> _sortedList = ValueNotifier([]);
  final ValueNotifier<DateTime> _selectedDate = ValueNotifier(DateTime.now());
  final ValueNotifier<String> _sortOption = ValueNotifier('All');
  final ValueNotifier<bool> _isLoading = ValueNotifier(true);

  @override
  void initState() {
    _getPunchingTime();
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
        bgColor: ConstantColor.background1Color);
  }

  Widget _punchingTimeBody() {
    return Column(
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
                }),
            //total
            ValueListenableBuilder(
                valueListenable: _isLoading,
                builder: (ctx, isLoading, child) {
                  return ValueListenableBuilder(
                      valueListenable: _sortedList,
                      builder: (ctx, sortedList, child) {
                        return Row(
                          children: [
                            Text(
                              'Total : ${sortedList.length}',
                              style: TextStyle(
                                fontFamily: ConstantFonts.sfProBold,
                                fontSize: 17.0,
                              ),
                            ),
                            if (isLoading) ...[
                              const SizedBox(width: 10.0),
                              const SizedBox(
                                height: 20.0,
                                width: 20.0,
                                child: CircularProgressIndicator(strokeWidth: 2.0),
                              )
                            ]
                          ],
                        );
                      });
                }),
            //sorter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                        style: TextStyle(fontFamily: ConstantFonts.sfProMedium, fontSize: 16),
                      ),
                      onTap: () {
                        _sortOption.value = _dropDown[i];
                        if (_dropDown[i] == 'All') {
                          _sortedList.value = _punchingDetails.value;
                        } else if (_dropDown[i] == 'Present') {
                          _sortedList.value =
                              _punchingDetails.value.where((element) => element.checkInTime != null).toList();
                        } else if (_dropDown[i] == 'Absentees') {
                          _sortedList.value =
                              _punchingDetails.value.where((element) => element.checkInTime == null).toList();
                        } else if (_dropDown[i] == 'Late Entry') {
                          _sortedList.value = _punchingDetails.value
                              .where(
                                (element) =>
                                    (element.checkInTime != null) &&
                                    (element.checkInTime!
                                            .difference(DateTime(element.checkInTime!.year, element.checkInTime!.month,
                                                element.checkInTime!.day, 09, 00))
                                            .inMinutes >
                                        10),
                              )
                              .toList();
                        } else if (_dropDown[i] == 'ID Tap') {
                          _sortedList.value = _punchingDetails.value
                              .where((element) => (!element.isProxy) && element.checkInTime != null)
                              .toList();
                        } else if (_dropDown[i] == 'Proxy') {
                          _sortedList.value = _punchingDetails.value.where((element) => element.isProxy).toList();
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
                            style: TextStyle(fontFamily: ConstantFonts.sfProMedium),
                          );
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
        //list view
        Expanded(child: _entryList()),
      ],
    );
  }

  Widget _search() {
    return CupertinoSearchTextField(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.grey.withOpacity(.3),
        ),
        onSubmitted: (value) => _sortedList.value = _punchingDetails.value
            .where((element) => element.name.toLowerCase().contains(value.trim().toLowerCase()))
            .toList(),
        onChanged: (value) => _sortedList.value = _punchingDetails.value
            .where((element) => element.name.toLowerCase().contains(value.trim().toLowerCase()))
            .toList(),
        padding: const EdgeInsets.all(10.0),
        style: TextStyle(fontFamily: 'Poppins', color: Theme.of(context).primaryColor),
        suffixIcon: const Icon(CupertinoIcons.xmark_circle_fill, color: Colors.grey),
        prefixIcon: Icon(Icons.search_rounded, color: Theme.of(context).primaryColor));
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
                        ? Center(child: Lottie.asset('assets/animations/new_loading.json'))
                        : ValueListenableBuilder(
                            valueListenable: _sortedList,
                            builder: (ctx, sortedList, child) {
                              sortedList.sort((a,b)=>a.name.compareTo(b.name));

                              return sortedList.isEmpty
                                  ? Center(
                                      child: Text(
                                      'No details found',
                                      style: TextStyle(fontFamily: ConstantFonts.sfProBold, fontSize: 16.0),
                                    ))
                                  : ListView.builder(
                                      itemCount: sortedList.length,
                                      itemBuilder: (ctx, index) {
                                        return PunchItem(punchDetail: sortedList[index]);
                                      });
                            });
                  },
                );
              });
        });
  }

  _showDatePicker() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate.value,
      firstDate: DateTime(2019),
      lastDate: DateTime(2200),
    );
    if (date == null) return;
    if (_isLoading.value) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(backgroundColor: Colors.red, content: Text('Please wait until current process finish')));
    } else {
      _selectedDate.value = date;
      _getPunchingTime();
    }
  }

  ///----FUNCTIONS---
  Future<void> _getPunchingTime() async {
    _isLoading.value = true;
    _sortedList.value.clear();
    _punchingDetails.value.clear();
    final allStaffs = await _getStaffDetails();

    //getting staff entry times
    for (var staff in allStaffs) {
      final data = await _checkTime(staff.uid, staff.name, staff.department);
      if (data != null) {
        _punchingDetails.value.add(data);
        _sortedList.value.add(data);
      } else {
        _punchingDetails.value.add(
          CustomPunchModel(
            name: staff.name,
            staffId: staff.uid,
            department: staff.department,
            checkInTime: null,
          ),
        );
        _sortedList.value.add(
          CustomPunchModel(
            name: staff.name,
            staffId: staff.uid,
            department: staff.department,
            checkInTime: null,
          ),
        );
      }
      _sortedList.notifyListeners();
      _punchingDetails.notifyListeners();
    }
    _isLoading.value = false;
  }

  Future<List<StaffAttendanceModel>> _getStaffDetails() async {
    List<StaffAttendanceModel> staffs = [];
    await FirebaseDatabase.instance.ref('staff').once().then((staff) async {
      for (var data in staff.snapshot.children) {
        var entry = data.value as Map<Object?, Object?>;
        final staffEntry = StaffAttendanceModel(
          uid: data.key.toString(),
          department: entry['department'].toString(),
          name: entry['name'].toString(),
        );
        if (staffEntry.name != 'Nikhil Deepak') {
          staffs.add(staffEntry);
        }
      }
    });
    return staffs;
  }

  Future<CustomPunchModel?> _checkTime(String staffId, String name, String department) async {
    CustomPunchModel? punchDetail;
    String dateFormat = DateFormat('yyyy-MM-dd').format(_selectedDate.value);
    await FirebaseDatabase.instance.ref('fingerPrint/$staffId/$dateFormat').once().then((value) async {
      if (value.snapshot.exists) {
        List<DateTime> allPunchedTime = [];
        for (var tapTime in value.snapshot.children) {
          String? tapTimeString = tapTime.key;
          if (tapTimeString != null) {
            //spitting time based on colon
            final timeList = tapTimeString.split(':');

            //converting splitted time into datetime format
            final tapTimeDateFormat = DateTime(
              _selectedDate.value.year,
              _selectedDate.value.month,
              _selectedDate.value.day,
              int.parse(timeList[0]),
              int.parse(timeList[1]),
              int.parse(timeList[2]),
            );
            allPunchedTime.add(tapTimeDateFormat);
          }
        }
        // checking for check in and check out time
        if (allPunchedTime.isNotEmpty) {
          DateTime? checkInTime;
          DateTime? checkOutTime;
          allPunchedTime.sort();

          checkInTime = allPunchedTime.first;
          if (allPunchedTime.last.difference(checkInTime).inMinutes > 5) {
            checkOutTime = allPunchedTime.last;
          }

          checkOutTime ??= await _checkProxyCheckOut(staffId, dateFormat);

          punchDetail = CustomPunchModel(
              name: name,
              staffId: staffId,
              department: department,
              checkInTime: checkInTime,
              checkOutTime: checkOutTime);
        }
      } else {
        //check in proxy attendance
        punchDetail = await _checkProxyEntry(staffId, dateFormat, department);
      }
    });
    return punchDetail;
  }

  Future<CustomPunchModel?> _checkProxyEntry(String staffId, String dateFormat, String department) async {
    CustomPunchModel? punchDetail;
    await FirebaseDatabase.instance.ref('proxy_attendance/$staffId/$dateFormat').once().then((proxy) async {
      if (proxy.snapshot.exists) {
        Map<Object?, Object?> checkInDetail = {};
        Map<Object?, Object?> checkOutDetail = {};
        if (proxy.snapshot.child('Check-in').exists) {
          checkInDetail = proxy.snapshot.child('Check-in').value as Map<Object?, Object?>;
        }
        if (proxy.snapshot.child('Check-out').exists) {
          checkOutDetail = proxy.snapshot.child('Check-out').value as Map<Object?, Object?>;
        }
        punchDetail = CustomPunchModel(
            name: checkInDetail['Name'].toString(),
            staffId: staffId,
            department: department,
            checkInTime: DateTime.fromMillisecondsSinceEpoch(int.parse(checkInDetail['Time'].toString())),
            checkOutTime: checkOutDetail.isEmpty
                ? null
                : DateTime.fromMillisecondsSinceEpoch(int.parse(checkOutDetail['Time'].toString())),
            checkInProxyBy: checkInDetail['Proxy'].toString(),
            checkInReason: checkInDetail['Reason'].toString(),
            checkOutProxyBy: checkOutDetail.isEmpty ? '' : checkOutDetail['Name'].toString(),
            checkOutReason: checkOutDetail.isEmpty ? '' : checkOutDetail['Reason'].toString(),
            isProxy: true);
      }
    });
    return punchDetail;
  }
}

Future<DateTime?> _checkProxyCheckOut(String staffId, String dateFormat) async {
  DateTime? checkOut;
  await FirebaseDatabase.instance.ref('proxy_attendance/$staffId/$dateFormat').once().then((proxy) async {
    if (proxy.snapshot.exists) {
      if (proxy.snapshot.child('Check-out').exists) {
        final data = proxy.snapshot.child('Check-out').value as Map<Object?, Object?>;
        checkOut = DateTime.fromMillisecondsSinceEpoch(int.parse(data['Time'].toString()));
      }
    }
  });
  return checkOut;
}

/// date formatter
String formatDate(DateTime date) => DateFormat.yMMMd().format(date);

class Skeleton extends StatelessWidget {
  const Skeleton({
    Key? key,
    this.height,
    this.width,
  }) : super(key: key);
  final double? height, width;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: height,
      width: width,
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: ConstantColor.background1Color),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade400,
        highlightColor: Colors.grey.shade100,
        child: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: size.width * 0.05,
            ),
            Container(
              height: size.height * 0.05,
              width: size.width * 0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
            ),
            SizedBox(width: size.width * 0.055),
            Container(
              height: size.height * 0.05,
              width: size.width * 0.20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}

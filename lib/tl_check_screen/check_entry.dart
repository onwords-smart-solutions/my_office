import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/models/staff_entry_model.dart';
import 'package:my_office/tl_check_screen/punch_item.dart';
import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import '../models/custom_punching_model.dart';
import '../util/main_template.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CheckEntryScreen extends StatefulWidget {
  final String userId;
  final String staffName;

  const CheckEntryScreen(
      {Key? key, required this.userId, required this.staffName})
      : super(key: key);

  @override
  State<CheckEntryScreen> createState() => _CheckEntryScreenState();
}

class _CheckEntryScreenState extends State<CheckEntryScreen> {
  final List<String> _dropDown = [
    'All',
    "Present",
    'Absentees',
    'Late Entry',
    "ID Tap",
    'Proxy'
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
      bgColor: ConstantColor.background1Color,
    );
  }

  Widget _punchingTimeBody() {
    return Column(
      children: [
        ValueListenableBuilder(
          valueListenable: _isLoading,
          builder: (ctx, isLoading, child) {
            return isLoading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Fetching data',
                        style: TextStyle(
                          fontFamily: ConstantFonts.sfProBold,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      const CircleAvatar(
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
                                    style: TextStyle(
                                      fontFamily: ConstantFonts.sfProBold,
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
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    onTap: () {
                                      _sortOption.value = _dropDown[i];
                                      if (_dropDown[i] == 'All') {
                                        _sortedList.value =
                                            _punchingDetails.value;
                                      } else if (_dropDown[i] == 'Present') {
                                        _sortedList.value = _punchingDetails
                                            .value
                                            .where((element) =>
                                                element.checkInTime != null)
                                            .toList();
                                      } else if (_dropDown[i] == 'Absentees') {
                                        _sortedList.value = _punchingDetails
                                            .value
                                            .where((element) =>
                                                element.checkInTime == null)
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
                                            .where((element) =>
                                                (!element.isProxy) &&
                                                element.checkInTime != null)
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
                                        style: TextStyle(),
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
    return Row(
      children: [
        Flexible(
          child: CupertinoSearchTextField(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.grey.withOpacity(.3),
            ),
            onSubmitted: (value) => _sortedList.value = _punchingDetails.value
                .where((element) => element.name
                    .toLowerCase()
                    .contains(value.trim().toLowerCase()))
                .toList(),
            onChanged: (value) => _sortedList.value = _punchingDetails.value
                .where((element) => element.name
                    .toLowerCase()
                    .contains(value.trim().toLowerCase()))
                .toList(),
            padding: const EdgeInsets.all(10.0),
            style: TextStyle(
                fontFamily: 'Poppins', color: Theme.of(context).primaryColor),
            suffixIcon: const Icon(CupertinoIcons.xmark_circle_fill,
                color: Colors.grey),
            prefixIcon: Icon(Icons.search_rounded,
                color: Theme.of(context).primaryColor),
          ),
        ),
        IconButton(
            onPressed: _printScreen, icon: const Icon(Icons.print_rounded)),
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
                            Lottie.asset('assets/animations/new_loading.json'))
                    : ValueListenableBuilder(
                        valueListenable: _sortedList,
                        builder: (ctx, sortedList, child) {
                          sortedList.sort((a, b) => a.name.compareTo(b.name));

                          return sortedList.isEmpty
                              ? Center(
                                  child: Text(
                                    'No details found',
                                    style: TextStyle(
                                        fontFamily: ConstantFonts.sfProBold,
                                        fontSize: 16.0),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: sortedList.length,
                                  itemBuilder: (ctx, index) {
                                    return PunchItem(
                                        punchDetail: sortedList[index]);
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
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate.value,
      firstDate: DateTime(2019),
      lastDate: DateTime(2200),
    );
    if (date == null) return;
    _selectedDate.value = date;
    _getPunchingTime();
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

  Future<CustomPunchModel?> _checkTime(
      String staffId, String name, String department) async {
    CustomPunchModel? punchDetail;
    bool isProxy = false;
    DateTime? checkInTime;
    DateTime? checkOutTime;

    String dateFormat = DateFormat('yyyy-MM-dd').format(_selectedDate.value);
    await FirebaseDatabase.instance
        .ref('fingerPrint/$staffId/$dateFormat')
        .once()
        .then((value) async {
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
          allPunchedTime.sort();
          checkInTime = allPunchedTime.first;
          if (allPunchedTime.length > 1) {
            if (allPunchedTime.last.difference(checkInTime!).inMinutes > 5) {
              checkOutTime = allPunchedTime.last;
            }
          }
        }
      }
    });
    //check in proxy attendance
    final punchDetailFromProxy =
        await _checkProxyEntry(staffId, dateFormat, department);

    if (punchDetailFromProxy != null) {
      // check in time
      if (punchDetailFromProxy.checkInTime != null) {
        if (checkInTime == null) {
          checkInTime = punchDetailFromProxy.checkInTime;
          isProxy = true;
        } else {
          final check =
              checkInTime!.compareTo(punchDetailFromProxy.checkInTime!);
          if (check == 1) {
            if (checkOutTime == null) {
              if (checkInTime!
                      .difference(punchDetailFromProxy.checkInTime!)
                      .inMinutes >
                  5) {
                checkOutTime = checkInTime;
              }
            }

            checkInTime = punchDetailFromProxy.checkInTime!;
            isProxy = true;
          }
        }
      }

      //check out time
      if (punchDetailFromProxy.checkOutTime != null) {
        if (checkOutTime == null) {
          checkOutTime = punchDetailFromProxy.checkOutTime;
          isProxy = true;
        } else {
          final check =
              checkOutTime!.compareTo(punchDetailFromProxy.checkOutTime!);
          if (check == -1) {
            checkOutTime = punchDetailFromProxy.checkOutTime!;
            isProxy = true;
          }
        }
      }
    }

    punchDetail = CustomPunchModel(
      name: name,
      staffId: staffId,
      department: department,
      checkInTime: checkInTime,
      checkOutTime: checkOutTime,
      isProxy: isProxy,
    );
    return punchDetail;
  }

  Future<CustomPunchModel?> _checkProxyEntry(
      String staffId, String dateFormat, String department) async {
    CustomPunchModel? punchDetail;
    await FirebaseDatabase.instance
        .ref('proxy_attendance/$staffId/$dateFormat')
        .once()
        .then((proxy) async {
      if (proxy.snapshot.exists) {
        Map<Object?, Object?> checkInDetail = {};
        Map<Object?, Object?> checkOutDetail = {};
        if (proxy.snapshot.child('Check-in').exists) {
          checkInDetail =
              proxy.snapshot.child('Check-in').value as Map<Object?, Object?>;
        }
        if (proxy.snapshot.child('Check-out').exists) {
          checkOutDetail =
              proxy.snapshot.child('Check-out').value as Map<Object?, Object?>;
        }

        punchDetail = CustomPunchModel(
          name: checkInDetail['Name'].toString(),
          staffId: staffId,
          department: department,
          checkInTime: checkInDetail.isEmpty
              ? null
              : DateTime.fromMillisecondsSinceEpoch(
                  int.parse(checkInDetail['Time'].toString())),
          checkOutTime: checkOutDetail.isEmpty
              ? null
              : DateTime.fromMillisecondsSinceEpoch(
                  int.parse(checkOutDetail['Time'].toString())),
          checkInProxyBy: checkInDetail['Proxy'].toString(),
          checkInReason: checkInDetail['Reason'].toString(),
          checkOutProxyBy:
              checkOutDetail.isEmpty ? '' : checkOutDetail['Name'].toString(),
          checkOutReason:
              checkOutDetail.isEmpty ? '' : checkOutDetail['Reason'].toString(),
          isProxy: true,
        );
      }
    });
    return punchDetail;
  }

  Future<void> _printScreen() async {
    final doc = pw.Document();
    DateTime endTime = DateTime.now();

    doc.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(15.0),
        build: (ctx) {
          return List.generate(_sortedList.value.length, (index) {
            PdfColor topContainerColor = PdfColors.green400;
            String status = 'Present on Time';
            String method = 'ID';

            if (_sortedList.value[index].isProxy) {
              method = 'Proxy';
            }

            if (_sortedList.value[index].checkOutTime != null) {
              endTime = _sortedList.value[index].checkOutTime!;
            }

            if (_sortedList.value[index].checkInTime == null) {
              topContainerColor = PdfColors.blueGrey600;
              status = 'Absent today';
            } else if (_sortedList.value[index].checkInTime!
                        .difference(
                          DateTime(
                            _sortedList.value[index].checkInTime!.year,
                            _sortedList.value[index].checkInTime!.month,
                            _sortedList.value[index].checkInTime!.day,
                            09,
                            00,
                          ),
                        )
                        .inMinutes >
                    10 &&
                _sortedList.value[index].checkInTime!
                        .difference(
                          DateTime(
                            _sortedList.value[index].checkInTime!.year,
                            _sortedList.value[index].checkInTime!.month,
                            _sortedList.value[index].checkInTime!.day,
                            09,
                            20,
                          ),
                        )
                        .inMinutes <=
                    0) {
              topContainerColor = PdfColors.deepOrange400;
              status =
                  'Late by ${_sortedList.value[index].checkInTime!.difference(DateTime(_sortedList.value[index].checkInTime!.year, _sortedList.value[index].checkInTime!.month, _sortedList.value[index].checkInTime!.day, 09, 00)).inMinutes - 10} mins';
            } else if (_sortedList.value[index].checkInTime!
                    .difference(
                      DateTime(
                        _sortedList.value[index].checkInTime!.year,
                        _sortedList.value[index].checkInTime!.month,
                        _sortedList.value[index].checkInTime!.day,
                        09,
                        00,
                      ),
                    )
                    .inMinutes >
                20) {
              topContainerColor = PdfColors.red400;
              status =
                  'Late by ${_sortedList.value[index].checkInTime!.difference(DateTime(_sortedList.value[index].checkInTime!.year, _sortedList.value[index].checkInTime!.month, _sortedList.value[index].checkInTime!.day, 09, 00)).inMinutes - 10} mins';
            }

            return pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 8.0),
              decoration: pw.BoxDecoration(
                borderRadius: pw.BorderRadius.circular(15.0),
                color: PdfColors.grey300,
              ),
              child: pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                            children: [
                              pw.Flexible(
                                child: pw.Text(
                                  _sortedList.value[index].name,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 12.0),
                                ),
                              ),
                              pw.Text(
                                ' (${_sortedList.value[index].department})',
                                style: const pw.TextStyle(fontSize: 10.0),
                              ),
                            ],
                          ),
                          if (_sortedList.value[index].checkInTime != null)
                            pw.Text(
                              'Check In : ${timeFormat(_sortedList.value[index].checkInTime!)}',
                              style: const pw.TextStyle(fontSize: 10.0),
                            ),
                          if (_sortedList.value[index].checkInTime != null)
                            pw.Text(
                              _sortedList.value[index].checkOutTime == null
                                  ? 'Check Out : No entry'
                                  : 'Check Out : ${timeFormat(_sortedList.value[index].checkOutTime!)}',
                              style: const pw.TextStyle(fontSize: 10.0),
                            ),
                        ],
                      ),
                    ),
                  ),
                  pw.Column(
                    children: [
                      pw.Text(
                        status,
                        style: pw.TextStyle(color: topContainerColor),
                      ),
                      pw.Text(
                        method,
                        style: pw.TextStyle(color: topContainerColor),
                      ),
                      if (_sortedList.value[index].checkInTime != null) ...[
                        pw.Text(
                          'Duration : ${duration(_sortedList.value[index].checkInTime!, endTime)}',
                        ),
                      ],
                    ],
                  ),
                  pw.Container(
                    width: 30.0,
                    height: 50.0,
                    margin: const pw.EdgeInsets.only(left: 5.0),
                    decoration: pw.BoxDecoration(
                      color: topContainerColor,
                      borderRadius: const pw.BorderRadius.horizontal(
                        right: pw.Radius.circular(15.0),
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
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

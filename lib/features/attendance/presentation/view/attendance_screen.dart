import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/features/attendance/data/data_source/attendance_fb_data_source.dart';
import 'package:my_office/features/attendance/data/data_source/attendance_fb_data_source_impl.dart';
import 'package:my_office/features/attendance/data/model/punch_model.dart';
import 'package:my_office/features/attendance/data/repository/attendance_repo_impl.dart';
import 'package:my_office/features/attendance/domain/repository/attendance_repository.dart';
import 'package:my_office/features/attendance/presentation/view_model/attendance_punch_screen.dart';
import 'package:pdf/pdf.dart';
import '../../../../core/utilities/constants/app_color.dart';
import '../../../../core/utilities/constants/app_main_template.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
    'Management',
    'App',
    'Web',
    'Media',
    'RND',
    'Installation',
    'HR',
    'PR',
    'Office staff',
  ];

  late final AttendanceFbDataSource _attendanceFbDataSource =
      AttendanceFbDataSourceImpl();
  late AttendanceRepository attendanceRepository =
      AttendanceRepoImpl(_attendanceFbDataSource);

  ///notifiers
  final ValueNotifier<List<AttendancePunchModel>> _punchingDetails =
      ValueNotifier([]);
  final ValueNotifier<List<AttendancePunchModel>> _sortedList =
      ValueNotifier([]);
  final ValueNotifier<DateTime> _selectedDate = ValueNotifier(DateTime.now());
  final ValueNotifier<String> _sortOption = ValueNotifier('All');
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  DateTime? punchInTime;

  Future<void> getPunchingTime() async {
    _isLoading.value = true;
    _punchingDetails.value.clear();
    _sortedList.value.clear();

    final allStaffs = await attendanceRepository.getStaffDetails();

    for (var staff in allStaffs) {
      final data = await attendanceRepository.checkTime(
        staff.uid,
        staff.department,
        staff.name,
        _selectedDate.value,
        staff.punchIn,
        staff.punchOut,
      );
      _punchingDetails.value = [
        ..._punchingDetails.value,
        if (data != null)
          data
        else
          AttendancePunchModel(
            name: staff.name,
            staffId: staff.uid,
            department: staff.department,
            checkInTime: null,
            punchIn: staff.punchIn,
            punchOut: staff.punchOut,
          ),
      ];

      _sortedList.value = [
        ..._sortedList.value,
        if (data != null)
          data
        else
          AttendancePunchModel(
            name: staff.name,
            staffId: staff.uid,
            department: staff.department,
            checkInTime: null,
            punchIn: staff.punchIn,
            punchOut: staff.punchOut,
          ),
      ];
    }

    _isLoading.value = false;
  }

  @override
  void initState() {
    getPunchingTime();
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
      bgColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }

  Widget _punchingTimeBody() {
    return Column(
      children: [
        ValueListenableBuilder(
          valueListenable: _isLoading,
          builder: (ctx, isLoading, child) {
            return isLoading
                ?  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Fetching data',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      CircleAvatar(
                        child: SizedBox(
                          height: 20.0,
                          width: 20.0,
                          child: CircularProgressIndicator(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            strokeWidth: 2.0,
                          ),
                        ),
                      ),
                      const Gap(7),
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
                                icon: Icon(Icons.calendar_month_rounded, color: Theme.of(context).primaryColor,),
                                label: Text(formatDate(date), style: TextStyle(color: Theme.of(context).primaryColor,),),
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
                              surfaceTintColor: Colors.transparent,
                              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(1),
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
                                      style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor,),
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
                                        _sortedList.value.clear();
                                        for (final lateStaffs
                                            in _punchingDetails.value) {
                                          List<String> punchInComponents =
                                              lateStaffs.punchIn.split(':');
                                          int punchInHour =
                                              int.parse(punchInComponents[0]);
                                          int punchInMinute =
                                              int.parse(punchInComponents[1]);

                                          // Formatting hours and minutes with leading zeros
                                          String formattedHour = punchInHour
                                              .toString()
                                              .padLeft(2, '0');
                                          String formattedMinute = punchInMinute
                                              .toString()
                                              .padLeft(2, '0');

                                          // Creating a DateTime object from the formatted values
                                         final punchInTime = DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day,
                                            int.parse(formattedHour),
                                            int.parse(formattedMinute),
                                          );
                                          if (lateStaffs.checkInTime != null &&
                                              lateStaffs.checkInTime!
                                                      .difference(punchInTime)
                                                      .inMinutes >
                                                  10) {
                                            _sortedList.value.add(lateStaffs);
                                          }
                                        }
                                        _sortedList.notifyListeners();
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
                                      } else if (_dropDown[i] == 'App') {
                                        _sortedList.value =
                                            _punchingDetails.value
                                                .where(
                                                  (element) => element
                                                      .department
                                                      .contains('APP'),
                                                )
                                                .toList();
                                      } else if (_dropDown[i] == 'Web') {
                                        _sortedList.value =
                                            _punchingDetails.value
                                                .where(
                                                  (element) => element
                                                      .department
                                                      .contains('WEB'),
                                                )
                                                .toList();
                                      } else if (_dropDown[i] == 'PR') {
                                        _sortedList.value =
                                            _punchingDetails.value
                                                .where(
                                                  (element) => element
                                                      .department
                                                      .contains('PR'),
                                                )
                                                .toList();
                                      } else if (_dropDown[i] == 'Media') {
                                        _sortedList.value =
                                            _punchingDetails.value
                                                .where(
                                                  (element) => element
                                                      .department
                                                      .contains('MEDIA'),
                                                )
                                                .toList();
                                      }else if (_dropDown[i] == 'RND') {
                                        _sortedList.value =
                                            _punchingDetails.value
                                                .where(
                                                  (element) => element
                                                      .department
                                                      .contains('RND'),
                                                )
                                                .toList();
                                      } else if (_dropDown[i] ==
                                          'Installation') {
                                        _sortedList.value =
                                            _punchingDetails.value
                                                .where(
                                                  (element) => element
                                                      .department
                                                      .contains('INSTALLATION'),
                                                )
                                                .toList();
                                      } else if (_dropDown[i] == 'HR') {
                                        _sortedList.value =
                                            _punchingDetails.value
                                                .where(
                                                  (element) => element
                                                      .department
                                                      .contains('HR'),
                                                )
                                                .toList();
                                      } else if (_dropDown[i] ==
                                          'Management') {
                                        _sortedList.value =
                                            _punchingDetails.value
                                                .where(
                                                  (element) => element
                                                  .department
                                                  .contains('MANAGEMENT'),
                                            )
                                                .toList();
                                      }else if (_dropDown[i] ==
                                          'Office staff') {
                                        _sortedList.value =
                                            _punchingDetails.value
                                                .where(
                                                  (element) => element
                                                  .department
                                                  .contains('OFFICE STAFF'),
                                            )
                                                .toList();
                                      }
                                    },
                                  );
                                },
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(CupertinoIcons.sort_down, color: Theme.of(context).primaryColor,),
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
              color: Theme.of(context).primaryColor,
            ),
            suffixIcon: Icon(
              CupertinoIcons.xmark_circle_fill,
              color: Theme.of(context).primaryColor,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        IconButton(
          onPressed: _printScreen,
          icon: Icon(Icons.print_rounded, color: Theme.of(context).primaryColor,),
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
                        Theme.of(context).scaffoldBackgroundColor == const Color(0xFF1F1F1F) ?
                        Lottie.asset('assets/animations/loading_light_theme.json'):
                        Lottie.asset('assets/animations/loading_dark_theme.json'),
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
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate.value,
      firstDate: DateTime(2023),
      lastDate: DateTime(2200),
    );
    if (date == null) return;
    _selectedDate.value = date;
    getPunchingTime();
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
                  'Late by ${_sortedList.value[index].checkInTime!.difference(
                        DateTime(
                          _sortedList.value[index].checkInTime!.year,
                          _sortedList.value[index].checkInTime!.month,
                          _sortedList.value[index].checkInTime!.day,
                          09,
                          00,
                        ),
                      ).inMinutes - 10} mins';
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
                  'Late by ${_sortedList.value[index].checkInTime!.difference(
                        DateTime(
                          _sortedList.value[index].checkInTime!.year,
                          _sortedList.value[index].checkInTime!.month,
                          _sortedList.value[index].checkInTime!.day,
                          09,
                          00,
                        ),
                      ).inMinutes - 10} mins';
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
                                    fontSize: 12.0,
                                  ),
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
                              'Check In : ${timeFormat(
                                _sortedList.value[index].checkInTime!,
                              )}',
                              style: const pw.TextStyle(fontSize: 10.0),
                            ),
                          if (_sortedList.value[index].checkInTime != null)
                            pw.Text(
                              _sortedList.value[index].checkOutTime == null
                                  ? 'Check Out : No entry'
                                  : 'Check Out : ${timeFormat(
                                      _sortedList.value[index].checkOutTime!,
                                    )}',
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
                          'Duration : ${duration(
                            _sortedList.value[index].checkInTime!,
                            endTime,
                          )}',
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
      onLayout: (PdfPageFormat format) async => doc.save(),
    );
  }

  /// date formatter
  String formatDate(DateTime date) => DateFormat.yMMMd().format(date);

  String duration(DateTime start, DateTime end) {
    final diff = end.difference(start);
    int hours = diff.inHours;
    int minutes = diff.inMinutes % 60;

    return '${hours}h ${minutes}m';
  }
}

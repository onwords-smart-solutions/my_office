import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import 'package:my_office/features/attendance/presentation/view_model/staff_attendance_model.dart';
import 'package:my_office/features/home/presentation/view_model/custom_punch_model.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../../presentation/view/attendance_punch_screen.dart';
import 'attendance_fb_data_source.dart';
import 'package:pdf/widgets.dart' as pw;

class AttendanceFbDataSourceImpl implements AttendanceFbDataSource {
  @override
  Future<CustomPunchModel?> checkTime(
    String staffId,
    String dep,
    String name,
  ) async {
    try{
      final ValueNotifier<DateTime> selectedDate = ValueNotifier(DateTime.now());
      CustomPunchModel? punchDetail;
      bool isProxy = false;
      DateTime? checkInTime;
      DateTime? checkOutTime;
      String proxyInBy = '';
      String proxyOutBy = '';
      String proxyInReason = '';
      String proxyOutReason = '';

      String yearFormat = DateFormat('yyyy').format(selectedDate.value);
      String monthFormat = DateFormat('MM').format(selectedDate.value);
      String dateFormat = DateFormat('dd').format(selectedDate.value);
      await FirebaseDatabase.instance
          .ref('attendance/$yearFormat/$monthFormat/$dateFormat/$staffId')
          .once()
          .then((value) async {
        if (value.snapshot.exists) {
          final attendanceData = value.snapshot.value as Map<Object?, Object?>;
          final checkIn = attendanceData['check_in'];
          final checkOut = attendanceData['check_out'];

          //check in time data
          if (checkIn != null) {
            checkInTime = DateTime(
              selectedDate.value.year,
              selectedDate.value.month,
              selectedDate.value.day,
              int.parse(
                checkIn.toString().split(':')[0],
              ),
              int.parse(
                checkIn.toString().split(':')[1],
              ),
            );
            try {
              final proxyInByName =
              attendanceData['proxy_in'] as Map<Object?, Object?>;
              proxyInBy = proxyInByName['proxy_by'].toString();
              final proxyInByReason =
              attendanceData['proxy_in'] as Map<Object?, Object?>;
              proxyInReason = proxyInByReason['reason'].toString();
              isProxy=true;
            } catch (e) {
              log('Check in exception is $e');
            }
          }

          //check out time data
          if (checkOut != null) {
            checkOutTime = DateTime(
              selectedDate.value.year,
              selectedDate.value.month,
              selectedDate.value.day,
              int.parse(
                checkOut.toString().split(':')[0],
              ),
              int.parse(
                checkOut.toString().split(':')[1],
              ),
            );
            try {
              final proxyOutByName =
              attendanceData['proxy_out'] as Map<Object?, Object?>;
              proxyOutBy = proxyOutByName['proxy_by'].toString();
              final proxyOutByReason =
              attendanceData['proxy_out'] as Map<Object?, Object?>;
              proxyOutReason = proxyOutByReason['reason'].toString();
              isProxy=true;
            } catch (e) {
              log('Check out exception is $e');
            }
          }

          punchDetail = CustomPunchModel(
            name: name,
            staffId: staffId,
            department: dep,
            checkInTime: checkInTime,
            checkOutTime: checkOutTime,
            checkInProxyBy: proxyInBy,
            checkInReason: proxyInReason,
            checkOutProxyBy: proxyOutBy,
            checkOutReason: proxyOutReason,
            isProxy: isProxy,
          );

        }
      });
      return punchDetail;
    }catch(e){
         ErrorResponse(
        metaInfo: 'Catch triggered while getting attendance list $e',
        error: 'Unable to fetch attendance details',
      );
    }
  }

  @override
  Future<void> getPunchingTime() async {
    final ValueNotifier<List<CustomPunchModel>> punchingDetails =
    ValueNotifier([]);
    final ValueNotifier<List<CustomPunchModel>> sortedList = ValueNotifier([]);
    final ValueNotifier<bool> isLoading = ValueNotifier(true);
    try{
      isLoading.value = true;
      sortedList.value.clear();
      punchingDetails.value.clear();
      sortedList.notifyListeners();
      punchingDetails.notifyListeners();
      final allStaffs = await getStaffDetails();

      //getting staff entry times
      for (var staff in allStaffs.right) {
        final data = await checkTime(staff.uid,  staff.department,staff.name,);
        if (data != null) {
          punchingDetails.value.add(data);
          sortedList.value.add(data);
        }
        else {
          punchingDetails.value.add(
            CustomPunchModel(
              name: staff.name,
              staffId: staff.uid,
              department: staff.department,
              checkInTime: null,
            ),
          );
          sortedList.value.add(
            CustomPunchModel(
              name: staff.name,
              staffId: staff.uid,
              department: staff.department,
              checkInTime: null,
            ),
          );
        }
        sortedList.notifyListeners();
        punchingDetails.notifyListeners();
      }
      isLoading.value = false;
    }catch(e){
        ErrorResponse(
          metaInfo: 'Catch triggered while getting attendance list $e',
          error: 'Unable to fetch attendance details',
      );
    }
  }

  @override
  Future<Either<ErrorResponse, List<StaffAttendanceModel>>> getStaffDetails() async {
    try{
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
      return Right(staffs);
    }catch(e){
      return Left(
        ErrorResponse(
          metaInfo: 'Catch triggered while getting staff details $e',
          error: 'Unable to fetch staff details',
        ),
      );
    }
  }

  @override
  Future<void> printScreen() async {
    final ValueNotifier<List<CustomPunchModel>> sortedList = ValueNotifier([]);
    try{
      final doc = pw.Document();
      DateTime endTime = DateTime.now();

      doc.addPage(
        pw.MultiPage(
          margin: const pw.EdgeInsets.all(15.0),
          build: (ctx) {
            return List.generate(sortedList.value.length, (index) {
              PdfColor topContainerColor = PdfColors.green400;
              String status = 'Present on Time';
              String method = 'ID';

              if (sortedList.value[index].isProxy) {
                method = 'Proxy';
              }

              if (sortedList.value[index].checkOutTime != null) {
                endTime = sortedList.value[index].checkOutTime!;
              }

              if (sortedList.value[index].checkInTime == null) {
                topContainerColor = PdfColors.blueGrey600;
                status = 'Absent today';
              } else if (sortedList.value[index].checkInTime!
                  .difference(
                DateTime(
                  sortedList.value[index].checkInTime!.year,
                  sortedList.value[index].checkInTime!.month,
                  sortedList.value[index].checkInTime!.day,
                  09,
                  00,
                ),
              )
                  .inMinutes >
                  10 &&
                  sortedList.value[index].checkInTime!
                      .difference(
                    DateTime(
                      sortedList.value[index].checkInTime!.year,
                      sortedList.value[index].checkInTime!.month,
                      sortedList.value[index].checkInTime!.day,
                      09,
                      20,
                    ),
                  )
                      .inMinutes <=
                      0) {
                topContainerColor = PdfColors.deepOrange400;
                status =
                'Late by ${sortedList.value[index].checkInTime!.difference(DateTime(sortedList.value[index].checkInTime!.year, sortedList.value[index].checkInTime!.month, sortedList.value[index].checkInTime!.day, 09, 00)).inMinutes - 10} mins';
              } else if (sortedList.value[index].checkInTime!
                  .difference(
                DateTime(
                  sortedList.value[index].checkInTime!.year,
                  sortedList.value[index].checkInTime!.month,
                  sortedList.value[index].checkInTime!.day,
                  09,
                  00,
                ),
              )
                  .inMinutes >
                  20) {
                topContainerColor = PdfColors.red400;
                status =
                'Late by ${sortedList.value[index].checkInTime!.difference(DateTime(sortedList.value[index].checkInTime!.year, sortedList.value[index].checkInTime!.month, sortedList.value[index].checkInTime!.day, 09, 00)).inMinutes - 10} mins';
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
                                    sortedList.value[index].name,
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                                pw.Text(
                                  ' (${sortedList.value[index].department})',
                                  style: const pw.TextStyle(fontSize: 10.0),
                                ),
                              ],
                            ),
                            if (sortedList.value[index].checkInTime != null)
                              pw.Text(
                                'Check In : ${timeFormat(sortedList.value[index].checkInTime!)}',
                                style: const pw.TextStyle(fontSize: 10.0),
                              ),
                            if (sortedList.value[index].checkInTime != null)
                              pw.Text(
                                sortedList.value[index].checkOutTime == null
                                    ? 'Check Out : No entry'
                                    : 'Check Out : ${timeFormat(sortedList.value[index].checkOutTime!)}',
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
                        if (sortedList.value[index].checkInTime != null) ...[
                          pw.Text(
                            'Duration : ${duration(sortedList.value[index].checkInTime!, endTime)}',
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
    }catch(e){

    }
  }
}

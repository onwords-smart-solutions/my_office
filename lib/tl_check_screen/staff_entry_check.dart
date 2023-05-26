import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/models/staff_entry_model.dart';
import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import '../util/screen_template.dart';

class StaffEntryCheckScreen extends StatefulWidget {
  final StaffAttendanceModel staffDetail;

  const StaffEntryCheckScreen({Key? key, required this.staffDetail})
      : super(key: key);

  @override
  State<StaffEntryCheckScreen> createState() => _StaffEntryCheckScreenState();
}

class _StaffEntryCheckScreenState extends State<StaffEntryCheckScreen> {
  List<String> attendanceTime = [];
  bool isLoading = true;
  final fingerPrint = FirebaseDatabase.instance.ref();
  final virtualAttendance = FirebaseDatabase.instance.ref();
  DateTime dateTime = DateTime.now();

  void entryCheck() async {
    setState(() {
      isLoading = true;
    });
    List<String> entryTime = [];
    var dateFormat = DateFormat('yyyy-MM-dd').format(dateTime);
    await fingerPrint
        .child('fingerPrint/${widget.staffDetail.uid}/$dateFormat')
        .once()
        .then((entry) async {

      if (entry.snapshot.value != null) {
        for (var time in entry.snapshot.children) {
          entryTime.add(time.key.toString());
        }
      } else {
       entryTime =  await
        checkVirtualAttendance();
      }

    });

    if (!mounted) return;
    setState(() {
      attendanceTime = entryTime;
      isLoading = false;
    });
  }

  Future<List<String>> checkVirtualAttendance() async {
    var yearFormat = DateFormat('yyyy').format(dateTime);
    var monthFormat = DateFormat('MM').format(dateTime);
    var dateFormat = DateFormat('yyyy-MM-dd').format(dateTime);
    List<String> attendTime = [];
    await virtualAttendance
        .child(
            'virtualAttendance/${widget.staffDetail.uid}/$yearFormat/$monthFormat/$dateFormat')
        .once()
        .then((virtual) {
          try{
            final data = virtual.snapshot.value as Map<Object?, Object?>;
            attendTime.add(data['Time'].toString());
          }catch(e){
            log('error is $e');
          }
      });
    return attendTime;
  }

  datePicker() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
    );
    if (newDate == null) return;
    setState(() {
      dateTime = newDate;
    });
    entryCheck();
  }

  @override
  void initState() {
    entryCheck();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      bodyTemplate: buildCheckEntry(),
      title: widget.staffDetail.name,
    );
  }

  Widget buildCheckEntry() {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 190),
              child: FloatingActionButton.small(
                elevation: 10,
                backgroundColor: ConstantColor.backgroundColor,
                tooltip: 'Date Picker',
                onPressed: () {
                  datePicker();
                },
                child: const Icon(Icons.date_range, size: 20),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              DateFormat('dd-MM-yyyy').format(dateTime),
              style: TextStyle(
                color: ConstantColor.headingTextColor,
                fontSize: 18,
                fontFamily: ConstantFonts.poppinsBold,
              ),
            ),
          ],
        ),
        isLoading
            ? Center(
                child: Lottie.asset(
                  "assets/animations/new_loading.json",
                ),
              )
            : attendanceTime.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: attendanceTime.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const CircleAvatar(
                          radius: 22,
                          backgroundColor: ConstantColor.backgroundColor,
                          child: Icon(Icons.access_time_rounded),
                        ),
                        title: Text(
                          attendanceTime[index],
                          style: TextStyle(
                              fontFamily: ConstantFonts.poppinsMedium,
                              color: ConstantColor.blackColor,
                              fontSize: 18),
                        ),
                      );
                    })
                : Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 50),
                        Center(
                          child: Lottie.asset('assets/animations/no_data.json',
                              height: 250.0),
                        ),
                        Text(
                          'No Attendance registered!!',
                          style: TextStyle(
                            fontFamily: ConstantFonts.poppinsRegular,
                            color: ConstantColor.blackColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
      ],
    );
  }
}

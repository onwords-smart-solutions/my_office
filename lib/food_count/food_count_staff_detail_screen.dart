import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/util/screen_template.dart';

import '../Constant/fonts/constant_font.dart';

class FoodCountStaffDetailScreen extends StatefulWidget {
  final String staffName;

  const FoodCountStaffDetailScreen({Key? key, required this.staffName})
      : super(key: key);

  @override
  State<FoodCountStaffDetailScreen> createState() =>
      _FoodCountStaffDetailScreenState();
}

class _FoodCountStaffDetailScreenState
    extends State<FoodCountStaffDetailScreen> {
  final ref = FirebaseDatabase.instance.ref();
  List<dynamic> staffLunchSummary = [];
  bool isLoading = true;

  String currentMonth = DateFormat.MMMM().format(DateTime.now()).toString();

  final Map<String, String> month = {
    'January': '01',
    'February': '02',
    'March': '03',
    'April': '04',
    'May': '05',
    'June': '06',
    'July': '07',
    'August': '08',
    'September': '09',
    'October': '10',
    'November': '11',
    'December': '12',
  };

  void checkFoodCount() async {

    List<dynamic> staffLunchData = [];
    final currentMonthFormat = '${DateTime.now().year}-${month[currentMonth]}';
    await ref.child('refreshments').once().then((value) {
      if (value.snapshot.exists) {
        for (var detail in value.snapshot.children) {
          final dividedFormat = detail.key!.substring(0, 7);
          if (dividedFormat.contains(currentMonthFormat)) {
            final data = detail.value as Map<Object?, Object?>;
            if (data['Lunch'] != null) {
              //CHECKING FOR STAFF
              final lunchData = data['Lunch'] as Map<Object?, Object?>;
              final lunchList =
                  lunchData['lunch_list'] as Map<Object?, Object?>;

              for(var staff in lunchList.values) {
                if (staff.toString() == widget.staffName) {
                  staffLunchData.add(detail.key);
                }
              }
            }
          }
        }
      }
    });

    if (!mounted) return;
    setState(() {
      isLoading = false;
      staffLunchSummary = staffLunchData;
    });
  }

  @override
  void initState() {
    checkFoodCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(bodyTemplate: buildBody(), title: widget.staffName);
  }

  Widget buildBody() {
    return Column(
      children: [
        //month picker
        buildDropDown(),
        //ListView
        Expanded(
          child: isLoading
              ? Center(
                  child: Lottie.asset(
                    "assets/animations/loading.json",
                  ),
                )
              : staffLunchSummary.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/animations/no_data.json',
                            height: 250.0),
                        Text(
                          'Food details not found',
                          style: TextStyle(
                            fontFamily: ConstantFonts.poppinsMedium,
                            color: ConstantColor.blackColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Text(
                          'Total Count : ${staffLunchSummary.length}',
                          style: TextStyle(
                              fontFamily: ConstantFonts.poppinsMedium,
                              color: ConstantColor.blackColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: staffLunchSummary.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (ctx, i) {
                              return ListTile(
                                leading: const Icon(
                                  Icons.calendar_month_rounded,
                                  size: 30.0,
                                  color: ConstantColor.backgroundColor,
                                ),
                                title: Text(
                                  staffLunchSummary[i].toString(),
                                  style: TextStyle(
                                    fontFamily: ConstantFonts.poppinsMedium,
                                    color: ConstantColor.blackColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
        )
      ],
    );
  }

  Widget buildDropDown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          PopupMenuButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            position: PopupMenuPosition.under,
            elevation: 10.0,
            itemBuilder: (ctx) => List.generate(
              month.length,
              (index) {
                return PopupMenuItem(
                  child: Text(
                    month.keys.toList()[index],
                    style: TextStyle(fontFamily: ConstantFonts.poppinsMedium),
                  ),
                  onTap: () {
                    setState(() {
                      currentMonth = month.keys.toList()[index];
                      checkFoodCount();
                    });
                  },
                );
              },
            ),
            icon: Image.asset(
              'assets/calender.png',
              scale: 3.0,
            ),
          ),
          Text(
            currentMonth,
            style: TextStyle(
                fontFamily: ConstantFonts.poppinsMedium, fontSize: 16.0),
          )
        ],
      ),
    );
  }
}

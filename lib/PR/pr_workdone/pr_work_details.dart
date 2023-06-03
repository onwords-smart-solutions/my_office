import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/PR/pr_workdone/prWorkDoneModel.dart';
import 'package:my_office/PR/pr_workdone/pr_full_work_details.dart';
import '../../Constant/colors/constant_colors.dart';
import '../../Constant/fonts/constant_font.dart';
import '../../util/main_template.dart';

class PrWorkDetails extends StatefulWidget {
  const PrWorkDetails({Key? key}) : super(key: key);

  @override
  State<PrWorkDetails> createState() => _PrWorkDetailsState();
}

class _PrWorkDetailsState extends State<PrWorkDetails> {
  List<PRWorkDoneModel> prStaffNames = [];
  bool isLoading = true;
  final ref = FirebaseDatabase.instance.ref();
  DateTime now = DateTime.now();

  Future<void> getPRWorkDone() async {
    final date = DateFormat('yyyy-MM-dd').format(now);
    final month = DateFormat('MM').format(now);
    setState(() {
      isLoading = true;
    });
    prStaffNames.clear();
    List<PRWorkDoneModel> prWork = [];
    await ref.child('PRPoints').once().then((staffEntry) {
      if (staffEntry.snapshot.exists) {
        for (var uid in staffEntry.snapshot.children) {
          try {

            final workDone = uid.child('${now.year}/$month/$date').value
                as Map<Object?, Object?>;
            log('message ${uid.value}');
            final staffData = uid.value as Map<Object?, Object?>;
            final data = PRWorkDoneModel(
                calls: int.parse(workDone['calls'].toString()),
                invoice: int.parse(workDone['invoice'].toString()),
                message: int.parse(workDone['message'].toString()),
                points: int.parse(workDone['points'].toString()),
                quote: int.parse(workDone['quote'].toString()),
                visit: int.parse(workDone['visit'].toString()),
                name: staffData['name'].toString(),
                uid: uid.key.toString());
            prWork.add(data);
          } catch (e) {
            log("ERROR IN GET FB $e");
          }
        }
      }
    });
    if (!mounted) return;
    setState(() {
      isLoading = false;
      prStaffNames = prWork;
    });
  }

  datePicker() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2100),
    );
    if (newDate == null) return;
    setState(() {
      now = newDate;
    });
    getPRWorkDone();
  }

  @override
  void initState() {
    getPRWorkDone();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      subtitle: 'Check for PR works here!!!',
      templateBody: buildPrWorkDetailsScreen(),
      bgColor: ConstantColor.background1Color,
    );
  }

  Widget buildPrWorkDetailsScreen() {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 190),
              child: FloatingActionButton.small(
                elevation: 5,
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
              DateFormat('dd-MM-yyyy').format(now),
              style: TextStyle(
                color: ConstantColor.headingTextColor,
                fontSize: 18,
                fontFamily: ConstantFonts.poppinsBold,
              ),
            ),
          ],
        ),
        isLoading
            ? Expanded(
                child: Center(
                  child: Lottie.asset(
                    "assets/animations/new_loading.json",
                  ),
                ),
              )
            : prStaffNames.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: prStaffNames.length,
                      itemBuilder: (ctx, i) {
                        return Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: ConstantColor.background1Color,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                offset: const Offset(-0.0, 5.0),
                                blurRadius: 8,
                              )
                            ],
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Center(
                            child: ListTile(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => PrFullWorkDetails(
                                    staffDetail: prStaffNames[i],
                                  ),
                                ),
                              ),
                              leading: const CircleAvatar(
                                radius: 20,
                                backgroundColor: ConstantColor.backgroundColor,
                                child: Icon(Icons.person),
                              ),
                              title: Text(
                                prStaffNames[i].name,
                                style: TextStyle(
                                    fontFamily: ConstantFonts.poppinsMedium,
                                    color: ConstantColor.blackColor,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.020),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset('assets/animations/no_data.json',
                              height: 300.0),
                        Text(
                          'No WorkDone Registered!!',
                          style: TextStyle(
                            color: ConstantColor.blackColor,
                            fontSize: 20,
                            fontFamily: ConstantFonts.poppinsRegular,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      ),
                    ),
                  ),
      ],
    );
  }
}

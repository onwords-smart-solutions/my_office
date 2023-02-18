import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/models/staff_model.dart';
import 'package:my_office/refreshment/refreshment_screen.dart';
import 'package:my_office/util/main_template.dart';
import '../Absentees/absentees.dart';
import '../Constant/fonts/constant_font.dart';
import '../database/hive_operations.dart';
import '../leads/search_leads.dart';
import '../leave_apply/leave_apply_screen.dart';
import '../leave_approval/leave_request.dart';
import '../onyx/announcement.dart';
import '../work_done/work_complete.dart';
import '../work_manager/work_entry.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;

  getConnectivity() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (!isDeviceConnected && isAlertSet == false) {
        showDialogBox();
        setState(() {
          isAlertSet = true;
        });
      }
    });
  }

  @override
  void initState() {
    HiveOperations().getUStaffDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return MainTemplate(
      subtitle: 'Choose your destination here!',
      templateBody: buildMenuGrid(height, width),
      bgColor: ConstantColor.background1Color,
    );
  }

  Widget buildMenuGrid(double height, double width) {
    return ValueListenableBuilder(
        valueListenable: staffDetails,
        builder: (BuildContext ctx, List<StaffModel> staffInfo, Widget? child) {
          return staffInfo.isNotEmpty
              ? staffInfo[0].department == 'ADMIN'
                  ?
                  //Admin gridview
                  GridView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 20.0),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              mainAxisExtent: 230),
                      children: [
                        buildButton(
                            name: 'Refreshment',
                            image: Image.asset(
                              'assets/refreshment.png',
                              scale: 3.8,
                            ),
                            page: RefreshmentScreen(
                              uid: staffInfo[0].uid,
                              name: staffInfo[0].name,
                            )),
                        buildButton(
                            name: 'Work done',
                            image: Image.asset(
                              'assets/work_entry.png',
                              scale: 3.5,
                            ),
                            page: WorkCompleteViewScreen(
                              userDetails: staffInfo[0],
                            )),
                        buildButton(
                            name: 'Absent Details',
                            image: Image.asset(
                              'assets/lead search.png',
                              scale: 3.0,
                            ),
                            page: const AbsenteeScreen()),
                      ],
                    )
                  :
                  //PR gridview
                  staffInfo[0].department == 'PR'
                      ? GridView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 20.0),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0,
                                  mainAxisExtent: 230),
                          children: [
                            buildButton(
                              name: 'Work Manager',
                              image: Image.asset(
                                'assets/work_entry.png',
                                scale: 3.5,
                              ),
                              page: WorkEntryScreen(
                                userId: staffInfo[0].uid,
                                staffName: staffInfo[0].name,
                              ),
                            ),
                            buildButton(
                                name: 'Refreshment',
                                image: Image.asset(
                                  'assets/refreshment.png',
                                  scale: 3.8,
                                ),
                                page: RefreshmentScreen(
                                  uid: staffInfo[0].uid,
                                  name: staffInfo[0].name,
                                )),
                            buildButton(
                                name: 'Search leads',
                                image: Image.asset('assets/leave_apply.png'),
                                page:
                                    SearchLeadsScreen(staffInfo: staffInfo[0])),
                          ],
                        )
                      : staffInfo[0].department == 'APP'
                          ? GridView(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 20.0),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10.0,
                                      mainAxisSpacing: 10.0,
                                      mainAxisExtent: 230),
                              children: [
                                buildButton(
                                  name: 'Work Manager',
                                  image: Image.asset(
                                    'assets/work_entry.png',
                                    scale: 3.5,
                                  ),
                                  page: WorkEntryScreen(
                                    userId: staffInfo[0].uid,
                                    staffName: staffInfo[0].name,
                                  ),
                                ),
                                buildButton(
                                    name: 'Refreshment',
                                    image: Image.asset(
                                      'assets/refreshment.png',
                                      scale: 3.8,
                                    ),
                                    page: RefreshmentScreen(
                                      uid: staffInfo[0].uid,
                                      name: staffInfo[0].name,
                                    )),
                                buildButton(
                                    name: 'Leave form',
                                    image:
                                        Image.asset('assets/leave_apply.png'),
                                    page: const LeaveApplyScreen()),
                                buildButton(
                                    name: 'Onyx',
                                    image: Image.asset(
                                      'assets/onxy.png',
                                      scale: 3.4,
                                    ),
                                    page: const AnnouncementScreen()),
                                buildButton(
                                    name: 'Work done',
                                    image: Image.asset(
                                      'assets/work_entry.png',
                                      scale: 3.5,
                                    ),
                                    page: WorkCompleteViewScreen(
                                      userDetails: staffInfo[0],
                                    )),
                                buildButton(
                                    name: 'Absent Details',
                                    image: Image.asset(
                                      'assets/lead search.png',
                                      scale: 3.0,
                                    ),
                                    page: const AbsenteeScreen()),
                                buildButton(
                                  name: 'Search Leads',
                                  image: Image.asset(
                                    'assets/leave form.png',
                                    scale: 4.0,
                                  ),
                                  page: SearchLeadsScreen(
                                      staffInfo: staffInfo[0]),
                                ),
                                buildButton(
                                  name: 'Leave Request',
                                  image: Image.asset(
                                    'assets/leave form.png',
                                    scale: 4.0,
                                  ),
                                  page: const LeaveApprovalScreen(),
                                ),
                              ],
                            )
                          :
                          //Default grid view
                          GridView(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 20.0),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10.0,
                                      mainAxisSpacing: 10.0,
                                      mainAxisExtent: 230),
                              children: [
                                buildButton(
                                  name: 'Work Manager',
                                  image: Image.asset(
                                    'assets/work_entry.png',
                                    scale: 3.5,
                                  ),
                                  page: WorkEntryScreen(
                                    userId: staffInfo[0].uid,
                                    staffName: staffInfo[0].name,
                                  ),
                                ),
                                buildButton(
                                    name: 'Refreshment',
                                    image: Image.asset(
                                      'assets/refreshment.png',
                                      scale: 3.8,
                                    ),
                                    page: RefreshmentScreen(
                                      uid: staffInfo[0].uid,
                                      name: staffInfo[0].name,
                                    )),
                              ],
                            )
              : Center(
                  child: Lottie.asset(
                    "assets/animations/loading.json",
                  ),
                );
        });
  }

  Widget buildButton(
      {required String name, required Image image, required Widget page}) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        decoration: BoxDecoration(
          color: const Color(0xffDAD6EE),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(child: image),
            AutoSizeText(
              name,
              style: TextStyle(
                fontFamily: ConstantFonts.poppinsMedium,
                color: ConstantColor.blackColor,
              ),
              maxFontSize: 18,
              minFontSize: 12,
            )
          ],
        ),
      ),
    );
  }

  showDialogBox() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text("No Connection"),
        content: const Text("Please check your internet connection"),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context, 'Cancel');
              setState(() {
                isAlertSet = false;
              });
              isDeviceConnected =
                  await InternetConnectionChecker().hasConnection;
              if (!isDeviceConnected) {
                showDialogBox();
                setState(() {
                  isAlertSet = true;
                });
              }
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:my_office/PR/invoice/Screens/Customer_Details_Screen.dart';
import 'package:my_office/app_version/version.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/PR/visit/visit_form_screen.dart';
import 'package:my_office/models/staff_model.dart';
import 'package:my_office/refreshment/refreshment_screen.dart';
import 'package:my_office/util/main_template.dart';
import 'package:my_office/util/notification_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Absentees/absentees.dart';
import '../Constant/fonts/constant_font.dart';
import '../attendance/attendance_screen.dart';
import '../PR/visit_check.dart';
import '../attendance/view_attendance.dart';
import '../database/hive_operations.dart';
import '../finance/finance_analysis.dart';
import '../food_count/food_count_screen.dart';
import '../leads/search_leads.dart';
import '../leave_apply/leave_apply_screen.dart';
import '../leave_approval/leave_request.dart';
import '../onyx/announcement.dart';
import '../suggestions/suggestions.dart';
import '../suggestions/view_suggestions.dart';
import '../work_done/work_complete.dart';
import '../work_manager/work_entry.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final HiveOperations _hiveOperations = HiveOperations();
  final NotificationService _notificationService = NotificationService();

  StaffModel? staffInfo;
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

  void getStaffDetail() async {
    final data = await _hiveOperations.getStaffDetail();
    setState(() {
      staffInfo = data;
    });
  }

  //Notification set
  setNotification() async {
    final pref = await SharedPreferences.getInstance();
    final isNotificationSet = pref.getString('NotificationSetTime') ?? '';
    _notificationService.showDailyNotification(setTime: isNotificationSet);
  }

  //Checking app version
  Future<void> checkAppVersion() async {
    final ref = FirebaseDatabase.instance.ref();

    ref.child('myOffice').once().then((value) {
      if (value.snapshot.exists) {
        final data = value.snapshot.value as Map<Object?, Object?>;
        final updatedVersion = data['versionNumber'];
        final updatedAdminVersion = data['adminVersion'];
        final updatedPrVersion = data['prVersion'];

        if (staffInfo?.department == 'ADMIN') {
          if (AppConstants.adminDepVersion != updatedAdminVersion) {
            showUpdateAppDialog();
          }
        } else if (staffInfo?.department == 'PR') {
          if (AppConstants.prDepVersion != updatedPrVersion) {
            showUpdateAppDialog();
          }
        } else {
          if (AppConstants.pubVersion != updatedVersion) {
            showUpdateAppDialog();
          }
        }
      }
    });
  }

  @override
  void initState() {
    checkAppVersion();
    getConnectivity();
    getStaffDetail();
    setNotification();
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
    return staffInfo != null
        ? staffInfo!.department == 'ADMIN'
            ? GridView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 20.0),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                      uid: staffInfo!.uid,
                      name: staffInfo!.name,
                    ),
                  ),
                  buildButton(
                    name: 'Food Count',
                    image: Image.asset(
                      'assets/food_count.png',
                      scale: 3,
                    ),
                    page: const FoodCountScreen(),
                  ),
                  buildButton(
                      name: 'Work done',
                      image: Image.asset(
                        'assets/work_entry.png',
                        scale: 3.5,
                      ),
                      page: WorkCompleteViewScreen(
                        userDetails: staffInfo!,
                      )),
                  buildButton(
                      name: 'Absent Details',
                      image: Image.asset(
                        'assets/lead search.png',
                        scale: 3.0,
                      ),
                      page: const AbsenteeScreen(),
                  ),
                  buildButton(
                    name: 'Search Leads',
                    image: Image.asset(
                      'assets/search_leads.png',
                      scale: 2.0,
                    ),
                    page: SearchLeadsScreen(staffInfo: staffInfo!),
                  ),
                  buildButton(
                    name: 'Visit Check',
                    image: Image.asset(
                      'assets/visit_check.png',
                      scale: 3.4,
                    ),
                    page: const VisitCheckScreen(),
                  ),
                  buildButton(
                    name: 'Visit',
                    image: Image.asset(
                      'assets/visit.png',
                      scale: 1.8,
                    ),
                    page: const VisitFromScreen(),
                  ),
                  buildButton(
                    name: 'Invoice Generator',
                    image: Image.asset(
                      'assets/invoice.png',
                      scale: 2,
                    ),
                    page: const CustomerDetails(),
                  ),
                  buildButton(
                    name: 'Finance',
                    image: Image.asset(
                      'assets/finance.png',
                      scale: 1,
                    ),
                    page: const FinanceScreen(),
                  ),
                  buildButton(
                    name: 'Suggestions',
                    image: Image.asset(
                      'assets/suggestions.png',
                      scale: 3,
                    ),
                    page: SuggestionScreen(
                      uid: staffInfo!.uid,
                      name: staffInfo!.name,
                    ),
                  ),
                  buildButton(
                    name: 'View Suggestions',
                    image: Image.asset(
                      'assets/view_suggestions.png',
                      scale: 15,
                    ),
                    page: ViewSuggestions(
                      uid: staffInfo!.uid,
                      name: staffInfo!.name,
                    ),
                  ),
                  buildButton(
                    name: 'View Attendance',
                    image: Image.asset(
                      'assets/view_attendance.png',
                      scale: 3,
                    ),
                    page: const ViewAttendanceScreen(),
                  ),
                ],
              )
            : staffInfo!.department == 'PR'
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
                      if (staffInfo!.uid == 'ZIuUpLfSIRgRN5EqP7feKA9SbbS2')
                        buildButton(
                          name: 'Visit Check',
                          image: Image.asset(
                            'assets/visit_check.png',
                            scale: 3.4,
                          ),
                          page: const VisitCheckScreen(),
                        ),
                      buildButton(
                        name: 'Work Manager',
                        image: Image.asset(
                          'assets/work_manager.png',
                          scale: 1.5,
                        ),
                        page: WorkEntryScreen(
                          userId: staffInfo!.uid,
                          staffName: staffInfo!.name,
                        ),
                      ),
                      buildButton(
                          name: 'Refreshment',
                          image: Image.asset(
                            'assets/refreshment.png',
                            scale: 3.8,
                          ),
                          page: RefreshmentScreen(
                            uid: staffInfo!.uid,
                            name: staffInfo!.name,
                          )),
                      buildButton(
                        name: 'Search Leads',
                        image: Image.asset(
                          'assets/search_leads.png',
                          scale: 2.0,
                        ),
                        page: SearchLeadsScreen(staffInfo: staffInfo!),
                      ),
                      buildButton(
                        name: 'Visit',
                        image: Image.asset(
                          'assets/visit.png',
                          scale: 1.8,
                        ),
                        page: const VisitFromScreen(),
                      ),
                      buildButton(
                        name: 'Invoice Generator',
                        image: Image.asset(
                          'assets/invoice.png',
                          scale: 2,
                        ),
                        page: const CustomerDetails(),
                      ),
                      buildButton(
                        name: 'Suggestions',
                        image: Image.asset(
                          'assets/suggestions.png',
                          scale: 3,
                        ),
                        page: SuggestionScreen(
                          uid: staffInfo!.uid,
                          name: staffInfo!.name,
                        ),
                      ),
                      buildButton(
                        name: 'Virtual Attendance',
                        image: Image.asset(
                          'assets/attendance.png',
                          scale: 3,
                        ),
                        page: AttendanceScreen(
                          uid: staffInfo!.uid,
                          name: staffInfo!.name,
                        ),
                      ),
                    ],
                  )
                : staffInfo!.department == 'APP'
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
                              'assets/work_manager.png',
                              scale: 1.5,
                            ),
                            page: WorkEntryScreen(
                              userId: staffInfo!.uid,
                              staffName: staffInfo!.name,
                            ),
                          ),
                          buildButton(
                            name: 'Refreshment',
                            image: Image.asset(
                              'assets/refreshment.png',
                              scale: 3.8,
                            ),
                            page: RefreshmentScreen(
                              uid: staffInfo!.uid,
                              name: staffInfo!.name,
                            ),
                          ),
                          buildButton(
                            name: 'Food Count',
                            image: Image.asset(
                              'assets/food_count.png',
                              scale: 3,
                            ),
                            page: const FoodCountScreen(),
                          ),
                          buildButton(
                              name: 'Leave form',
                              image: Image.asset('assets/leave_apply.png'),
                              page: const LeaveApplyScreen()),
                          buildButton(
                              name: 'Onyx',
                              image: Image.asset(
                                'assets/onxy.png',
                                scale: 2.8,
                              ),
                              page: const AnnouncementScreen()),
                          buildButton(
                              name: 'Work done',
                              image: Image.asset(
                                'assets/work_entry.png',
                                scale: 3.5,
                              ),
                              page: WorkCompleteViewScreen(
                                userDetails: staffInfo!,
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
                              'assets/search_leads.png',
                              scale: 2.0,
                            ),
                            page: SearchLeadsScreen(staffInfo: staffInfo!),
                          ),
                          buildButton(
                            name: 'Leave Request',
                            image: Image.asset(
                              'assets/leave form.png',
                              scale: 4.0,
                            ),
                            page: const LeaveApprovalScreen(),
                          ),
                          buildButton(
                            name: 'Visit',
                            image: Image.asset(
                              'assets/visit.png',
                              scale: 1.8,
                            ),
                            page: const VisitFromScreen(),
                          ),
                          buildButton(
                            name: 'Invoice Generator',
                            image: Image.asset(
                              'assets/invoice.png',
                              scale: 2,
                            ),
                            page: const CustomerDetails(),
                          ),
                          buildButton(
                            name: 'Visit Check',
                            image: Image.asset(
                              'assets/visit_check.png',
                              scale: 3.4,
                            ),
                            page: const VisitCheckScreen(),
                          ),
                          buildButton(
                            name: 'Finance',
                            image: Image.asset(
                              'assets/finance.png',
                              scale: 1,
                            ),
                            page: const FinanceScreen(),
                          ),
                          buildButton(
                            name: 'Suggestions',
                            image: Image.asset(
                              'assets/suggestions.png',
                              scale: 3,
                            ),
                            page: SuggestionScreen(
                              uid: staffInfo!.uid,
                              name: staffInfo!.name,
                            ),
                          ),
                          buildButton(
                            name: 'Virtual Attendance',
                            image: Image.asset(
                              'assets/attendance.png',
                              scale: 3,
                            ),
                            page: AttendanceScreen(
                              uid: staffInfo!.uid,
                              name: staffInfo!.name,
                            ),
                          ),
                          buildButton(
                            name: 'View Suggestions',
                            image: Image.asset(
                              'assets/view_suggestions.png',
                              scale: 15,
                            ),
                            page: ViewSuggestions(
                              uid: staffInfo!.uid,
                              name: staffInfo!.name,
                            ),
                          ),
                          buildButton(
                            name: 'View Attendance',
                            image: Image.asset(
                              'assets/view_attendance.png',
                              scale: 3,
                            ),
                            page: const ViewAttendanceScreen(),
                          ),
                        ],
                      )
                    : GridView(
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
                              'assets/work_manager.png',
                              scale: 1.5,
                            ),
                            page: WorkEntryScreen(
                              userId: staffInfo!.uid,
                              staffName: staffInfo!.name,
                            ),
                          ),
                          buildButton(
                            name: 'Refreshment',
                            image: Image.asset(
                              'assets/refreshment.png',
                              scale: 3.8,
                            ),
                            page: RefreshmentScreen(
                              uid: staffInfo!.uid,
                              name: staffInfo!.name,
                            ),
                          ),
                          buildButton(
                            name: 'Suggestions',
                            image: Image.asset(
                              'assets/suggestions.png',
                              scale: 3,
                            ),
                            page: SuggestionScreen(
                              uid: staffInfo!.uid,
                              name: staffInfo!.name,
                            ),
                          ),
                          buildButton(
                            name: 'Virtual Attendance',
                            image: Image.asset(
                              'assets/attendance.png',
                              scale: 3,
                            ),
                            page: AttendanceScreen(
                              uid: staffInfo!.uid,
                              name: staffInfo!.name,
                            ),
                          ),
                        ],
                      )
        : Center(
            child: Lottie.asset(
              "assets/animations/loading.json",
            ),
          );
  }

  Widget buildButton(
      {required String name, required Image image, required Widget page}) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.vibrate();
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        decoration: BoxDecoration(
            color: const Color(0xffDAD6EE),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26,
                  offset: Offset(3.0, 3.0),
                  blurRadius: 3)
            ]),
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

  showUpdateAppDialog() {
    showCupertinoDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => WillPopScope(
        child: CupertinoAlertDialog(
          title: Text(
            "New Update Available!",
            style: TextStyle(
              fontFamily: ConstantFonts.poppinsBold,
            ),
          ),
          content: Text(
            "You are currently using an outdated version. Please update to a newer version to continue",
            style: TextStyle(
              fontFamily: ConstantFonts.poppinsMedium,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              textStyle: TextStyle(
                fontFamily: ConstantFonts.poppinsMedium,
              ),
              onPressed: () async {
                final url = Uri.parse(
                    'https://play.google.com/store/apps/details?id=com.onwords.my_office');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url,
                      mode: LaunchMode.externalNonBrowserApplication);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: const Text("Update Now"),
            ),
          ],
        ),
        onWillPop: () async {
          return false;
        },
      ),
    );
  }
}

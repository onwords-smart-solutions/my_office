import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:my_office/PR/invoice/Screens/Customer_Details_Screen.dart';
import 'package:my_office/app_version/version.dart';
import 'package:my_office/tl_check_screen/check_entry.dart';
import 'package:my_office/late_workdone/late_entry.dart';
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
import '../PR/pr_points_screen.dart';
import '../PR/visit_check.dart';
import '../database/hive_operations.dart';
import '../finance/finance_analysis.dart';
import '../food_count/food_count_screen.dart';
import '../leads/search_leads.dart';
import '../leave_apply/leave_apply_screen.dart';
import '../leave_approval/leave_approval_screen.dart';
import '../onyx/announcement.dart';
import '../suggestions/suggestions.dart';
import '../suggestions/view_suggestions.dart';
import '../virtual_attendance/attendance_screen.dart';
import '../virtual_attendance/view_attendance.dart';
import '../work_details/work_complete.dart';
import '../work_entry/work_entry.dart';

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
                  childAspectRatio: 1/1.2,
                  crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,),
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
                    name: 'Food count',
                    image: Image.asset(
                      'assets/food_count.png',
                      scale: 3.4,
                    ),
                    page: const FoodCountScreen(),
                  ),
                  buildButton(
                      name: 'Work details',
                      image: Image.asset(
                        'assets/work_details.png',
                        scale: 3.5,
                      ),
                      page: WorkCompleteViewScreen(
                        userDetails: staffInfo!,
                      ),
                  ),
                  buildButton(
                      name: 'Absent details',
                      image: Image.asset(
                        'assets/lead search.png',
                        scale: 3.0,
                      ),
                      page: const AbsenteeScreen(),
                  ),
                  buildButton(
                    name: 'Search leads',
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
                    name: 'Visit check',
                    image: Image.asset(
                      'assets/visit_check.png',
                      scale: 3.4,
                    ),
                    page: const VisitCheckScreen(),
                  ),
                  buildButton(
                    name: 'Invoice generator',
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
                      scale: 3.4,
                    ),
                    page: SuggestionScreen(
                      uid: staffInfo!.uid,
                      name: staffInfo!.name,
                    ),
                  ),
                  buildButton(
                    name: 'View suggestions',
                    image: Image.asset(
                      'assets/view_suggestions.png',
                      scale: 16.8,
                    ),
                    page: ViewSuggestions(
                      uid: staffInfo!.uid,
                      name: staffInfo!.name,
                    ),
                  ),
                  buildButton(
                    name: 'View attendance',
                    image: Image.asset(
                      'assets/view_attendance.png',
                      scale: 3.36,
                    ),
                    page: const ViewAttendanceScreen(),
                  ),
                  buildButton(
                    name: 'Check Entry',
                    image: Image.asset(
                      'assets/check_entry.png',
                      scale: 3.36,
                    ),
                    page: CheckEntryScreen(
                      userId: staffInfo!.uid,
                      staffName: staffInfo!.name,
                    ),
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
                            childAspectRatio: 1/1.2,
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0),
                    children: [
                      if (staffInfo!.uid == 'ZIuUpLfSIRgRN5EqP7feKA9SbbS2')
                        buildButton(
                          name: 'Visit check',
                          image: Image.asset(
                            'assets/visit_check.png',
                            scale: 3.4,
                          ),
                          page: const VisitCheckScreen(),
                        ),
                      buildButton(
                        name: 'Work entry',
                        image: Image.asset(
                          'assets/work_entry.png',
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
                        name: 'Search leads',
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
                        name: 'Invoice generator',
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
                          scale: 3.4,
                        ),
                        page: SuggestionScreen(
                          uid: staffInfo!.uid,
                          name: staffInfo!.name,
                        ),
                      ),
                      buildButton(
                        name: 'Virtual attendance',
                        image: Image.asset(
                          'assets/virtual_attendance.png',
                          scale: 3.4,
                        ),
                        page: AttendanceScreen(
                          uid: staffInfo!.uid,
                          name: staffInfo!.name,
                        ),
                      ),
                      buildButton(
                        name: 'PR points',
                        image: Image.asset(
                          'assets/pr_points.png',
                          scale: 3.36,
                        ),
                        page: PrPointsScreen(
                          userId: staffInfo!.uid,
                          staffName: staffInfo!.name,
                        ),
                      ),
                      if (staffInfo!.uid == 'ZIuUpLfSIRgRN5EqP7feKA9SbbS2')
                      buildButton(
                        name: 'Check Entry',
                        image: Image.asset(
                          'assets/check_entry.png',
                          scale: 3.36,
                        ),
                        page: CheckEntryScreen(
                          userId: staffInfo!.uid,
                          staffName: staffInfo!.name,
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
                              childAspectRatio: 1/1.2,
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,),
                        children: [
                          buildButton(
                            name: 'Work entry',
                            image: Image.asset(
                              'assets/work_entry.png',
                              scale: 1.5,
                            ),
                            page: WorkEntryScreen(
                              userId: staffInfo!.uid,
                              staffName: staffInfo!.name,
                            ),
                          ),
                          buildButton(
                            name: 'Work details',
                            image: Image.asset(
                              'assets/work_details.png',
                              scale: 3.5,
                            ),
                            page: WorkCompleteViewScreen(
                              userDetails: staffInfo!,
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
                            name: 'Food count',
                            image: Image.asset(
                              'assets/food_count.png',
                              scale: 3.4,
                            ),
                            page: const FoodCountScreen(),
                          ),
                          buildButton(
                              name: 'Leave form',
                              image: Image.asset('assets/leave_apply.png'),
                              page:  LeaveApplyScreen(
                                name: staffInfo!.name,
                                uid: staffInfo!.uid,
                              ),
                          ),
                          buildButton(
                              name: 'Onyx',
                              image: Image.asset(
                                'assets/onxy.png',
                                scale: 3,
                              ),
                              page: const AnnouncementScreen(),
                          ),
                          buildButton(
                              name: 'Absent details',
                              image: Image.asset(
                                'assets/lead search.png',
                                scale: 3.0,
                              ),
                              page: const AbsenteeScreen(),
                          ),
                          buildButton(
                            name: 'Leave approval',
                            image: Image.asset(
                              'assets/leave_request.png',
                              scale: 3.3,
                            ),
                            page: LeaveApprovalScreen(
                              name: staffInfo!.name,
                              uid: staffInfo!.uid,
                            ),
                          ),
                          buildButton(
                            name: 'Search leads',
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
                            name: 'Visit check',
                            image: Image.asset(
                              'assets/visit_check.png',
                              scale: 3.4,
                            ),
                            page: const VisitCheckScreen(),
                          ),
                          buildButton(
                            name: 'Invoice generator',
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
                              scale: 3.4,
                            ),
                            page: SuggestionScreen(
                              uid: staffInfo!.uid,
                              name: staffInfo!.name,
                            ),
                          ),
                          buildButton(
                            name: 'Virtual attendance',
                            image: Image.asset(
                              'assets/virtual_attendance.png',
                              scale: 3.4,
                            ),
                            page: AttendanceScreen(
                              uid: staffInfo!.uid,
                              name: staffInfo!.name,
                            ),
                          ),
                          buildButton(
                            name: 'View suggestions',
                            image: Image.asset(
                              'assets/view_suggestions.png',
                              scale: 16.8,
                            ),
                            page: ViewSuggestions(
                              uid: staffInfo!.uid,
                              name: staffInfo!.name,
                            ),
                          ),
                          buildButton(
                            name: 'View attendance',
                            image: Image.asset(
                              'assets/view_attendance.png',
                              scale: 3.36,
                            ),
                            page: const ViewAttendanceScreen(),
                          ),
                          buildButton(
                            name: 'Late entry',
                            image: Image.asset(
                              'assets/late_entry.png',
                              scale: 3.36,
                            ),
                            page: LateEntryScreen(
                              userId: staffInfo!.uid,
                              staffName: staffInfo!.name,
                            ),
                          ),
                          buildButton(
                            name: 'PR points',
                            image: Image.asset(
                              'assets/pr_points.png',
                              scale: 3.36,
                            ),
                            page: PrPointsScreen(
                              userId: staffInfo!.uid,
                              staffName: staffInfo!.name,
                            ),
                          ),
                          buildButton(
                            name: 'Check Entry',
                            image: Image.asset(
                              'assets/check_entry.png',
                              scale: 3.36,
                            ),
                            page: CheckEntryScreen(
                              userId: staffInfo!.uid,
                              staffName: staffInfo!.name,
                            ),
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
                                childAspectRatio: 1/1.2,
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0),
                        children: [
                          buildButton(
                            name: 'Work entry',
                            image: Image.asset(
                              'assets/work_entry.png',
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
                              scale: 3.4,
                            ),
                            page: SuggestionScreen(
                              uid: staffInfo!.uid,
                              name: staffInfo!.name,
                            ),
                          ),
                          buildButton(
                            name: 'Virtual attendance',
                            image: Image.asset(
                              'assets/virtual_attendance.png',
                              scale: 3.4,
                            ),
                            page: AttendanceScreen(
                              uid: staffInfo!.uid,
                              name: staffInfo!.name,
                            ),
                          ),
                          if (staffInfo!.uid == 'QPgtT8vDV8Y9pdy8fhtOmBON1Q03'|| staffInfo!.uid == 'hCxvT3mh1sgORNUMjsSNc9rgxgk2')
                          buildButton(
                            name: 'Check Entry',
                            image: Image.asset(
                              'assets/check_entry.png',
                              scale: 3.36,
                            ),
                            page: CheckEntryScreen(
                              userId: staffInfo!.uid,
                              staffName: staffInfo!.name,
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
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffBFACE2),
              Color(0xff8355B7),
            ],
          ),
            // color: const Color(0xffDAD6EE),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26,
                  offset: Offset(5.0, 5.0),
                  blurRadius: 5)
            ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(child: image),
            AutoSizeText(
              name,
              style: TextStyle(
                fontFamily: ConstantFonts.poppinsMedium,
                color: ConstantColor.background1Color,
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
            "New Update Available!!!",
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

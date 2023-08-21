import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:install_plugin_v2/install_plugin_v2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/leave_apply/leave_apply_screen.dart';
import 'package:my_office/leave_approval/leave_approval_screen.dart';
import 'package:my_office/models/prdash_model.dart';
import 'package:my_office/models/staff_model.dart';
import 'package:my_office/suggestions/view_suggestions.dart';
import 'package:my_office/util/main_template.dart';
import 'package:my_office/util/notification_services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../Constant/fonts/constant_font.dart';
import '../app_version/version.dart';
import '../constant/app_defaults.dart';
import '../database/hive_operations.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final HiveOperations _hiveOperations = HiveOperations();
  final NotificationService _notificationService = NotificationService();
  bool isLoading = false;
  bool isAlwaysShown = true;
  final ScrollController _scrollController = ScrollController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  double prFixedAmount = 0.0;
  double prTotalAmountNumber = 0.0;
  int prTotalAmount = 0;
  List<PRDashModel> prDashInfo = [];
  List<String> managementStaffNames = [];
  List<String> tlStaffNames = [];
  List<String> rndTlStaffNames = [];
  List<String> installationBoysNames = [];
  List<String> userAccessGridButtonsName = [];
  List<String> userAccessGridButtonsPics = [];
  List<Map<String, dynamic>> prDashboard = [];

  //Getting management staff names form database
  Future<void> getManagementNames() async {
    List<String> names = [];
    final ref = FirebaseDatabase.instance.ref().child('special_access');
    await ref.child('management').once().then((value) {
      if (value.snapshot.exists) {
        for (var mgmt in value.snapshot.children) {
          names.add(mgmt.value.toString());
        }
        managementStaffNames = names;
      }
    });
    await getTlNames();
    await getRndTlNames();
    await getInstallationNames();
    getStaffDetail();
  }

  //Getting Tl names from database
  Future<void> getTlNames() async {
    List<String> tlNames = [];
    final ref = FirebaseDatabase.instance.ref().child('special_access');
    await ref.child('tl').once().then((value) {
      if (value.snapshot.exists) {
        for (var tl in value.snapshot.children) {
          tlNames.add(tl.value.toString());
        }
        tlStaffNames = tlNames;
      }
    });
  }

  //Getting rnd tl names from database
  Future<void> getRndTlNames() async {
    List<String> rndTlNames = [];
    final ref = FirebaseDatabase.instance.ref().child('special_access');
    await ref.child('rnd_tl').once().then((value) {
      if (value.snapshot.exists) {
        for (var tl in value.snapshot.children) {
          rndTlNames.add(tl.value.toString());
        }
        rndTlStaffNames = rndTlNames;
      }
    });
  }

  //Getting installation boys names from database
  Future<void> getInstallationNames() async {
    List<String> installationNames = [];
    final ref = FirebaseDatabase.instance.ref().child('special_access');
    await ref.child('installation').once().then((value) {
      if (value.snapshot.exists) {
        for (var tl in value.snapshot.children) {
          installationNames.add(tl.value.toString());
        }
        installationBoysNames = installationNames;
      }
    });
  }

  StaffModel? staffInfo;
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;

  //CHECKING INTERNET CONNECTIVITY
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

  //GETTING STAFF DETAILS FOR CHECKING THE HOME SCREEN TABS
  void getStaffDetail() async {
    final data = await _hiveOperations.getStaffDetail();
    setState(() {
      // log('current user is ${data.name}');
      // log('management names are $managementStaffNames');
      // log('tl names are $tlStaffNames');
      // log('rnd tl names are $rndTlStaffNames');
      // log('installation boys names are $installationBoysNames');
      if (managementStaffNames.any((element) => element == data.name)) {
        userAccessGridButtonsName.addAll(AppDefaults.gridButtonsNames);
        userAccessGridButtonsPics.addAll(AppDefaults.gridButtonPics);
        if (data.uid != 'ZIuUpLfSIRgRN5EqP7feKA9SbbS2') {
          userAccessGridButtonsName.remove('Create leads');
          userAccessGridButtonsPics.remove('assets/create_leads.png');
        }
        userAccessGridButtonsName.remove('View suggestions');
        userAccessGridButtonsName.remove('Onyx');
        userAccessGridButtonsName.remove('Late entry');
        userAccessGridButtonsName.remove('Staff details');
        userAccessGridButtonsPics.remove('assets/view_suggestions.png');
        userAccessGridButtonsPics.remove('assets/onxy.png');
        userAccessGridButtonsPics.remove('assets/late_entry.png');
        userAccessGridButtonsPics.remove('assets/staff_details.png');
      } else if (tlStaffNames.any((element) => element == data.name)) {
        for (int i = 0; i < AppDefaults.gridButtonsNames.length; i++) {
          if (AppDefaults.gridButtonsNames[i] == 'Work entry' ||
              AppDefaults.gridButtonsNames[i] == 'Work details' ||
              AppDefaults.gridButtonsNames[i] == 'Refreshment' ||
              AppDefaults.gridButtonsNames[i] == 'Leave apply form' ||
              AppDefaults.gridButtonsNames[i] == 'Absent details' ||
              AppDefaults.gridButtonsNames[i] == 'Leave approval' ||
              AppDefaults.gridButtonsNames[i] == 'Suggestions' ||
              AppDefaults.gridButtonsNames[i] == 'Virtual attendance' ||
              AppDefaults.gridButtonsNames[i] == 'Check Virtual entry' ||
              AppDefaults.gridButtonsNames[i] == 'Entry time' ||
              AppDefaults.gridButtonsNames[i] == 'Quotation template' ||
              AppDefaults.gridButtonsNames[i] == 'Installation pdf') {
            userAccessGridButtonsName.add(AppDefaults.gridButtonsNames[i]);
            userAccessGridButtonsPics.add(AppDefaults.gridButtonPics[i]);
          }
        }
      } else if (rndTlStaffNames.any((element) => element == data.name)) {
        for (int i = 0; i < AppDefaults.gridButtonsNames.length; i++) {
          if (AppDefaults.gridButtonsNames[i] == 'Work entry' ||
              AppDefaults.gridButtonsNames[i] == 'Work details' ||
              AppDefaults.gridButtonsNames[i] == 'Refreshment' ||
              AppDefaults.gridButtonsNames[i] == 'Leave apply form' ||
              AppDefaults.gridButtonsNames[i] == 'Leave approval' ||
              AppDefaults.gridButtonsNames[i] == 'Suggestions' ||
              AppDefaults.gridButtonsNames[i] == 'Virtual attendance' ||
              AppDefaults.gridButtonsNames[i] == 'Quotation template' ||
              AppDefaults.gridButtonsNames[i] == 'Installation pdf') {
            userAccessGridButtonsName.add(AppDefaults.gridButtonsNames[i]);
            userAccessGridButtonsPics.add(AppDefaults.gridButtonPics[i]);
          }
        }
      } else if (installationBoysNames.any((element) => element == data.name)) {
        for (int i = 0; i < AppDefaults.gridButtonsNames.length; i++) {
          if (AppDefaults.gridButtonsNames[i] == 'Work entry' ||
              AppDefaults.gridButtonsNames[i] == 'Refreshment' ||
              AppDefaults.gridButtonsNames[i] == 'Leave apply form' ||
              AppDefaults.gridButtonsNames[i] == 'Invoice generator' ||
              AppDefaults.gridButtonsNames[i] == 'Suggestions' ||
              AppDefaults.gridButtonsNames[i] == 'Virtual attendance' ||
              AppDefaults.gridButtonsNames[i] == 'Quotation template' ||
              AppDefaults.gridButtonsNames[i] == 'Installation pdf') {
            userAccessGridButtonsName.add(AppDefaults.gridButtonsNames[i]);
            userAccessGridButtonsPics.add(AppDefaults.gridButtonPics[i]);
          }
        }
      } else if (data.department == 'ADMIN') {
        userAccessGridButtonsName.addAll(AppDefaults.gridButtonsNames);
        userAccessGridButtonsName.remove('Onyx');
        userAccessGridButtonsName.remove('Late entry');
        userAccessGridButtonsPics.addAll(AppDefaults.gridButtonPics);
        userAccessGridButtonsPics.remove('assets/onxy.png');
        userAccessGridButtonsPics.remove('assets/late_entry.png');
      } else if (data.department == 'APP') {
        userAccessGridButtonsName.addAll(AppDefaults.gridButtonsNames);
        userAccessGridButtonsPics.addAll(AppDefaults.gridButtonPics);
        if (data.uid != '58JIRnAbechEMJl8edlLvRzHcW52') {
          userAccessGridButtonsName.remove('Staff details');
          userAccessGridButtonsPics.remove(
            'assets/staff_details.png',
          );
        }
      } else if (data.department == 'PR') {
        for (int i = 0; i < AppDefaults.gridButtonsNames.length; i++) {
          if (AppDefaults.gridButtonsNames[i] == 'Work entry' ||
              AppDefaults.gridButtonsNames[i] == 'Refreshment' ||
              AppDefaults.gridButtonsNames[i] == 'Leave apply form' ||
              AppDefaults.gridButtonsNames[i] == 'Search leads' ||
              AppDefaults.gridButtonsNames[i] == 'Visit' ||
              AppDefaults.gridButtonsNames[i] == 'Invoice generator' ||
              AppDefaults.gridButtonsNames[i] == 'Suggestions' ||
              AppDefaults.gridButtonsNames[i] == 'Virtual attendance' ||
              AppDefaults.gridButtonsNames[i] == 'PR Work done' ||
              AppDefaults.gridButtonsNames[i] == 'Sales points' ||
              AppDefaults.gridButtonsNames[i] == 'Scan QR' ||
              AppDefaults.gridButtonsNames[i] == 'PR Reminder' ||
              AppDefaults.gridButtonsNames[i] == 'Quotation template') {
            userAccessGridButtonsName.add(AppDefaults.gridButtonsNames[i]);
            userAccessGridButtonsPics.add(AppDefaults.gridButtonPics[i]);
          }
        }
      } else {
        for (int i = 0; i < AppDefaults.gridButtonsNames.length; i++) {
          if (AppDefaults.gridButtonsNames[i] == 'Work entry' ||
              AppDefaults.gridButtonsNames[i] == 'Refreshment' ||
              AppDefaults.gridButtonsNames[i] == 'Leave apply form' ||
              AppDefaults.gridButtonsNames[i] == 'Suggestions' ||
              AppDefaults.gridButtonsNames[i] == 'Virtual attendance') {
            userAccessGridButtonsName.add(AppDefaults.gridButtonsNames[i]);
            userAccessGridButtonsPics.add(AppDefaults.gridButtonPics[i]);
          }
        }
      }
      staffInfo = data;
      getToken();
    });
  }

  //SETTING NOTIFICATION FOR REFRESHMENT
  setNotification() async {
    final pref = await SharedPreferences.getInstance();
    final isNotificationSet = pref.getString('NotificationSetTime') ?? '';
    _notificationService.showDailyNotificationWithPayload(
        setTime: isNotificationSet);
  }

  //CHECKING APP VERSION
  Future<void> checkAppVersion() async {
    final ref = FirebaseDatabase.instance.ref();
    ref.child('myOffice').once().then((value) {
      if (value.snapshot.exists) {
        final data = value.snapshot.value as Map<Object?, Object?>;
        final updatedVersion = data['versionNumber'];
        if (AppConstants.pubVersion != updatedVersion) {
          showUpdateAppDialog();
        }
      }
    });
  }

  //GETTING ALL MOBILE DEVICE ID'S AS TOKENS
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    if (token.isEmpty) {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      // log('Token of the device is $fcmToken');
      await saveTokenToDb(fcmToken!);
      FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDb);
      prefs.setString('token', fcmToken);
    }
  }

  //SAVING THE DEVICE TOKENS IN FIRESTORE DB
  Future<void> saveTokenToDb(String fcmToken) async {
    await FirebaseFirestore.instance
        .collection('Devices')
        .doc(staffInfo!.uid)
        .set({
      'Name': staffInfo!.name,
      'Date': DateFormat('dd-MM-yyyy').format(DateTime.now()),
      'Time': DateFormat.jms().format(DateTime.now()),
      'Token': fcmToken,
    });
  }

  //REQUEST PERMISSION FOR SENDING DEVICE NOTIFICATIONS SEPARATELY
  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('user granted access');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('user granted limited access');
    } else {
      print('user denied permission');
    }
  }

  //TIME OF DAY GREETING IN HOME SCREEN
  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good morning, Today's ur day🤗";
    } else if (hour < 16) {
      return "Good noon, Stay focused😍";
    } else {
      return "Good evening, Let's do it🤩";
    }
  }

  //GETTING PR DASHBOARD DETAILS FROM DB
  void getDashboardDetails() {
    double fixedAmount = 0.0;
    double totalAmountNumber = 0.0;
    int totalSalesNumber = 0;
    List<PRDashModel> prDash = [];
    var ref = FirebaseDatabase.instance.ref();
    ref.child('PRDashboard/allteam').once().then((data) {
      for (var prData in data.snapshot.children) {
        final data = prData.value as Map<Object?, Object?>;

        // -- getting fixed amount --
        if (prData.key.toString() == 'fixedamount') {
          fixedAmount = double.parse(data['amount'].toString());
        } else {
          // -- adding team details into model list --
          prDash.add(PRDashModel(
              amount: double.parse(data['amount'].toString()),
              teamName: prData.key.toString(),
              sales: int.parse(data['sales'].toString())));
        }
      }
      for (var totalSales in prDash) {
        totalSalesNumber += totalSales.sales;
      }
      for (var totalAmount in prDash){
        totalAmountNumber += totalAmount.amount;
      }
       setState(() {
         prFixedAmount = fixedAmount;
         prDashInfo = prDash;
         prTotalAmount = totalSalesNumber;
         prTotalAmountNumber = totalAmountNumber;
       });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      buildPRDashboard();
    });
    }

  @override
  void initState() {
    checkAppVersion();
    getManagementNames();
    getConnectivity();
    getDashboardDetails();
    setNotification();
    requestPermission();

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      final screen = event.data['screen'];
      if (screen == 'ViewSuggestionsScreen') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const ViewSuggestions(),
          ),
        );
      } else if (screen == 'LeaveApprovalScreen') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => LeaveApprovalScreen(
              name: staffInfo!.name,
              uid: staffInfo!.uid,
              department: staffInfo!.department,
            ),
          ),
        );
      } else if (screen == 'LeaveApplyForm') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => LeaveApplyScreen(
                name: staffInfo!.name,
                uid: staffInfo!.uid,
                department: staffInfo!.department),
          ),
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return MainTemplate(
      subtitle: greeting(),
      templateBody: buildMenuGrid(height, width),
      bgColor: ConstantColor.background1Color,
    );
  }

  //DIALOG BOX FOR SHOWING PR DASHBOARD IN INIT STATE
  buildPRDashboard() {
    final context=this.context;
    final size = MediaQuery.sizeOf(context);
    return showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                insetPadding:const EdgeInsets.all(15),
                title: Center(
                  child: Text(
                    'PR Dashboard',
                    style: TextStyle(
                        fontFamily: ConstantFonts.sfProBold,
                        color: Colors.purple),
                  ),
                ),
                content: Column(
                  children: [
                    Text(
                      'Sales Revenue',
                      style: TextStyle(
                        fontFamily: ConstantFonts.sfProBold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.2,
                      width: size.width,
                      child: ListView.builder(
                        itemCount: prDashInfo.length,
                        itemBuilder: (ctx, i) {
                          String name = 'Alpha';
                          Color color = Colors.deepPurple;

                          switch (prDashInfo[i].teamName) {
                            case 'team2':
                              name = 'Bravo';
                              color = Colors.redAccent;
                              break;
                            case 'team4':
                              name = 'Delta';
                              color = Colors.blue;
                              break;
                          }
                          return prDashInfo[i].teamName == 'team3'
                              ? const SizedBox.shrink()
                              : ListTile(
                                  leading: Icon(
                                    Icons.leaderboard,
                                    color: color,
                                  ),
                                  title: Text(
                                    name,
                                    style: TextStyle(
                                      fontFamily: ConstantFonts.sfProMedium,
                                      fontSize: 18,
                                      color: color,
                                    ),
                                  ),
                                  trailing: Text(
                                    prDashInfo[i].sales.toString(),
                                    style: TextStyle(
                                      fontFamily: ConstantFonts.sfProMedium,
                                      fontSize: 18,
                                      color: color,
                                    ),
                                  ),
                                );
                        },
                      ),
                    ),
                    Divider(
                      height: size.height * 0.015,
                      thickness: 1,
                      color: Colors.black,
                    ),
                    Row(
                      children: [
                        const Spacer(flex: 3),
                        Text(
                          'Total',
                          style: TextStyle(
                              fontFamily: ConstantFonts.sfProBold,
                              fontSize: 18),
                        ),
                        const Spacer(flex: 4),
                        Text(
                          '=',
                          style: TextStyle(
                              fontFamily: ConstantFonts.sfProBold,
                              fontSize: 18),
                        ),
                        const Spacer(flex: 4),
                        Text(
                          '$prTotalAmount',
                          style: TextStyle(
                              fontFamily: ConstantFonts.sfProBold,
                              fontSize: 18),
                        ),
                        const Spacer(flex: 1),
                      ],
                    ),
                    Divider(
                      height: size.height * 0.015,
                      thickness: 1,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    SizedBox(
                      height: size.height * 0.4,
                      width: size.width,
                      child: SfCartesianChart(
                        plotAreaBorderWidth: 0.0,
                        primaryXAxis: CategoryAxis(
                          labelStyle: TextStyle(
                              fontFamily: ConstantFonts.sfProMedium,
                              color: Colors.black),
                          majorGridLines: const MajorGridLines(width: 0),
                        ),
                        primaryYAxis: NumericAxis(
                            labelStyle: TextStyle(
                                fontFamily: ConstantFonts.sfProMedium,
                                color: Colors.black),
                            majorGridLines: const MajorGridLines(width: 0)),
                        series: <ColumnSeries<SalesData, String>>[
                          ColumnSeries<SalesData, String>(
                            dataLabelSettings: DataLabelSettings(
                                isVisible: true,
                                textStyle: TextStyle(
                                  fontSize: 12,
                                  fontFamily: ConstantFonts.sfProBold,
                                  color: Colors.black,
                                )),
                            dataSource: getChartData(),
                            xValueMapper: (SalesData sales, _) =>
                                sales.sales,
                            yValueMapper: (SalesData sales, _) =>
                                sales.year,
                            pointColorMapper: (SalesData sale, _) {
                              if (sale.sales == 'Alpha') {
                                return Colors.deepPurple;
                              } else if (sale.sales == 'Bravo') {
                                return Colors.redAccent;
                              }
                              return Colors.blue;
                            },
                            dataLabelMapper: (SalesData sales, _) =>
                                sales.year.toInt().toString(),
                          ),
                        ],
                        borderWidth: 0.0,
                        title: ChartTitle(
                          text: 'Sales Chart',
                          textStyle: TextStyle(
                              fontFamily: ConstantFonts.sfProBold,
                              color: Colors.black),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Total  =  ${prTotalAmountNumber.toInt()}',
                        style: TextStyle(
                          fontFamily: ConstantFonts.sfProBold,
                          fontSize: 17,
                        ),
                      ),
                    )
                  ],
                ),
                actions: [
                  FilledButton(
                    style: FilledButton.styleFrom(
                      elevation: 10,
                      backgroundColor: Colors.purple.withOpacity(0.8),
                    ),
                    child: Text(
                      'OK',
                      style: TextStyle(
                        fontFamily: ConstantFonts.sfProBold,
                        fontSize: 17,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
  }

  List<SalesData> getChartData() {
    List<SalesData> data = [];

    for (var team in prDashInfo) {
      if (team.teamName != 'team3') {
        String name = 'Alpha';
        if (team.teamName == 'team2') {
          name = 'Bravo';
        } else if (team.teamName == 'team4') {
          name = 'Delta';
        }

        data.add(SalesData(team.amount, name));
      }
    }
    return data;
  }

  Widget buildMenuGrid(double height, double width) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return staffInfo != null
        ? GridView.builder(
            itemCount: userAccessGridButtonsName.length,
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            scrollDirection: Axis.vertical,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1 / 1.2,
              crossAxisCount: 3,
              crossAxisSpacing: 7.0,
              mainAxisSpacing: 4,
            ),
            itemBuilder: (BuildContext context, int index) {
              final page = AppDefaults()
                  .getPage(userAccessGridButtonsName[index], staffInfo!);
              return buildButton(
                  name: userAccessGridButtonsName[index],
                  image: Image.asset(
                    userAccessGridButtonsPics[index],
                    width: width * 1,
                    height: height * 0.1,
                    fit: BoxFit.contain,
                  ),
                  page: page);
            },
          )
        : Center(
            child: Lottie.asset(
              "assets/animations/new_loading.json",
            ),
          );
  }

  Widget buildButton(
      {required String name, required Image image, required Widget page}) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 10,
        child: Container(
          height: height * 0.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xff9384D1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              image,
              AutoSizeText(
                textAlign: TextAlign.center,
                name,
                style: TextStyle(
                  fontFamily: ConstantFonts.sfProMedium,
                  fontSize: 15,
                  color: CupertinoColors.white,
                ),
                maxFontSize: 15,
                minFontSize: 8,
              )
            ],
          ),
        ),
      ),
    );
  }

  showDialogBox() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(
          "No Internet Connection💀",
          style: TextStyle(
            color: ConstantColor.headingTextColor,
            fontFamily: ConstantFonts.sfProBold,
            // fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        content: Text(
          "Please connect to a Wi-Fi / Mobile network 📶",
          style: TextStyle(
            color: ConstantColor.headingTextColor,
            fontFamily: ConstantFonts.sfProMedium,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context, 'CANCEL');
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
            child: Text(
              "OK",
              style: TextStyle(
                color: ConstantColor.backgroundColor,
                fontFamily: ConstantFonts.sfProRegular,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  showUpdateAppDialog() {
    showCupertinoDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        bool isUpdating = false;
        return WillPopScope(
          child: StatefulBuilder(
            builder: (BuildContext context, setState) => CupertinoAlertDialog(
              title: isUpdating
                  ? Text(
                      'Checking for update..',
                      style: TextStyle(
                        fontFamily: ConstantFonts.sfProBold,
                        fontSize: 18,
                      ),
                    )
                  : Text(
                      "New Update Available!!",
                      style: TextStyle(
                        fontFamily: ConstantFonts.sfProBold,
                        fontSize: 18,
                      ),
                    ),
              content: isUpdating
                  ? Column(
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          'While prompted to update \nPress Update',
                          style: TextStyle(
                            color: ConstantColor.backgroundColor,
                            fontSize: 17,
                            fontFamily: ConstantFonts.sfProMedium,
                          ),
                        ),
                        Lottie.asset('assets/animations/app_update.json'),
                      ],
                    )
                  : Text(
                      "You are currently using an outdated version. Update the app to use the latest features..",
                      style: TextStyle(
                        fontFamily: ConstantFonts.sfProMedium,
                        fontSize: 16,
                      ),
                    ),
              actions: [
                isUpdating
                    ? const SizedBox.shrink()
                    : CupertinoDialogAction(
                        isDefaultAction: true,
                        textStyle: TextStyle(
                          fontFamily: ConstantFonts.sfProRegular,
                        ),
                        onPressed: () async {
                          final permission =
                              await Permission.requestInstallPackages.isGranted;
                          if (permission) {
                            setState(() {
                              isUpdating = true;
                            });
                            onClickInstallApk();
                          } else {
                            await Permission.requestInstallPackages.request();
                          }
                        },
                        child: Text(
                          "Update Now",
                          style: TextStyle(
                              color: ConstantColor.backgroundColor,
                              fontFamily: ConstantFonts.sfProBold),
                        ),
                      ),
              ],
            ),
          ),
          onWillPop: () async {
            return false;
          },
        );
      },
    );
  }

  Future<void> onClickInstallApk() async {
    final resultPath =
        FirebaseStorage.instance.ref('MY OFFICE APK/app-release.apk');
    final appDocDir = await getExternalStorageDirectory();
    final String appDocPath = appDocDir!.path;
    final File tempFile = File('$appDocPath/MY_OFFICE_UPDATED.apk');
    try {
      await resultPath.writeToFile(tempFile);
      await tempFile.create();
      await InstallPlugin.installApk(tempFile.path, 'com.onwords.office')
          .then((result) {
        // print('install apk $result');
      }).catchError((error) {
        // print('install apk error: $error');
      });
    } on FirebaseException {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error, file is not available to download',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }
  }
}

class SalesData {
  SalesData(this.year, this.sales);

  final String sales;
  final double year;
}

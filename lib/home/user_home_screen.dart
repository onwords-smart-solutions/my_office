import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:install_plugin_v2/install_plugin_v2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/models/staff_model.dart';
import 'package:my_office/util/main_template.dart';
import 'package:my_office/util/notification_services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Constant/fonts/constant_font.dart';
import '../app_version/version.dart';
import '../constant/app_defaults.dart';
import '../database/hive_operations.dart';
import '../refreshment/refreshment_screen.dart';

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

  List<String> managementStaffNames = [];
  List<String> userAccessGridButtonsName = [];
  List<String> userAccessGridButtonsImages = [];

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
    getStaffDetail();
  }

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
      log('names are $managementStaffNames');
      log('data are ${data.name}');
      if (managementStaffNames.any((element) => element == data.name)) {
        userAccessGridButtonsName.addAll(AppDefaults.gridButtonsNames);
        userAccessGridButtonsName.remove('View suggestions');
        userAccessGridButtonsName.remove('Onyx');
        userAccessGridButtonsName.remove('Late entry');
        userAccessGridButtonsImages.addAll(AppDefaults.gridButtonsImages);
        userAccessGridButtonsImages.remove('assets/view_suggestions.png');
        userAccessGridButtonsImages.remove('assets/onxy.png');
        userAccessGridButtonsImages.remove('assets/late_entry.png');
      } else if (data.department == 'ADMIN') {
        userAccessGridButtonsName.addAll(AppDefaults.gridButtonsNames);
        userAccessGridButtonsName.remove('Onyx');
        userAccessGridButtonsName.remove('Late entry');
        userAccessGridButtonsImages.addAll(AppDefaults.gridButtonsImages);
        userAccessGridButtonsImages.remove('assets/onxy.png');
        userAccessGridButtonsImages.remove('assets/late_entry.png');
      } else if (data.department == 'APP') {
        userAccessGridButtonsName.addAll(AppDefaults.gridButtonsNames);
        userAccessGridButtonsImages.addAll(AppDefaults.gridButtonsImages);
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
              AppDefaults.gridButtonsNames[i] == 'Sales points') {
            userAccessGridButtonsName.add(AppDefaults.gridButtonsNames[i]);
            userAccessGridButtonsImages.add(AppDefaults.gridButtonsImages[i]);
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
            userAccessGridButtonsImages.add(AppDefaults.gridButtonsImages[i]);
          }
        }
      }
      staffInfo = data;
    });
  }

  //Notification set
  setNotification() async {
    final pref = await SharedPreferences.getInstance();
    final isNotificationSet = pref.getString('NotificationSetTime') ?? '';
    _notificationService.showDailyNotificationWithPayload(
        setTime: isNotificationSet);
  }

  //CHECKING APP VERSION..//
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

  @override
  void initState() {
    checkAppVersion();
    getManagementNames();
    getConnectivity();
    setNotification();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return staffInfo != null
        ? GridView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: userAccessGridButtonsName.length,
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1 / 1.3,
                crossAxisCount: 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0),
            itemBuilder: (BuildContext context, int index) {
              final page = AppDefaults()
                  .getPage(userAccessGridButtonsName[index], staffInfo!);
              return buildButton(
                  name: userAccessGridButtonsName[index],
                  image: Image.asset(
                    userAccessGridButtonsImages[index],
                    width: width * 1,
                    height: height * 0.12,
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
    return GestureDetector(
      onTap: () {
        HapticFeedback.vibrate();
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                color: Colors.black26, offset: Offset(5.0, 5.0), blurRadius: 5)
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
              maxFontSize: 11,
              minFontSize: 8,
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
        title: const Text("No Internet Connection"),
        content: const Text("Please check your internet connection"),
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
      builder: (BuildContext context) {
        bool isUpdating = false;
        return WillPopScope(
          child: StatefulBuilder(
            builder: (BuildContext context, setState) => CupertinoAlertDialog(
              title: isUpdating
                  ? Text(
                      'App is updating..',
                      style: TextStyle(
                        fontFamily: ConstantFonts.poppinsBold,
                      ),
                    )
                  : Text(
                      "New Update Available!!",
                      style: TextStyle(
                        fontFamily: ConstantFonts.poppinsBold,
                      ),
                    ),
              content: isUpdating
                  ? Column(
                    children: [
                      const Text('While prompted to update \nPress Update'),
                      Lottie.asset('assets/animations/app_update.json'),
                    ],
                  )
                  : Text(
                      "You are currently using an outdated version. Update the app to use the latest features..",
                      style: TextStyle(
                        fontFamily: ConstantFonts.poppinsMedium,
                      ),
                    ),

              actions: [
                 isUpdating ? SizedBox.shrink() :CupertinoDialogAction(
                  isDefaultAction: true,
                  textStyle: TextStyle(
                    fontFamily: ConstantFonts.poppinsMedium,
                  ),
                  onPressed: () async {
                    final permission = await Permission.requestInstallPackages.isGranted;
                  if (permission){
                    setState(() {
                      isUpdating = true;
                    });
                    onClickInstallApk();
                  }else{
                   await Permission.requestInstallPackages.request();
                  }
                  },
                  child: Text(
                    "Update Now",
                    style: TextStyle(
                        color: ConstantColor.backgroundColor,
                        fontWeight: FontWeight.w600,
                        fontFamily: ConstantFonts.poppinsRegular),
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
        print('install apk $result');
      }).catchError((error) {
        print('install apk error: $error');
      });
    } on FirebaseException {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error, file is not available to download',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      );
    }
  }
}

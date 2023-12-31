import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:install_plugin_v2/install_plugin_v2.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/home/custom_search_delegate.dart';
import 'package:my_office/home/home_menu_item.dart';
import 'package:my_office/home/home_view_model.dart';
import 'package:my_office/home/info_item.dart';
import 'package:my_office/home/no_user.dart';
import 'package:my_office/home/onyx.dart';
import 'package:my_office/provider/user_provider.dart';
import 'package:my_office/services/notification_service.dart';
import 'package:my_office/util/custom_alerts.dart';
import 'package:my_office/util/custom_snackbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Account/account_screen.dart';
import '../app_version/version.dart';
import '../models/custom_punching_model.dart';
import '../models/staff_access_model.dart';
import '../models/staff_model.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'api_operations.dart';

//onyx variables
final ValueNotifier<bool> isListening = ValueNotifier(false);
final ValueNotifier<bool> isLoading = ValueNotifier(false);
final ValueNotifier<bool> isPlayPause = ValueNotifier(false);
final ValueNotifier<String> recognizedWords = ValueNotifier('');
final ValueNotifier<Map<String, dynamic>> replyFromOnyx = ValueNotifier({});

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final NotificationService _notificationService = NotificationService();
  int _motivationIndex = 0;
  late StreamSubscription subscription;

  //notifiers
  final ValueNotifier<List<StaffAccessModel>> _staffAccess = ValueNotifier([]);
  final ValueNotifier<bool> _haveNetwork = ValueNotifier(true);
  final ValueNotifier<double> _totalMB = ValueNotifier(-1.0);
  final ValueNotifier<double> _downloadedMB = ValueNotifier(0.0);
  final HomeViewModel _homeViewModel = HomeViewModel();
  final ValueNotifier<CustomPunchModel?> _entryDetail = ValueNotifier(null);
  final ValueNotifier<DateTime> _endTime = ValueNotifier(DateTime.now());
  final ValueNotifier<List<StaffModel>> _bdayStaffs = ValueNotifier([]);

  //Onyx Screen contents
  final ApiOperations _apiOperations = ApiOperations();
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts flutterTts = FlutterTts();

  void _initSpeech() async {
    final context=this.context;
    await _speechToText.initialize(
      onStatus: (value) async {
        if (value == 'listening') {
          isListening.value = true;
        } else {
          isListening.value = false;

          if (recognizedWords.value.isNotEmpty && value == 'done') {
            isLoading.value = true;
            await callOnyx(context,recognizedWords.value);
            isLoading.value = false;
          }
        }
      },
    );
  }



  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
  }

  void _stopListening() async {
    await _speechToText.stop();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    recognizedWords.value = result.recognizedWords;
  }

  @override
  void initState() {
    final context = this.context;
    _getInfoItemDetails();
    _motivationIndex = _homeViewModel.getRandomNumber();
    _checkAppVersion();
    _getStaffAccess();
    _getNetworkStatus();
    _notificationService.storeFCM(context: context);
    _notificationService.initFCMNotifications();
    _setNotification();
    _setupFCMListener(context);
    _initSpeech();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Consumer<UserProvider>(
      builder: (ctx, userProvider, child) {
        return userProvider.user == null
            ? const NoUser()
            : Scaffold(
                appBar: AppBar(
                  surfaceTintColor: Colors.white,
                  backgroundColor: Colors.white,
                  leading: GestureDetector(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AccountScreen(),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      clipBehavior: Clip.hardEdge,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: userProvider.user!.profilePic.isEmpty
                          ? const Image(
                              image: AssetImage('assets/profile_icon.jpg'),
                            )
                          : CachedNetworkImage(
                              imageUrl: userProvider.user!.profilePic,
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      CircularProgressIndicator(
                                value: downloadProgress.progress,
                              ),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                            ),
                    ),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/onwords.png',
                        height: 14,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        'Hello, ${userProvider.user!.name}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 25.0,
                        ),
                      ),
                    ],
                  ),
                ),
                body: _body(userProvider, size),

                //Onyx button
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
                floatingActionButton: FloatingActionButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  backgroundColor: const Color(0xff793FDF),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => Onyx(
                          onListen: _startListening,
                          onStop: _stopListening,
                        ),
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/onyx_thala.png',
                    scale: 1.7,
                  ),
                ),
              );
      },
    );
  }

  Widget _body(UserProvider userProvider, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //search bar
        _search(size, userProvider),
        Expanded(
          child: ListView(
            children: [
              //info
              ValueListenableBuilder(
                valueListenable: _bdayStaffs,
                builder: (ctx, birthdayList, child) {
                  return ValueListenableBuilder(
                    valueListenable: _entryDetail,
                    builder: (ctx, staffEntry, child) {
                      return ValueListenableBuilder(
                        valueListenable: _endTime,
                        builder: (ctx, endTime, child) {
                          return InfoItem(
                            staff: userProvider.user!,
                            todayBirthdayList: birthdayList,
                            quoteIndex: _motivationIndex,
                            staffEntryDetail: staffEntry,
                            endTime: endTime,
                          );
                        },
                      );
                    },
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  'Utilities',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20.0,
                    color: Colors.black38.withOpacity(.7),
                  ),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: _staffAccess,
                builder: (ctx, staffAccess, child) {
                  return staffAccess.isEmpty
                      ? Lottie.asset(
                          'assets/animations/new_loading.json',
                          height: size.height * .6,
                        )
                      : Consumer<UserProvider>(
                          builder: (ctx, userProvider, child) {
                            return GridView.builder(
                              itemCount: staffAccess.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(10.0),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 15.0,
                                mainAxisSpacing: 30,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return HomeMenuItem(
                                  title: staffAccess[index].title,
                                  image: staffAccess[index].image,
                                  staff: userProvider.user!,
                                );
                              },
                            );
                          },
                        );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _search(Size size, UserProvider userProvider) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      color: Colors.white,
      child: TextField(
        onTap: () {
          HapticFeedback.mediumImpact();
          showSearch(
            context: context,
            delegate: CustomSearchDelegate(
              allAccess: _staffAccess.value,
              staffInfo: userProvider.user!,
            ),
          );
        },
        readOnly: true,
        decoration: InputDecoration(
          suffixIcon: const Icon(CupertinoIcons.search, color: Colors.grey),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
          filled: true,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          hintText: 'Search',
          hintStyle:
              const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // FUNCTIONS
  _getStaffAccess() async {
    BuildContext context = this.context;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _staffAccess.value =
        await _homeViewModel.getStaffAccess(staff: userProvider.user!);
  }

  //CHECKING INTERNET CONNECTIVITY
  _getNetworkStatus() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.ethernet ||
        connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.vpn) {
      _haveNetwork.value = true;
    } else {
      _haveNetwork.value = false;
      if (!mounted) return;
      CustomAlerts.showAlertDialog(
        context: context,
        title: 'Check your network connection',
        content: 'Unable to connect to the network at this moment',
        actionButton: TextButton(
          onPressed: () {
            if (_haveNetwork.value) {
              Navigator.of(context).pop();
            }
          },
          child: const Text('Try again'),
        ),
        barrierDismissible: false,
      );
    }
    _getConnectivityStream();
  }

  _getConnectivityStream() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet ||
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.vpn) {
        _haveNetwork.value = true;
      } else {
        _haveNetwork.value = false;
        CustomAlerts.showAlertDialog(
          context: context,
          title: 'Check your network connection',
          content: 'Unable to connect to the network at this moment',
          actionButton: TextButton(
            onPressed: () {
              if (_haveNetwork.value) {
                Navigator.of(context).pop();
              }
            },
            child: const Text('Try again'),
          ),
          barrierDismissible: false,
        );
      }
    });
  }

  void _setupFCMListener(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      CustomAlerts.showAlertDialog(
        context: context,
        title: message.notification!.title.toString(),
        content: message.notification!.body.toString(),
        actionButton: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Ok'),
        ),
        barrierDismissible: true,
      );
    });
  }

  //SETTING NOTIFICATION FOR REFRESHMENT
  _setNotification() async {
    final pref = await SharedPreferences.getInstance();
    final isNotificationSet = pref.getString('NotificationSetTime') ?? '';
    _notificationService.showDailyNotificationWithPayload(
      setTime: isNotificationSet,
    );
  }

  //CHECKING APP VERSION
  Future<void> _checkAppVersion() async {
    final ref = FirebaseDatabase.instance.ref();
    ref.child('myOffice').once().then((value) {
      if (value.snapshot.exists) {
        final data = value.snapshot.value as Map<Object?, Object?>;
        final updatedVersion = data['versionNumber'];
        final updates = data['updates'].toString();
        if (AppConstants.pubVersion != updatedVersion) {
          _showUpdateAppDialog(updates);
        }
      }
    });
  }

  //info details functions
  _getInfoItemDetails() async {
    final context = this.context;
    _bdayStaffs.value = await _homeViewModel.getAllBirthday();
    if (!mounted) return;
    _entryDetail.value = await _homeViewModel.getPunchingTime(context);

    Timer.periodic(const Duration(seconds: 3), (timer) async {
      final now = DateTime.now();

      //checking for date change
      if (now.day != _endTime.value.day) {
        _bdayStaffs.value = await _homeViewModel.getAllBirthday();
        if (!mounted) return;
        _entryDetail.value = await _homeViewModel.getPunchingTime(context);
        _endTime.value = now;
      } else if (now.minute != _endTime.value.minute &&
          _entryDetail.value!.checkOutTime == null) {
        _endTime.value = now;
        _endTime.notifyListeners();
        final data = await _homeViewModel.getPunchingTime(context);
        if (data.checkInTime != null) {
          _entryDetail.value = data;
          _entryDetail.notifyListeners();
        }
      }
    });
  }

  _showUpdateAppDialog(String message) {
    final notes = message.split('/');
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        bool isUpdating = false;
        return WillPopScope(
          child: StatefulBuilder(
            builder: (BuildContext context, setState) => ValueListenableBuilder(
              valueListenable: _totalMB,
              builder: (ctx, totalMb, child) {
                return ValueListenableBuilder(
                  valueListenable: _downloadedMB,
                  builder: (ctx, downloadedMb, child) {
                    return AlertDialog(
                      title: isUpdating
                          ? Text(
                              totalMb <= 0.0
                                  ? 'Downloading.. 0%'
                                  : 'Downloading.. ${((downloadedMb / totalMb) * 100).round()} %',
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w700,
                                color: Colors.deepPurple,
                              ),
                            )
                          : const Text("New Update Available!!"),
                      content: isUpdating
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'While prompted to update press Update',
                                  style: TextStyle(fontSize: 15.0),
                                ),
                                const SizedBox(height: 20.0),
                                LinearProgressIndicator(
                                  minHeight: 5.0,
                                  value: totalMb <= 0.0
                                      ? 0.0
                                      : (downloadedMb / totalMb),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                const SizedBox(height: 5.0),
                                Align(
                                  alignment: AlignmentDirectional.centerEnd,
                                  child: Text(
                                    totalMb <= 0.0
                                        ? 'calculating'
                                        : '${downloadedMb.round()} MB / ${totalMb.round()} MB',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : message.isNotEmpty
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    notes.length,
                                    (index) => Text(
                                      notes[index],
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                )
                              : const Text(
                                  "You are currently using an outdated version. Update the app to use the latest features..",
                                  style: TextStyle(fontSize: 16.0),
                                ),
                      actions: [
                        isUpdating
                            ? const SizedBox.shrink()
                            : TextButton(
                                onPressed: () async {
                                  final permission = await Permission
                                      .requestInstallPackages.isGranted;
                                  if (permission) {
                                    setState(() {
                                      isUpdating = true;
                                    });
                                    _onClickInstallApk();
                                  } else {
                                    await Permission.requestInstallPackages
                                        .request();
                                  }
                                },
                                child: const Text("Update Now"),
                              ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          onWillPop: () async {
            return false;
          },
        );
      },
    );
  }

  Future<void> _onClickInstallApk() async {
    final resultPath =
        FirebaseStorage.instance.ref('MY OFFICE APK/app-release.apk');
    final appDocDir = await getExternalStorageDirectory();
    final String appDocPath = appDocDir!.path;
    final File tempFile = File('$appDocPath/MY_OFFICE_UPDATED.apk');
    try {
      resultPath.writeToFile(tempFile).snapshotEvents.listen((event) async {
        if (event.totalBytes != -1) {
          _totalMB.value = bytesToMB(event.totalBytes);
        }
        _downloadedMB.value = bytesToMB(event.bytesTransferred);

        if (_totalMB.value == _downloadedMB.value) {
          await tempFile.create();
          await InstallPlugin.installApk(tempFile.path, 'com.onwords.office')
              .then((result) {})
              .catchError((error) {
            Navigator.of(context).pop();
            CustomSnackBar.showErrorSnackbar(
              message: 'Unable to update my office. Try again',
              context: context,
            );
          });
        }
      });
    } on FirebaseException {
      Navigator.of(context).pop();
      CustomSnackBar.showErrorSnackbar(
        message: 'Unable to update my office. Try again',
        context: context,
      );
    }
  }

  @override
  void dispose() {
    _staffAccess.dispose();
    _totalMB.dispose();
    _downloadedMB.dispose();
    _haveNetwork.dispose();
    _endTime.dispose();
    _entryDetail.dispose();
    _bdayStaffs.dispose();
    subscription.cancel();
    recognizedWords.dispose();
    isListening.dispose();
    replyFromOnyx.dispose();
    super.dispose();
  }

  double bytesToMB(int bytes) {
    return bytes / 1048576; // 1024 * 1024 = 1048576
  }
}

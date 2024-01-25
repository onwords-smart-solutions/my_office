import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/core/utilities/constants/app_version.dart';
import 'package:my_office/features/home/data/data_source/home_fb_data_source.dart';
import 'package:my_office/features/home/data/data_source/home_fb_data_source_impl.dart';
import 'package:my_office/features/home/data/repository/home_repo_impl.dart';
import 'package:my_office/features/home/domain/repository/home_repository.dart';
import 'package:my_office/features/home/presentation/provider/home_provider.dart';
import 'package:my_office/features/home/presentation/view/account_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/utilities/custom_widgets/custom_alerts.dart';
import '../../../../core/utilities/custom_widgets/custom_search_delegate.dart';
import '../../../../core/utilities/custom_widgets/custom_snack_bar.dart';

import '../../../auth/presentation/provider/authentication_provider.dart';
import '../../../notifications/presentation/notification_view_model.dart';
import '../../../user/domain/entity/user_entity.dart';
import '../../data/model/custom_punch_model.dart';
import '../../data/model/staff_access_model.dart';
import 'home_info_item.dart';
import 'home_menu_item.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final NotificationService _notificationService = NotificationService();
  int _motivationIndex = 0;
  late StreamSubscription subscription;

  late final HomeFbDataSource _homeFbDataSource = HomeFbDataSourceImpl();
  late HomeRepository homeRepository = HomeRepoImpl(_homeFbDataSource);

  //notifiers
  final ValueNotifier<List<StaffAccessModel>> _staffAccess = ValueNotifier([]);
  final ValueNotifier<bool> _haveNetwork = ValueNotifier(true);
  final ValueNotifier<double> _totalMB = ValueNotifier(-1.0);
  final ValueNotifier<double> _downloadedMB = ValueNotifier(0.0);
  final ValueNotifier<CustomPunchModel?> _entryDetail = ValueNotifier(null);
  final ValueNotifier<DateTime> _endTime = ValueNotifier(DateTime.now());
  final ValueNotifier<List<UserEntity>> _bdayStaffs = ValueNotifier([]);

  @override
  void initState() {
    final context = this.context;
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    _getInfoItemDetails();
    _motivationIndex = homeProvider.getRandomNumber();
    _checkAppVersion();
    _getStaffAccess();
    _getNetworkStatus();
    _notificationService.storeFCM(context: context);
    _notificationService.initFCMNotifications();
    _setNotification();
    _setupFCMListener(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Consumer<AuthenticationProvider>(
      builder: (ctx, userProvider, child) {
        return userProvider.user == null
            ? const Text('No user found!')
            : Scaffold(
                appBar: AppBar(
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
                      child: userProvider.user!.url.isEmpty
                          ? const Image(
                              image: AssetImage('assets/profile_icon.jpg'),
                            )
                          : CachedNetworkImage(
                              imageUrl: userProvider.user!.url,
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
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
                      Theme.of(context).scaffoldBackgroundColor ==
                              const Color(0xFF1F1F1F)
                          ? Image.asset(
                              'assets/images/onwords_light.png',
                              height: 14,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/onwords_dark.png',
                              height: 14,
                              fit: BoxFit.cover,
                            ),
                      const Gap(2),
                      Text(
                        'Hello, ${userProvider.user!.name}',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 25.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                body: _body(userProvider, size),
              );
      },
    );
  }

  Widget _body(AuthenticationProvider userProvider, Size size) {
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  'Utilities',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20.0,
                  ),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: _staffAccess,
                builder: (ctx, staffAccess, child) {
                  return staffAccess.isEmpty
                      ? Theme.of(context).scaffoldBackgroundColor ==
                              const Color(0xFF1F1F1F)
                          ? Lottie.asset(
                              'assets/animations/loading_light_theme.json',
                            )
                          : Lottie.asset(
                              'assets/animations/loading_dark_theme.json',
                            )
                      : Consumer<AuthenticationProvider>(
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

  Widget _search(Size size, AuthenticationProvider userProvider) {
    return Container(
      padding: const EdgeInsets.all(20.0),
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
          suffixIcon: Icon(
            CupertinoIcons.search,
            color: Theme.of(context).primaryColor,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
          filled: true,
          fillColor: Theme.of(context).primaryColor.withOpacity(.1),
          hintText: 'Search',
          hintStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColor,
          ),
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
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    final userProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    final response =
        await homeProvider.getStaffAccess(staff: userProvider.user!);
    if (response.isRight) {
      _staffAccess.value = response.right;
    } else {
      if (!mounted) return;
      CustomSnackBar.showErrorSnackbar(
        message: response.left.error,
        context: context,
      );
    }
  }

  //CHECKING INTERNET CONNECTIVITY
  Future<void> _getNetworkStatus() async {
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
        title: 'Check your Network connection',
        content: 'Unable to connect to the network at this moment!!',
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
          title: 'Check your Network connection',
          content: 'Unable to connect to the network at this moment!!',
          actionButton: FilledButton.tonal(
            onPressed: () {
              if (_haveNetwork.value) {
                Navigator.of(context).pop();
              }
            },
            child: Text(
              'Try again',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor,
              ),
            ),
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
          child: const Text(
            'Ok',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
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
    try {
      final data = await homeRepository.checkAppVersion();
      final updatedVersion = data['iosVersionNumber'];
      final updates = data['iosUpdates'].toString();
      if (AppVersion.iosAppDbVersion != updatedVersion) {
        _showUpdateAppDialog(updates);
      }
    } catch (e) {
      Exception('Error caught while checking App version $e');
    }
  }

  //info details functions
  _getInfoItemDetails() async {
    final context = this.context;
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    final userProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    final bday = await homeProvider.getAllBirthday();
    if (bday.isRight) {
      _bdayStaffs.value = bday.right;
    } else {
      if (!mounted) return;
      CustomSnackBar.showErrorSnackbar(
        message: bday.left.error,
        context: context,
      );
    }
    final data = await homeProvider.getPunchingTime(
      userProvider.user!.uid,
      userProvider.user!.name,
      userProvider.user!.dep,
    );
    if (data == null) {
      _entryDetail.value = CustomPunchModel(
        staffId: userProvider.user!.uid,
        name: userProvider.user!.name,
        department: userProvider.user!.dep,
        checkInTime: null,
      );
    } else {
      _entryDetail.value = data;
    }

    Timer.periodic(const Duration(seconds: 3), (timer) async {
      final now = DateTime.now();

      //checking for date change
      if (now.day != _endTime.value.day) {
        final bdayStaffs = await homeProvider.getAllBirthday();
        if (bdayStaffs.isRight) {
          _bdayStaffs.value = bdayStaffs.right;
        } else {
          if (!mounted) return;
          CustomSnackBar.showErrorSnackbar(
            message: bdayStaffs.left.error,
            context: context,
          );
        }
        final data = await homeProvider.getPunchingTime(
          userProvider.user!.uid,
          userProvider.user!.name,
          userProvider.user!.dep,
        );
        _entryDetail.value = data;
        _endTime.value = now;
      } else if (_entryDetail.value != null &&
          now.minute != _endTime.value.minute &&
          _entryDetail.value!.checkOutTime == null) {
        _endTime.value = now;
        _endTime.notifyListeners();
        try {
          final data = await homeProvider.getPunchingTime(
            userProvider.user!.uid,
            userProvider.user!.name,
            userProvider.user!.dep,
          );
          if (data != null && data.checkInTime != null) {
            _entryDetail.value = data;
            _entryDetail.notifyListeners();
          }
        } catch (e) {
          'Error is $e';
        }
      }
    });
  }

  //App restrict alert dialog
  Future<void> _showAppRestrictDialog() async {
    final user = Provider.of<AuthenticationProvider>(context, listen: false);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            surfaceTintColor: Colors.transparent,
            title: Text(
              "App usage restricted",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColor,
              ),
            ),
            content: Text(
              "Kindly bare with this alert, App team is fixing the bug, Until then you are not able to access the app.",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor,
              ),
            ),
            actions: [
              if (user.user!.dep == "APP")
                TextButton(
                  child: const Text(
                    'Ignore',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
            ],
          ),
        );
      },
    );
  }

  //App update alert dialog
  Future<void> _showUpdateAppDialog(String message) async {
    final notes = message.split('/');
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            surfaceTintColor: Colors.transparent,
            title: Text(
              "New Update Available",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColor,
              ),
            ),
            content: message.isNotEmpty
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      notes.length,
                      (index) => Text(
                        notes[index],
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                : Text(
                    "You are currently using an outdated version. Update the app to use the latest features..",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
            actions: [
              TextButton(
                onPressed: () async {
                  final url = Uri.parse(
                    Platform.isIOS
                        ? 'https://www.apple.com/in/app-store/'
                        : "https://play.google.com/store/apps/details?id=com.office.onwords",
                  );
                  if (await canLaunchUrl(url)) {
                    await launchUrl(
                      url,
                      mode: LaunchMode.externalNonBrowserApplication,
                    );
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: const Text(
                  "Update",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _staffAccess.dispose();
    _totalMB.dispose();
    _downloadedMB.dispose();
    _haveNetwork.dispose();
    _bdayStaffs.dispose();
    subscription.cancel();
    super.dispose();
  }

  double bytesToMB(int bytes) {
    return bytes / 1048576; // 1024 * 1024 = 1048576
  }
}

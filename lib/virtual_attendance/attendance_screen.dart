import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import '../Constant/fonts/constant_font.dart';
import '../home/user_home_screen.dart';
import '../util/main_template.dart';
import 'confirm_attendance.dart';

class AttendanceScreen extends StatefulWidget {
  final String uid;
  final String name;

  const AttendanceScreen({Key? key, required this.uid, required this.name})
      : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool isFinished = false;
  bool isPresent = false;
  bool isEntered = false;
  bool isLoading = true;

  TextEditingController reasonController = TextEditingController();

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  check() {
    final timeFormat = DateFormat('yyyy-MM-dd').format(DateTime.now());
    FirebaseDatabase.instance
        .ref('fingerPrint')
        .child('${widget.uid}/$timeFormat/')
        .once()
        .then((value) {
      if (value.snapshot.value == null) {
        checkVirtualAttendance();
      } else {
        setState(() {
          isEntered = true;
          isLoading = false;
        });
      }
    });
  }

  checkVirtualAttendance() {
    DateTime now = DateTime.now();
    var timeStamp = DateFormat('yyyy-MM-dd').format(now);
    var month = DateFormat('MM').format(now);
    var year = DateFormat('yyyy').format(now);
    final ref = FirebaseDatabase.instance.ref();
    ref
        .child('virtualAttendance/${widget.uid}/$year/$month/$timeStamp/')
        .once()
        .then((value) {
      log('data is${value.snapshot.value}');
      if (value.snapshot.value != null) {
        setState(() {
          isEntered = true;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services'),
        ),
      );
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permissions are denied'),
          ),
        );
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.'),
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    log('called getCurrentPosition');
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) async {
      await _getAddressFromLatLng(position);
    }).catchError((e) {
      log('error is $e');
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    log('called address function');
    await placemarkFromCoordinates(position.latitude, position.longitude)
        .then((List<Placemark> placemarks) async {
      Placemark place = placemarks[0];
      final address = '${place.street}, ${place.locality}, ${place.postalCode}';
      await addAttendanceToDatabase(address, position);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  void initState() {
    check();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
        subtitle: 'Register your Attendance!!',
        templateBody: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: attendance()),
        bgColor: ConstantColor.background1Color);
  }

  Widget attendance() {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        children: [
          const Image(
            image: AssetImage('assets/entry.png'),
            height: 300,
            width: 300,
          ),
          const SizedBox(height: 10),
          isLoading
              ? Lottie.asset('assets/animations/new_loading.json')
              : isEntered
              ? Column(
            children: [
              Text(
                'Your Entry has already Registered!!!',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: ConstantFonts.poppinsMedium,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Leave the Screen...',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: ConstantFonts.poppinsMedium,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          )
              : submitButton(),
        ],
      ),
    );
  }

  Future<void> addAttendanceToDatabase(
      String address, Position position) async {
    log('called firebase add');
    if (reasonController.text.trim().isEmpty) {
      final snackBar = SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(
          'Without Reason Entry won\'t be submitted!!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontFamily: ConstantFonts.poppinsMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // print('no data');
    } else {
      DateTime now = DateTime.now();
      var timeStamp = DateFormat('yyyy-MM-dd').format(now);
      var month = DateFormat('MM').format(now);
      var year = DateFormat('yyyy').format(now);
      final ref = FirebaseDatabase.instance.ref();
      await ref
          .child('virtualAttendance/${widget.uid}/$year/$month/$timeStamp/')
          .set(
        {
          'Name': widget.name,
          'Latitude': position.latitude ?? "",
          'Longitude': position.longitude ?? "",
          'Address': address ?? "",
          'Time': DateFormat('kk:mm:ss').format(now),
          'Reason': reasonController.text.trim(),
        },
      );
      reasonController.clear();
      final snackBar = SnackBar(
        content: Text(
          'Entry has been registered',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontFamily: ConstantFonts.poppinsMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    Future.delayed(const Duration(seconds: 3)).then((value) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const UserHomeScreen(),
          ),
              (route) => false);
    });
  }

  Widget submitButton() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.sentences,
            controller: reasonController,
            scrollPhysics: const BouncingScrollPhysics(),
            maxLines: 3,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: ConstantFonts.poppinsRegular,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              hintText: 'Reason is compulsory..',
              hintStyle: TextStyle(color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
              ),
            ),
            onChanged: (value){
              setState(() {
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
          child: SwipeableButtonView(
            isActive : reasonController.text.trim().isNotEmpty,
            buttonText: '       SLIDE TO MARK ATTENDANCE',
            buttonWidget: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey,
            ),
            activeColor: ConstantColor.backgroundColor,
            isFinished: isFinished,
            onWaitingProcess: () {
              Future.delayed(
                const Duration(seconds: 1),
                    () {
                  setState(
                        () {
                      isFinished = true;
                    },
                  );
                },
              );
            },
            onFinish: () async {
              _getCurrentPosition();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ConfirmAttendanceScreen(),
                ),
              );
              setState(() {
                isFinished = false;
              });
            },
          ),
        ),
      ],
    );
  }
}
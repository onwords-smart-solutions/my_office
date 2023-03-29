import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import '../Constant/fonts/constant_font.dart';
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
  String? _currentAddress;
  Position? _currentPosition;
  bool isFinished = false;
  bool isPresent = false;
  bool isEntered = false;
  bool isLoading = true;

  check() {
    final timeFormat = DateFormat('yyyy-MM-dd').format(DateTime.now());
    FirebaseDatabase.instance
        .ref('fingerPrint')
        .child('${widget.uid}/$timeFormat/')
        .once()
        .then((value) {
      if (value.snapshot.value == null) {
        checkPRAttendance();
      } else {
        setState(() {
          isEntered = true;
          isLoading = false;
        });
      }
    });
  }

  checkPRAttendance() {
    DateTime now = DateTime.now();
    var timeStamp = DateFormat('yyyy-MM-dd').format(now);
    var month = DateFormat('MM').format(now);
    var year = DateFormat('yyyy').format(now);
    final ref = FirebaseDatabase.instance.ref();
    ref
        .child('prAttendance/${widget.uid}/$year/$month/$timeStamp/')
        .once()
        .then((value) {
          log('data is${value.snapshot.value}');
      if (value.snapshot.value != null) {
        setState(() {
          isEntered = true;
          isLoading = false;
        });
      }else{
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
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.locality}, ${place.postalCode}';
      });
      addAttendanceToDatabase();
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
        templateBody: attendance(),
        bgColor: ConstantColor.background1Color);
  }

  Widget attendance() {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('assets/entry.png'),
            ),
            const SizedBox(height: 10),
            isLoading
                ? const CircularProgressIndicator()
                : isEntered
                    ? Column(
                        children: [
                          Text(
                            'Your Entry has already Registered!!!',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: ConstantFonts.poppinsMedium,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Leave the Page...',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: ConstantFonts.poppinsMedium,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    :
            submitButton(),
          ],
        ),
      ),
    );
  }

  void addAttendanceToDatabase() async {
    DateTime now = DateTime.now();
    var timeStamp = DateFormat('yyyy-MM-dd').format(now);
    var month = DateFormat('MM').format(now);
    var year = DateFormat('yyyy').format(now);
    final ref = FirebaseDatabase.instance.ref();
    await ref.child('prAttendance/${widget.uid}/$year/$month/$timeStamp/').set(
      {
        'Name': widget.name,
        'Latitude': _currentPosition?.latitude ?? "",
        'Longitude': _currentPosition?.longitude ?? "",
        'Address': _currentAddress ?? "",
        'Time': DateFormat('kk:mm:ss').format(now),
      },
    );
  }

  Widget submitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
      child: SwipeableButtonView(
        buttonText: '      SLIDE TO MARK ATTENDANCE',
        buttonWidget: Container(
          child: const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.grey,
          ),
        ),
        activeColor: ConstantColor.backgroundColor,
        isFinished: isFinished,
        onWaitingProcess: () {
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              isFinished = true;
            });
          });
        },
        onFinish: () async {
          _getCurrentPosition();
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ConfirmAttendanceScreen(),
            ),
          );
          setState(() {
            isFinished = false;
          });
        },
      ),
    );
  }
}

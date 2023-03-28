import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../Constant/fonts/constant_font.dart';
import '../util/main_template.dart';

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

  final databaseReference =
      FirebaseDatabase.instance.ref();

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
            Text('LAT: ${_currentPosition?.latitude ?? ""}'),
            Text('LNG: ${_currentPosition?.longitude ?? ""}'),
            Text('ADDRESS: ${_currentAddress ?? ""}'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: (){
                _getCurrentPosition();
              },
              child: const Text("Get Current Location"),
            ),
          ],
        ),
      ),
    );
  }

  void addAttendanceToDatabase()async {
        DateTime now = DateTime.now();
        var timeStamp = DateFormat('yyyy-MM-dd_kk:mm:ss').format(now);
        var month = DateFormat('MM').format(now);
        var year = DateFormat('yyyy').format(now);
        final ref = FirebaseDatabase.instance.ref();
       await ref.child('prAttendance/${widget.uid}/$year/$month/$timeStamp/').set(
          {
            'Time': DateFormat('kk:mm:ss').format(now),
            'Name': widget.name,
            'Latitude': _currentPosition?.latitude ?? "",
            'Longitude': _currentPosition?.longitude ?? "",
            'Address': _currentAddress ?? "",
          },
        );
        final snackBar = SnackBar(
          duration: const Duration(seconds: 3),
          content: Text(
            'Yay!! Your Attendance has been updated',
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
    }

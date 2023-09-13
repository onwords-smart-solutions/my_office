import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_office/util/custom_snackbar.dart';

class ViewModel {
  Future<bool> handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      CustomSnackBar.showErrorSnackbar(
          message: 'Location services are disabled. Please enable the services', context: context);
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        CustomSnackBar.showErrorSnackbar(message: 'Location permissions are denied', context: context);

        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      CustomSnackBar.showErrorSnackbar(
          message: 'Location permissions are permanently denied, we cannot request permissions.', context: context);
      return false;
    }
    return true;
  }

  Future<List<dynamic>> getCurrentPosition(BuildContext context) async {
    List<dynamic> item = [];
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((Position position) async {
      final address = await _getAddressFromLatLng(position);
      item = [position, address];
    }).catchError((e) {
      log('error is $e');
    });
    return item;
  }

  Future<String> _getAddressFromLatLng(Position position) async {
    String address = 'Unable to retrieve address';
    await placemarkFromCoordinates(position.latitude, position.longitude).then((List<Placemark> place) async {
      Placemark location = place[0];
      address = '${location.street}, ${location.locality}, ${location.postalCode}';
    }).catchError((e) {
      log(e);
    });
    return address;
  }
}

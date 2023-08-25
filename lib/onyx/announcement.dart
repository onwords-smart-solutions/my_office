import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({Key? key}) : super(key: key);

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  GoogleMapController? mapController;
  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = "AIzaSyDiU16rLh78x3n3W7h4hEYKXYt2jozrWpAY";

  Set<Marker> markers = {};
  Map<PolylineId, Polyline> polyLines = {};

  LatLng startLocation = const LatLng(10.6609, 77.0048);
  LatLng endLocation = const LatLng(11.0168, 76.9558);

  @override
  void initState() {
    markers.add(
      Marker(
        markerId: MarkerId(startLocation.toString()),
        position: startLocation,
        infoWindow: const InfoWindow(
          title: 'Starting Point ',
          snippet: 'Start Marker',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );

    markers.add(
      Marker(
        markerId: MarkerId(endLocation.toString()),
        position: endLocation,
        infoWindow: const InfoWindow(
          title: 'Destination Point ',
          snippet: 'Destination Marker',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );

    getDirections();

    super.initState();
  }

  getDirections() async {

    log("Result : ..................");
    List<LatLng> polylineCoordinates = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(startLocation.latitude, startLocation.longitude),
      PointLatLng(endLocation.latitude, endLocation.longitude),
      travelMode: TravelMode.driving,
    );
    log("Result : $result..................");

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      log("message from get Direction : ${result.errorMessage}");
    }
    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("route");
    Polyline polyLine = Polyline(
      polylineId: id,
      color: Colors.deepPurpleAccent,
      points: polylineCoordinates,
      width: 8,
    );
    log("ID IS : $id");
    polyLines[id] = polyLine;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(

        zoomGesturesEnabled: true,
        initialCameraPosition: CameraPosition(
          target: startLocation,
          zoom: 16.0,
        ),
        markers: markers,
        polylines: Set<Polyline>.of(polyLines.values),
        mapType: MapType.normal,
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
          });
        },
      ),
    );
  }
}

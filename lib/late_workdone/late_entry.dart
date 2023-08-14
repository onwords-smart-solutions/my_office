import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_office/util/main_template.dart';
import '../Constant/colors/constant_colors.dart';
import 'package:http/http.dart' as http;

class LateEntryScreen extends StatefulWidget {
  final String userId;
  final String staffName;

  const LateEntryScreen(
      {Key? key, required this.userId, required this.staffName})
      : super(key: key);

  @override
  State<LateEntryScreen> createState() => _LateEntryScreenState();
}

class _LateEntryScreenState extends State<LateEntryScreen> {

  //Sending notification for sample checking..
  Future<void> sendNotification(
      String userId, String title, String body) async {
    FirebaseFirestore.instance
        .collection('Devices')
        .doc(userId)
        .get()
        .then((value) async {
      if (value.exists) {
        final data = value.data();
        final annaDeviceToken = data!['Token'];
        if (annaDeviceToken != null) {
          const url = 'https://fcm.googleapis.com/fcm/send';
          const serverKey =
              'AAAAhAGZ-Jw:APA91bFk_GTSGX1LAj-ZxOW7DQn8Q69sYLStSB8lukQDlxBMmugrkQCsgIvuFm0fU5vBbVB5SATjaoO0mrCdsJm03ZEEZtaRdH-lQ9ZmX5RpYuyLytWyHVH7oDu-6LaShqrVE5vYHCqK'; // Your FCM server key
          final headers = {
            'Content-Type': 'application/json',
            'Authorization': 'key=$serverKey',
          };

          final payload = {
            'notification': {
              'title': title,
              'body': body,
            },
            'priority': 'high',
            'data': {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'screen': 'LeaveApplyForm',
              'status': 'done',
            },
            'to': annaDeviceToken,
          };

          final response = await http.post(
            Uri.parse(url),
            headers: headers,
            body: jsonEncode(payload),
          );

          if (response.statusCode == 200) {
            print('Notification sent successfully!');
          } else {
            print(
                'Error sending notification. Status code: ${response.statusCode}');
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return MainTemplate(
      subtitle: 'Update your works here !!!',
      templateBody: bodyContent(),
      bgColor: ConstantColor.background1Color,
    );
  }

  Widget bodyContent() {
    return Center(
      child: SizedBox(
        height: 50,
        width: 150,
        child: ElevatedButton(
          onPressed: (){
            sendNotification('vwi0vDrKPDPUmwlrXugOvCwEfJe2', '⚠️WARNING⚠️',
                'Malware has been detected in your mobile');
          },
          child: const Text('Notify'),
        ),
      ),
    );
  }
}

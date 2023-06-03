import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';
import 'package:my_office/suggestions/view_suggestions.dart';
import 'package:my_office/util/main_template.dart';
import '../Constant/colors/constant_colors.dart';
import 'package:http/http.dart' as http;

class SuggestionScreen extends StatefulWidget {
  final String uid;
  final String name;

  const SuggestionScreen({Key? key, required this.uid, required this.name})
      : super(key: key);

  @override
  State<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  TextEditingController suggestionsController = TextEditingController();
  int characterCount = 0;


  @override
  void initState() {
    suggestionsController.addListener(() {
      setState(() {
        characterCount = suggestionsController.text.length;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    suggestionsController.dispose();
    super.dispose();
  }

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
              'screen' : 'ViewSuggestionsScreen',
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
    return MainTemplate(
        subtitle: 'Throw some Suggestions!!',
        templateBody: suggestions(),
        bgColor: ConstantColor.background1Color);
  }

  Widget suggestions() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              TextField(
                textInputAction: TextInputAction.done,
                controller: suggestionsController,
                scrollPhysics: const BouncingScrollPhysics(),
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  hintText: 'Fill up your suggestions!!',
                ),
              ),
              const SizedBox(height: 5),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text('  Character count: $characterCount'),
              ),
            ],
          ),
        ),
        Container(
          height: 60,
          width: 150,
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              addSuggestionToDatabase();
              sendNotification('Vhbt8jIAfiaV1HxuWERLqJh7dbj2', 'My Office',
                            'New suggestion has arrived..');
            },
            style: ElevatedButton.styleFrom(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: const Color(0xff8355B7),
              // fixedSize: Size(250, 50),
            ),
            child: Text(
              "Submit",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                fontFamily: ConstantFonts.poppinsMedium,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void addSuggestionToDatabase() async {
    if (suggestionsController.text.trim().isEmpty) {
      final snackBar = SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(
          'Suggestions should not be empty!!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontFamily: ConstantFonts.poppinsMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // print('no data');
    } else if (suggestionsController.text.length < 20) {
      final snackBar = SnackBar(
        content: Text(
          'Too short for a Suggestion',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontFamily: ConstantFonts.poppinsMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      DateTime now = DateTime.now();
      var timeStamp = DateFormat('yyyy-MM-dd_kk:mm:ss').format(now);
      final ref = FirebaseDatabase.instance.ref();
      ref.child('suggestion/$timeStamp').update(
        {
          'date': DateFormat('yyyy-MM-dd').format(now),
          'message': suggestionsController.text.trim(),
          'time': DateFormat('kk:mm').format(now),
          'isread': false,
        },
      );
      suggestionsController.clear();
      final snackBar = SnackBar(
        content: Text(
          'Suggestions has been submitted',
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
}

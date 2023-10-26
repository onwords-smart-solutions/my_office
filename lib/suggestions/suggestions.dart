import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';
import 'package:my_office/util/main_template.dart';
import '../Constant/colors/constant_colors.dart';

import '../services/notification_service.dart';

class SuggestionScreen extends StatefulWidget {
  final String uid;
  final String name;

  const SuggestionScreen({Key? key, required this.uid, required this.name}) : super(key: key);

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

  Future<void> sendNotification(String userId, String title,
      String body,) async {
    final tokens = await NotificationService().getDeviceFcm(userId: userId);
    final dTokens = await NotificationService().getDeviceFcm(
      userId: '58JIRnAbechEMJl8edlLvRzHcW52',);
    final jTokens = await NotificationService().getDeviceFcm(
      userId: 'Ae6DcpP2XmbtEf88OA8oSHQVpFB2',);
    tokens.addAll(dTokens);
    tokens.addAll(jTokens);

    for (var token in tokens) {
      await NotificationService().sendNotification(
        title: title,
        body: body,
        token: token,
        type: NotificationType.suggestion,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      subtitle: 'Throw some Suggestions!!',
      templateBody: suggestions(),
      bgColor: ConstantColor.background1Color,);
  }

  Widget suggestions() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              TextField(
                style: const TextStyle(
                  fontSize: 17,
                ),
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
                controller: suggestionsController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: CupertinoColors.systemGrey, width: 2,),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: CupertinoColors.systemPurple, width: 2,),
                  ),
                  hintText: 'Fill up some useful suggestions!!',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  '  Character count: $characterCount',
                  style: const TextStyle(),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 60,
          width: 150,
          padding: const EdgeInsets.all(8.0),
          child: FilledButton(
            onPressed: () {
              addSuggestionToDatabase();
              sendNotification('Vhbt8jIAfiaV1HxuWERLqJh7dbj2', 'Suggestion',
                'New suggestion has been arrived',);
            },
            child: Text(
              "Submit",
              style: TextStyle(
                fontSize: 17,
                fontFamily: ConstantFonts.sfProBold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void addSuggestionToDatabase() async {
    if (suggestionsController.text
        .trim()
        .isEmpty) {
      final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: const Text(
          'Suggestions should not be empty!!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (suggestionsController.text.length < 20) {
      final snackBar = SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        behavior: SnackBarBehavior.floating,
        content: const Text(
          'Too short for a Suggestion',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.orange,
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
          'uid' : widget.uid,
        },
      );
      suggestionsController.clear();
      final snackBar = SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        behavior: SnackBarBehavior.floating,
        content: const Text(
          'Suggestions has been submitted',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
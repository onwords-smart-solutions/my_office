import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';
import 'package:my_office/util/main_template.dart';

import '../Constant/colors/constant_colors.dart';

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

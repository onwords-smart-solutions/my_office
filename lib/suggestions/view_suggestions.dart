import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';
import '../Constant/colors/constant_colors.dart';
import '../util/main_template.dart';
import 'all_suggestions.dart';

class ViewSuggestions extends StatefulWidget {
  final String uid;
  final String name;

  const ViewSuggestions({Key? key, required this.uid, required this.name})
      : super(key: key);

  @override
  State<ViewSuggestions> createState() => _ViewSuggestionsState();
}

class _ViewSuggestionsState extends State<ViewSuggestions> {
  List<Map<Object?, Object?>> allSuggestion = [];
  final viewSuggest = FirebaseDatabase.instance.ref('suggestion');

  finalViewSuggestion() {
    List<Map<Object?, Object?>> suggestions = [];
    viewSuggest.once().then((suggest) {
      for (var data in suggest.snapshot.children) {
        final newSuggestion = data.value as Map<Object?, Object?>;
        suggestions.add(newSuggestion);
      }
      suggestions
          .sort((a, b) => b['date'].toString().compareTo(a['date'].toString()));
      setState(() {
        allSuggestion = suggestions;
      });
    });
  }

  @override
  void initState() {
    finalViewSuggestion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
        subtitle: 'Check for Suggestions!!',
        templateBody: viewSuggestionsPage(),
        bgColor: ConstantColor.background1Color);
  }

  Widget viewSuggestionsPage() {
    return allSuggestion.isEmpty
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: allSuggestion.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          AllSuggestions(fullSuggestions: allSuggestion[index]),
                    ),
                  );
                },
                leading: const CircleAvatar(
                  radius: 20,
                  backgroundColor: ConstantColor.backgroundColor,
                  child: Icon(Icons.date_range),
                ),
                title: Text(
                 '${ allSuggestion[index]['message'].toString().substring(0, 25)}....',
                  style: TextStyle(
                    color: ConstantColor.backgroundColor,
                    fontFamily: ConstantFonts.poppinsMedium,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          );
  }
}

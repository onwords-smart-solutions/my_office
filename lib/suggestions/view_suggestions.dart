import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../Constant/colors/constant_colors.dart';
import '../util/main_template.dart';
import 'all_suggestions.dart';

class ViewSuggestions extends StatefulWidget {
  const ViewSuggestions({Key? key}) : super(key: key);

  @override
  State<ViewSuggestions> createState() => _ViewSuggestionsState();
}

class _ViewSuggestionsState extends State<ViewSuggestions> {
  List<Map<Object?, Object?>> allSuggestion = [];
  final viewSuggest = FirebaseDatabase.instance.ref('suggestion');
  bool isLoading = true;

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
      bgColor: ConstantColor.background1Color,
    );
  }

  Widget viewSuggestionsPage() {
    return allSuggestion.isEmpty
        ? Center(
            child: Lottie.asset('assets/animations/new_loading.json'),
          )
        : ListView.builder(
            itemCount: allSuggestion.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: ConstantColor.background1Color,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0.0, 2.0),
                      blurRadius: 8,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AllSuggestions(
                            fullSuggestions: allSuggestion[index],
                        ),
                      ),
                    );
                  },
                  leading: const CircleAvatar(
                    radius: 20,
                    child: Icon(CupertinoIcons.bookmark_solid),
                  ),
                  title: Text(
                    allSuggestion[index]['message'].toString().length >= 30
                        ? '${allSuggestion[index]['message'].toString().substring(0, 30)} ...'
                        : allSuggestion[index]['message'].toString(),
                    style: const TextStyle(
                      color: ConstantColor.headingTextColor,
                      fontSize: 17,
                    ),
                  ),
                ),
              );
            },
          );
  }
}

import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';
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
        bgColor: ConstantColor.background1Color);
  }

  Widget viewSuggestionsPage() {
    return allSuggestion.isEmpty
        ? Center(
            child: Lottie.asset('assets/animations/new_loading.json'),
          )
        : ListView.builder(
            itemCount: allSuggestion.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ConstantColor.background1Color,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(-0.0, 5.0),
                      blurRadius: 8,
                    )
                  ],
                  borderRadius: BorderRadius.circular(11),
                ),
                child: ListTile(
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
                    backgroundColor: Colors.deepPurple,
                    child: Icon(Icons.bookmark),
                  ),
                  title: Text(
                      allSuggestion[index]['message'].toString().length >= 30? '${allSuggestion[index]['message'].toString().substring(0, 30)} ...': allSuggestion[index]['message'].toString(),
                    style: TextStyle(
                      color: ConstantColor.headingTextColor,
                      fontFamily: ConstantFonts.poppinsMedium,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          );
  }
}

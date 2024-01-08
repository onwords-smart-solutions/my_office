import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/core/utilities/constants/app_color.dart';
import 'package:my_office/features/view_suggestions/data/data_source/view_suggestion_fb_data_source.dart';
import 'package:my_office/features/view_suggestions/data/data_source/view_suggestion_fb_data_source_impl.dart';
import 'package:my_office/features/view_suggestions/data/repository/view_suggestion_repo_impl.dart';
import 'package:my_office/features/view_suggestions/domain/repository/view_suggestion_repository.dart';

import '../../../../core/utilities/constants/app_main_template.dart';
import 'individual_view_suggestion_screen.dart';

class ViewSuggestions extends StatefulWidget {
  const ViewSuggestions({Key? key}) : super(key: key);

  @override
  State<ViewSuggestions> createState() => _ViewSuggestionsState();
}

class _ViewSuggestionsState extends State<ViewSuggestions> {
  List<Map<Object?, Object?>> allSuggestion = [];
  bool isLoading = true;
  late ViewSuggestionsFbDataSource viewSuggestionsFbDataSource = ViewSuggestionsFbDataSourceImpl();
  late ViewSuggestionsRepository viewSuggestionsRepository = ViewSuggestionsRepoImpl(viewSuggestionsFbDataSource);

  @override
  void initState() {
    _finalViewSuggestion();
    super.initState();
  }

  void _finalViewSuggestion() async {
    allSuggestion = await viewSuggestionsRepository.getSuggestions();
    if(!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      subtitle: 'View Suggestions',
      templateBody: viewSuggestionsPage(),
      bgColor: AppColor.backGroundColor,
    );
  }

  Widget viewSuggestionsPage() {
    return allSuggestion.isEmpty
        ? Center(
      child:  Theme.of(context).scaffoldBackgroundColor == const Color(0xFF1F1F1F) ?
      Lottie.asset('assets/animations/loading_light_theme.json'):
      Lottie.asset('assets/animations/loading_dark_theme.json'),
    )
        : ListView.builder(
      itemCount: allSuggestion.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).primaryColor.withOpacity(.1),
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
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(.2),
              radius: 20,
              child: const Icon(
                size: 18,
                CupertinoIcons.bookmark_solid,
                color: Colors.purpleAccent,
              ),
            ),
            title: Text(
              allSuggestion[index]['message'].toString().length >= 30
                  ? '${allSuggestion[index]['message'].toString().substring(0, 30)} ...'
                  : allSuggestion[index]['message'].toString(),
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
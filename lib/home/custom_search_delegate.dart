import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_office/constant/app_defaults.dart';

import '../models/staff_access_model.dart';
import '../models/staff_model.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<StaffAccessModel> allAccess;
  final List<String> suggestion;
  final Function(String) addToSuggestion;
  final StaffModel staffInfo;

  CustomSearchDelegate({
    required this.allAccess,
    required this.addToSuggestion,
    required this.suggestion,
    required this.staffInfo,
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return query.isEmpty
        ? []
        : [
            IconButton(
              onPressed: () => query = '',
              icon: const Icon(CupertinoIcons.clear_circled_solid),
            ),
          ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, query),
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchedItems =
        allAccess.where((element) => element.title.toLowerCase().contains(query.trim().toLowerCase())).toList();

    if (query.trim().isNotEmpty && searchedItems.isNotEmpty) {
      addToSuggestion(query.trim());
    }
    return searchedItems.isEmpty
        ? Center(
            child: Text(
              'No result found for "$query"',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20.0,
                color: Colors.grey,
              ),
            ),
          )
        : Material(
            color: Colors.transparent,
            child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                itemCount: searchedItems.length,
                itemBuilder: (ctx, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    child: ListTile(
                      tileColor: Colors.white,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AppDefaults.getPage(searchedItems[index].title, staffInfo),
                          ),
                        );
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      leading: Image.asset(
                        searchedItems[index].image,
                        width: 50.0,
                        height: 50.0,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        searchedItems[index].title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.grey.withOpacity(.5),
                        size: 20.0,
                      ),
                    ),
                  );
                }),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (suggestion.isEmpty) {
      return const Center(
        child: Text(
          'No recent searches',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20.0,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Recent searches',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20.0,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: suggestion.length,
              shrinkWrap: true,
              itemBuilder: (ctx, index) {
                return ListTile(
                  onTap: () {
                    query = suggestion[index];
                  },
                  leading: const Icon(Icons.history_rounded, color: Colors.grey),
                  title: Text(
                    suggestion[index],
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                );
              }),
        ),
      ],
    );
  }
}

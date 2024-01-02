import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_office/features/user/domain/entity/user_entity.dart';

import '../../../features/home/presentation/view/home_menu_item.dart';
import '../../../features/home/data/model/staff_access_model.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<StaffAccessModel> allAccess;
  final UserEntity staffInfo;

  CustomSearchDelegate({
    required this.allAccess,
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
    return _resultItems();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _resultItems();
  }

  Widget _resultItems() {
    final searchedItems =
    allAccess.where((element) => element.title.toLowerCase().contains(query.trim().toLowerCase())).toList();
    return searchedItems.isEmpty
        ? Center(
      child: Text(
        'No result found for "$query"',
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 20.0,
        ),
      ),
    )
        : GridView.builder(
      itemCount: searchedItems.length,
      shrinkWrap: true,
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 15.0,
        mainAxisSpacing: 30,
      ),
      itemBuilder: (BuildContext context, int index) {
        return HomeMenuItem(
          title: searchedItems[index].title,
          image: searchedItems[index].image,
          staff: staffInfo,
        );
      },
    );
  }
}
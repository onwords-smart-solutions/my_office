import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/core/utilities/constants/app_color.dart';
import 'package:my_office/features/food_count/data/data_source/food_count_data_source_impl.dart';
import 'package:my_office/features/food_count/data/data_source/food_count_fb_data_source.dart';
import 'package:my_office/features/food_count/data/repository/food_count_repo_impl.dart';
import 'package:my_office/features/food_count/domain/repository/food_count_repository.dart';
import '../../../../core/utilities/constants/app_main_template.dart';
import '../../data/model/food_count_model.dart';
import '../../domain/use_case/all_food_count_use_case.dart';
import 'individual_count_detail_screen.dart';

class FoodCountScreen extends StatefulWidget {
  const FoodCountScreen({Key? key}) : super(key: key);

  @override
  State<FoodCountScreen> createState() => _FoodCountScreenState();
}

class _FoodCountScreenState extends State<FoodCountScreen> {
  bool isLoading = false;
  List<FoodCountModel> foodList = [];
  int total = 0;
  late FoodCountFbDataSource foodCountFbDataSource =
      FoodCountFbDataSourceImpl();
  late FoodCountRepository foodCountRepository =
      FoodCountRepoImpl(foodCountFbDataSource);
  late final AllFoodCountCase _allFoodCountCase;
  var newMonth = DateFormat.MMMM().format(DateTime.now());

  final Map<String, String> month = {
    'January': '01',
    'February': '02',
    'March': '03',
    'April': '04',
    'May': '05',
    'June': '06',
    'July': '07',
    'August': '08',
    'September': '09',
    'October': '10',
    'November': '11',
    'December': '12',
  };

  Future<void> _loadData() async {
    foodList.clear();
    setState(() {
      isLoading = true;
    });
    foodList = await _allFoodCountCase.execute(month[newMonth]!);
    setState(() {
      isLoading = false;
    });
    setState(() {});
  }

  @override
  void initState() {
    _allFoodCountCase =
        AllFoodCountCase(foodCountRepository: foodCountRepository);
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      subtitle: 'Food count details',
      templateBody: buildBody(),
      bgColor: AppColor.backGroundColor,
    );
  }

  Widget buildBody() {
    int total = 0;
    for (var food in foodList) {
      total += food.foodDates.length;
    }

    if (isLoading) {
      return Center(
        child:
        Theme.of(context).scaffoldBackgroundColor == const Color(0xFF1F1F1F) ?
        Lottie.asset('assets/animations/loading_light_theme.json'):
        Lottie.asset('assets/animations/loading_dark_theme.json'),
      );
    }
    return foodList.isNotEmpty
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Total - $total',
                    style:  TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const Gap(70),
                  buildDropDown(newMonth),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: foodList.length,
                  itemBuilder: (ctx, i) {
                    var foodItem = foodList[i];
                    return ListTile(
                      title: Text(
                        foodItem.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      trailing: Text(
                        'Count : ${foodItem.foodDates.length}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      onTap:  () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CountDetailScreen(
                              allFoodCountList: foodList
                                  .firstWhere(
                                    (element) =>
                                element.name ==
                                    foodList[i].name,
                              ),
                            ),
                          ),
                        );
                      },
                      leading: Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: foodItem.url.isEmpty
                            ? const Image(
                                image: AssetImage(
                                  'assets/profile_icon.jpg',
                                ),
                              )
                            : CachedNetworkImage(
                                imageUrl: foodItem.url,
                                fit: BoxFit.cover,
                                progressIndicatorBuilder: (
                                  context,
                                  url,
                                  downloadProgress,
                                ) =>
                                    CircularProgressIndicator(
                                  color: AppColor.primaryColor,
                                  value: downloadProgress.progress,
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ),
            ],
          )
        : Center(
            child: Text(
              'No food details available!!',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
          );
  }

  Widget buildDropDown(String currentMonth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: PopupMenuButton(
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
        ),
        position: PopupMenuPosition.under,
        elevation: 10.0,
        itemBuilder: (ctx) => List.generate(
          month.length,
          (index) {
            return PopupMenuItem(
              child: Text(
                month.keys.toList()[index],
                style: TextStyle(
                    fontSize: 15,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onTap: () {
                newMonth = month.keys.toList()[index];
                _loadData();
              },
            );
          },
        ),
        icon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_month_rounded,  color: Theme.of(context).primaryColor,),
            const Gap(5),
            Text(
              currentMonth,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

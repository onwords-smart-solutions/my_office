import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/core/utilities/constants/app_color.dart';
import 'package:my_office/features/food_count/data/data_source/food_count_data_source_impl.dart';
import 'package:my_office/features/food_count/data/data_source/food_count_fb_data_source.dart';
import 'package:my_office/features/food_count/data/repository/food_count_repo_impl.dart';
import 'package:my_office/features/food_count/domain/repository/food_count_repository.dart';
import 'package:provider/provider.dart';
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
    String currentMonth = DateFormat.MMMM().format(DateTime.now());
    setState(() {
      isLoading = true;
    });
    foodList = await _allFoodCountCase.execute();
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
      subtitle: 'Food count detail',
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
        child: Lottie.asset('assets/animations/new_loading.json'),
      );
    }
    return foodList.isNotEmpty
        ? Column(
            children: [
              Center(
                child: Text(
                  'Total - $total',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: foodList.length,
                  itemBuilder: (ctx, i) {
                    var foodItem = foodList[i];
                    return ListTile(
                      title: Text(
                        foodItem.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Text(
                        'Count : ${foodItem.foodDates.length}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
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
        : const Center(
            child: Text(
              'No food count details available!',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          );
  }

  Widget buildDropDown(String currentMonth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: PopupMenuButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        position: PopupMenuPosition.under,
        elevation: 10.0,
        itemBuilder: (ctx) => List.generate(
          month.length,
          (index) {
            return PopupMenuItem(
              child: Text(
                month.keys.toList()[index],
                style: const TextStyle(fontSize: 15),
              ),
              onTap: () {
                currentMonth = month.keys.toList()[index];
                foodList;
              },
            );
          },
        ),
        icon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.calendar_month_rounded, color: Colors.deepPurple),
            Text(
              currentMonth,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

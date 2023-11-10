import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/core/utilities/constants/app_color.dart';
import 'package:my_office/features/food_count/data/model/food_count_model.dart';
import 'package:my_office/features/food_count/presentation/provider/food_count_provider.dart';
import 'package:provider/provider.dart';
import '../../../../core/utilities/constants/app_main_template.dart';
import 'individual_count_detail_screen.dart';

class FoodCountScreen extends StatefulWidget {
  const FoodCountScreen({Key? key}) : super(key: key);

  @override
  State<FoodCountScreen> createState() => _FoodCountScreenState();
}

class _FoodCountScreenState extends State<FoodCountScreen> {
  // notifiers
  final ValueNotifier<bool> _isLoading = ValueNotifier(true);
  final ValueNotifier<String> _currentMonth =
      ValueNotifier(DateFormat.MMMM().format(DateTime.now()));
  final ValueNotifier<List<FoodCountModel>> _allFoodCountList =
      ValueNotifier([]);

  final ref = FirebaseDatabase.instance.ref();
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

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<FoodCountProvider>(context, listen: false).fetchAllFoodCount();
    });
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
    return ValueListenableBuilder(
      valueListenable: _allFoodCountList,
      builder: (ctx, foodList, child) {
        return ValueListenableBuilder(
          valueListenable: _isLoading,
          builder: (ctx, loading, child) {
            int total = 0;
            for (var food in foodList) {
              total += food.foodDates.length;
            }

            return (loading && foodList.isEmpty)
                ? Center(
                    child: Lottie.asset("assets/animations/new_loading.json"),
                  )
                : Column(
                    children: [
                      if (!loading)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                'Total : $total',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            ValueListenableBuilder(
                              valueListenable: _currentMonth,
                              builder: (ctx, month, child) {
                                return buildDropDown(month);
                              },
                            ),
                          ],
                        ),
                      if (loading) ...[
                        const Text(
                          'Fetching data',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        const CircleAvatar(
                          child: SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                            ),
                          ),
                        ),
                      ],
                      if (foodList.isEmpty)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              'assets/animations/no_data.json',
                              height: 300.0,
                            ),
                            const Text(
                              'No list for selected month',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        )
                      else
                        Expanded(
                          child: Material(
                            color: Colors.transparent,
                            child: ListView(
                              children: List.generate(
                                foodList.length,
                                (index) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0,
                                    vertical: 5.0,
                                  ),
                                  child: ListTile(
                                    tileColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => CountDetailScreen(
                                            allFoodCountList: _allFoodCountList
                                                .value
                                                .firstWhere(
                                              (element) =>
                                                  element.name ==
                                                  foodList[index].name,
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
                                      child: foodList[index].url.isEmpty
                                          ? const Image(
                                              image: AssetImage(
                                                'assets/profile_icon.jpg',
                                              ),
                                            )
                                          : CachedNetworkImage(
                                              imageUrl: foodList[index].url,
                                              fit: BoxFit.cover,
                                              progressIndicatorBuilder: (
                                                context,
                                                url,
                                                downloadProgress,
                                              ) =>
                                                  CircularProgressIndicator(
                                                color: AppColor.primaryColor,
                                                value:
                                                    downloadProgress.progress,
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(
                                                Icons.error,
                                                color: Colors.red,
                                              ),
                                            ),
                                    ),
                                    title: Text(
                                      foodList[index].name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    subtitle: Text(
                                      foodList[index].department,
                                      style: const TextStyle(fontSize: 13.0),
                                    ),
                                    trailing: Text(
                                      'Count : ${foodList[index].foodDates.length}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
          },
        );
      },
    );
  }

  Widget buildDropDown(String currentMonth) {
    final provider = Provider.of<FoodCountProvider>(context,listen: false);
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
                _currentMonth.value = month.keys.toList()[index];
                provider.fetchAllFoodCount;
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

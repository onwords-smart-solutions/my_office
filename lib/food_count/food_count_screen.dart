import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/util/main_template.dart';
import '../Constant/fonts/constant_font.dart';
import '../constant/colors/constant_colors.dart';
import '../models/food_count_model.dart';

class FoodCountScreen extends StatefulWidget {
  const FoodCountScreen({Key? key}) : super(key: key);

  @override
  State<FoodCountScreen> createState() => _FoodCountScreenState();
}

class _FoodCountScreenState extends State<FoodCountScreen> {
  // notifiers
  final ValueNotifier<bool> _isLoading = ValueNotifier(true);
  final ValueNotifier<String> _currentMonth = ValueNotifier(DateFormat.MMMM().format(DateTime.now()));
  final ValueNotifier<List<FoodCountModel>> _allFoodCountList = ValueNotifier([]);

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
    getAllFoodCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
        subtitle: 'Food count detail', templateBody: buildBody(), bgColor: ConstantColor.background1Color);
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
                    ? Center(child: Lottie.asset("assets/animations/new_loading.json"))
                    : Column(
                        children: [
                          if (!loading)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Text('Total : $total',
                                      style: TextStyle(fontFamily: ConstantFonts.sfProBold, fontSize: 16.0)),
                                ),
                                ValueListenableBuilder(
                                    valueListenable: _currentMonth,
                                    builder: (ctx, month, child) {
                                      return buildDropDown(month);
                                    }),
                              ],
                            ),
                          if (loading) ...[
                            Text('Fetching data',
                                style: TextStyle(
                                  fontFamily: ConstantFonts.sfProBold,
                                  fontSize: 18.0,
                                )),
                            const SizedBox(height: 5.0),
                            const CircleAvatar(
                              child: SizedBox(
                                height: 20.0,
                                width: 20.0,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                ),
                              ),
                            )
                          ],
                          if (foodList.isEmpty)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset('assets/animations/no_data.json', height: 300.0),
                                Text(
                                  'No list for selected month',
                                  style: TextStyle(
                                    fontFamily: ConstantFonts.sfProMedium,
                                    color: ConstantColor.blackColor,
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
                                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                                      child: ListTile(
                                        tileColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                                        leading: Container(
                                          width: 40.0,
                                          height: 40.0,
                                          decoration: const BoxDecoration(shape: BoxShape.circle),
                                          clipBehavior: Clip.hardEdge,
                                          child: foodList[index].url.isEmpty
                                              ? const Image(image: AssetImage('assets/profile_icon.jpg'))
                                              : CachedNetworkImage(
                                                  imageUrl: foodList[index].url,
                                                  fit: BoxFit.cover,
                                                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                      CircularProgressIndicator(
                                                          color: ConstantColor.backgroundColor,
                                                          value: downloadProgress.progress),
                                                  errorWidget: (context, url, error) => const Icon(
                                                    Icons.error,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                        ),
                                        title: Text(
                                          foodList[index].name,
                                          style: TextStyle(fontFamily: ConstantFonts.sfProBold),
                                        ),
                                        subtitle: Text(
                                          foodList[index].department,
                                          style: TextStyle(fontFamily: ConstantFonts.sfProMedium, fontSize: 13.0),
                                        ),
                                        trailing: Text(
                                          'Count : ${foodList[index].foodDates.length}',
                                          style: TextStyle(
                                            fontFamily: ConstantFonts.sfProBold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                        ],
                      );
              });
        });
  }

  Widget buildDropDown(String currentMonth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: PopupMenuButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        position: PopupMenuPosition.under,
        elevation: 10.0,
        itemBuilder: (ctx) => List.generate(
          month.length,
          (index) {
            return PopupMenuItem(
              child: Text(
                month.keys.toList()[index],
                style: TextStyle(fontFamily: ConstantFonts.sfProMedium, fontSize: 15),
              ),
              onTap: () {
                _currentMonth.value = month.keys.toList()[index];
                getAllFoodCount();
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
              style: TextStyle(fontFamily: ConstantFonts.sfProBold, fontSize: 16.0, color: Colors.deepPurple),
            )
          ],
        ),
      ),
    );
  }

  // Functions
  Future<void> getAllFoodCount() async {
    _isLoading.value = true;
    _allFoodCountList.value.clear();
    await ref.child('staff').once().then((staffSnapshot) async {
      for (var staff in staffSnapshot.snapshot.children) {
        final staffInfo = staff.value as Map<Object?, Object?>;
        final name = staffInfo['name'].toString();
        final dept = staffInfo['department'].toString();
        final email = staffInfo['email'].toString();
        final url = staffInfo['profileImage'] == null ? '' : staffInfo['profileImage'].toString();

        final foodDetails = await checkFoodCount(name);
        if (foodDetails.isNotEmpty) {
          _allFoodCountList.value.add(
            FoodCountModel(
              name: name,
              department: dept,
              url: url,
              email: email,
              foodDates: foodDetails,
            ),
          );
          _allFoodCountList.notifyListeners();
        }
      }
    });
    _isLoading.value = false;
  }

  Future<List<dynamic>> checkFoodCount(String staffName) async {
    List<dynamic> staffLunchData = [];
    final currentMonthFormat = '${DateTime.now().year}-${month[_currentMonth.value]}';
    await ref.child('refreshments').once().then((value) {
      if (value.snapshot.exists) {
        for (var detail in value.snapshot.children) {
          final dividedFormat = detail.key!.substring(0, 7);
          if (dividedFormat.contains(currentMonthFormat)) {
            final data = detail.value as Map<Object?, Object?>;
            if (data['Lunch'] != null) {
              //CHECKING FOR STAFF
              final lunchData = data['Lunch'] as Map<Object?, Object?>;
              final lunchList = lunchData['lunch_list'] as Map<Object?, Object?>;

              for (var staff in lunchList.values) {
                if (staff.toString() == staffName) {
                  staffLunchData.add(detail.key);
                }
              }
            }
          }
        }
      }
    });
    return staffLunchData;
  }
}

import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/refreshment/refreshment_details.dart';
import 'package:my_office/util/custom_rect_tween.dart';
import 'package:my_office/util/hero_dialog_route.dart';
import 'package:my_office/util/main_template.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

import '../Constant/fonts/constant_font.dart';

class RefreshmentScreen extends StatefulWidget {
  final String uid;
  final String name;

  const RefreshmentScreen({Key? key, required this.uid, required this.name})
      : super(key: key);

  @override
  State<RefreshmentScreen> createState() => _RefreshmentScreenState();
}

class _RefreshmentScreenState extends State<RefreshmentScreen> {
  final currentDateTime = DateTime.now();
  bool isMngTea = false;
  bool isEvgTea = false;

  void checkMorningTime() {
    final mngStart = DateTime(
        currentDateTime.year, currentDateTime.month, currentDateTime.day, 9, 30);
    final mngEnd = DateTime(currentDateTime.year, currentDateTime.month,
        currentDateTime.day, 11, 0);
    if (currentDateTime.isBefore(mngEnd) && currentDateTime.isAfter(mngStart)) {
      setState(() {
        isMngTea = true;
      });
    }
  }

  void checkEveningTime() {
    final evgStart = DateTime(currentDateTime.year, currentDateTime.month,
        currentDateTime.day, 13, 30);
    final evgEnd = DateTime(currentDateTime.year, currentDateTime.month,
        currentDateTime.day, 15, 30);
    if (currentDateTime.isBefore(evgEnd) && currentDateTime.isAfter(evgStart)) {
      setState(() {
        isEvgTea = true;
      });
    }
  }

  var formattedDate;
  var formattedMonth;
  var formattedYear;
  String? formattedTime;

  todayDate() {
    var now = DateTime.now();
    var formatterDate = DateFormat('yyy-MM-dd');
    var formatterYear = DateFormat('yyy');
    var formatterMonth = DateFormat('MM');
    formattedTime = DateFormat('HH:mm').format(now);
    formattedDate = formatterDate.format(now);
    formattedYear = formatterYear.format(now);
    formattedMonth = formatterMonth.format(now);

  }

  @override
  void initState() {
    todayDate();
    checkMorningTime();
    checkEveningTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(formattedDate);
    // print(formattedMonth);
    // print(formattedYear);
    return MainTemplate(
      subtitle: 'Choose your Refreshment here !',
      templateBody: buildRefreshmentSection(),
      bgColor: ConstantColor.background1Color,
      bottomImage: buildBottomImage(),
    );
  }

  Widget buildRefreshmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //DETAILS
        Container(
          padding: const EdgeInsets.only(right: 15.0),
          margin: const EdgeInsets.only(bottom: 20.0),
          alignment: AlignmentDirectional.centerEnd,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(HeroDialogRoute(
                    builder: (ctx) {
                      return const RefreshmentDetails();
                    },
                  ));
                },
                child: Hero(
                  tag: 'details',
                  createRectTween: (begin, end) {
                    return CustomRectTween(begin: begin!, end: end!);
                  },
                  child: Image.asset(
                    'assets/count.png',
                    scale: 4.0,
                  ),
                ),
              ),
              // Text(
              //   '34',
              //   style: TextStyle(
              //       fontFamily: ConstantFonts.poppinsRegular, fontSize: 15),
              // )
            ],
          ),
        ),

        //TEA
        if (isMngTea || isEvgTea)
          buildSlider(
              image: Image.asset(
                'assets/tea slider.png',
                scale: 3.5,
              ),
              title: 'Slide to have a Tea',
              item: 'Tea'),
        const SizedBox(height: 30.0),
        //COFFEE
        if (isMngTea || isEvgTea)
          buildSlider(
              image: Image.asset(
                'assets/coffee slider.png',
                fit: BoxFit.fitHeight,
              ),
              title: 'Slide to have a Coffee',
              item: 'Coffee'),
        const SizedBox(height: 30.0),
        //LUNCH
        if (isMngTea)
          buildSlider(
              title: 'Slide to have a Food',
              image: Image.asset(
                'assets/food.png',
                scale: 2.5,
              ),
              item: 'Food'),

        if (!isMngTea && !isEvgTea)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Lottie.asset('assets/animations/Time anime.json',height: 200),
                const SizedBox(height: 15.0),
                Text(
                  'Wait until refreshment portal opens...',
                  style: TextStyle(fontFamily: ConstantFonts.poppinsBold,color: Colors.deepPurple,fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25.0),
                Text(
                  'Morning refreshment and food time: 9:30 AM - 11:00 AM',
                  style: TextStyle(fontFamily: ConstantFonts.poppinsMedium,color: Colors.deepPurple,fontSize: 12.0),
                  textAlign: TextAlign.center,
                ),Text(
                  'Evening refreshment time: 1:30 PM - 3:30 PM',
                  style: TextStyle(fontFamily: ConstantFonts.poppinsMedium,color: Colors.deepPurple,fontSize: 12.0),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
      ],
    );
  }

  Widget buildBottomImage() => Positioned(
      bottom: 10.0,
      child: Image.asset(
        'assets/man_with_laptop.png',
   height: MediaQuery.of(context).size.height*.25,
      ));

  Widget buildSlider({
    required String title,
    required Image image,
    required String item,
  }) {
    return ConfirmationSlider(
      stickToEnd: true,
      onConfirmation: () {
        HapticFeedback.heavyImpact();
        orderRefreshment(item: item);
      },
      height: 70,
      width: MediaQuery.of(context).size.width * .85,
      backgroundColor: ConstantColor.background1Color,
      foregroundColor: ConstantColor.background1Color,
      backgroundShape: BorderRadius.circular(40),
      text: title,
      textStyle: TextStyle(
          fontFamily: ConstantFonts.poppinsMedium,
          color: const Color(0xff5E5E5E)),
      sliderButtonContent: image,
    );
  }

  void orderRefreshment({required String item}) {
    final today = DateTime.now();
    final day = today.day < 10 ? '0${today.day}' : today.day;
    final month = today.month < 10 ? '0${today.month}' : today.month;
    final String format = '${today.year}-$month-$day';
    String mode = 'FN';

    if (today.hour <= 11) {
      mode = 'FN';
    } else {
      mode = 'AN';
    }

    if (item == 'Food') {
      int foodCount = 0;
      bool isFoodBooked = false;
      getFoodDetails(date: format).then((value) {
        if (value != null) {
          Map<Object?, Object?> foodList =
              value['lunch_list'] as Map<Object?, Object?>;

          //Checking whether already booked food or not
          if (foodList.isNotEmpty) {
            // isFoodBooked = foodList.containsValue(widget.name);
            foodCount = value['lunch_count'];
          }

          // if (isFoodBooked) {
          //   showSnackBar(
          //       message: 'You have already ordered your Food',
          //       color: Colors.red);
          // } else {
          //   bookFood(foodCount: foodCount, date: format);
          // }

          bookFood(foodCount: foodCount, date: format);
        } else {
          bookFood(foodCount: foodCount, date: format);
        }
      });
    } else {
      getRefreshmentDetails(date: format, mode: mode).then((value) {
        Map<Object?, Object?> teaList = {};
        Map<Object?, Object?> coffeeList = {};
        int teaCount = 0;
        int coffeeCount = 0;
        bool isTeaOrdered = false;
        bool isCoffeeOrdered = false;
        if (value != null) {
          //Tea list
          try {
            teaList = value['tea'] as Map<Object?, Object?>;
          } catch (e) {
            print('Error for tea $e');
          }
          //Coffee list
          try {
            coffeeList = value['coffee'] as Map<Object?, Object?>;
          } catch (e) {
            print('Error for Coffee $e');
          }

          //Checking for already ordered Tea or not
          if (teaList.isNotEmpty) {
            // isTeaOrdered = teaList.containsValue(widget.name);
            teaCount = value['tea_count'];
          }

          //Checking for already ordered Coffee or not
          if (coffeeList.isNotEmpty) {
            // isCoffeeOrdered = coffeeList.containsValue(widget.name);
            coffeeCount = value['coffee_count'];
          }

          // if (isTeaOrdered || isCoffeeOrdered) {
          //   final item = isTeaOrdered ? 'Tea' : 'Coffee';
          //   showSnackBar(
          //       message: 'You have already submitted your $item',
          //       color: Colors.red);
          // } else {
          //   orderTeaOrCoffee(
          //       item: item,
          //       coffeeCount: coffeeCount,
          //       teaCount: teaCount,
          //       date: format,
          //       mode: mode);
          // }

          orderTeaOrCoffee(
              item: item,
              coffeeCount: coffeeCount,
              teaCount: teaCount,
              date: format,
              mode: mode);

        } else {
          orderTeaOrCoffee(
              item: item,
              coffeeCount: coffeeCount,
              teaCount: teaCount,
              date: format,
              mode: mode);
        }
      });
    }
  }

  Future<dynamic> getRefreshmentDetails(
      {required String date, required String mode}) async {
    Object? data;
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('/refreshments/$date/$mode').get();
    if (snapshot.exists) {
      data = snapshot.value;
    }
    return data;
  }

  Future<dynamic> getFoodDetails({required String date}) async {
    Object? data;
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('/refreshments/$date/Lunch').get();
    if (snapshot.exists) {
      data = snapshot.value;
    }
    return data;
  }

  Future<void> orderTeaOrCoffee(
      {required String item,
      required int coffeeCount,
      required int teaCount,
      required String date,
      required String mode}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    if (item == 'Tea') {
      await ref.child('/refreshments/$date/$mode/tea').update({
        'name${teaCount + 1}': widget.name,
      });

      await ref.child('/refreshments/$date/$mode').update({
        'tea_count': teaCount + 1,
      });
      showSnackBar(message: 'Tea ordered successfully', color: Colors.green);
    } else if (item == 'Coffee') {
      await ref.child('/refreshments/$date/$mode/coffee').update({
        'name${coffeeCount + 1}': widget.name,
      });

      await ref.child('/refreshments/$date/$mode').update({
        'coffee_count': coffeeCount + 1,
      });
      showSnackBar(message: 'Coffee ordered successfully', color: Colors.green);
    }
  }

  Future<void> bookFood({required int foodCount, required String date}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    await ref.child('/refreshments/$date/Lunch/lunch_list').update({
      'name${foodCount + 1}': widget.name,
    });

    await ref.child('/refreshments/$date/Lunch').update({
      'lunch_count': foodCount + 1,
    });
    showSnackBar(message: 'Food ordered successfully', color: Colors.green);
  }

  void showSnackBar({required String message, required Color color}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        padding: const EdgeInsets.all(0.0),
        content: Container(
            height: 50.0,
            color: color,
            child: Center(
                child: Text(
              message,
              style: TextStyle(fontFamily: ConstantFonts.poppinsMedium),
            )))));
  }
}

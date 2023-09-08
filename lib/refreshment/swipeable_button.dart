import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import '../Constant/fonts/constant_font.dart';

class SwipeableButton extends StatelessWidget {
  final Widget button;
  final String message;
  final String name;
  final String type;

  const SwipeableButton({Key? key, required this.button, required this.message, required this.type, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> isFinished = ValueNotifier(false);
    final ValueNotifier<bool> ordered = ValueNotifier(false);
    return ValueListenableBuilder(
        valueListenable: ordered,
        builder: (ctx, alreadyOrdered, child) {
          return ValueListenableBuilder(
              valueListenable: isFinished,
              builder: (ctx, finished, child) {
                return SwipeableButtonView(
                  isFinished: finished,
                  onFinish: () async {
                    if (alreadyOrdered) {
                      await Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: CompleteScreen(message: '$type ordered successfully'),
                        ),
                      );
                    }
                    isFinished.value = false;
                  },
                  onWaitingProcess: () async {
                    HapticFeedback.mediumImpact();
                    final status = await orderRefreshment(item: type, context: context);
                    ordered.value = status;
                    isFinished.value = true;
                  },
                  activeColor: Colors.black45,
                  buttontextstyle: TextStyle(
                    fontFamily: ConstantFonts.sfProMedium,
                    color: Colors.white,
                  ),
                  buttonColor: Colors.white,
                  indicatorColor: const AlwaysStoppedAnimation(Colors.white),
                  // buttonWidget: button,
                  buttonText: message,
                  buttonWidget: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey,
                  ),
                );
              });
        });
  }

  // FUNCTIONS
  Future<bool> orderRefreshment({required String item, required BuildContext context}) async {
    bool status = true;
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

    final mngExceedTime = DateTime(today.year, today.month, today.day, 10, 45);
    final noonExceedTime = DateTime(today.year, today.month, today.day, 14, 00);

    //Checking background running app with time in slider
    if (today.hour < 9 ||
        (today.isAfter(mngExceedTime) && today.isBefore(noonExceedTime)) ||
        (today.hour >= 15 && today.minute > 30) ||
        today.hour > 15) {
      showSnackBar(message: 'Refreshment time exceeded', color: Colors.red, context: context);
      return false;
    }
    log('TIME IS $today');

    if (item == 'Food') {
      int foodCount = 0;
      bool isFoodBooked = false;
      await getFoodDetails(date: format).then(
        (value) async {
          if (value != null) {
            Map<Object?, Object?> foodList = value['lunch_list'] as Map<Object?, Object?>;
            log('food list is $value');
            //Checking whether already booked food or not
            if (foodList.isNotEmpty) {
              isFoodBooked = foodList.containsValue(name);
              foodCount = value['lunch_count'];
            }

            if (isFoodBooked) {
              status = false;
              showSnackBar(message: 'You have already ordered your Food', color: Colors.red, context: context);
            } else {
              await bookFood(foodCount: foodCount, date: format, context: context);
            }
          } else {
            await bookFood(foodCount: foodCount, date: format, context: context);
          }
        },
      );
    } else {
      await getRefreshmentDetails(date: format, mode: mode).then((value) async {
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
          await orderTeaOrCoffee(
              item: item, coffeeCount: coffeeCount, teaCount: teaCount, date: format, mode: mode, context: context);
        } else {
          await orderTeaOrCoffee(
              item: item, coffeeCount: coffeeCount, teaCount: teaCount, date: format, mode: mode, context: context);
        }
      });
    }
    return status;
  }

  Future<dynamic> getRefreshmentDetails({required String date, required String mode}) async {
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
      required BuildContext context,
      required String date,
      required String mode}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    if (item == 'Tea') {
      await ref.child('/refreshments/$date/$mode/tea').update({
        'name${teaCount + 1}': name,
      });

      await ref.child('/refreshments/$date/$mode').update({
        'tea_count': teaCount + 1,
      });
    } else if (item == 'Coffee') {
      await ref.child('/refreshments/$date/$mode/coffee').update({
        'name${coffeeCount + 1}': name,
      });

      await ref.child('/refreshments/$date/$mode').update({
        'coffee_count': coffeeCount + 1,
      });
    }
  }

  Future<void> bookFood({required int foodCount, required String date, required BuildContext context}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    await ref.child('/refreshments/$date/Lunch/lunch_list').update({
      'name${foodCount + 1}': name,
    });

    await ref.child('/refreshments/$date/Lunch').update({
      'lunch_count': foodCount + 1,
    });
  }

  void showSnackBar({required String message, required Color color, required BuildContext context}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        padding: const EdgeInsets.all(0.0),
        content: Container(
          height: 50.0,
          color: color,
          child: Center(
            child: Text(
              message,
              style: TextStyle(fontFamily: ConstantFonts.sfProMedium),
            ),
          ),
        ),
      ),
    );
  }
}

class CompleteScreen extends StatelessWidget {
  final String message;

  const CompleteScreen({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () => Navigator.of(context).pop());
    return Scaffold(
      backgroundColor: const Color(0xff252525),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/animations/done.json'),
          Text(
            message,
            style: TextStyle(fontFamily: ConstantFonts.sfProBold, fontSize: 16.0, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

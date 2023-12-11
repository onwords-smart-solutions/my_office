import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import '../../../../core/utilities/custom_widgets/custom_snack_bar.dart';
import '../../data/data_source/refreshment_fb_data_source.dart';
import '../../data/data_source/refreshment_fb_data_source_impl.dart';
import '../../data/repository/refreshment_repo_impl.dart';
import '../../domain/repository/refreshment_repository.dart';

class SwipeableButton extends StatefulWidget {
  final String message;
  final String name;
  final String type;

  const SwipeableButton({
    Key? key,
    required this.message,
    required this.type,
    required this.name,
  }) : super(key: key);

  @override
  State<SwipeableButton> createState() => _SwipeableButtonState();
}

class _SwipeableButtonState extends State<SwipeableButton> {
  Map<String, dynamic> refreshmentDetails = {};
  Map<String, dynamic> foodDetails = {};
  late RefreshmentFbDataSource refreshmentFbDataSource =
      RefreshmentFbDataSourceImpl();
  late RefreshmentRepository refreshmentRepository =
      RefreshmentRepoImpl(refreshmentFbDataSource);

  @override
  Widget build(BuildContext context) {
    Image image = Image.asset(
      'assets/food.png',
      scale: 2.5,
    );

    if (widget.type == 'Coffee') {
      image = Image.asset(
        'assets/coffee slider.png',
        scale: 2.0,
        fit: BoxFit.fitHeight,
      );
    } else if (widget.type == "Tea") {
      image = Image.asset(
        'assets/tea.png',
        scale: 3.5,
      );
    } else if (widget.type == "Milk") {
      image = Image.asset(
        'assets/milk.png',
        width: 30.0,
        height: 30.0,
      );
    }

    final ValueNotifier<bool> isOrder = ValueNotifier(false);
    return ValueListenableBuilder(
      valueListenable: isOrder,
      builder: (ctx, isOrdering, child) {
        return AnimatedSwitcher(
          duration: const Duration(seconds: 1),
          switchInCurve: Curves.easeInOut,
          child: isOrdering
              ? const Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    child: SizedBox(
                      width: 30.0,
                      height: 30.0,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.0,
                      ),
                    ),
                  ),
                )
              : ConfirmationSlider(
                  onConfirmation: () async {
                    HapticFeedback.mediumImpact();
                    isOrder.value = true;
                    final status = await orderRefreshment(
                      item: widget.type,
                      context: context,
                    );
                    if(!mounted) return;
                    if (status) {
                      await Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: CompleteScreen(
                            message: '${widget.type} ordered successfully',
                          ),
                        ),
                      );
                    }
                    isOrder.value = false;
                  },
                  height: 65,
                  width: MediaQuery.of(context).size.width * .85,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.white,
                  backgroundShape: BorderRadius.circular(40),
                  text: widget.message,
                  textStyle:
                      const TextStyle(fontSize: 15.0, color: Colors.grey),
                  sliderButtonContent: image,
                ),
        );
      },
    );
  }

  // FUNCTIONS
  Future<bool> orderRefreshment({
    required String item,
    required BuildContext context,
  }) async {
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
      CustomSnackBar.showErrorSnackbar(
        message: 'Refreshment time exceeded',
        context: context,
      );
      return false;
    }
    log('TIME IS $today');

    if (item == 'Food') {
      int foodCount = 0;
      bool isFoodBooked = false;
      await fetchDetails(date: format, mode: mode).then(
        (value) async {
          if (foodDetails.isNotEmpty) {
            Map<Object?, Object?> foodList =
                foodDetails['lunch_list'] as Map<Object?, Object?>;
            log('food list is $foodDetails');
            //Checking whether already booked food or not
            if (foodList.isNotEmpty) {
              isFoodBooked = foodList.containsValue(widget.name);
              foodCount = foodDetails['lunch_count'];
            }

            if (isFoodBooked) {
              status = false;
              CustomSnackBar.showErrorSnackbar(
                message: 'You have already ordered your Food',
                context: context,
              );
            } else {
              await handleFoodBooking(
                foodCount: foodCount,
                date: format,
                context: context,
                name: widget.name,
              );
            }
          } else {
            await handleFoodBooking(
              foodCount: foodCount,
              date: format,
              context: context,
              name: widget.name,
            );
          }
        },
      );
    } else {
      String errorMessage = '';
      await fetchDetails(date: format, mode: mode).then((value) async {
        Map<Object?, Object?> teaList = {};
        Map<Object?, Object?> coffeeList = {};
        Map<Object?, Object?> milkList = {};
        int teaCount = 0;
        int coffeeCount = 0;
        int milkCount = 0;
        bool isTeaOrdered = false;
        bool isCoffeeOrdered = false;
        bool isMilkOrdered = false;
        if (refreshmentDetails.isNotEmpty) {
          //Tea list
          try {
            teaList = refreshmentDetails['tea'] as Map<Object?, Object?>;
          } catch (e) {
            print('Error for tea $e');
          }
          //Coffee list
          try {
            coffeeList = refreshmentDetails['coffee'] as Map<Object?, Object?>;
          } catch (e) {
            print('Error for Coffee $e');
          }
          //milk list
          try {
            milkList = refreshmentDetails['milk'] as Map<Object?, Object?>;
          } catch (e) {
            print('Error for milk $e');
          }

          //Checking for already ordered Tea or not
          if (teaList.isNotEmpty) {
            isTeaOrdered = teaList.containsValue(widget.name);
            teaCount = refreshmentDetails['tea_count'];
          }
          if(isTeaOrdered && item == 'Tea'){
            errorMessage ='You have already ordered your Tea';
            status = false;
          }

          //Checking for already ordered Coffee or not
          if (coffeeList.isNotEmpty) {
            isCoffeeOrdered = coffeeList.containsValue(widget.name);
            coffeeCount = refreshmentDetails['coffee_count'];
          }
          if(isCoffeeOrdered && item == 'Coffee'){
            errorMessage ='You have already ordered your Coffee';
            status = false;
          }

          //Checking for already ordered milk or not
          if (milkList.isNotEmpty) {
            isMilkOrdered = milkList.containsValue(widget.name);
            milkCount = refreshmentDetails['milk_count'];
          }
          if(isMilkOrdered && item == 'Milk'){
            errorMessage ='You have already ordered your Milk';
            status = false;
          }

          if(status){
            await handleOrder(
              item: item,
              coffeeCount: coffeeCount,
              teaCount: teaCount,
              milkCount: milkCount,
              date: format,
              mode: mode,
              context: context,
              name: widget.name,
            );
          }else{
            CustomSnackBar.showErrorSnackbar(message: errorMessage, context: context);
          }

        } else {
          await handleOrder(
            item: item,
            coffeeCount: coffeeCount,
            teaCount: teaCount,
            milkCount: milkCount,
            date: format,
            mode: mode,
            context: context,
            name: widget.name,
          );
        }
      });
    }
    return status;
  }

  Future<void> handleOrder({
    required String item,
    required int coffeeCount,
    required int teaCount,
    required int milkCount,
    required String date,
    required String mode,
    required BuildContext context,
    required String name,
  }) async {
    try {
      bool success = await refreshmentRepository.orderItem(
        name: name,
        item: item,
        date: date,
        mode: mode,
      );
      log('Name is ${widget.name}');
      if (success) {
        if (!mounted) return;
        CustomSnackBar.showSuccessSnackbar(
          message: 'Refreshment has been booked successfully',
          context: context,
        );
      } else {
        if (!mounted) return;
        CustomSnackBar.showErrorSnackbar(
          message: 'Refreshment order has been failed!',
          context: context,
        );
      }
    } catch (e) {
      CustomSnackBar.showErrorSnackbar(
        message: 'Error caught while ordering refreshment $e',
        context: context,
      );
    }
  }

  Future<void> handleFoodBooking({
    required int foodCount,
    required String date,
    required BuildContext context,
    required String name,
  }) async {
    try {
      bool success =
          await refreshmentRepository.bookLunch(name: name, date: date);
      log('Name is ${widget.name}');
      if (success) {
        if (!mounted) return;
        CustomSnackBar.showSuccessSnackbar(
          message: 'Food has been booked successfully',
          context: context,
        );
      } else {
        if (!mounted) return;
        CustomSnackBar.showErrorSnackbar(
          message: 'Food order has been failed!',
          context: context,
        );
      }
    } catch (e) {
      CustomSnackBar.showErrorSnackbar(
        message: 'Error caught while ordering food $e',
        context: context,
      );
    }
  }

  Future<void> fetchDetails({
    required String date,
    required String mode,
  }) async {
    try {
      var refreshmentData = await refreshmentRepository.fetchRefreshmentDetails(
        date: date,
        mode: mode,
      );
      var foodData = await refreshmentRepository.fetchFoodDetails(date: date);
      setState(() {
        refreshmentDetails = refreshmentData;
        foodDetails = foodData;
      });
    } catch (e) {
      if (!mounted) return;
      CustomSnackBar.showErrorSnackbar(
        message: 'Error caught while fetching refreshment details $e',
        context: context,
      );
    }
  }
}

class CompleteScreen extends StatelessWidget {
  final String message;

  const CompleteScreen({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 2),
      () => Navigator.of(context).pop(),
    );
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/animations/done.json'),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

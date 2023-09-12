// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';

import '../util/custom_rect_tween.dart';

class RefreshmentDetails extends StatefulWidget {
  const RefreshmentDetails({Key? key}) : super(key: key);

  @override
  State<RefreshmentDetails> createState() => _RefreshmentDetailsState();
}

class _RefreshmentDetailsState extends State<RefreshmentDetails> {
  bool _isLoading = true;
  String _dayTime = 'Morning';
  int _coffeeCount = 0;
  int _teaCount = 0;
  int _foodCount = 0;
  int _milkCount = 0;
  bool isFoodShow = true;
  late Timer _timer;
  var _data;
  var _foodData;
  final _today = DateTime.now();

  Future<void> getData() async {
    final day = _today.day < 10 ? '0${_today.day}' : _today.day;
    final month = _today.month < 10 ? '0${_today.month}' : _today.month;
    final String format = '${_today.year}-$month-$day';
    String mode = '';


      if (_today.hour <= 11) {
        _dayTime = 'Morning';
        mode = 'FN';
      } else {
        _dayTime = 'Evening';
        mode = 'AN';
      }


    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('/refreshments/$format/$mode').get();
    if (snapshot.exists) {
      if (!mounted) return;

        _data = snapshot.value;
        _coffeeCount = _data['coffee_count'] ?? 0;
        _teaCount = _data['tea_count'] ?? 0;
        _milkCount = _data['milk_count'] ?? 0;


    }

    //Food section
    final foodSnapshot = await ref.child('/refreshments/$format/Lunch').get();
    if (foodSnapshot.exists) {
      if (!mounted) return;

        _foodData = foodSnapshot.value;
        _foodCount = _foodData['lunch_count'] ?? 0;

    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    getData();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      getData();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTime = DateTime.now();
    final foodEndTime = DateTime(currentTime.year, currentTime.month, currentTime.day, 14, 0);

    if (currentTime.isAfter(foodEndTime)) {
      isFoodShow = false;
    }

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Iconsax.close_square5,
            color: Colors.redAccent,
          ),
        ),
        title: const Text(
          'Refreshment Count',
          style: TextStyle(
            color: Color(0xff8355B7),
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: Lottie.asset('assets/animations/new_loading.json'))
          : Column(
              children: [
                buildHeadSection(),
                Expanded(
                  child: ListView(
                    children: [
                      buildTeaSection(),
                      buildCoffeeSection(),
                      buildMilkSection(),
                      if (isFoodShow) buildFoodSection(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget buildHeadSection() {
    final Map<String, int> refreshmentDetail = {
      'Tea': _teaCount,
      'Coffee': _coffeeCount,
      'Milk': _milkCount,
    };

    if (isFoodShow) {
      refreshmentDetail.addAll({"Food": _foodCount});
    }
    List<Widget> refreshment = [];
    refreshmentDetail.forEach((key, value) {
      refreshment.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/${key.toLowerCase()}.png',
              width: 25.0,
              height: 25.0,
            ),
            const SizedBox(width: 5.0),
            Text(
              '$key: $value',
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
            ),
          ],
        ), // You can use any widget type here
      );
    });

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 20.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20.0),
        ),
      ),
      child: Column(
        children: [
          Text(
            _dayTime,
            style: const TextStyle(color: Color(0xff8355B7), fontSize: 15.0, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: refreshment,
          )
        ],
      ),
    );
  }

  Widget buildTeaSection() {
    List<String> listOfTea = [];
    if (_teaCount > 0) {
      final Map<dynamic, dynamic> tea = _data['tea'];
      final teaKeys = tea.keys;
      for (var i in teaKeys) {
        listOfTea.add(tea[i]);
      }
    }

    return Container(
      margin: const EdgeInsets.only(left: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tea',
              style: TextStyle(
                color: Color(0xffDD9324),
                fontSize: 26.0,
              )),
          Container(
            margin: const EdgeInsets.only(left: 25.0, right: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: listOfTea.isEmpty
                      ? const Text(
                          'No data',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            fontSize: 18.0,
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: listOfTea.length,
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (ctx, index) {
                            return Text(
                              listOfTea[index],
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            );
                          }),
                ),
                Image.asset(
                  'assets/tea_design.png',
                  scale: 4.0,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildCoffeeSection() {
    List<String> listOfCoffee = [];
    if (_coffeeCount > 0) {
      final Map<dynamic, dynamic> coffee = _data['coffee'];
      final coffeeKeys = coffee.keys;
      for (var i in coffeeKeys) {
        listOfCoffee.add(coffee[i]);
      }
    }
    return Container(
      margin: const EdgeInsets.only(top: 15.0, left: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Coffee',
              style: TextStyle(
                color: Color(0xff5B3618),
                fontSize: 26.0,
              )),
          Container(
            // height: MediaQuery.of(context).size.height * .18,
            margin: const EdgeInsets.only(left: 25.0, right: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: listOfCoffee.isEmpty
                      ? const Text(
                          'No data',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            fontSize: 18.0,
                          ),
                        )
                      : ListView.builder(
                          itemCount: listOfCoffee.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (ctx, index) {
                            return Text(
                              listOfCoffee[index],
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            );
                          }),
                ),
                Image.asset(
                  'assets/coffee_design.png',
                  scale: 4.0,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildMilkSection() {
    List<String> listOfMilk = [];
    if (_milkCount > 0) {
      final Map<dynamic, dynamic> milk = _data['milk'];
      final coffeeKeys = milk.keys;
      for (var i in coffeeKeys) {
        listOfMilk.add(milk[i]);
      }
    }
    return Container(
      margin: const EdgeInsets.only(top: 15.0, left: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Milk',
              style: TextStyle(
                color: Colors.lightBlue.shade800,
                fontSize: 26.0,
              )),
          Container(
            margin: const EdgeInsets.only(left: 25.0, right: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: listOfMilk.isEmpty
                      ? const Text(
                          'No data',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            fontSize: 18.0,
                          ),
                        )
                      : ListView.builder(
                          itemCount: listOfMilk.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (ctx, index) {
                            return Text(
                              listOfMilk[index],
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            );
                          }),
                ),
                Image.asset(
                  'assets/tea_design.png',
                  scale: 4.0,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildFoodSection() {
    List<String> listOfFood = [];
    if (_foodCount > 0) {
      final Map<dynamic, dynamic> food = _foodData['lunch_list'];
      final foodKeys = food.keys;
      for (var i in foodKeys) {
        listOfFood.add(food[i]);
      }
    }
    return Container(
      margin: const EdgeInsets.only(top: 15.0, left: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Food',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 26.0,
              )),
          Container(
            // height: MediaQuery.of(context).size.height * .18,
            margin: const EdgeInsets.only(left: 25.0, right: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: listOfFood.isEmpty
                      ? const Text(
                          'No data',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            fontSize: 18.0,
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: listOfFood.length,
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (ctx, index) {
                            return Text(
                              listOfFood[index],
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            );
                          },
                        ),
                ),
                // Image.asset(
                //   'assets/coffee_design.png',
                //   scale: 4.0,
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

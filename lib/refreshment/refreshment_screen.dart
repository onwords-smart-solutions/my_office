import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/refreshment/refreshment_details.dart';
import 'package:my_office/refreshment/swipeable_button.dart';
import '../util/custom_rect_tween.dart';
import '../util/hero_dialog_route.dart';

class RefreshmentScreen extends StatefulWidget {
  final String uid;
  final String name;

  const RefreshmentScreen({Key? key, required this.uid, required this.name}) : super(key: key);

  @override
  State<RefreshmentScreen> createState() => _RefreshmentScreenState();
}

class _RefreshmentScreenState extends State<RefreshmentScreen> {
  final DateTime _now = DateTime.now();
  late Timer _timer;

  // notifiers
  final ValueNotifier<String> _currentBgImage = ValueNotifier('assets/tea.jpg');
  final ValueNotifier<bool> _showSecondImage = ValueNotifier(false);
  final ValueNotifier<String> _secondImage = ValueNotifier('assets/food.jpg');
  final ValueNotifier<bool> _isMorning = ValueNotifier(false);
  final ValueNotifier<bool> _isEvening = ValueNotifier(false);

  @override
  void initState() {
    _checkMorningTime();
    _checkEveningTime();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_isEvening.value) {
        _secondImage.value = 'assets/milk.jpg';
      } else {
        _secondImage.value = 'assets/food.jpg';
      }
      _showSecondImage.value = !_showSecondImage.value;
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _currentBgImage.dispose();
    _secondImage.dispose();
    _showSecondImage.dispose();
    _isMorning.dispose();
    _isEvening.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return ValueListenableBuilder(
        valueListenable: _isMorning,
        builder: (ctx, isMng, child) {
          return ValueListenableBuilder(
              valueListenable: _isEvening,
              builder: (ctx, isEvg, child) {
                return Scaffold(
                  body: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      // -- App Bar --
                      SliverAppBar(
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        stretch: true,
                        leading: IconButton.filled(
                          onPressed: () => Navigator.of(context).pop(),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.deepPurple,
                          ),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          color: Colors.white,
                        ),
                        elevation: 0,
                        pinned: true,
                        expandedHeight: size.height * .4,
                        flexibleSpace: _bgContainer(size, isMng, isEvg),
                        actions: [
                          IconButton.filled(
                            onPressed: () {
                              Navigator.of(context).push(
                                HeroDialogRoute(
                                  builder: (ctx) {
                                    return const RefreshmentDetails();
                                  },
                                ),
                              );
                            },
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.deepPurple,
                            ),
                            icon: Image.asset(
                              'assets/count.png',
                              scale: 6.0,
                            ),
                            color: Colors.white,
                          )
                        ],
                      ),

                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: (!isMng && !isEvg)
                            ? Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Align(
                                        alignment: AlignmentDirectional.centerStart,
                                        child: Text(
                                          'Refreshment Portal',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.deepPurple.shade800,
                                              fontSize: 25.0),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: size.height * .06),
                                    const Text(
                                      'Wait until Refreshment portal opens...',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20.0,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 15.0),
                                    RichText(
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Morning refreshment and food time - ',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '(09:00 AM - 10:45 AM)',
                                            style: TextStyle(
                                              color: Colors.purple,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    RichText(
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Evening refreshment time - ',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '(2:00 PM - 3:30 PM)',
                                            style: TextStyle(
                                              color: Colors.purple,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.symmetric(horizontal: size.width * .08),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 20.0),
                                    Text(
                                      'Refreshment Portal',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.deepPurple.shade800,
                                          fontSize: 25.0),
                                    ),
                                    SizedBox(height: size.height * .06),
                                    if (isMng || isEvg) ...[
                                      SwipeableButton(
                                        message: 'Slide to have a Tea',
                                        type: 'Tea',
                                        name: widget.name,
                                      ),
                                      const SizedBox(height: 30.0),
                                      SwipeableButton(
                                        message: 'Slide to have a Coffee',
                                        type: 'Coffee',
                                        name: widget.name,
                                      ),
                                      const SizedBox(height: 30.0),
                                      SwipeableButton(
                                        message: 'Slide to have a Milk',
                                        type: 'Milk',
                                        name: widget.name,
                                      ),
                                    ],
                                    const SizedBox(height: 30.0),
                                    if (isMng)
                                      SwipeableButton(
                                        message: 'Slide to order Food',
                                        type: 'Food',
                                        name: widget.name,
                                      ),
                                  ],
                                ),
                              ),
                      )
                    ],
                  ),
                );
              });
        });
  }

  Widget _bgContainer(Size size, bool isMng, bool isEvg) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30.0)),
      child: (!isMng && !isEvg)
          ? Container(
              color: Colors.amber.shade100,
              child: Center(child: Lottie.asset('assets/animations/time_out.json', height: size.height * .35)),
            )
          : Stack(
              children: [
                ValueListenableBuilder(
                  valueListenable: _currentBgImage,
                  builder: (ctx, image, child) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      foregroundDecoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(image),
                          fit: BoxFit.cover,
                          colorFilter: const ColorFilter.mode(
                            Colors.black38,
                            BlendMode.darken,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: _showSecondImage,
                  builder: (ctx, isShow, child) {
                    return AnimatedSwitcher(
                      duration: const Duration(seconds: 1),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      switchInCurve: Curves.easeIn,
                      switchOutCurve: Curves.easeOut,
                      child: isShow
                          ? ValueListenableBuilder(
                              valueListenable: _secondImage,
                              builder: (ctx, image, child) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  foregroundDecoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(image),
                                      fit: BoxFit.cover,
                                      colorFilter: const ColorFilter.mode(
                                        Colors.black38,
                                        BlendMode.darken,
                                      ),
                                    ),
                                  ),
                                );
                              })
                          : const SizedBox.shrink(),
                    );
                  },
                ),
              ],
            ),
    );
  }

  void _checkMorningTime() {
    final mngStart = DateTime(_now.year, _now.month, _now.day, 9, 0);
    final mngEnd = DateTime(_now.year, _now.month, _now.day, 10, 45);
    if (_now.isBefore(mngEnd) && _now.isAfter(mngStart)) {
      _isMorning.value = true;
      _secondImage.value = 'assets/food.jpg';
    }
  }

  void _checkEveningTime() {
    final evgStart = DateTime(_now.year, _now.month, _now.day, 14, 0);
    final evgEnd = DateTime(_now.year, _now.month, _now.day, 15, 30);
    if (_now.isBefore(evgEnd) && _now.isAfter(evgStart)) {
      _isEvening.value = true;
      _currentBgImage.value = 'assets/coffee.jpg';
      _secondImage.value = 'assets/milk.jpg';
    }
  }
}

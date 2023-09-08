import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/refreshment/refreshment_details.dart';
import 'package:my_office/refreshment/swipeable_button.dart';
import '../Constant/fonts/constant_font.dart';
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
  final ValueNotifier<bool> _isFood = ValueNotifier(false);
  final ValueNotifier<bool> _isMorning = ValueNotifier(false);
  final ValueNotifier<bool> _isEvening = ValueNotifier(false);

  @override
  void initState() {
    _checkMorningTime();
    _checkEveningTime();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_isEvening.value) {
        timer.cancel();
      } else {
        _isFood.value = !_isFood.value;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _currentBgImage.dispose();
    _isFood.dispose();
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
                Color color = Colors.white;
                if (!isMng && !isEvg) {
                  color = Colors.black;
                }

                return Scaffold(
                  extendBodyBehindAppBar: true,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    leading: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        color: color),
                    title: Text(
                      'Refreshment',
                      style: TextStyle(fontFamily: ConstantFonts.sfProMedium, color: color),
                    ),
                    centerTitle: true,
                    actions: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            HeroDialogRoute(
                              builder: (ctx) {
                                return const RefreshmentDetails();
                              },
                            ),
                          );
                        },
                        child: Hero(
                          tag: 'details',
                          createRectTween: (begin, end) {
                            return CustomRectTween(begin: begin!, end: end!);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: Image.asset(
                              'assets/count.png',
                              scale: 4.0,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  body: SizedBox.expand(
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        if (!isMng && !isEvg)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset('assets/animations/time_out.json', width: size.width * .6),
                              const SizedBox(height: 20.0),
                              Text(
                                'Wait until Refreshment portal opens...',
                                style: TextStyle(
                                  fontFamily: ConstantFonts.sfProBold,
                                  fontSize: 18.0,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 15.0),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Morning refreshment and food time - ',
                                      style: TextStyle(
                                        fontFamily: ConstantFonts.sfProMedium,
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '(09:00 AM - 10:45 AM)',
                                      style: TextStyle(
                                        fontFamily: ConstantFonts.sfProMedium,
                                        color: Colors.purple,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Evening refreshment time - ',
                                      style: TextStyle(fontFamily: ConstantFonts.sfProMedium, color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: '(2:00 PM - 3:30 PM)',
                                      style: TextStyle(fontFamily: ConstantFonts.sfProMedium, color: Colors.purple),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        else ...[
                          if (isMng || isEvg) _bgContainer(size),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: size.height * .2, horizontal: size.width * .08),
                            child: Column(
                              children: [
                                if (isMng || isEvg) ...[
                                  SwipeableButton(
                                    button: Image.asset('assets/tea slider.png', scale: 2.5),
                                    message: 'Slide to order Tea',
                                    type: 'Tea',
                                    name: widget.name,
                                  ),
                                  const SizedBox(height: 30.0),
                                  SwipeableButton(
                                    button: Image.asset('assets/coffee slider.png', fit: BoxFit.fitHeight),
                                    message: 'Slide to order Coffee',
                                    type: 'Coffee',
                                    name: widget.name,
                                  ),
                                ],
                                const SizedBox(height: 30.0),
                                if (isMng)
                                  SwipeableButton(
                                    button: Image.asset('assets/food.png', scale: 2.5),
                                    message: 'Slide to order Food',
                                    type: 'Food',
                                    name: widget.name,
                                  ),
                              ],
                            ),
                          )
                        ]
                      ],
                    ),
                  ),
                );
              });
        });
  }

  Widget _bgContainer(Size size) {
    return Stack(
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
          valueListenable: _isFood,
          builder: (ctx, isFood, child) {
            return AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              child: isFood
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      foregroundDecoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/food.jpg'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black38,
                            BlendMode.darken,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            );
          },
        ),
      ],
    );
  }

  void _checkMorningTime() {
    final mngStart = DateTime(_now.year, _now.month, _now.day, 9, 0);
    final mngEnd = DateTime(_now.year, _now.month, _now.day, 10, 45);
    if (_now.isBefore(mngEnd) && _now.isAfter(mngStart)) {
      _isMorning.value = true;
    }
  }

  void _checkEveningTime() {
    final evgStart = DateTime(_now.year, _now.month, _now.day, 14, 0);
    final evgEnd = DateTime(_now.year, _now.month, _now.day, 15, 30);
    if (_now.isBefore(evgEnd) && _now.isAfter(evgStart)) {
      _isEvening.value = true;
      _isFood.value = false;
      _currentBgImage.value = 'assets/coffee.jpg';
    }
  }
}

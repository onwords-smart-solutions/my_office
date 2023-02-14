import 'package:flutter/material.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/refreshment/refreshment_details.dart';
import 'package:my_office/util/custom_rect_tween.dart';
import 'package:my_office/util/hero_dialog_route.dart';
import 'package:my_office/util/main_template.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

import '../Constant/fonts/constant_font.dart';

class RefreshmentScreen extends StatefulWidget {
  const RefreshmentScreen({Key? key}) : super(key: key);

  @override
  State<RefreshmentScreen> createState() => _RefreshmentScreenState();
}

class _RefreshmentScreenState extends State<RefreshmentScreen> {
  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      name: 'Test Admin',
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
              Text(
                '34',
                style: TextStyle(
                    fontFamily: ConstantFonts.poppinsRegular, fontSize: 15),
              )
            ],
          ),
        ),

        //TEA
        buildSlider(
            image: Image.asset(
              'assets/tea slider.png',
              scale: 3.5,
            ),
            title: 'Slide to have a Tea'),
        const SizedBox(height: 30.0),
        //COFFEE
        buildSlider(
            image: Image.asset(
              'assets/coffee slider.png',
              fit: BoxFit.fitHeight,
            ),
            title: 'Slide to have a Coffee'),
        const SizedBox(height: 30.0),
        //LUNCH
        buildSlider(
          title: 'Slide to have a Food',
          image: Image.asset(
            'assets/food.png',
            scale: 2.5,
          ),
        ),
      ],
    );
  }

  Widget buildBottomImage() => Positioned(
      bottom: 10.0,
      child: Image.asset(
        'assets/man_with_laptop.png',
        scale: 5.0,
      ));

  Widget buildSlider({
    required String title,
    required Image image,
  }) {
    return ConfirmationSlider(
      // stickToEnd: true,
      onConfirmation: () {
        print('added Tea');
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
}

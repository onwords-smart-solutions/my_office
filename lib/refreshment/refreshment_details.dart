import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';

import '../util/custom_rect_tween.dart';

class RefreshmentDetails extends StatefulWidget {
  const RefreshmentDetails({Key? key}) : super(key: key);

  @override
  State<RefreshmentDetails> createState() => _RefreshmentDetailsState();
}

class _RefreshmentDetailsState extends State<RefreshmentDetails> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Hero(
          tag: 'details',
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin!, end: end!);
          },
          child: Material(
            color: Colors.white,
            elevation: 20,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    buildHeadSection(),
                    buildTeaSection(),
                    buildCoffeeSection(),
                    buildFoodSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeadSection() {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        Container(
      width: double.infinity,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(.7),
                    blurRadius: 10.0,
                    offset: const Offset(0, 10))
              ]),
          child: Column(
            children: [
              Text(
                'Refreshment Count',
                style: TextStyle(
                    color: const Color(0xff8355B7),
                    fontSize: 16.0,
                    fontFamily: ConstantFonts.poppinsMedium),
              ),
              const SizedBox(height: 20.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
             physics: const BouncingScrollPhysics(),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width*.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Tea Count
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Image.asset(
                            'assets/tea.png',
                            scale: 3,
                          ),
                          const SizedBox(width: 5.0),
                          Text(
                            'Tea 34',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontFamily: ConstantFonts.poppinsMedium),
                          ),
                        ],
                      ),

                      //Coffee Count
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Image.asset(
                            'assets/coffee.png',
                            scale: 3,
                          ),
                          const SizedBox(width: 5.0),
                          Text('Coffee 04',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontFamily: ConstantFonts.poppinsMedium)),
                        ],
                      ),

                      //Food Count
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Image.asset(
                            'assets/food.png',
                            scale: 3.5,
                          ),
                          Text('Food 24',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontFamily: ConstantFonts.poppinsMedium)),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        IconButton(
          onPressed: () =>Navigator.of(context).pop(),
          icon:const Icon(
            Iconsax.close_square5,
            color: Colors.redAccent,
          ),
          splashRadius: 10.0,
        ),
      ],
    );
  }

  Widget buildTeaSection() {
    List<String> teaNames = ['Jibin', 'Mohan', 'Vinith', 'Ganesh'];
    return Container(
      margin: const EdgeInsets.only(top: 25.0, left: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tea',
              style: TextStyle(
                  color: const Color(0xffDD9324),
                  fontSize: 26.0,
                  fontFamily: ConstantFonts.poppinsMedium)),
          Container(
            height: MediaQuery.of(context).size.height * .18,
            margin: const EdgeInsets.only(left: 25.0, right: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: teaNames.length,
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        return Text(teaNames[index]);
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
    List<String> teaNames = [
      'Jeeva',
      'Ram',
      'Koushik',
      'Jyothi',
      'Kavin',
      'Anitha',
      'Bala'
    ];
    return Container(
      margin: const EdgeInsets.only(top: 15.0, left: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Coffee',
              style: TextStyle(
                  color: const Color(0xff5B3618),
                  fontSize: 26.0,
                  fontFamily: ConstantFonts.poppinsMedium)),
          Container(
            height: MediaQuery.of(context).size.height * .18,
            margin: const EdgeInsets.only(left: 25.0, right: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: teaNames.length,
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        return Text(teaNames[index]);
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

  Widget buildFoodSection() {
    List<String> teaNames = [
      'Jeeva',
      'Ram',
      'Koushik',
      'Jyothi',
      'Kavin',
      'Anitha',
      'Bala'
    ];
    return Container(
      margin: const EdgeInsets.only(top: 15.0, left: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Food',
              style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 26.0,
                  fontFamily: ConstantFonts.poppinsMedium)),
          Container(
            height: MediaQuery.of(context).size.height * .18,
            margin: const EdgeInsets.only(left: 25.0, right: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: teaNames.length,
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        return Text(teaNames[index]);
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
}

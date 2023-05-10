import 'package:flutter/material.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';

import '../Constant/fonts/constant_font.dart';

class ScreenTemplate extends StatelessWidget {
  final Widget bodyTemplate;
  final String title;

  const ScreenTemplate(
      {Key? key, required this.bodyTemplate, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: height * 1,
              width: width,
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).viewPadding.top * 1.5),
              decoration: const BoxDecoration(
                color: ConstantColor.background1Color,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon:
                                const Icon(Icons.arrow_back_ios_new_rounded)),

                        //Name and subtitle
                        Text(
                          title,
                          style: TextStyle(
                            fontFamily: ConstantFonts.poppinsMedium,
                            fontSize: 24.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.01),

                    //Custom widget section
                    Expanded(child: bodyTemplate),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

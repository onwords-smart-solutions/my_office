import 'package:flutter/material.dart';
import 'package:my_office/core/utilities/constants/app_color.dart';

class ScreenTemplate extends StatelessWidget {
  final Widget bodyTemplate;
  final String title;

  const ScreenTemplate({
    Key? key,
    required this.bodyTemplate,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: Colors.black,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: height * 1,
              width: width,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).viewPadding.top * 1.5,
              ),
              decoration: BoxDecoration(
                color: AppColor.backGroundColor,
                borderRadius: const BorderRadius.only(
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
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        ),

                        //Name and subtitle
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 25.0,
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

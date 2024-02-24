import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/core/utilities/constants/app_color.dart';
import 'package:my_office/core/utilities/constants/app_main_template.dart';

class ViewLeadsAchievedScreen extends StatelessWidget {
  final RemoteMessage content;
  const ViewLeadsAchievedScreen({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
        templateBody: buildLeadsAchievedData(),
        bgColor: AppColor.backGroundColor,
      subtitle: 'Sale achievement',
    );
  }

  buildLeadsAchievedData(){
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Lottie.asset(
            'assets/animations/pr_sale.json',
        fit: BoxFit.fill,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Triumph Twins🏆',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Colors.purpleAccent,
              ),
            ),
            const Gap(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                content.notification!.body.toString(),
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Lottie.asset(
            'assets/animations/pr_sale.json',
            fit: BoxFit.fill,
          ),
        ),
      ],
    );
  }
}

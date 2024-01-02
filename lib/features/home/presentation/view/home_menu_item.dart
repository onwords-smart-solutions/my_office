import 'package:flutter/material.dart';
import 'package:my_office/features/user/domain/entity/user_entity.dart';

import '../../../../core/utilities/constants/app_default_screens.dart';

class HomeMenuItem extends StatelessWidget {
  final UserEntity staff;
  final String title;
  final String image;

  const HomeMenuItem({Key? key, required this.title, required this.image, required this.staff}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.sizeOf(context);
    return InkWell(
      splashColor: Colors.deepPurple.withOpacity(.3),
      borderRadius: BorderRadius.circular(15.0),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AppDefaults.getPage(
              title,
              staff,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Expanded(child: Image.asset(image)),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
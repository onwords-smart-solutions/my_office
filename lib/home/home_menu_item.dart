import 'package:flutter/material.dart';
import 'package:my_office/constant/app_defaults.dart';
import 'package:my_office/models/staff_model.dart';

class HomeMenuItem extends StatelessWidget {
  final StaffModel staff;
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
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

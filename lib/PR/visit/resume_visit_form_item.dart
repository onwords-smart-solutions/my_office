import 'package:flutter/material.dart';

import '../../Constant/fonts/constant_font.dart';

class ResumeVisitFormItem extends StatelessWidget {
  final String name;
  final String number;
  final String date;
  final String time;

  const ResumeVisitFormItem(
      {Key? key,
      required this.name,
      required this.date,
      required this.time,
      required this.number})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.grey.withOpacity(.3)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.edit_note_rounded),
                const SizedBox(width: 10.0),
                Text(name,
                    style: TextStyle(
                        fontFamily: ConstantFonts.poppinsBold,
                        fontSize: 15.0)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(date,
                    style: TextStyle(
                        fontFamily: ConstantFonts.poppinsMedium,
                        fontSize: 12.0)),
                Text(time,
                    style: TextStyle(
                        fontFamily: ConstantFonts.poppinsMedium,
                        fontSize: 12.0)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

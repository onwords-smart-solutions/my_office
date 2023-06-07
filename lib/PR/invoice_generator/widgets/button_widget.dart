import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';

import '../../../Constant/fonts/constant_font.dart';

class Button {
  final String title;
  final VoidCallback onTab;

  const Button(this.title,this.onTab,
      {Key? key,
      });

  Widget button() {
    return GestureDetector(
     onTap: onTab,
      child: Container(
        height: 50,
        width: 300,
        decoration: BoxDecoration(
          color: ConstantColor.backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontFamily: ConstantFonts.poppinsMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
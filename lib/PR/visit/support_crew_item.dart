import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';

class SupportCrewItem extends StatelessWidget {
  final String name;
  final File image;

  const SupportCrewItem({Key? key, required this.image, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Row(
        children: [
          Text(name, style: TextStyle(fontFamily: ConstantFonts.sfProRegular),),
        ],
      ),

      ClipRRect(borderRadius: BorderRadius.circular(10.0),
        child: Image.file(image, height: size.height*.2,width:size.width*.6 , fit: BoxFit.cover,),),
      const SizedBox(height: 10.0),
    ],);
  }
}

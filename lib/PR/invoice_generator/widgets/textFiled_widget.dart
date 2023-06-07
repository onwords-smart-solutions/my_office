import 'package:flutter/material.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';

class TextFiledWidget {
  final TextEditingController controller;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final String hintName;
  final Icon icon;
  final int maxLength;
  final bool? isEnable;
  final bool? isOptional;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;


  const TextFiledWidget({Key? key,
    required this.controller,
    required this.textInputType,
    required this.textInputAction,
    required this.hintName,
    required this.icon,
    required this.maxLength,
    this.validator,
    this.isEnable,
    this.isOptional,
    this.onTap,
  });

  Widget textInputFiled() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      controller: controller,
      textInputAction: textInputAction,
      keyboardType: textInputType,
      maxLength: maxLength,
      enabled: isEnable,
      style: TextStyle(color: Colors.black,
          fontWeight: FontWeight.w600,
          fontFamily: ConstantFonts.poppinsRegular),
      decoration: InputDecoration(
        counterText: '',
        prefixIcon: icon,
        hintText: hintName,
        labelText: hintName,
        labelStyle: TextStyle(color: Colors.black,
            fontWeight: FontWeight.w600,
            fontFamily: ConstantFonts.poppinsRegular),
        hintStyle:
        TextStyle(color: Colors.black.withOpacity(0.6),
            fontWeight: FontWeight.w600,
            fontFamily: ConstantFonts.poppinsRegular),
        border: myInputBorder(),
        enabledBorder: myInputBorder(),
        focusedBorder: myFocusBorder(),
        disabledBorder: myDisabledBorder(),
      ),
      validator: validator,
      onTap: onTap,

    );
  }

  OutlineInputBorder myInputBorder() {
    return OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color: Colors.black.withOpacity(0.3),
          width: 2,
        )
    );
  }

  OutlineInputBorder myFocusBorder() {
    return OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(20),
        ),
        borderSide: BorderSide(
          color: Colors.black.withOpacity(0.3),
          width: 2,
        )
    );
  }

  OutlineInputBorder myDisabledBorder() {
    return OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(20),
        ),
        borderSide: BorderSide(
          color: Colors.black.withOpacity(0.3),
          width: 2,
        )
    );
  }
}


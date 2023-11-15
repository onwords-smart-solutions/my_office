import 'package:flutter/material.dart';

class CustomTextField {
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


  const CustomTextField({Key? key,
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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        controller: controller,
        textInputAction: textInputAction,
        keyboardType: textInputType,
        maxLength: maxLength,
        enabled: isEnable,
        style: TextStyle(color: Colors.black,
        ),
        decoration: InputDecoration(
          counterText: '',
          prefixIcon: icon,
          hintText: hintName,
          labelText: hintName,
          labelStyle: TextStyle(color: Colors.black,
          ),
          hintStyle:
          TextStyle(color: Colors.black.withOpacity(0.6),
          ),
          border: myInputBorder(),
          enabledBorder: myInputBorder(),
          focusedBorder: myFocusBorder(),
          disabledBorder: myDisabledBorder(),
        ),
        validator: validator,
        onTap: onTap,
      ),
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

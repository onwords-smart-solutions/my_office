import 'package:flutter/material.dart';

class CustomAlertTextField {
  final TextEditingController controller;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final String hintName;
  final Icon? icon;
  final int maxLength;
  final bool? isEnable;
  final bool? isOptional;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final bool? readOnly;
  final TextCapitalization? textCapitalizationWords;

  const CustomAlertTextField({
    Key? key,
    required this.controller,
    required this.textInputType,
    required this.textInputAction,
    required this.hintName,
    this.icon,
    required this.maxLength,
    this.validator,
    this.isEnable,
    this.isOptional,
    this.onTap,
    this.readOnly,
    this.textCapitalizationWords,
  });

  Widget textInputField(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        textCapitalization: textCapitalizationWords ??
            TextCapitalization.sentences,
        controller: controller,
        textInputAction: textInputAction,
        keyboardType: textInputType,
        maxLength: maxLength,
        enabled: isEnable,
        style: const TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          counterText: '',
          prefixIcon: icon,
          hintText: hintName,
          labelText: hintName,
          labelStyle: const TextStyle(
            color: Colors.black,
          ),
          hintStyle: TextStyle(
            color: Colors.black
                .withOpacity(.3),
          ),
          border: myInputBorder(context),
          enabledBorder: myInputBorder(context),
          focusedBorder: myFocusBorder(context),
          disabledBorder: myDisabledBorder(context),
          errorBorder: myErrorBorder(),
        ),
        validator: validator,
        onTap: onTap,
      ),
    );
  }

  OutlineInputBorder myInputBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(
        color: Colors.black
            .withOpacity(0.3),
        width: 2,
      ),
    );
  }

  OutlineInputBorder myFocusBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(12),
      ),
      borderSide: BorderSide(
        color: Colors.black
            .withOpacity(0.3),
        width: 2,
      ),
    );
  }

  OutlineInputBorder myDisabledBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(12),
      ),
      borderSide: BorderSide(
        color: Colors.black
            .withOpacity(0.3),
        width: 2,
      ),
    );
  }

  OutlineInputBorder myErrorBorder() {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(12),
      ),
      borderSide: BorderSide(
        color: Colors.red.withOpacity(0.5),
        width: 2,
      ),
    );
  }
}
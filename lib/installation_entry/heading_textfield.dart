import 'package:flutter/material.dart';

class HeadingTextFormField extends StatelessWidget {
  final String title;
  final String? Function(String?) validator;
  final Function(String?)? onSaved;
  final String hintText;
  final TextEditingController controller;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;
  final bool? readOnly;
  final VoidCallback? onTap;

  const HeadingTextFormField({
    Key? key,
    required this.title,
    required this.validator,
    required this.hintText,
    required this.onSaved,
    required this.controller,
    this.textInputAction,
    this.textCapitalization,
    this.readOnly,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey, fontSize: 16.0),
        ),
        const SizedBox(height: 5.0),
        TextFormField(
          style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
          readOnly: readOnly ?? false,
          onTap: onTap,
          validator: validator,
          onSaved: onSaved,
          controller: controller,
          textCapitalization: textCapitalization ?? TextCapitalization.none,
          textInputAction: textInputAction ?? TextInputAction.done,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
            filled: true,
            fillColor: Colors.white,
            hintText: hintText,
            hintStyle: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide.none,
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

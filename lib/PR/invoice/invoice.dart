import 'package:flutter/material.dart';
import 'package:my_office/util/screen_template.dart';

class Invoice extends StatelessWidget {
  const Invoice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(bodyTemplate: Text('hey'), title: 'Invoice Generator');
  }
}
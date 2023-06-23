import 'package:flutter/material.dart';

import '../Constant/colors/constant_colors.dart';
import '../util/main_template.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  @override
  Widget build(BuildContext context) {
    return MainTemplate(
        subtitle: 'Look up your Reminders!',
        templateBody: buildReminder(),
        bgColor: ConstantColor.background1Color);
  }

  Widget buildReminder(){
    return Column(
      children: [
        Text('heeloo'),
        Text('he')
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../Constant/colors/constant_colors.dart';
import '../util/main_template.dart';

class LeaveStatusScreen extends StatefulWidget {
  final String uid;
  final String name;
  const LeaveStatusScreen({super.key, required this.uid, required this.name});

  @override
  State<LeaveStatusScreen> createState() => _LeaveStatusScreenState();
}

class _LeaveStatusScreenState extends State<LeaveStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return MainTemplate(
        subtitle: 'Employee names!!',
        templateBody: buildEmployeeNames(),
        bgColor: ConstantColor.background1Color);
  }

  Widget buildEmployeeNames(){
    return Column(
      children: [
        Center(
          child: FloatingActionButton(
            onPressed: (){},
            child: Text('Test'),
          )
        ),
      ],
    );
  }
}

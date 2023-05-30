import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';
import '../home/user_home_screen.dart';
import '../util/main_template.dart';

class ConfirmAttendanceScreen extends StatelessWidget {
  const ConfirmAttendanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
        subtitle: 'Attendance Reference Screen',
        templateBody: attendance(),
        bgColor: ConstantColor.background1Color);
  }

  Widget attendance() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/animations/attendance.json',
              height: 400, fit: BoxFit.contain),
          Text(
            'Wait Until your Entry is Registered!!',
            style: TextStyle(
              fontFamily: ConstantFonts.poppinsMedium,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: ConstantColor.backgroundColor,
            ),
          ),
        ],
      ),
    );
  }
}

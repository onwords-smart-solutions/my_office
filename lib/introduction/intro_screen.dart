import 'package:flutter/material.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';

import '../Constant/fonts/constant_font.dart';
import '../login/login_screen.dart';

class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ConstantColor.background1Color,
      body: Column(
        children: [
          imageWidget(height),
          textWidget(height, width),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginScreen()));
        },
        child: buttonWidget(),
      ),
    );
  }

  Widget imageWidget(double height) {
    return Container(
      height: height * 0.45,
      width: double.infinity,
      color: Colors.transparent,
      child: Image.asset(
        'assets/intro pic.png',
      ),
    );
  }

  Widget textWidget(double height, double width) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: height * 0.03, horizontal: width * 0.05),
      height: height * 0.23,
      width: double.infinity,
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            'Manage Your daily',
            style: TextStyle(
              fontFamily: ConstantFonts.poppinsMedium,
              color: ConstantColor.blackColor,
              fontSize: height * 0.045,
            ),
            gradient: const LinearGradient(
              colors: [
                Colors.black,
                Colors.black,
              ],
            ),
          ),
          GradientText(
            'Work manager',
            style: TextStyle(
              fontFamily: ConstantFonts.poppinsMedium,
              color: ConstantColor.blackColor,
              fontSize: height * 0.045,
            ),
            gradient: const LinearGradient(
              colors: [
                Color(0xffB33DC9),
                Color(0xffA043C1),
              ],
            ),
          ),
          GradientText(
            'Here !',
            style: TextStyle(
              fontFamily: ConstantFonts.poppinsMedium,
              color: ConstantColor.blackColor,
              fontSize: height * 0.045,
            ),
            gradient: const LinearGradient(
              colors: [
                Colors.black,
                Colors.black,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonWidget() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xffBC3CCC),
            Color(0xff814EB6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(5, 5),
            blurRadius: 10,
          )
        ],
      ),
      child: const Center(
        child: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    required this.gradient,
    this.style,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}

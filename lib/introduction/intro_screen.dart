import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import '../login/login_screen.dart';

class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          imageWidget(height),
          textWidget(height, width),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen(),
              ),
          );
        },
        child: buttonWidget(),
      ),
    );
  }

  Widget imageWidget(double height) {
    return SizedBox(
      height: height * 0.45,
      width: double.infinity,
      child: SvgPicture.asset(
        'assets/intro_pic.svg',
      ),
    );
  }

  Widget textWidget(double height, double width) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: height * 0.05,
        horizontal: width * 0.05,
      ),
      height: height * 0.25,
      width: double.infinity,
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            'Manage your daily',
            style: TextStyle(
              color: ConstantColor.blackColor,
              fontSize: height * 0.040,
            ),
            gradient: const LinearGradient(
              colors: [
                Colors.black,
                Colors.black,
              ],
            ),
          ),
          GradientText(
            'works with our',
            style: TextStyle(
              color: ConstantColor.blackColor,
              fontSize: height * 0.040,
            ),
            gradient: const LinearGradient(
              colors: [
                Colors.black,
                Colors.black,
              ],
            ),
          ),
          GradientText(
            'Work Manager',
            style: TextStyle(
              color: ConstantColor.blackColor,
              fontSize: height * 0.040,
            ),
            gradient: const LinearGradient(
              colors: [
                Color(0xffD136D4),
                Color(0xff7652B2),
              ],
            ),
          ),
          GradientText(
            'from here!!',
            style: TextStyle(
              color: ConstantColor.blackColor,
              fontSize: height * 0.040,
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
      ),
      child: const Center(
        child: Icon(Icons.arrow_forward_ios, color: Colors.white),
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

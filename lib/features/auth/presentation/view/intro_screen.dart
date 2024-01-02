import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'login_screen.dart';

class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            imageWidget(height, context),
            textWidget(height, width),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginScreen()));
        },
        child: buttonWidget(context),
      ),
    );
  }

  Widget imageWidget(double height, BuildContext context) {
    return SizedBox(
      height: height * 0.4,
      width: double.infinity,
      child: SvgPicture.asset(
        'assets/images/intro_screen.svg',
      ),
    );
  }

  Widget textWidget(double height, double width) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: height * 0.05, horizontal: width * 0.05,),
      height: height * 0.25,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Manage your daily',
            style: TextStyle(
              fontSize: height * 0.040,
            ),
          ),
          Text(
            'works with our',
            style: TextStyle(
              fontSize: height * 0.040,
            ),
          ),
          GradientText(
            'Onwords Workspace',
            style: TextStyle(
              fontSize: height * 0.040,
            ),
            gradient: const LinearGradient(
              colors: [
                Color(0xffD136D4),
                Color(0xff7652B2),
              ],
            ),
          ),
         Text(
            'from here!!',
            style: TextStyle(
              fontSize: height * 0.040,
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonWidget(BuildContext context) {
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
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Icon(Icons.arrow_forward_ios,color: Theme.of(context).primaryColor, ),
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
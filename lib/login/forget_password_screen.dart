import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_office/login/login_screen.dart';

import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ConstantColor.background1Color,
      body: Stack(
        children: [
          ///Top Circle...
          Positioned(
            top: height * 0.03,
            // left: 0,
            right: width * -0.02,
            child: Image.asset(
              'assets/top circle.png',
              scale: 4.0,
            ),
          ),

          ///Top Text...
          Positioned(
            top: height * 0.35,
            left: width * 0.05,
            // right: width*0.0,
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'Forgot\nPassword ?\n',
                  style: TextStyle(
                    fontFamily: ConstantFonts.poppinsMedium,
                    color: ConstantColor.blackColor,
                    fontSize: height * 0.035,
                  ),
                ),
                TextSpan(
                  text: 'Please enter your  email id below',
                  style: TextStyle(
                    fontFamily: ConstantFonts.poppinsMedium,
                    color: ConstantColor.blackColor,
                    fontSize: height * 0.020,
                  ),
                ),
              ]),
            ),
          ),

          ///Center Image...
          Positioned(
            top: height * -0.016,
            left: width * 0.0,
            right: width * 0.0,
            child: Image.asset(
              'assets/forget password.png',
              scale: 4.5,
            ),
          ),

          /// TextFields And Submit Button...
          Positioned(
            top: height * 0.30,
            left: width * 0.05,
            right: width * 0.05,
            bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.2,
                  ),
                  textFiledWidget(
                      height,
                      TextInputType.emailAddress,
                      TextInputAction.done,
                      'Email Id',
                      emailEditingController,
                      const Icon(Icons.person_outlined),
                  ),
                  SizedBox(
                    height: height*0.05,
                  )


                ],
              ),
            ),
          ),

          /// Button...
          Positioned(
            top: height * 0.8,
            left: width * 0.05,
            right: width * 0.05,
            child: buttonWidget(height,const LoginScreen(),'Submit'),
          ),



        ],
      ),
    );
  }



  Widget buttonWidget(double height,Widget screen,String name) {
    return GestureDetector(
      onTap: (){
        setState(() {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> screen));
        });
      },
      child: Container(
        height: height*0.07,
        decoration:  BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [
              Color(0xffD136D4),
              Color(0xff7652B2),
            ],
          ),
        ),
        child: Center(
          child: Text(
            name,
            style: TextStyle(
              fontFamily: ConstantFonts.poppinsMedium,
              color: ConstantColor.background1Color,
              fontSize: height * 0.030,
            ),
          ),
        ),
      ),
    );
  }



  Widget textFiledWidget(
      double height,
      TextInputType textInputType,
      TextInputAction textInputAction,
      String hintName,
      TextEditingController textEditingController,
      Icon icon) {
    return Padding(
      padding:  EdgeInsets.only(top: height*0.03),
      child: TextField(
        controller: textEditingController,
        textInputAction: textInputAction,
        autofocus: false,
        keyboardType: textInputType,
        style: TextStyle(
            fontSize: height * 0.02,
            color: Colors.black,
            fontFamily: ConstantFonts.poppinsRegular),
        decoration: InputDecoration(
          prefixIcon: icon,
          border: InputBorder.none,
          hintText: hintName,
          filled: true,
          fillColor: ConstantColor.background1Color,
          contentPadding:
          const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: ConstantColor.background1Color),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}


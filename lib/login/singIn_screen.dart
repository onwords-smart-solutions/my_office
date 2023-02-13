import 'package:flutter/material.dart';
import 'package:my_office/login/login_screen.dart';
import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
class SingInScreen extends StatefulWidget {
  const SingInScreen({Key? key}) : super(key: key);

  @override
  State<SingInScreen> createState() => _SingInScreenState();
}

class _SingInScreenState extends State<SingInScreen> {
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController numberEditingController = TextEditingController();
  TextEditingController confirmPasswordEditingController = TextEditingController();

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
            top: height * 0.02,
            // left: 0,
            right: width * -0.04,
            child: Image.asset(
              'assets/top circle.png',
              scale: 3.5,
            ),
          ),

          ///Top Text...
          Positioned(
            top: height * 0.05,
            left: width * 0.05,
            // right: width*0.0,
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'Hello !\n',
                  style: TextStyle(
                    fontFamily: ConstantFonts.poppinsMedium,
                    color: ConstantColor.blackColor,
                    fontSize: height * 0.035,
                  ),
                ),
                TextSpan(
                  text: 'Welcome To Team onwords',
                  style: TextStyle(
                    fontFamily: ConstantFonts.poppinsMedium,
                    color: ConstantColor.blackColor,
                    fontSize: height * 0.020,
                  ),
                ),
              ]),
            ),
          ),

          ///Woman Image...
          Positioned(
            top: height * -0.065,
            left: width * 0.0,
            right: width * 0.0,
            child: Image.asset(
              'assets/young_woman_talking_online 1.png',
              scale: 4.5,
            ),
          ),

          /// TextFields And Submit Button...
          Positioned(
            top: height * 0.13,
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
                      TextInputAction.next,
                      'Name',
                      emailEditingController,
                      const Icon(Icons.person_outlined)),
                  textFiledWidget(
                    height,
                    TextInputType.number,
                    TextInputAction.next,
                    'Phone Number',
                    numberEditingController,
                    const Icon(Icons.call),
                  ),
                  textFiledWidget(
                    height,
                    TextInputType.emailAddress,
                    TextInputAction.done,
                    'Password',
                    passwordEditingController,
                    const Icon(Icons.lock_open_outlined),
                  ),
                  textFiledWidget(
                    height,
                    TextInputType.emailAddress,
                    TextInputAction.done,
                    'Confirm Password',
                    confirmPasswordEditingController,
                    const Icon(Icons.lock_open_outlined),
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
            child: buttonWidget(height,const LoginScreen(),'SingIn'),
          ),

          /// Already member...
          Positioned(
            top: height * 0.9,
            left: width * 0.05,
            right: width * 0.05,
            child: haveAccountWidget(height,const LoginScreen()),
          ),


        ],
      ),
    );
  }

  Widget haveAccountWidget(double height,Widget screen) {
    return GestureDetector(
      onTap: (){
        setState(() {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> screen));
        });
      },
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            children: [
              TextSpan(text: 'Already member  ', style: TextStyle(
                fontFamily: ConstantFonts.poppinsMedium,
                color: ConstantColor.blackColor,
                fontSize: height * 0.015,
              ),),
              TextSpan(text: 'Login ?', style: TextStyle(
                fontFamily: ConstantFonts.poppinsMedium,
                color: ConstantColor.pinkColor,
                fontSize: height * 0.015,
              ),
              ),

            ]
        ),
      ),
    );
  }

  Widget buttonWidget(double height,Widget screen,String name) {
    return GestureDetector(
      onTap: (){
        setState(() {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> screen));
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
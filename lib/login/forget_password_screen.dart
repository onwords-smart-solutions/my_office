import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_office/login/login_screen.dart';

import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import '../util/main_template.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController emailEditingController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return  Scaffold(
      backgroundColor: ConstantColor.background1Color,
      body: Form(
        key: formKey,
        child: Stack(

          children: [

            ///Center Image...
            Positioned(
              top: height * 0.5,
              left: width * 0.30,
              // right: width * 0.0,
              child: Image.asset(
                'assets/forget password.png',
                scale: 4.5,
              ),
            ),

            ///Top Text...
            Positioned(
              top: height * 0.1,
              left: width * 0.05,
              // right: width*0.0,
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: 'Forgot\nPassword?\n',
                    style: TextStyle(
                      fontFamily: ConstantFonts.sfProRegular,
                      color: ConstantColor.blackColor,
                      fontSize: height * 0.035,
                    ),
                  ),
                  TextSpan(
                    text: 'Please enter your Mail id below',
                    style: TextStyle(
                      fontFamily: ConstantFonts.sfProRegular,
                      color: ConstantColor.blackColor,
                      fontSize: height * 0.020,
                    ),
                  ),
                ]),
              ),
            ),



            /// TextFields And Submit Button...
            Positioned(
              top: height * 0.3,
              left: width * 0.05,
              right: width * 0.05,
              bottom: 0,
              child: Column(
                children: [

                  Container(
                    decoration: BoxDecoration(
                      // color: Colors.black,
                      border: Border.all(color: Colors.black,),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: textFiledWidget(
                      height,
                      TextInputType.emailAddress,
                      TextInputAction.done,
                      'Email Id',
                      emailEditingController,
                      const Icon(Icons.person_outlined),
                    ),
                  ),
                  SizedBox(
                    height: height*0.05,
                  )


                ],
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
      ),
    );
  }




  Widget buttonWidget(double height,Widget screen,String name) {
    return GestureDetector(
      onTap: (){
        setState(() {
          if(emailEditingController.text.isNotEmpty && emailEditingController.text.contains("@")) {
            if(formKey.currentState!.validate()){
              resetPassword();
            }
            Navigator.push(context, MaterialPageRoute(builder: (context)=> screen));
          }else{
            showErrorSnackBar(message: 'enter a valid e-mail',color: Colors.red);
          }

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
              fontFamily: ConstantFonts.sfProRegular,
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
      padding:  EdgeInsets.symmetric(vertical: height*0.01),
      child: TextFormField(
        controller: textEditingController,
        textInputAction: textInputAction,
        autofocus: false,
        keyboardType: textInputType,
        style: TextStyle(
            fontSize: height * 0.02,
            color: Colors.black,
            fontFamily: ConstantFonts.sfProRegular),
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
            borderRadius: BorderRadius.circular(20.0),
          ),

          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }


  resetPassword() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(),)
    );
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailEditingController.text.trim());
      showErrorSnackBar(message: 'Password reset Mail has been sent',color: Colors.green);
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
    on FirebaseAuthException catch(e)
    {
      showErrorSnackBar(message: '${e.message}',color: Colors.red);
      Navigator.pop(context);
    }

  }


  void showErrorSnackBar({required String message,required Color color}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 0.0,
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              fontSize: 12.0),
        ),
      ),
    );
  }
}



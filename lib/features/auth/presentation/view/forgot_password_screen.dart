import 'package:flutter/material.dart';
import 'package:my_office/core/utilities/constants/app_color.dart';
import 'package:provider/provider.dart';
import '../../../../core/utilities/custom_widgets/custom_snack_bar.dart';
import '../provider/authentication_provider.dart';
import 'login_screen.dart';

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
    return Scaffold(
      backgroundColor: AppColor.backGroundColor,
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
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Forgot\nPassword?\n',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: height * 0.035,
                      ),
                    ),
                    TextSpan(
                      text: 'Please enter your Mail id below',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: height * 0.020,
                      ),
                    ),
                  ],
                ),
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
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(20),
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
                    height: height * 0.05,
                  ),
                ],
              ),
            ),

            /// Button...
            Positioned(
              top: height * 0.8,
              left: width * 0.05,
              right: width * 0.05,
              child: buttonWidget(height, const LoginScreen(), 'Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonWidget(double height, Widget screen, String name) {
    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (emailEditingController.text.isNotEmpty &&
              emailEditingController.text.contains("@")) {
            if (formKey.currentState!.validate()) {
              authProvider.resetPassword(
                email: emailEditingController.text,
              );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => screen),
                );
                CustomSnackBar.showSuccessSnackbar(
                    message: 'Password reset mail has been sent to your mail id',
                    context: context,
                );
            }
          } else {
            CustomSnackBar.showErrorSnackbar(
              context: context,
              message: 'Please enter a valid mail id!!',
            );
          }
        });
      },
      child: Container(
        height: height * 0.07,
        decoration: BoxDecoration(
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
              fontWeight: FontWeight.w500,
              color: AppColor.backGroundColor,
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
    Icon icon,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.01),
      child: TextFormField(
        controller: textEditingController,
        textInputAction: textInputAction,
        autofocus: false,
        keyboardType: textInputType,
        style: TextStyle(
          fontSize: height * 0.02,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          prefixIcon: icon,
          border: InputBorder.none,
          hintText: hintName,
          filled: true,
          fillColor: AppColor.backGroundColor,
          contentPadding:
              const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.backGroundColor),
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
}

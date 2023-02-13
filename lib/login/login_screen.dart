import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_office/login/singIn_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import '../home/home_screen.dart';
import 'forget_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController passwordEditingController = TextEditingController();

  late SharedPreferences logData;
  bool _showPassword = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  signIn() {
    _auth.signInWithEmailAndPassword(
        email: emailEditingController.text.trim(),
        password: passwordEditingController.text.trim());
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  @override
  void dispose() {
    emailEditingController.dispose();
    passwordEditingController.dispose();
    super.dispose();
  }

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
            top: height * -0.013,
            left: width * 0.0,
            right: width * 0.0,
            child: Image.asset(
              'assets/young_woman_talking_online 1.png',
              scale: 3.5,
            ),
          ),

          /// TextFields And Submit Button...
          Positioned(
            top: height * 0.23,
            left: width * 0.05,
            right: width * 0.05,
            bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.2,
                  ),

                  /// Email field
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.03),
                    child: TextFormField(
                      controller: emailEditingController,
                      textInputAction: TextInputAction.next,
                      autofocus: false,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                          fontSize: height * 0.02,
                          color: Colors.black,
                          fontFamily: ConstantFonts.poppinsRegular),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: InputBorder.none,
                        hintText: 'Email',
                        filled: true,
                        fillColor: ConstantColor.background1Color,
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 6.0, top: 8.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: ConstantColor.background1Color),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ('Email required');
                        }
                        return null;
                      },
                      onSaved: (value) {
                        emailEditingController.text = value!;
                      },
                    ),
                  ),

                  /// Password Field
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.03),
                    child: TextFormField(
                      controller: passwordEditingController,
                      textInputAction: TextInputAction.done,
                      autofocus: false,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: !_showPassword,
                      style: TextStyle(
                          fontSize: height * 0.02,
                          color: Colors.black,
                          fontFamily: ConstantFonts.poppinsRegular),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.password),
                        border: InputBorder.none,
                        hintText: 'Password',
                        filled: true,
                        fillColor: ConstantColor.background1Color,
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 6.0, top: 8.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: ConstantColor.background1Color),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black.withOpacity(0.5),
                          ),
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ('Passwords Required');
                        }
                        return null;
                      },
                      onSaved: (value) {
                        passwordEditingController.text = value!;
                      },
                    ),
                  ),
                  forgetPasswordWidget(height, const ForgetPasswordScreen()),
                ],
              ),
            ),
          ),

          /// Button...
          Positioned(
            top: height * 0.8,
            left: width * 0.05,
            right: width * 0.05,
            child: buildGestureDetector(height),
          ),

          /// Create Account...
          Positioned(
            top: height * 0.9,
            left: width * 0.05,
            right: width * 0.05,
            child: createAccountWidget(height, const SingInScreen()),
          ),
        ],
      ),
    );
  }

  GestureDetector buildGestureDetector(
    double height,
  ) {
    return GestureDetector(
      onTap: () async {
        // logData = await SharedPreferences.getInstance();
        setState(() {
          // logData.setBool('login', true);
          signIn();
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
            'Login',
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

  Widget createAccountWidget(double height, Widget screen) {
    return GestureDetector(
      onTap: () {
        setState(() {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => screen));
        });
      },
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
            text: 'Not a member  ',
            style: TextStyle(
              fontFamily: ConstantFonts.poppinsMedium,
              color: ConstantColor.blackColor,
              fontSize: height * 0.015,
            ),
          ),
          TextSpan(
            text: 'Create a account ?',
            style: TextStyle(
              fontFamily: ConstantFonts.poppinsMedium,
              color: ConstantColor.pinkColor,
              fontSize: height * 0.015,
            ),
          ),
        ]),
      ),
    );
  }

  Widget forgetPasswordWidget(double height, Widget screen) {
    return Padding(
      padding: EdgeInsets.only(top: height * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => screen));
            },
            child: Text(
              'Forgot password ?',
              style: TextStyle(
                fontFamily: ConstantFonts.poppinsMedium,
                color: ConstantColor.pinkColor,
                fontSize: height * 0.015,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget textFiledWidget(
      double height,
      TextInputType textInputType,
      TextInputAction textInputAction,
      String hintName,
      TextEditingController textEditingController,
      TextEditingController textEditingController2,
      String required,
      Icon icon) {
    return Padding(
      padding: EdgeInsets.only(top: height * 0.03),
      child: TextFormField(
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
          suffixIcon: IconButton(
            icon: Icon(
              _showPassword ? Icons.visibility : Icons.visibility_off,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                _showPassword = !_showPassword;
              });
            },
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return (required);
          }
          return null;
        },
        onSaved: (value) {
          textEditingController2.text = value!;
        },
      ),
    );
  }
}

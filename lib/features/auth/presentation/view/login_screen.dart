import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/features/auth/presentation/provider/auth_provider.dart';
import 'package:my_office/features/home/presentation/view/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/utilities/constants/app_color.dart';
import '../../../../core/utilities/custom_widgets/custom_snack_bar.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  late SharedPreferences logData;
  bool _showPassword = false;
  bool _isLoading = false;
  String _email = '';
  String _password = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColor.backGroundColor,
      body: Form(
        key: _formKey,
        child: Stack(
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
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Hi There!!\n',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: height * 0.035,
                      ),
                    ),
                    TextSpan(
                      text: 'Welcome To Team Onwords😎',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: height * 0.020,
                      ),
                    ),
                  ],
                ),
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
                        textInputAction: TextInputAction.next,
                        autofocus: false,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          fontSize: height * 0.02,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(CupertinoIcons.mail_solid),
                          border: InputBorder.none,
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            fontSize: height * 0.02,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          filled: true,
                          fillColor: AppColor.backGroundColor,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'Enter your mail id';
                          } else if (!value.trim().contains('@')) {
                            return 'Enter a valid email!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _email = value!.trim();
                        },
                      ),
                    ),

                    /// Password Field
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.03),
                      child: TextFormField(
                        textInputAction: TextInputAction.done,
                        autofocus: false,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !_showPassword,
                        style: TextStyle(
                          fontSize: height * 0.02,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(CupertinoIcons.padlock_solid),
                          border: InputBorder.none,
                          hintText: 'Password',
                          filled: true,
                          hintStyle: TextStyle(
                            fontSize: height * 0.02,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          fillColor: AppColor.backGroundColor,
                          contentPadding: const EdgeInsets.only(
                            left: 14.0,
                            bottom: 6.0,
                            top: 8.0,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
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
                            splashRadius: 20.0,
                          ),
                        ),
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return ('Enter the password');
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _password = value!.trim();
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
              top: height * 0.75,
              left: width * 0.05,
              right: width * 0.05,
              child: buildGestureDetector(height),
            ),

          ],
        ),
      ),
    );
  }

  Widget buildGestureDetector(
    double height,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: submitForm,
      child: Ink(
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
          child: _isLoading
              ? Lottie.asset(
                  "assets/animations/loading.json",
                )
              : Text(
                  'Log in',
                  style: TextStyle(
                    color: AppColor.backGroundColor,
                    fontSize: height * 0.033,
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
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        });
      },
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Not a member  ',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: height * 0.015,
              ),
            ),
            TextSpan(
              text: 'Create an account ?',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColor.primaryColor,
                fontSize: height * 0.015,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget forgetPasswordWidget(double height, Widget screen) {
    return Padding(
      padding: EdgeInsets.only(top: height * 0.025, right: height * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => screen),
              );
            },
            child: Text(
              'Forgot password?',
              style: TextStyle(
                color: AppColor.primaryColor,
                fontSize: height * 0.02,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //FUNCTIONS
  Future<void> submitForm() async {
    final valid = _formKey.currentState!.validate();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (valid) {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();
      final response = await authProvider.onLogin(
        email: _email,
        password: _password,
      );
      if (response != null) {
        setState(() {
          _isLoading = false;
        });
        if (!mounted) return;
        CustomSnackBar.showErrorSnackbar(
          context: context,
          message: 'Provide valid email and password!!',
        );
      } else {
        if(!mounted)return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const UserHomeScreen()),
          (route) => false,
        );
      }
    }
  }
}

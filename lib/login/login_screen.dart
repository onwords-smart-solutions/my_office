import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
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
      backgroundColor: ConstantColor.background1Color,
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
                        textInputAction: TextInputAction.next,
                        autofocus: false,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                            fontSize: height * 0.02,
                            color: Colors.black,
                            fontFamily: ConstantFonts.poppinsRegular),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Iconsax.user),
                          border: InputBorder.none,
                          hintText: 'Email',
                          filled: true,
                          fillColor: ConstantColor.background1Color,
                          // contentPadding: const EdgeInsets.only(
                          //     left: 14.0, bottom: 6.0, top: 8.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: ConstantColor.background1Color),
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
                            return 'Email required';
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
                            fontFamily: ConstantFonts.poppinsRegular),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Iconsax.lock),
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
                            return ('Password Required');
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
                ? const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  )
                : Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: ConstantFonts.poppinsMedium,
                      color: ConstantColor.background1Color,
                      fontSize: height * 0.030,
                    ),
                  ),
          )),
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

  //FUNCTIONS
  Future<void> submitForm() async {
    final valid = _formKey.currentState!.validate();
    if (valid) {
      if(!mounted)return;
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();
      await signIn();
    }
  }

  Future<void> signIn() async {
    final navigator = Navigator.of(context);
    try {
      await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      if(!mounted)return;
      setState(() {
        _isLoading = false;
      });
      if (e.code.contains('invalid-email')) {
        showErrorSnackbar(message: 'Provide a valid email');
      } else if (e.code.contains('user-not-found')) {
        showErrorSnackbar(message: 'No user associates with this email');
      } else if (e.code.contains('wrong-password')) {
        showErrorSnackbar(message: 'Invalid password');
      } else {
        showErrorSnackbar(message: 'Something went wrong. try again!');
      }
    }
  }

  //SNACK BAR
  void showErrorSnackbar({required String message}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 0.0,
        content: Text(
          message,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              fontSize: 12.0),
        ),
      ),
    );
  }
}

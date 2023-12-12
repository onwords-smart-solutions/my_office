import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/features/auth/data/repository/auth_repo_impl.dart';
import 'package:my_office/features/auth/domain/repository/auth_repository.dart';
import 'package:my_office/features/auth/presentation/provider/authentication_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/utilities/constants/app_color.dart';
import '../../../../core/utilities/custom_widgets/custom_snack_bar.dart';
import '../../../../main.dart';
import '../../data/data_source/auth_fb_data_souce_impl.dart';
import '../../data/data_source/auth_fb_data_source.dart';
import '../../data/data_source/auth_local_data_source.dart';
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
      onTap: _isLoading ? null : submitForm,
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
                  "assets/animations/loading.json"
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
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      await _signIn();
    } catch (e) {
      Exception('Error caught while saving form key! $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signIn() async {
    late FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    late FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
    late AuthFbDataSource authFbDataSource = AuthFbDataSourceImpl(
      firebaseDatabase,
      firebaseAuth,
    );
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    late AuthLocalDataSourceImpl authLocalDataSourceImpl =
        AuthLocalDataSourceImpl(
      sharedPreferences,
    );
    late AuthRepository authRepository = AuthRepoImpl(
      authFbDataSource,
      authLocalDataSourceImpl,
    );
    try {
      log("called");
      final userCredential =
          await authRepository.signIn(email: _email, password: _password);
      await _fetchAndProcessStaffDetails(userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      print("error $e");
      // Handle Firebase specific errors
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      if (e.code.contains('Invalid-email')) {
        CustomSnackBar.showErrorSnackbar(message: 'Provide a valid email', context: context);
      } else if (e.code.contains('user-not-found')) {
        CustomSnackBar.showErrorSnackbar(message: 'No user associates with this email', context: context);
      } else if (e.code.contains('wrong-password')) {
        CustomSnackBar.showErrorSnackbar(message: 'Invalid password', context: context);
      } else {
        CustomSnackBar.showErrorSnackbar(message: 'Something went wrong. try again!', context: context);
      }
    } catch (e) {
      // Handle other errors
    }
  }

  Future<void> _fetchAndProcessStaffDetails(String uid) async {
    final navigator = Navigator.of(context);

    late FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    late FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
    late AuthFbDataSource authFbDataSource = AuthFbDataSourceImpl(
      firebaseDatabase,
      firebaseAuth,
    );
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    late AuthLocalDataSourceImpl authLocalDataSourceImpl =
        AuthLocalDataSourceImpl(
      sharedPreferences,
    );
    late AuthRepository authRepository = AuthRepoImpl(
      authFbDataSource,
      authLocalDataSourceImpl,
    );
    final staff = await authRepository.getStaff(
      uid,
      await authLocalDataSourceImpl.getUniqueID(),
    );
    if (staff != null) {
      // Process staff details, e.g., navigate to a new screen or update state
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AuthenticationScreen()),
        (route) => false,
      );
      _initUserData();
    } else {
      // Handle case where staff details are not found
      CustomSnackBar.showErrorSnackbar(
          message: 'Something went wrong. Try again', context: context);
      try {
        FirebaseAuth.instance.signOut();
      } catch (e) {
        print('user not logged in $e');
      }
    }
  }

  Future<void> _initUserData() async {
    late FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    late FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
    late AuthFbDataSource authFbDataSource = AuthFbDataSourceImpl(
      firebaseDatabase,
      firebaseAuth,
    );
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    late AuthLocalDataSourceImpl authLocalDataSourceImpl =
        AuthLocalDataSourceImpl(
      sharedPreferences,
    );
    late AuthRepository authRepository = AuthRepoImpl(
      authFbDataSource,
      authLocalDataSourceImpl,
    );

    final context = this.context;
    if (FirebaseAuth.instance.currentUser != null) {
      final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
      final response = await authRepository.getStaff(
          FirebaseAuth.instance.currentUser!.uid,
          await authLocalDataSourceImpl.getUniqueID());
      log("Logged user is $response");
      authProvider.user = response;
    }
  }
}

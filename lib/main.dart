import 'package:after_layout/after_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/home/home_screen.dart';
import 'package:my_office/home/user_home_screen.dart';
import 'package:my_office/login/login_screen.dart';
import 'package:my_office/util/main_template.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'introduction/intro_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Console',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: ConstantColor.backgroundColor,
          fontFamily: 'PoppinsRegular',
      ),
      home:  const InitialScreen(),
    );
  }
}



class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  InitialScreenState createState() =>  InitialScreenState();
}

class InitialScreenState extends State<InitialScreen> with AfterLayoutMixin<InitialScreen> {

  Future checkFirstSeen() async {
    final navigation=Navigator.of(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = (prefs.getBool('seen') ?? false);

    if (seen) {
     navigation .pushReplacement(
           MaterialPageRoute(builder: (context) =>  const AuthenticationScreen()));
    } else {
      await prefs.setBool('seen', true);
      navigation.pushReplacement(
           MaterialPageRoute(builder: (context) =>  const IntroductionScreen()));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      backgroundColor: ConstantColor.blackColor,
      body:  Center(
        child:  Text('Loading...'),
      ),
    );
  }
}


class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // print('iam inside of home ');
            // return const HomeScreen();
            return const  UserHomeScreen();
          } else {
            // print('iam inside of login ');
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
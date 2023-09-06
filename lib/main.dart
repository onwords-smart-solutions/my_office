import 'dart:developer';

import 'package:after_layout/after_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/PR/visit/visit_form_screen.dart';
import 'package:my_office/home/user_home_screen.dart';
import 'package:my_office/login/login_screen.dart';
import 'package:my_office/models/staff_model.dart';
import 'package:my_office/util/notification_services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'PR/invoice_generator/models/providers.dart';
import 'PR/invoice_generator/quotation_template/provider/providers.dart';
import 'PR/invoice_generator/screens/client_detials.dart';
import 'firebase_options.dart';
import 'introduction/intro_screen.dart';
import 'models/visit_model.dart';

/// version: 1.1.3+16 Updated On (14/03/2023)

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //Hive database Setup
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(StaffModelAdapter().typeId)) {
    Hive.registerAdapter(StaffModelAdapter());
  }
  if (!Hive.isAdapterRegistered(VisitModelAdapter().typeId)) {
    Hive.registerAdapter(VisitModelAdapter());
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]).then(
    (value) => runApp(
      const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final NotificationService _notificationService = NotificationService();
  bool isAllowed = false;

  @override
  void initState() {
    _notificationService.initializePlatformNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => InvoiceProvider()),
        ChangeNotifierProvider(create: (context) => Invoice1Provider()),
      ],
      child: MaterialApp(
        title: 'My Office',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.amber,
          scaffoldBackgroundColor: const Color(0xffEEEEEE),
          fontFamily: 'sfPro',
        ),
        home: const InitialScreen(),
        routes: {
          '/visitResume': (_) => const VisitFromScreen(),
          '/invoiceGenerator': (_) => const ClientDetails(),
        },
      ),
    );
  }
}

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  InitialScreenState createState() => InitialScreenState();
}

class InitialScreenState extends State<InitialScreen> with AfterLayoutMixin<InitialScreen> {
  Future checkFirstSeen() async {
    final navigation = Navigator.of(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = (prefs.getBool('seen') ?? false);

    if (seen) {
      navigation.pushReplacement(MaterialPageRoute(builder: (context) => const AuthenticationScreen()));
    } else {
      await prefs.setBool('seen', true);
      navigation.pushReplacement(MaterialPageRoute(builder: (context) => const IntroductionScreen()));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: ConstantColor.blackColor,
      body: Center(
        child: Text('Loading...'),
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
            return const UserHomeScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}

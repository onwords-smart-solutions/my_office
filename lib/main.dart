import 'dart:developer';
import 'package:after_layout/after_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/PR/visit/visit_form_screen.dart';
import 'package:my_office/firebase_options.dart';
import 'package:my_office/home/user_home_screen.dart';
import 'package:my_office/login/login_screen.dart';
import 'package:my_office/models/staff_model.dart';
import 'package:my_office/provider/user_provider.dart';
import 'package:my_office/birthday_picker_screen.dart';
import 'package:my_office/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'PR/invoice_generator/models/providers.dart';
import 'PR/invoice_generator/quotation_template/provider/providers.dart';
import 'PR/invoice_generator/screens/client_detials.dart';
import 'introduction/intro_screen.dart';
import 'models/visit_model.dart';

/// version: 1.1.3+16 Updated On (14/03/2023)

final navigationKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
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
  final UserProvider _userProvider = UserProvider();
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    _notificationService.initializePlatformNotifications();
    _getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => _userProvider),
        ChangeNotifierProvider(create: (context) => InvoiceProvider()),
        ChangeNotifierProvider(create: (context) => Invoice1Provider()),
      ],
      child: MaterialApp(
        navigatorKey: navigationKey,
        title: 'My Office',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.amber,
          scaffoldBackgroundColor: const Color(0xffEEEEEE),
          fontFamily: 'sfPro',
        ),
        home: const InitialScreen(),
        // home: const Sample(),
        routes: {
          '/visitResume': (_) => const VisitFromScreen(),
          '/invoiceGenerator': (_) => const ClientDetails(),
        },
      ),
    );
  }

  Future<void> _getUserInfo() async {
    await _userProvider.initiateUser();
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
            return Consumer<UserProvider>(
              builder: (ctx, userProvider, child) {
                return userProvider.user != null
                    ? userProvider.user!.dob == 0
                        ? BirthdayPickerScreen()
                        : child!
                    : const Loading();
              },
              child: const UserHomeScreen(),
            );
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> isShown = ValueNotifier(false);
    Future.delayed(const Duration(seconds: 10), () => isShown.value = true);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/animations/new_loading.json'),
          ValueListenableBuilder(
            valueListenable: isShown,
            builder: (ctx, isVisible, child) {
              return isVisible ? child! : const SizedBox.shrink();
            },
            child: ElevatedButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                await FirebaseAuth.instance.signOut();
                final pref = await SharedPreferences.getInstance();
                await pref.clear();
                Provider.of<UserProvider>(context, listen: false).clearUser();
                navigator.pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: const Text('Reset session'),
            ),
          ),
        ],
      ),
    );
  }
}

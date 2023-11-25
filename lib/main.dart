import 'dart:developer';
import 'package:after_layout/after_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/features/auth/presentation/provider/auth_provider.dart';
import 'package:my_office/features/create_lead/presentation/provider/create_lead_provider.dart';
import 'package:my_office/features/create_product/presentation/provider/create_product_provider.dart';
import 'package:my_office/features/employee_of_the_week/presentation/provider/employee_of_the_week_provider.dart';
import 'package:my_office/features/home/presentation/provider/home_provider.dart';
import 'package:my_office/features/pr_reminder/presentation/provider/pr_reminder_provider.dart';
import 'package:my_office/features/proxy_attendance/presentation/provider/proxy_attendance_provider.dart';
import 'package:my_office/features/search_leads/presentation/provider/feedback_button_provider.dart';
import 'package:my_office/features/staff_details/presentation/provider/staff_detail_provider.dart';
import 'package:my_office/features/auth/presentation/view/phone_number_screen.dart';
import 'package:my_office/features/auth/presentation/view/birthday_picker_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/auth/data/data_source/auth_fb_data_souce_impl.dart';
import 'features/auth/data/data_source/auth_fb_data_source.dart';
import 'features/auth/data/data_source/auth_local_data_source.dart';
import 'features/auth/data/repository/auth_repo_impl.dart';
import 'features/auth/domain/repository/auth_repository.dart';
import 'features/auth/presentation/view/intro_screen.dart';
import 'features/auth/presentation/view/login_screen.dart';
import 'features/home/presentation/view/home_screen.dart';
import 'package:my_office/core/utilities/injection_container.dart' as di;

import 'features/invoice_generator/presentation/provider/invoice_generator_provider.dart';
import 'features/invoice_generator/presentation/view/client_details_screen.dart';
import 'features/notifications/presentation/notification_view_model.dart';
import 'features/quotation_template/presentation/provider/invoice_provider.dart';

/// version: 1.1.3+16 Updated On (14/03/2023)

final navigationKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]).then(
    (value) => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>(
            create: (_) => di.sl<AuthProvider>(),
          ),
          ChangeNotifierProvider<HomeProvider>(
            create: (_) => di.sl<HomeProvider>(),
          ),
          ChangeNotifierProvider<EmployeeProvider>(
            create: (_) => di.sl<EmployeeProvider>(),
          ),
          ChangeNotifierProvider<CreateLeadProvider>(
            create: (_) => di.sl<CreateLeadProvider>(),
          ),
          ChangeNotifierProvider<CreateProductProvider>(
            create: (_) => di.sl<CreateProductProvider>(),
          ),
          ChangeNotifierProvider<ProxyAttendanceProvider>(
            create: (_) => di.sl<ProxyAttendanceProvider>(),
          ),
          ChangeNotifierProvider<PrReminderProvider>(
            create: (_) => di.sl<PrReminderProvider>(),
          ),
          ChangeNotifierProvider<StaffDetailProvider>(
            create: (_) => di.sl<StaffDetailProvider>(),
          ),
          ChangeNotifierProvider(
            create: (context) => InvoiceGeneratorProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => Invoice1Provider(),
          ),
          ChangeNotifierProvider<FeedbackButtonProvider>(
            create: (_) => di.sl<FeedbackButtonProvider>(),
          ),
        ],
        child: const MyApp(),
      ),
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
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final response = await authRepository.getStaff(FirebaseAuth.instance.currentUser!.uid, await authLocalDataSourceImpl.getUniqueID());
        authProvider.user = response;
    }
  }

  @override
  void initState() {
    _notificationService.initializePlatformNotifications();
    _initUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigationKey,
      title: 'My Office',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: const Color(0xffEEEEEE),
        fontFamily: 'Roboto',
      ),
      home: const InitialScreen(),
      routes: {
        //   '/visitResume': (_) => const VisitFromScreen(),
        '/invoiceGenerator': (_) => const ClientDetails(),
      },
    );
  }
}


class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  InitialScreenState createState() => InitialScreenState();
}

class InitialScreenState extends State<InitialScreen>
    with AfterLayoutMixin<InitialScreen> {
  Future checkFirstSeen() async {
    final navigation = Navigator.of(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = (prefs.getBool('seen') ?? false);

    if (seen) {
      navigation.pushReplacement(
        MaterialPageRoute(
          builder: (context) => const AuthenticationScreen(),
        ),
      );
    } else {
      await prefs.setBool('seen', true);
      navigation.pushReplacement(
        MaterialPageRoute(builder: (context) => const IntroductionScreen()),
      );
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
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
            return Consumer<AuthProvider>(
              builder: (ctx, userProvider, child) {
                return userProvider.user != null
                    ? userProvider.user!.dob == 0
                        ? BirthdayPickerScreen()
                        : userProvider.user!.mobile == 0
                            ? const PhoneNumberScreen()
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
                Provider.of<AuthProvider>(context, listen: false).clearUser();
                navigator.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
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

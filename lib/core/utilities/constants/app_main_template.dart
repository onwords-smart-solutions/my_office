import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/features/auth/presentation/provider/authentication_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../features/auth/presentation/view/login_screen.dart';

class MainTemplate extends StatelessWidget {
  final Widget templateBody;
  final String? subtitle;
  final Color bgColor;

  const MainTemplate({
    Key? key,
    this.subtitle,
    required this.templateBody,
    required this.bgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<AuthenticationProvider>(
        builder: (ctx, userProvider, child) {
          return userProvider.user == null ? _loading(context) : templateBody;
        },
      ),
    );
  }

  Widget _loading(BuildContext context) {
    ValueNotifier<bool> isShown = ValueNotifier(false);
    Future.delayed(const Duration(seconds: 10), () => isShown.value = true);

    return Column(
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
              // Provider.of<UserProvider>(context, listen: false).clearUser();
              navigator.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reset session'),
          ),
        ),
      ],
    );
  }
}

//TIME OF DAY GREETING IN HOME SCREEN
String greeting() {
  var hour = DateTime.now().hour;
  if (hour < 12) {
    return "Good morning, Today's ur day🤗";
  } else if (hour < 16) {
    return "Good noon, Stay focused😍";
  } else {
    return "Good evening, Let's do it🤩";
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/auth/presentation/view/login_screen.dart';
import '../provider/user_provider.dart';

class NoUser extends StatelessWidget {
  const NoUser({Key? key}) : super(key: key);

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

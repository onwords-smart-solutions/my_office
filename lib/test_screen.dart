import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_office/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/auth/presentation/view/login_screen.dart';

class TestScreen extends StatelessWidget{
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () async {
            final navigator = Navigator.of(context);
            await FirebaseAuth.instance.signOut();
            final pref = await SharedPreferences.getInstance();
            await pref.clear();
            Provider.of<UserProvider>(context, listen: false).clearUser();
            navigator.pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
          },
          child: Text(
          'Log out',
          ),
        ),
      ),
    );
  }
}
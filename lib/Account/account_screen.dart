import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:my_office/models/staff_model.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';

import '../database/hive_operations.dart';
import '../login/login_screen.dart';

class AccountScreen extends StatefulWidget {
  final StaffModel staffDetails;

  const AccountScreen({Key? key, required this.staffDetails}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xffEEF0FE),
            Color(0xffEEF0FE),
            Color(0xffEEF0FE),
          ], end: Alignment.bottomRight, begin: Alignment.topLeft),
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    top: height * 0.08,
                    left: width * 0.2,
                    right: width * 0.2,
                    child: DelayedDisplay(
                      delay: 0.6.seconds,
                      child: WidgetCircularAnimator(
                        innerColor: Colors.orange,
                        outerColor: Colors.black,
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: const Offset(2, 2),
                                spreadRadius: 2,
                                blurRadius: 0,
                              ),
                              const BoxShadow(
                                  color: Color(0xffEEF0FE),
                                  offset: Offset(2, 2),
                                  spreadRadius: 2,
                                  blurRadius: 5),
                            ],
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: height * 0.38,
                    left: 0,
                    right: 0,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: width * 0.05),
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.10, vertical: height * 0.03),
                      height: height * 0.4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          DelayedDisplay(
                              delay: 1.seconds,
                              child: buildText(height, width, 'Name',
                                  widget.staffDetails.name)),
                          DelayedDisplay(
                            delay: 1.2.seconds,
                            child: buildText(height, width, 'Email',
                                widget.staffDetails.email),
                          ),
                          DelayedDisplay(
                              delay: 1.4.seconds,
                              child: buildText(height, width, 'Department',
                                  widget.staffDetails.department)),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: height * 0.80,
                    left: 0,
                    right: 0,
                    child: DelayedDisplay(
                      delay: 1.6.seconds,
                      child: Center(
                        child: TextButton.icon(
                          onPressed: () async {
                            final navigator = Navigator.of(context);
                            await FirebaseAuth.instance.signOut();
                            await HiveOperations().clearDetails();

                            navigator.pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()),
                                (route) => false);
                          },
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.black),
                          label: Text('Log out',
                              style: TextStyle(
                                  fontSize: height * 0.020,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          icon: const Icon(Icons.logout_rounded),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildText(double height, double width, String title, String value) =>
      Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        margin: EdgeInsets.symmetric(vertical: height * 0.01),
        height: height * 0.09,
        decoration: BoxDecoration(
            color: const Color(0xffEEF0FE),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: height * 0.015,
                fontWeight: FontWeight.bold,
                color: Colors.black26,
              ),
            ),
            Text(value,
                style: TextStyle(
                    fontSize: height * 0.018,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            const Divider(
              // height: height * 0.03,
              color: Colors.black54,
              thickness: 1.0,
            ),
          ],
        ),
      );
}

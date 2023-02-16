import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';
import 'package:my_office/database/hive_operations.dart';
import 'package:my_office/login/login_screen.dart';
import 'package:my_office/models/staff_model.dart';

class StaffDetail extends StatelessWidget {
  final StaffModel details;

  const StaffDetail({Key? key, required this.details}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: ConstantColor.backgroundColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Positioned(
                top: 10.0,
                child: Text(
                  'Profile',
                  style: TextStyle(
                      fontFamily: ConstantFonts.poppinsMedium,
                      fontSize: 16.0,
                      color: Colors.white),
                ),
              ),
              Container(
                width: size.width * .8,
                height: size.height * .6,
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(color: Colors.black87, blurRadius: 20.0)
                    ],
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  clipBehavior: Clip.none,
                  children: [
                    const Positioned(
                      top: -50,
                      left: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 70.0,
                        backgroundColor: Color(0xffFFACAC),
                        child: Icon(
                          Icons.person_outline_rounded,
                          size: 100.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 80.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                details.name,
                                style: TextStyle(
                                    fontFamily: ConstantFonts.poppinsMedium,
                                    fontSize: 20.0),
                              ),
                              Text(
                                details.email,
                                style: TextStyle(
                                    fontFamily: ConstantFonts.poppinsMedium,
                                    fontSize: 15.0),
                              ),
                            ],
                          ),
                          const SizedBox(height: 100.0),
                          TextButton.icon(
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
                            label: const Text('Log out'),
                            icon: const Icon(Icons.logout_rounded),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

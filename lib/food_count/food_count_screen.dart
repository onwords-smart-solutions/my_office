import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/util/main_template.dart';

import '../Constant/fonts/constant_font.dart';
import '../constant/colors/constant_colors.dart';
import 'food_count_staff_detail_screen.dart';

class FoodCountScreen extends StatefulWidget {
  const FoodCountScreen({Key? key}) : super(key: key);

  @override
  State<FoodCountScreen> createState() => _FoodCountScreenState();
}

class _FoodCountScreenState extends State<FoodCountScreen> {
  List<String> staffNames = [];
  bool isLoading = true;
  final ref = FirebaseDatabase.instance.ref();

  void getStaffNames() {
    ref.child('staff').once().then((staffSnapshot) {
      for (var data in staffSnapshot.snapshot.children) {
        var fbData = data.value as Map<Object?, Object?>;
        final name = fbData['name'].toString();
        staffNames.add(name);
      }

      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    getStaffNames();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
        subtitle: 'Food count detail',
        templateBody: buildBody(),
        bgColor: ConstantColor.background1Color);
  }

  Widget buildBody() {
    return isLoading
        ? Center(
            child: Lottie.asset(
              "assets/animations/new_loading.json",
            ),
          )
        : ListView.builder(
            itemCount: staffNames.length,
            itemBuilder: (ctx, i) {
              return Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: ConstantColor.background1Color,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0.0, 2.0),
                      blurRadius: 8,
                    )
                  ],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: ListTile(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => FoodCountStaffDetailScreen(
                          staffName: staffNames[i],
                        ),
                      ),
                    ),
                    leading: const CircleAvatar(
                      radius: 20,
                      child: Icon(CupertinoIcons.person_2_fill),
                    ),
                    title: Text(
                      staffNames[i],
                      style: TextStyle(
                          fontFamily: ConstantFonts.sfProMedium,
                          color: ConstantColor.blackColor,
                          fontSize: MediaQuery.of(context).size.height * 0.021),
                    ),
                  ),
                ),
              );
            },
    );
  }
}

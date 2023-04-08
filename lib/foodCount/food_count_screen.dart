import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/foodCount/food_count_staff_detail_screen.dart';
import 'package:my_office/util/main_template.dart';

import '../Constant/fonts/constant_font.dart';
import '../constant/colors/constant_colors.dart';

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
              "assets/animations/loading.json",
            ),
          )
        : ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: staffNames.length,
            itemBuilder: (ctx, i) {
              return Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ConstantColor.background1Color,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(-0.0, 5.0),
                      blurRadius: 8,
                    )
                  ],
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Center(
                  child: ListTile(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => FoodCountStaffDetailScreen(
                            staffName: staffNames[i]))),
                    leading: const CircleAvatar(
                      radius: 20,
                      backgroundColor: ConstantColor.backgroundColor,
                      child: Icon(Icons.person),
                    ),
                    title: Text(
                      staffNames[i],
                      style: TextStyle(
                          fontFamily: ConstantFonts.poppinsMedium,
                          color: ConstantColor.blackColor,
                          fontSize: MediaQuery.of(context).size.height * 0.020),
                    ),
                  ),
                ),
              );
            });
  }
}

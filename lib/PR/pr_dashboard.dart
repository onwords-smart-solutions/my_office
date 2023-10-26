import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/util/main_template.dart';

import '../models/staff_entry_model.dart';

class PrDashboard extends StatefulWidget {
  const PrDashboard({super.key});

  @override
  State<PrDashboard> createState() => _PrDashboardState();
}

class _PrDashboardState extends State<PrDashboard> {
  TextEditingController totalPrGetTarget = TextEditingController();
  TextEditingController totalPrTarget = TextEditingController();

  //Get PR Dashboard data
  void prDashboardDetails() {
    final ref = FirebaseDatabase.instance.ref();
    ref.child('PRDashboard').once().then((value) {
      if (value.snapshot.exists) {
        for (var prTarget in value.snapshot.children) {
          if (prTarget.key!.contains('prtarget')) {
            final data = prTarget.value as Map<Object?, Object?>;
            totalPrGetTarget.text = data['totalprgettarget'].toString();
            totalPrTarget.text = data['totalprtarget'].toString();
          }
        }
      }
    });
  }

  //Update PR Dashboard data
  Future<void> updatePrDashboard() async {
    if(totalPrGetTarget.text.isEmpty || totalPrTarget.text.isEmpty){
      final snackBar = SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        behavior: SnackBarBehavior.floating,
        content: const Text(
          'Enter all PR data',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    else{
      final ref = FirebaseDatabase.instance.ref();
      await ref.child('PRDashboard/prtarget').update({
        'totalprgettarget': totalPrGetTarget.text,
        'totalprtarget': totalPrTarget.text,
      });
      final snackBar = SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        behavior: SnackBarBehavior.floating,
        content: const Text(
          'PR data has been updated!!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    prDashboardDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      templateBody: buildPrDashboard(),
      bgColor: ConstantColor.background1Color,
    );
  }

  Widget buildPrDashboard() {
    return SingleChildScrollView(
      child: SafeArea(
        minimum: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Text(
              'PR status details'.toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 17,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  'Current PR status',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.purple,
                    fontSize: 17,
                  ),
                ),
                Flexible(
                  child: SizedBox(
                    width: 130,
                    child: TextField(
                      style: const TextStyle(
                        height: 1,
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      controller: totalPrGetTarget,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: CupertinoColors.systemGrey,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: CupertinoColors.systemPurple,
                            width: 2,
                          ),
                        ),
                        hintText: 'PR Get Target',
                        hintStyle: const TextStyle(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  '       PR Target           ',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.purple,
                    fontSize: 17,
                  ),
                ),
                Flexible(
                  child: SizedBox(
                    width: 130,
                    child: TextField(
                      style: const TextStyle(
                        height: 1,
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      controller: totalPrTarget,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: CupertinoColors.systemGrey,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: CupertinoColors.systemPurple,
                            width: 2,
                          ),
                        ),
                        hintText: 'PR target',
                        hintStyle: const TextStyle(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: updatePrDashboard,
              child: const Text(
                'Update',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
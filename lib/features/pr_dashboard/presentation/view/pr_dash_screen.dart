import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_office/features/pr_dashboard/presentation/provider/pr_dash_provider.dart';
import 'package:provider/provider.dart';
import '../../../../core/utilities/constants/app_color.dart';
import '../../../../core/utilities/constants/app_main_template.dart';

class PrDashboard extends StatefulWidget {
  const PrDashboard({super.key});

  @override
  State<PrDashboard> createState() => _PrDashboardState();
}

class _PrDashboardState extends State<PrDashboard> {
  TextEditingController totalPrGetTarget = TextEditingController();
  TextEditingController totalPrTarget = TextEditingController();

  @override
  void initState() {
    Provider.of<PrDashProvider>(context, listen: false).fetchPrDashboardDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      templateBody: buildPrDashboard(),
      bgColor: AppColor.backGroundColor,
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
              onPressed: (){},
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
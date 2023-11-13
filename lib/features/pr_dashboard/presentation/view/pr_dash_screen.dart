
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_office/core/utilities/custom_widgets/custom_snack_bar.dart';
import 'package:my_office/features/pr_dashboard/data/data_source/pr_dash_fb_data_source_impl.dart';
import 'package:my_office/features/pr_dashboard/data/repository/pr_dash_repo_impl.dart';
import 'package:my_office/features/pr_dashboard/domain/repository/pr_dash_repository.dart';
import 'package:my_office/features/pr_dashboard/domain/use_case/pr_dashboard_details_use_case.dart';
import 'package:my_office/features/pr_dashboard/domain/use_case/update_pr_dashboard_use_case.dart';
import '../../../../core/utilities/constants/app_color.dart';
import '../../../../core/utilities/constants/app_main_template.dart';
import '../../data/data_source/pr_dash_fb_data_source.dart';

class PrDashboard extends StatefulWidget {
  const PrDashboard({super.key});

  @override
  State<PrDashboard> createState() => _PrDashboardState();
}

class _PrDashboardState extends State<PrDashboard> {
  TextEditingController totalPrGetTarget = TextEditingController();
  TextEditingController totalPrTarget = TextEditingController();

  late final PrDashFbDataSource _prDashFbDataSource = PrDashFbDataSourceImpl();
  late PrDashRepository prDashRepository = PrDashRepoImpl(_prDashFbDataSource);
  late PrDashboardCase prDashboardCase = PrDashboardCase(prDashRepository: prDashRepository);
  late UpdatePrDashboardCase updatePrDashboardCase = UpdatePrDashboardCase(prDashRepository: prDashRepository);

  @override
  void initState() {
    prDashboardDetails();
    super.initState();
  }

  void prDashboardDetails() async {
    Map<String, dynamic> data = await prDashboardCase.execute();
    if (data.isNotEmpty) {
      totalPrGetTarget.text = data['totalprgettarget'].toString();
      totalPrTarget.text = data['totalprtarget'].toString();
    }
  }

  Future<void> updatePrDashboard() async {
    try {
      await updatePrDashboardCase.execute(totalPrGetTarget.text, totalPrTarget.text);
      if(!mounted) return;
      CustomSnackBar.showSuccessSnackbar(
          message: 'PR dashboard has been updated!',
          context: context,
      );
      Navigator.pop(context);
    } on Exception catch (e) {
      CustomSnackBar.showErrorSnackbar(
        message: 'Error caught while updating PR dashboard $e!',
        context: context,
      );
    }
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
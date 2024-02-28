import 'package:flutter/material.dart';
import 'package:my_office/core/utilities/constants/app_main_template.dart';
import 'package:my_office/features/pr_bucket/presentation/provider/pr_bucket_provider.dart';
import 'package:my_office/features/pr_bucket/presentation/view/pr_buckets_name_screen.dart';
import 'package:provider/provider.dart';

import '../../../../core/utilities/constants/app_color.dart';

class PrStaffNames extends StatefulWidget {
  const PrStaffNames({super.key});

  @override
  State<PrStaffNames> createState() => _PrStaffNamesState();
}

class _PrStaffNamesState extends State<PrStaffNames> {

  @override
  void initState() {
    super.initState();
    fetchPrNames();
  }

  void fetchPrNames() {
    final provider = Provider.of<PrBucketProvider>(context, listen: false);
    provider.getPrNames();
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      subtitle: 'PR Staffs',
      templateBody: getPrStaffNames(),
      bgColor: AppColor.backGroundColor,
    );
  }

  Widget getPrStaffNames() {
    return Consumer<PrBucketProvider>(
      builder: (context, prNames, child) {
        if (prNames.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (prNames.staffNames.isEmpty) {
          return const Center(child: Text('No PR staffs found'));
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: prNames.staffNames.length,
            itemBuilder: (ctx, index) {
              return Card(
                surfaceTintColor: Colors.transparent,
                color: Theme.of(context).scaffoldBackgroundColor ==
                        const Color(0xFF1F1F1F)
                    ? Colors.grey.withOpacity(.2)
                    : Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    prNames.staffNames[index],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => PrBucketNames(
                                  staffName: prNames.staffNames[index],
                                ),
                        ),
                    );
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}

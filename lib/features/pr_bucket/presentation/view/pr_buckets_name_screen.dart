import 'package:flutter/material.dart';
import 'package:my_office/core/utilities/constants/app_color.dart';
import 'package:my_office/core/utilities/constants/app_main_template.dart';
import 'package:my_office/features/pr_bucket/presentation/provider/pr_bucket_provider.dart';
import 'package:my_office/features/pr_bucket/presentation/view/pr_bucket_values_screen.dart';
import 'package:provider/provider.dart';

class PrBucketNames extends StatefulWidget {
  final String staffName;

  const PrBucketNames({super.key, required this.staffName});

  @override
  State<PrBucketNames> createState() => _PrBucketNamesState();
}

class _PrBucketNamesState extends State<PrBucketNames> {
  @override
  void initState() {
    fetchPrBuckets();
    super.initState();
  }

  void fetchPrBuckets() {
    final provider = Provider.of<PrBucketProvider>(context, listen: false);
    provider.prBucketNames(widget.staffName);
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      subtitle: '${widget.staffName} bucket',
      templateBody: getPrBucketNames(),
      bgColor: AppColor.backGroundColor,
    );
  }

  Widget getPrBucketNames() {
    return Consumer<PrBucketProvider>(
      builder: (context, bucketNames, child) {
        if (bucketNames.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (bucketNames.bucketNames.isEmpty) {
          return const Center(
            child: Text('No bucket names found'),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: bucketNames.bucketNames.length,
            itemBuilder: ((ctx, index) {
              List<String> keyValueData = bucketNames.bucketNames[index].split('-');
              String dataKey = keyValueData[0];
              String dataValue = keyValueData[1];
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
                    bucketNames.bucketNames[index],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PrBucketValues(
                          prName: widget.staffName,
                          bucketName: dataKey,
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          );
        }
      },
    );
  }
}

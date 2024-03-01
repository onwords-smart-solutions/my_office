import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_office/core/utilities/constants/app_color.dart';
import 'package:my_office/core/utilities/constants/app_main_template.dart';
import 'package:my_office/features/pr_bucket/presentation/provider/pr_bucket_provider.dart';
import 'package:my_office/features/pr_bucket/presentation/view/pr_bucket_chart_data.dart';
import 'package:my_office/features/pr_bucket/presentation/view/pr_bucket_values_screen.dart';
import 'package:provider/provider.dart';

class PrBucketNames extends StatefulWidget {
  final String staffName;

  const PrBucketNames({super.key, required this.staffName});

  @override
  State<PrBucketNames> createState() => _PrBucketNamesState();
}

class _PrBucketNamesState extends State<PrBucketNames> {
  List<dynamic> customerState = [];

  @override
  void initState() {
    fetchPrBuckets();
    fetchCustomerState();
    super.initState();
  }

  void fetchPrBuckets() {
    final provider = Provider.of<PrBucketProvider>(context, listen: false);
    provider.prBucketNames(widget.staffName);
  }


  Future<List<dynamic>> fetchCustomerState() async {
    final provider = Provider.of<PrBucketProvider>(context, listen: false);
    final bucketNames = provider.bucketNames;
    for (String bucketName in bucketNames) {
      List<String> keyValueData = bucketName.split('-');
      final key = keyValueData[0];
      final value = keyValueData[1];
      List<dynamic> states = await provider.allCustomerData(widget.staffName, key);
      customerState.addAll(states);
    }
    return customerState;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
         '${widget.staffName} bucket',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 25,
          ),
        ),
      ),
      body: getPrBucketNames(),
      floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PrBucketChartData(states: customerState),
                ),
              );
            },
            child: const Icon(Icons.add_chart),
          ),
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
                List<String> keyValueData = bucketNames.bucketNames[index]
                    .split('-');
                String dataKey = keyValueData[0];
                String dataValue = keyValueData[1];
                return Card(
                  surfaceTintColor: Colors.transparent,
                  color: Theme
                      .of(context)
                      .scaffoldBackgroundColor ==
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
                          builder: (_) =>
                              PrBucketValues(
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

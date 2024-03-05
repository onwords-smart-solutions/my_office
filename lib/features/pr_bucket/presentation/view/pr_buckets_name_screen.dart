import 'dart:developer';

import 'package:flutter/material.dart';
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
  Map<String, List<Map<String, String>>> customerState = {};

  @override
  void initState() {
    fetchCustomerState();
    super.initState();
  }

  Future <void> fetchCustomerState() async {
    customerState.clear();
    final provider = Provider.of<PrBucketProvider>(context, listen: false);
    customerState = await provider.allCustomerData(widget.staffName);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PrBucketProvider>(context,listen: false);
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
      floatingActionButton: Consumer<PrBucketProvider>(
        builder: ((context, bucket, child) {
          return bucket.isLoading? const CircularProgressIndicator() :FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PrBucketChartData(states: customerState),
                ),
              );
            },
            child: const Icon(Icons.add_chart),
          );
        }),
      ),
    );
  }


    Widget getPrBucketNames() {
      return Consumer<PrBucketProvider>(
        builder: (context, bucketNames, child) {
          if (bucketNames.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: customerState.keys
                  .toList()
                  .length,
              itemBuilder: ((ctx, index) {
                List<String> keyValueData = customerState.keys.toList()[index]
                    .split('-');
                String dataKey = keyValueData[0];
                // String dataValue = keyValueData[1];
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
                      '${customerState.keys
                          .toList()[index]} - ${customerState[customerState.keys
                          .toList()[index]]!.length}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      log('Customer state is ${customerState}');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PrBucketValues(
                                bucketName: dataKey,
                                bucketValue: customerState[customerState.keys
                                    .toList()[index]]!,
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

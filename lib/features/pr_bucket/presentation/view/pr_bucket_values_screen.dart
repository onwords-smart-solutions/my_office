import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_office/features/pr_bucket/presentation/provider/pr_bucket_provider.dart';
import 'package:my_office/features/pr_bucket/presentation/view/pr_bucket_chart_data.dart';
import 'package:provider/provider.dart';

class PrBucketValues extends StatefulWidget {
  final String prName;
  final String bucketName;

  const PrBucketValues(
      {super.key, required this.prName, required this.bucketName});

  @override
  State<PrBucketValues> createState() => _PrBucketValuesState();
}

class _PrBucketValuesState extends State<PrBucketValues> {
  List<String> selectedValues = [];

  @override
  void initState() {
    fetchBucketValues();
    super.initState();
  }

  void fetchBucketValues() {
    final provider = Provider.of<PrBucketProvider>(context, listen: false);
    provider.bucketDataValues(widget.prName, widget.bucketName);
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
          widget.bucketName,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 25,
          ),
        ),
      ),
      body: getBucketValues(),
      floatingActionButton: Consumer<PrBucketProvider>(
        builder: (context, bucketValue, child) {
          return FloatingActionButton(
            onPressed: () {
              if (bucketValue.bucketValues.isEmpty) {
                return;
              }
              List<String> allValues = bucketValue.bucketValues.map((item) {
                List<String> parts = item.split(" - ");
                return parts[1];
              }).toList();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PrBucketChartData(mobile: allValues),
                ),
              );
            },
            child: const Icon(Icons.add_chart),
          );
        },
      ),
    );
  }

  Widget getBucketValues() {
    return Consumer<PrBucketProvider>(
      builder: (context, bucketValue, child) {
        if (bucketValue.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (bucketValue.bucketValues.isEmpty) {
          return const Center(
            child: Text('No customer data available'),
          );
        } else {
          return ListView.builder(
            itemCount: bucketValue.bucketValues.length,
            itemBuilder: ((ctx, index) {
              String mergedData = bucketValue.bucketValues[index];
              List<String> parts = mergedData.split(" - ");
              String key = parts[0];
              String value = parts[1];
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
                  title: SelectableText(
                    bucketValue.bucketValues[index].toString(),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      if (selectedValues.contains(value)) {
                        selectedValues.remove(value);
                      } else {
                        selectedValues.add(value);
                      }
                    });
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

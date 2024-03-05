import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_office/features/pr_bucket/presentation/view/pr_bucket_chart_data.dart';

class PrBucketValues extends StatefulWidget {
  final String bucketName;
  final List<Map<String, String>> bucketValue;

  const PrBucketValues(
      {super.key, required this.bucketValue,required this.bucketName});

  @override
  State<PrBucketValues> createState() => _PrBucketValuesState();
}

class _PrBucketValuesState extends State<PrBucketValues> {

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
      floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PrBucketChartData(states: {'bucket' : widget.bucketValue}),
                ),
              );
            },
            child: const Icon(Icons.add_chart),
          ),
    );
  }

  Widget getBucketValues() {
    return  ListView.builder(
      itemCount: widget.bucketValue.length,
      itemBuilder: ((ctx, index) {
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
              widget.bucketValue[index].keys.first.toString(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }),
    );
  }
}

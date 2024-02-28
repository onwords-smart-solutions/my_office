import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../provider/pr_bucket_provider.dart';

class PrBucketChartData extends StatefulWidget {
  final List<String> mobile;

  const PrBucketChartData({super.key, required this.mobile});

  @override
  State<PrBucketChartData> createState() => _PrBucketChartDataState();
}

class _PrBucketChartDataState extends State<PrBucketChartData> {
  @override
  void initState() {
    fetchCustomerData();
    super.initState();
  }

  void fetchCustomerData() {
    final provider = Provider.of<PrBucketProvider>(context, listen: false);
    provider.allCustomerData(widget.mobile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PrBucketProvider>(
        builder: (ctx, customerData, child) {
          if (customerData.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (customerData.getCustomerData.isEmpty) {
            return const Center(
              child: Text('No customer data found'),
            );
          } else {
            List<ChartData> chartData = calculateChartData(customerData.getCustomerData);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Total - ${customerData.getCustomerData.length}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SfCircularChart(
                  series: <CircularSeries>[
                    PieSeries<ChartData, String>(
                      dataSource: chartData,
                      pointColorMapper: (ChartData data, _) => data.color,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          labelPosition: ChartDataLabelPosition.outside,
                          connectorLineSettings: ConnectorLineSettings(type: ConnectorType.curve),
                          textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          useSeriesColor: true,
                          labelIntersectAction: LabelIntersectAction.shift,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: chartData.map((data) =>
                        Row(
                          children: [
                            const SizedBox(width: 15),
                            Container(width: 12, height: 12, color: data.color),
                            const SizedBox(width: 5),
                            Text('${data.x} (${data.y})',style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
                          ],
                        ),
                    ).toList(),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
  List<ChartData> calculateChartData(List<dynamic> allData) {
    Map<String, int> stateCounts = {};
    for (var data in allData) {
      stateCounts[data['customer_state']] = (stateCounts[data['customer_state']] ?? 0) + 1;
    }
    return stateCounts.entries.map((entry) => ChartData(entry.key, entry.value, _getRandomColor())).toList();
  }

  Color _getRandomColor() {
    return Color((Random().nextDouble() * 0xffFFFFF).toInt() << 0).withOpacity(1);
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);

  final String x;
  final int y;
  final Color? color;
}

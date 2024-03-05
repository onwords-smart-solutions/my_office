
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PrBucketChartData extends StatefulWidget {
  final Map<String, List<Map<String, String>>> states;

  const PrBucketChartData({super.key, required this.states});

  @override
  State<PrBucketChartData> createState() => _PrBucketChartDataState();
}

class _PrBucketChartDataState extends State<PrBucketChartData> {
  int totalCount = 0;
  List<ChartData> calculateChartData(Map<String, List<Map<String, String>>> states) {
    Map<String, int> stateCounts = {};
    List<Map<String, String>> stateList = [];
    for (final bucket in states.values){
      stateList.addAll(bucket);
    }
    for(final state in stateList){
      stateCounts[state.values.first] = (stateCounts[state.values.first] ?? 0) + 1;
    }
    return stateCounts.entries.map(
          (entry) => ChartData(entry.key, entry.value, _getRandomColor()),
    ).toList();
  }

  Color _getRandomColor() {
    return Color((Random().nextDouble() * 0xffFFFFF).toInt() << 0).withOpacity(1);
  }

  @override
  void initState() {
   for (final bucket in widget.states.values){
     totalCount+= bucket.length;
   }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<ChartData> chartData = calculateChartData(widget.states);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Total - $totalCount',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea( 
        child: SingleChildScrollView(
          child: Column(
            children: [
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
          ),
        ),
      ),
      );
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);

  final String x;
  final int y;
  final Color? color;
}

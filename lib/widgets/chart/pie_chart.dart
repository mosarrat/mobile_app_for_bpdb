import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../api/chart_api.dart';
import '../../models/charts_lookups/pie_chart.dart';

class PieChartView extends StatefulWidget {
  final String? selectedData;

  PieChartView({super.key, required this.selectedData});

  @override
  _PieChartViewState createState() => _PieChartViewState();
}

class _PieChartViewState extends State<PieChartView> {
  Future<List<ZoneData>>? _futureZones;
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didUpdateWidget(PieChartView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedData != widget.selectedData) {
      _loadData();
    }
  }

  void _loadData() {
    setState(() {
      _futureZones = PieData(widget.selectedData);
    });
  }

  List<PieChartSectionData> getPieChartData(
      List<ZoneData> zones, double height) {
    List<Color> colors = [
      Colors.green,
      Colors.blue,
      Colors.red,
      Colors.yellow,
      Colors.deepPurple,
      Colors.brown,
      Colors.orange,
      Colors.indigo,
      Colors.lime,
      Colors.blueGrey,
    ];

    return zones.asMap().entries.map((entry) {
      int index = entry.key;
      ZoneData zoneInfo = entry.value;
      double unhover_radius;
      double hover_radius;
      if (height < 600) {
        unhover_radius = 85;
        hover_radius = 93;
      } else if (height > 500) {
        unhover_radius = 85;
        hover_radius = 110;
      } else {
        unhover_radius = 120;
        hover_radius = 135;
      }
      final isTouched = index == touchedIndex;
      final double fontSize = isTouched ? 18 : 14;
      final double radius = isTouched ? hover_radius : unhover_radius;
      var formatter = NumberFormat('#,##,000');
      final val = formatter.format(zoneInfo.count);
      final String titelVal = isTouched ? '$val' : '${zoneInfo.percentage}%';
      return PieChartSectionData(
        color: colors[index % colors.length],
        value: zoneInfo.count.toDouble(),
        title: titelVal,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  List<LegendItem> getLegends(List<ZoneData> zones) {
    List<Color> colors = [
      Colors.green,
      Colors.blue,
      Colors.red,
      Colors.yellow,
      Colors.deepPurple,
      Colors.brown,
      Colors.orange,
      Colors.indigo,
      Colors.lime,
      Colors.blueGrey,
    ];

    return zones.asMap().entries.map((entry) {
      int index = entry.key;
      ZoneData zoneInfo = entry.value;
      return LegendItem(
        zoneName: zoneInfo.name,
        color: colors[index % colors.length],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    double pieheight;
    if (height < 1300 && height > 900) {
      // print(height);
      // print("1");
      pieheight = height * 0.19;
    } else if (height < 900 && height > 600) {
      // print(height);
      // print("2");
      pieheight = height * 0.27;
    } else if (height < 600 && height > 400) {
      // print(height);
      // print("3");
      pieheight = height * 0.3;
    } else if (height < 400 && height > 200) {
      // print(height);
      // print("4");
      pieheight = height * 0.4;
    } else {
      // print(height);
      // print("5");
      pieheight = height * 0.27;
    }
    return FutureBuilder<List<ZoneData>>(
      future: _futureZones,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available!'));
        } else {
          List<ZoneData> zones = snapshot.data!;
          List<PieChartSectionData> pieSections =
              getPieChartData(zones, height);
          List<LegendItem> legends = getLegends(zones);

          return Card(
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: 16.0, left: 0.0, right: 10.0, top: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Text(height.toString()),
                  SizedBox(width: width * 0.1),
                  SizedBox(
                    height: pieheight,
                    width: width / 3,
                    child: PieChart(
                      PieChartData(
                        sections: pieSections,
                        centerSpaceRadius: 0,
                        sectionsSpace: 2,
                        borderData: FlBorderData(show: false),
                        pieTouchData: PieTouchData(
                          //longPressDuration: const Duration(seconds: 2),
                          touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (pieTouchResponse != null &&
                                  pieTouchResponse.touchedSection != null) {
                                touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                                Future.delayed(const Duration(seconds: 5), () {
                                  setState(() {
                                    touchedIndex = -1;
                                  });
                                });
                              } else {
                                touchedIndex = -1;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.1),
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: legends.length,
                      itemBuilder: (context, index) {
                        final legend = legends[index];
                        return Container(
                          //margin: EdgeInsets.only(top:8),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                color: legend.color,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                legend.zoneName,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class LegendItem {
  final String zoneName;
  final Color color;

  LegendItem({
    required this.zoneName,
    required this.color,
  });
}

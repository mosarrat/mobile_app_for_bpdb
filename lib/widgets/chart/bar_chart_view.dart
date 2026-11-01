import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../api/chart_api.dart';
import '../../constants/app_colors.dart';
import '../../models/charts_lookups/bar_chart.dart';
import '../../models/regions/feederlinetype.dart';

class BarChartView extends StatefulWidget {
  final String? selectedBarData;

  BarChartView({super.key, required this.selectedBarData});

  @override
  _BarChartViewState createState() => _BarChartViewState();
}

class _BarChartViewState extends State<BarChartView> {
  Future<List<ZoneReport>>? _futureZones;
  Future<List<FeederLineType>>? _futureFeederLineTypes;

  List<ZoneReport> zoneDataList = [];
  List<FeederLineType> feederLineTypeList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadFeederLineTypes();
  }

  @override
  void didUpdateWidget(BarChartView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedBarData != widget.selectedBarData) {
      _loadData();
    }
  }

  void _loadData() {
    setState(() {
      _futureZones = BarData(widget.selectedBarData);
      _futureZones!.then((data) {
        setState(() {
          zoneDataList = data;
        });
      });
    });
  }

  void _loadFeederLineTypes() {
    setState(() {
      _futureFeederLineTypes = fetchFeederLineTypeInfo();
      _futureFeederLineTypes!.then((data) {
        setState(() {
          feederLineTypeList = data;
        });
      });
    });
  }

  List<BarChartGroupData> getBarGroups() {
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

    return List.generate(zoneDataList.length, (index) {
      final zoneData = zoneDataList[index];
      //print(zoneDataList.length);
      return BarChartGroupData(
        x: index,
        barRods: List.generate(zoneData.typeCount.length, (typeIndex) {
          final typeCount = zoneData.typeCount[typeIndex];

          return BarChartRodData(
            borderRadius: BorderRadius.circular(2),
            toY: typeCount.count.toDouble(),
            width: 16,
            color: colors[typeIndex % colors.length],
          );
        }),
      );
    });
  }

  double getMaxY() {
    double maxY = 0;
    for (var zoneData in zoneDataList) {
      for (var typeCount in zoneData.typeCount) {
        if (typeCount.count > maxY) {
          maxY = typeCount.count.toDouble();
        }
      }
    }
    return maxY + (maxY * 0.1);
  }

  Widget buildTypeLegend() {
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

    List<Widget> legendRows = [];
    if (zoneDataList.isNotEmpty) {
      var result = zoneDataList.length;
      var zoneIndex;
      if (result > 3) {
        zoneIndex = 3;
      } else {
        zoneIndex = 0;
      }
      final typeCountList = zoneDataList[zoneIndex].typeCount;
      for (int i = 0; i < typeCountList.length; i += 2) {
        List<Widget> rowItems = [];
        for (int j = 0; j < 2; j++) {
          if (i + j < typeCountList.length) {
            final typeCount = typeCountList[i + j];
            final index = typeCountList.indexOf(typeCount);
            rowItems.add(
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      color: colors[index % colors.length],
                    ),
                    const SizedBox(width: 4),
                    Text(typeCount.type),
                  ],
                ),
              ),
            );
          }
        }
        legendRows.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: rowItems,
        ));
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: legendRows,
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    double barheight;

    if (height < 1300 && height > 900) {
      // print(height);
      // print("1");
      barheight = height / 5.2;
    } else if (height < 900 && height > 600) {
      // print(height);
      // print("2");
      barheight = height / 4.6;
    } else if (height < 450 && height > 400) {
      // print(height);
      // print("IPhone Bar Chart");
      barheight = height / 3.4;
    } else if (height < 600 && height > 400) {
      // print(height);
      // print("3");
      barheight = height / 3.8;
    } else if (height < 400 && height > 200) {
      // print(height);
      // print("4");
      barheight = height / 2;
    } else {
      // print(height);
      // print("5");
      barheight = height / 4.8;
    }
    return FutureBuilder<List<ZoneReport>>(
      future: _futureZones,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available!'));
        } else {
          return Card(
            child: Container(
              //margin: EdgeInsets.only(top:8),
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  SizedBox(
                    height: barheight,
                    child: BarChart(
                      BarChartData(
                        maxY: getMaxY(),
                        barGroups: getBarGroups(),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              reservedSize: 40,
                              showTitles: true,
                              // interval: 300000,
                              interval: 307140,
                              getTitlesWidget: (value, meta) {
                                return Container(
                                  child: Text(
                                    value.round().toString(),
                                    style: const TextStyle(fontSize: 10),
                                    textAlign: TextAlign.end,
                                    softWrap: false,
                                  ),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 45,
                              getTitlesWidget: (value, meta) {
                                final zoneIndex = value.toInt();
                                if (zoneIndex < 0 ||
                                    zoneIndex >= zoneDataList.length) {
                                  return const Text('');
                                }
                                // return Column(
                                //   children: [
                                //     Text(
                                //       zoneDataList[zoneIndex].name.split(' ')[0], // First part before the space
                                //       style: const TextStyle(fontSize: 10),
                                //       softWrap: true,
                                //       overflow: TextOverflow.visible,
                                //     ),
                                //     Text(
                                //       zoneDataList[zoneIndex].name.split(' ').length > 1
                                //           ? zoneDataList[zoneIndex].name.split(' ')[1] 
                                //           : '',
                                //       style: const TextStyle(fontSize: 10),
                                //       // softWrap: true,
                                //       // overflow: TextOverflow.visible,
                                //     ),
                                //   ],
                                // );
                                
                                // return Text(
                                //   zoneDataList[zoneIndex].name,
                                //   style: const TextStyle(fontSize: 10),
                                // );
                                return Container(
                                  margin: const EdgeInsets.only(top: 10),  // Add top margin here
                                  child: Transform.rotate(
                                    angle: 270 * 3.14159 / 150,
                                    child: Column(
                                      children: [
                                        Text(
                                          zoneDataList[zoneIndex].name.split(' ')[0],  // First part before the space
                                          style: const TextStyle(fontSize: 10),
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                        ),
                                        Text(
                                          zoneDataList[zoneIndex].name.split(' ').length > 1
                                              ? zoneDataList[zoneIndex].name.split(' ')[1]  // Second part after the space
                                              : '',
                                          style: const TextStyle(fontSize: 10),
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(show: false),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  buildTypeLegend(),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

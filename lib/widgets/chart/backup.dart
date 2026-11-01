import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartView extends StatefulWidget {
  const PieChartView({super.key});

  @override
  State<PieChartView> createState() => _PieChartViewState();
}

class _PieChartViewState extends State<PieChartView> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.only(right: 8)),
            SizedBox(
              height: 150,
              width: 150,
              child: PieChart(
                PieChartData(
                  sections: getPieChartData(),
                  centerSpaceRadius: 0,
                  sectionsSpace: 2,
                  borderData: FlBorderData(show: false),
                  pieTouchData: PieTouchData(
                    //longPressDuration: const Duration(seconds: 2),
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (pieTouchResponse != null &&
                            pieTouchResponse.touchedSection != null) {
                          setState(() {
                            touchedIndex = pieTouchResponse
                                .touchedSection!
                                .touchedSectionIndex;
                          });
                          Future.delayed(const Duration(seconds: 5), () {
                            setState(() {
                              touchedIndex = -1;
                            });
                          });
                        } else {
                          setState(() {
                            touchedIndex = -1;
                          });
                        }
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 60),
            // Legends
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: getLegends(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> getPieChartData() {
    return PieData.data.asMap().entries.map((entry) {
      int index = entry.key;
      Data data = entry.value;

      final isTouched = index == touchedIndex;
      final double fontSize = isTouched ? 20 : 14;
      //final double radius = isTouched ? 90 : 85;
      final double radius = 85;
      final String val = isTouched
          ? '${data.percentage}'
          : '${data.percentage}%';
      return PieChartSectionData(
        color: data.color,
        value: data.percentage,
        title: val,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  List<Widget> getLegends() {
    return PieData.data.map((data) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Container(width: 16, height: 16, color: data.color),
            const SizedBox(width: 8),
            Text(
              data.name,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }).toList();
  }
}

class PieData {
  static List<Data> data = [
    Data(name: 'Chattogram', percentage: 35, color: const Color(0xFF2196F3)),
    Data(name: 'Cimilla', percentage: 30, color: const Color(0xFFFF683B)),
    Data(
      name: 'Mymensingh',
      percentage: 20,
      color: const Color.fromARGB(255, 58, 243, 33),
    ),
    Data(name: 'Sylet', percentage: 15, color: const Color(0xFFE80054)),
  ];
}

class Data {
  final String name;
  final double percentage;
  final Color color;

  Data({required this.name, required this.percentage, required this.color});
}

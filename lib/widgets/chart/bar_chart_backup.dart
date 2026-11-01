// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// import '../../constants/app_colors.dart';

// class BarChartView extends StatefulWidget {
//   const BarChartView({super.key});

//   final Color leftBarColor = AppColors.contentColorBlue;
//   final Color rightBarColor = AppColors.contentColorRed;
//   final Color avgColor = AppColors.contentColorOrange;

//   @override
//   State<StatefulWidget> createState() => BarChartViewState();
// }

// class BarChartViewState extends State<BarChartView> {
//   final double width = 5;

//   late List<BarChartGroupData> rawBarGroups;
//   late List<BarChartGroupData> showingBarGroups;

//   int touchedGroupIndex = -1;

//   @override
//   void initState() {
//     super.initState();

//     final barGroup1 = makeGroupData(0, 95, 100);
//     final barGroup2 = makeGroupData(1, 25, 100);
//     final barGroup3 = makeGroupData(2, 35, 100);
//     final barGroup4 = makeGroupData(3, 45, 100);
//     final barGroup5 = makeGroupData(4, 20, 100);
//     final barGroup6 = makeGroupData(5, 75, 100);

//     final items = [
//       barGroup1,
//       barGroup2,
//       barGroup3,
//       barGroup4,
//       barGroup5,
//       barGroup6,
//     ];

//     rawBarGroups = items;
//     showingBarGroups = rawBarGroups;
//   }

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;

//     return SizedBox(
//       height: height * 0.35,
//       width: width,
//       child: AspectRatio(
//         aspectRatio: 1.5,
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               const Center(
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     Text(
//                       'Consumers Collection',
//                       style: TextStyle(
//                         color: AppColors.contentColorTeal,
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(width: 4),
//                     Text(
//                       '2024',
//                       style: TextStyle(
//                         color: Color(0xff77839a),
//                         fontSize: 22,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Expanded(
//                 child: Column(
//                   children: [
//                     Expanded(
//                       child: BarChart(
//                         BarChartData(
//                           maxY: 100,
//                           barTouchData: BarTouchData(
//                             touchTooltipData: BarTouchTooltipData(
//                               getTooltipItem: (a, b, c, d) => null,
//                             ),
//                             touchCallback: (FlTouchEvent event, response) {
//                               // Touch callback logic
//                             },
//                           ),
//                           titlesData: FlTitlesData(
//                             show: true,
//                             rightTitles: const AxisTitles(
//                               sideTitles: SideTitles(showTitles: false),
//                             ),
//                             topTitles: const AxisTitles(
//                               sideTitles: SideTitles(showTitles: false),
//                             ),
//                             bottomTitles: AxisTitles(
//                               sideTitles: SideTitles(
//                                 showTitles: true,
//                                 getTitlesWidget: bottomTitles,
//                                 reservedSize: 42,
//                               ),
//                             ),
//                             leftTitles: AxisTitles(
//                               sideTitles: SideTitles(
//                                 showTitles: true,
//                                 reservedSize: 28,
//                                 interval: 1,
//                                 getTitlesWidget: leftTitles,
//                               ),
//                             ),
//                           ),
//                           borderData: FlBorderData(show: false),
//                           barGroups: showingBarGroups,
//                           gridData: const FlGridData(show: false),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         _buildLegendItem(
//                           'Collection',
//                           widget.leftBarColor,
//                         ),
//                         const SizedBox(width: 20),
//                         _buildLegendItem(
//                           'Total Collection',
//                           widget.rightBarColor,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLegendItem(String label, Color color) {
//     return Row(
//       children: [
//         Container(
//           width: 12,
//           height: 12,
//           color: color,
//         ),
//         const SizedBox(width: 8),
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 12,
//             color: Color(0xff7589a2),
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget leftTitles(double value, TitleMeta meta) {
//     const style = TextStyle(
//       color: AppColors.contentColorBlack,
//       fontWeight: FontWeight.normal,
//       fontSize: 9,
//     );

//     // Determine the text based on the value
//     String text;
//     if (value == 0) {
//       text = '0%';
//     } else if (value == 10) {
//       text = '10%';
//     } else if (value == 20) {
//       text = '20%';
//     } else if (value == 30) {
//       text = '30%';
//     } else if (value == 40) {
//       text = '40%';
//     } else if (value == 50) {
//       text = '50%';
//     } else if (value == 60) {
//       text = '60%';
//     } else if (value == 70) {
//       text = '70%';
//     } else if (value == 80) {
//       text = '80%';
//     } else if (value == 90) {
//       text = '90%';
//     } else if (value == 100) {
//       text = '100%';
//     } else {
//       // Return an empty container if the value doesn't match any specific text
//       return Container();
//     }

//     // Create a widget to display the title
//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       space: 0,
//       child: Text(text, style: style),
//     );
//   }

//   Widget bottomTitles(double value, TitleMeta meta) {
//     // Define the titles for the x-axis
//     final titles = <String>[
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'May',
//       'Jun',
//     ];

//     // Get the corresponding title based on the value
//     final text = titles[value.toInt()];

//     // Create a widget to display the title
//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       space: 5,
//       child: Text(
//         text,
//         style: const TextStyle(
//           color: Color(0xff7589a2),
//           fontWeight: FontWeight.bold,
//           fontSize: 12,
//         ),
//       ),
//     );
//   }

//   BarChartGroupData makeGroupData(int x, double y1, double y2) {
//     return BarChartGroupData(
//       barsSpace: 15,
//       x: x,
//       barRods: [
//         BarChartRodData(
//           toY: y1,
//           color: widget.leftBarColor,
//           width: width,
//         ),
//         BarChartRodData(
//           toY: y2,
//           color: widget.rightBarColor,
//           width: width,
//         ),
//       ],
//     );
//   }
// }

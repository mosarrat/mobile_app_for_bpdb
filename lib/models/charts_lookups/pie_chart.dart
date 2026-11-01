// class ZoneData {
//   final String zone;
//   final int count;
//   final int? percentage;

//   ZoneData({required this.zone, required this.count, required this.percentage});

//   factory ZoneData.fromJson(Map<String, dynamic> json) {
//     return ZoneData(
//       zone: json['zone'],
//       count: json['count'],
//       percentage: json['percentage'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'zone': zone,
//       'count': count,
//       'percentage': percentage,
//     };
//   }
// }
class ZoneData {
  final String name;
  final int count;
  final int? percentage;

  ZoneData({required this.name, required this.count, required this.percentage});

  factory ZoneData.fromJson(Map<String, dynamic> json) {
    return ZoneData(
      name: json['name'],
      count: json['count'],
      percentage: json['percentage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'count': count,
      'percentage': percentage,
    };
  }
}



// class SndInfo {
//   final int sndId;
//   final int circleId;
//   final String sndCode;
//   final String sndName;

//   SndInfo({
//     required this.sndId,
//     required this.circleId,
//     required this.sndCode,
//     required this.sndName,
//   });

//   factory SndInfo.fromJson(Map<String, dynamic> json) {
//     return SndInfo(
//       sndId: json['sndId'] ?? 0, // Default to 0 if null
//       circleId: json['circleId'] ?? 0, // Default to 0 if null
//       sndCode: json['sndCode'] ?? '', // Default to empty string if null
//       sndName: json['snDName'] ?? '', // Default to empty string if null
//     );
//   }
// }


class SndInfo {
  int? sndId;
  String? sndCode;
  String? snDName;
  String? districtGeoCode;
  double? centerLatitude;
  double? centerLongitude;
  int? defaultZoomLevel;

  int? totalEsu;
  int? totalSubstation;
  int? totalPole;
  int? totalDT;
  int? totalConsumers;
  int? threePhase;
  int? singlePhase;

  final double feeder33KvLength;
  final int feeder33KvCount;
  final double feeder11KvLength;
  final int feeder11KvCount;
  final double feeder04KvLength;
  final int feeder04KvCount;

  SndInfo({
    this.sndId,
    this.sndCode,
    this.snDName,
    this.districtGeoCode,
    this.centerLatitude,
    this.centerLongitude,
    this.defaultZoomLevel,
    this.totalEsu,
    this.totalSubstation,
    this.totalPole,
    this.totalDT,
    this.totalConsumers,
    this.threePhase,
    this.singlePhase,
    required this.feeder33KvLength,
    required this.feeder33KvCount,
    required this.feeder11KvLength,
    required this.feeder11KvCount,
    required this.feeder04KvLength,
    required this.feeder04KvCount,
  });

  factory SndInfo.fromJson(Map<String, dynamic> json) {
    return SndInfo(
      sndId: json['sndId'],
      sndCode: json['sndCode'],
      snDName: json['snDName'],
      districtGeoCode: json['districtGeoCode'],
      centerLatitude: (json['centerLatitude'] as num?)?.toDouble(),
      centerLongitude: (json['centerLongitude'] as num?)?.toDouble(),
      defaultZoomLevel: json['defaultZoomLevel'],
      totalEsu: json['totalEsu'],
      totalSubstation: json['totalSubstation'],
      totalPole: json['totalPole'],
      totalDT: json['totalDT'],
      totalConsumers: json['totalConsumers'],
      threePhase: json['threePhase'],
      singlePhase: json['singlePhase'],
      feeder33KvLength: (json['feeder33KvLength'] ?? 0.0).toDouble(),
      feeder33KvCount: json['feeder33KvCount'] ?? 0,
      feeder11KvLength: (json['feeder11KvLength'] ?? 0.0).toDouble(),
      feeder11KvCount: json['feeder11KvCount'] ?? 0,
      feeder04KvLength: (json['feeder04KvLength'] ?? 0.0).toDouble(),
      feeder04KvCount: json['feeder04KvCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sndId': sndId,
      'sndCode': sndCode,
      'snDName': snDName,
      'districtGeoCode': districtGeoCode,
      'centerLatitude': centerLatitude,
      'centerLongitude': centerLongitude,
      'defaultZoomLevel': defaultZoomLevel,
      'totalEsu': totalEsu,
      'totalSubstation': totalSubstation,
      'totalPole': totalPole,
      'totalDT': totalDT,
      'totalConsumers': totalConsumers,
      'threePhase': threePhase,
      'singlePhase': singlePhase,
      'feeder33KvLength': feeder33KvLength,
      'feeder33KvCount': feeder33KvCount,
      'feeder11KvLength': feeder11KvLength,
      'feeder11KvCount': feeder11KvCount,
      'feeder04KvLength': feeder04KvLength,
      'feeder04KvCount': feeder04KvCount,
    };
  }
}




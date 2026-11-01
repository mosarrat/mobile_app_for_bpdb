class Zone {
  final int zoneId;
  final String zoneCode;
  final String zoneName;
  final double centerLatitude;
  final double centerLongitude;
  final int defaultZoomLevel;

  final int totalCircle;
  final int totalPole;
  final int totalDT;
  final int totalConsumers;
  final int threePhase;
  final int singlePhase;

  final double feeder33KvLength;
  final int feeder33KvCount;
  final double feeder11KvLength;
  final int feeder11KvCount;
  final double feeder04KvLength;
  final int feeder04KvCount;

  Zone({
    required this.zoneId,
    required this.zoneCode,
    required this.zoneName,
    required this.centerLatitude,
    required this.centerLongitude,
    required this.defaultZoomLevel,
    required this.totalCircle,
    required this.totalPole,
    required this.totalDT,
    required this.totalConsumers,
    required this.threePhase,
    required this.singlePhase,
    required this.feeder33KvLength,
    required this.feeder33KvCount,
    required this.feeder11KvLength,
    required this.feeder11KvCount,
    required this.feeder04KvLength,
    required this.feeder04KvCount,
  });

  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      zoneId: json['zoneId'] ?? 0,
      zoneCode: json['zoneCode'] ?? '',
      zoneName: json['zoneName'] ?? '',
      centerLatitude: (json['centerLatitude'] ?? 0.0).toDouble(),
      centerLongitude: (json['centerLongitude'] ?? 0.0).toDouble(),
      defaultZoomLevel: json['defaultZoomLevel'] ?? 0,
      totalCircle: json['totalCircle'] ?? 0,
      totalPole: json['totalPole'] ?? 0,
      totalDT: json['totalDT'] ?? 0,
      totalConsumers: json['totalConsumers'] ?? 0,
      threePhase: json['threePhase'] ?? 0,
      singlePhase: json['singlePhase'] ?? 0,

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
      'zoneId': zoneId,
      'zoneCode': zoneCode,
      'zoneName': zoneName,
      'centerLatitude': centerLatitude,
      'centerLongitude': centerLongitude,
      'defaultZoomLevel': defaultZoomLevel,
      'totalCircle': totalCircle,
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
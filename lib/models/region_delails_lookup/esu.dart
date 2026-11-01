class Esu {
  int? esuId;
  String? esuCode;
  String? esuName;
  double? centerLatitude;
  double? centerLongitude;
  int? defaultZoomLevel;

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

  Esu({
    this.esuId,
    this.esuCode,
    this.esuName,
    this.centerLatitude,
    this.centerLongitude,
    this.defaultZoomLevel,
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

  factory Esu.fromJson(Map<String, dynamic> json) {
    return Esu(
      esuId: json['esuId'],
      esuCode: json['esuCode'],
      esuName: json['esuName'],
      centerLatitude: (json['centerLatitude'] as num?)?.toDouble(),
      centerLongitude: (json['centerLongitude'] as num?)?.toDouble(),
      defaultZoomLevel: json['defaultZoomLevel'],
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
      'esuId': esuId,
      'esuCode': esuCode,
      'esuName': esuName,
      'centerLatitude': centerLatitude,
      'centerLongitude': centerLongitude,
      'defaultZoomLevel': defaultZoomLevel,
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

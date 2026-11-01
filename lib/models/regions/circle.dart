// class Circles {
//   final int circleId;
//   final int zoneId;
//   final String circleCode;
//   final String circleName;
//   final double centerLatitude;
//   final double centerLongitude;
//   final int defaultZoomLevel;

//   Circles({
//     required this.circleId,
//     required this.zoneId,
//     required this.circleCode,
//     required this.circleName,
//     required this.centerLatitude,
//     required this.centerLongitude,
//     required this.defaultZoomLevel,
//   });

//   factory Circles.fromJson(Map<String, dynamic> json) {
//     return Circles(
//       circleId: json['circleId'],
//       zoneId: json['zoneId'],
//       circleCode: json['circleCode'],
//       circleName: json['circleName'],
//       centerLatitude: (json['centerLatitude'] ?? 0.0).toDouble(), // Handle null with default 0.0
//       centerLongitude: (json['centerLongitude'] ?? 0.0).toDouble(), // Handle null with default 0.0
//       defaultZoomLevel: json['defaultZoomLevel'] ?? 0, // Handle null with default 0
//     );
//   }
// }

class Circles {
  int? circleId;
  String? circleCode;
  int? zoneId;
  String? zoneName;
  String? circleName;
  double? centerLatitude;
  double? centerLongitude;
  int? defaultZoomLevel;
  DateTime? startingDate;
  DateTime? endingDate;
  int? activationStatusId;
  String? dataActivationStatus;
  int? verificationStateId;
  String? dataVerificationState;
  String? officeInfo;

  int? totalSnd;
  int? totalEsu;
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


  Circles({
    this.circleId,
    this.circleCode,
    this.zoneId,
    this.zoneName,
    this.circleName,
    this.centerLatitude,
    this.centerLongitude,
    this.defaultZoomLevel,
    this.startingDate,
    this.endingDate,
    this.activationStatusId,
    this.dataActivationStatus,
    this.verificationStateId,
    this.dataVerificationState,
    this.officeInfo,
    this.totalSnd,
    this.totalEsu,
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

  factory Circles.fromJson(Map<String, dynamic> json) {
    return Circles(
      circleId: json['circleId'],
      circleCode: json['circleCode'],
      zoneId: json['zoneId'],
      zoneName: json['zoneInfo'] != null ? json['zoneInfo']['zoneName'] : null,
      circleName: json['circleName'],
      centerLatitude: (json['centerLatitude'] as num?)?.toDouble(),
      centerLongitude: (json['centerLongitude'] as num?)?.toDouble(),
      defaultZoomLevel: json['defaultZoomLevel'],
      startingDate: json['startingDate'] != null
          ? DateTime.parse(json['startingDate'])
          : null,
      endingDate: json['endingDate'] != null
          ? DateTime.parse(json['endingDate'])
          : null,
      activationStatusId: json['activationStatusId'],
      dataActivationStatus: json['dataActivationStatus'],
      verificationStateId: json['verificationStateId'],
      dataVerificationState: json['dataVerificationState'],
      officeInfo: json['officeInfo'],
      totalSnd: json['totalSnd'],
      totalEsu: json['totalEsu'],
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
      'circleId': circleId,
      'circleCode': circleCode,
      'zoneId': zoneId,
      'zoneName': zoneName,
      'circleName': circleName,
      'centerLatitude': centerLatitude,
      'centerLongitude': centerLongitude,
      'defaultZoomLevel': defaultZoomLevel,
      'startingDate': startingDate?.toIso8601String(),
      'endingDate': endingDate?.toIso8601String(),
      'activationStatusId': activationStatusId,
      'dataActivationStatus': dataActivationStatus,
      'verificationStateId': verificationStateId,
      'dataVerificationState': dataVerificationState,
      'officeInfo': officeInfo,
      'totalSnd': totalSnd,
      'totalEsu': totalEsu,
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


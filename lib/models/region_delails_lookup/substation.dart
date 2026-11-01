class Substations {
  int? substationId;
  String? substationName;
  String? substationCode;
  String? substationTypeName;
  String? nominalVoltage;
  String? installedCapacity;
  double? maximumDemand;
  double? peakLoad;
  String? location;
  String? areaOfSubstation;
  double? latitude;
  double? longitude;
  int? defaultZoomLevel;
  String? yearOfComissioning;
  String? operatingSndName;

  // extra fields from JSON
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

  Substations({
    this.substationId,
    this.substationName,
    this.substationCode,
    this.substationTypeName,
    this.nominalVoltage,
    this.installedCapacity,
    this.maximumDemand,
    this.peakLoad,
    this.location,
    this.areaOfSubstation,
    this.latitude,
    this.longitude,
    this.defaultZoomLevel,
    this.yearOfComissioning,
    this.operatingSndName,
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

  factory Substations.fromJson(Map<String, dynamic> json) {
    return Substations(
      substationId: json['substationId'] as int?,
      substationName: json['substationName'] as String?,
      substationCode: json['substationCode'] as String?,
      substationTypeName: json['substationTypeName'] as String?, // ✅ added
      nominalVoltage: json['nominalVoltage'] as String?,
      installedCapacity: json['installedCapacity'] as String?,
      maximumDemand: (json['maximumDemand'] as num?)?.toDouble(),
      peakLoad: (json['peakLoad'] as num?)?.toDouble(),
      location: json['location'] as String?,
      areaOfSubstation: json['areaOfSubstation'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      defaultZoomLevel: json['defaultZoomLevel'] as int?,
      yearOfComissioning: json['yearOfComissioning'] as String?,
      totalDT: json['totalDT'] as int?,
      totalConsumers: json['totalConsumers'] as int?,
      threePhase: json['threePhase'] as int?,
      singlePhase: json['singlePhase'] as int?,
      operatingSndName: json['operatingSndName'] as String?,  
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
      'substationId': substationId,
      'substationName': substationName,
      'substationCode': substationCode,
      'substationTypeName': substationTypeName, // ✅ added
      'nominalVoltage': nominalVoltage,
      'installedCapacity': installedCapacity,
      'maximumDemand': maximumDemand,
      'peakLoad': peakLoad,
      'location': location,
      'areaOfSubstation': areaOfSubstation,
      'latitude': latitude,
      'longitude': longitude,
      'defaultZoomLevel': defaultZoomLevel,
      'yearOfComissioning': yearOfComissioning,
      'totalDT': totalDT,
      'totalConsumers': totalConsumers,
      'threePhase': threePhase,
      'singlePhase': singlePhase,
      'operatingSndName': operatingSndName,
      'feeder33KvLength': feeder33KvLength,
      'feeder33KvCount': feeder33KvCount,
      'feeder11KvLength': feeder11KvLength,
      'feeder11KvCount': feeder11KvCount,
      'feeder04KvLength': feeder04KvLength,
      'feeder04KvCount': feeder04KvCount,
    };
  }
}

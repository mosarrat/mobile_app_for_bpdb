class PoleUpdate{
  final int poleId;
  final int poleConditionId;
  final double latitude;
  final double longitude;
  final int? noOfWireHt;
  final int? noOfWireLt;
  final bool streetLight;
  final bool commonPole;
  final bool tap;
  final double? poleHeight;
  final int? noOfLine11Kv;
  final int? noOfLineP4Kv;
  final int? noOfLine33Kv;

  PoleUpdate({
    required this.poleId,
    required this.poleConditionId,
    required this.latitude,
    required this.longitude,
    this.noOfWireHt,
    this.noOfWireLt,
    required this.streetLight,
    required this.commonPole,
    required this.tap,
    this.poleHeight,
    this.noOfLine11Kv,
    this.noOfLineP4Kv,
    this.noOfLine33Kv,
  });
  factory PoleUpdate.fromJson(Map<String, dynamic> json) {
    return PoleUpdate(
      poleId: json['poleId'] as int,
      poleConditionId: json['poleConditionId'] as int,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      noOfWireHt: json['noOfWireHt'] as int?,
      noOfWireLt: json['noOfWireLt'] as int?,
      streetLight: json['streetLight'] as bool? ?? false,
      commonPole: json['commonPole'] as bool? ?? false,
      tap: json['tap'] as bool? ?? false,
      poleHeight: json['poleHeight'] as double?,
      noOfLine11Kv: json['noOfLine11Kv'] as int?,
      noOfLineP4Kv: json['noOfLineP4Kv'] as int?,
      noOfLine33Kv: json['noOfLine33Kv'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'poleId': poleId,
      'poleConditionId': poleConditionId,
      'latitude': latitude,
      'longitude': longitude,
      'noOfWireHt': noOfWireHt,
      'noOfWireLt': noOfWireLt,
      'streetLight': streetLight,
      'commonPole': commonPole,
      'tap': tap,
      'poleHeight': poleHeight,
      'noOfLine11Kv': noOfLine11Kv,
      'noOfLineP4Kv': noOfLineP4Kv,
      'noOfLine33Kv': noOfLine33Kv,
    };
  }
}

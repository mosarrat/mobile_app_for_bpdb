class PoleForMap {
  final int poleId;
  final String poleNo;
  final double latitude;
  final double longitude;

  PoleForMap({
    required this.poleId,
    required this.poleNo,
    required this.latitude,
    required this.longitude,
  });

  factory PoleForMap.fromJson(Map<String, dynamic> json) {
    return PoleForMap(
      poleId: json['poleId'],
      poleNo: json['poleNo'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'poleId': poleId,
      'poleNo': poleNo,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
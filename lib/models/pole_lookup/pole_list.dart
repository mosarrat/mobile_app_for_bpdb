class PoleList {
  int zoneId;
  int circleId;
  int sndId;
  int? esuId; // Nullable int
  int poleId;
  String poleTypeName;
  String conditionName;
  double? poleHeight; // Nullable double (or int if it's an integer)

  PoleList({
    required this.zoneId,
    required this.circleId,
    required this.sndId,
    this.esuId, // Nullable field
    required this.poleId,
    required this.poleTypeName,
    required this.conditionName,
    this.poleHeight, // Nullable field
  });

  factory PoleList.fromJson(Map<String, dynamic> json) {
    return PoleList(
      zoneId: json['zoneId'],
      circleId: json['circleId'],
      sndId: json['sndId'],
      esuId: json['esuId'], // Accepting null value
      poleId: json['poleId'],
      poleTypeName: json['poleTypeName'],
      conditionName: json['conditionName'],
      poleHeight: json['poleHeight']?.toDouble(), // Convert to double and handle null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'zoneId': zoneId,
      'circleId': circleId,
      'sndId': sndId,
      'esuId': esuId, // Nullable field
      'poleId': poleId,
      'poleTypeName': poleTypeName,
      'conditionName': conditionName,
      'poleHeight': poleHeight, // Nullable field
    };
  }
}

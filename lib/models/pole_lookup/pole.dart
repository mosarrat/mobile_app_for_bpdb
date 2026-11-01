class Poles {
  int? poleId;
  int? zoneId;
  int? circleId;
  int? sndId;
  int? esuId;
  int? poleTypeId;
  int? poleConditionId;
  String? surveyDate;
  String? surveyorName;
  double? latitude;
  double? longitude;
  int? noOfWireHt;
  int? noOfWireLt;
  String? msjNo;
  String? sleeveNo;
  String? twistNo;
  bool? streetLight;
  bool? transformerExist;
  bool? commonPole;
  bool? tap;
  String? poleNumber;
  double? poleHeight;
  int? noOfLine33Kv;
  int? noOfLine11Kv;
  int? noOfLineP4Kv;
  String? startingDate;
  String? endingDate;
  int? activationStatusId;
  int? verificationStateId;
  String? remarks;

  Poles({
    this.poleId,
    this.zoneId,
    this.circleId,
    this.sndId,
    this.esuId,
    this.poleTypeId,
    this.poleConditionId,
    this.surveyDate,
    this.surveyorName,
    this.latitude,
    this.longitude,
    this.noOfWireHt,
    this.noOfWireLt,
    this.msjNo,
    this.sleeveNo,
    this.twistNo,
    this.streetLight,
    this.transformerExist,
    this.commonPole,
    this.tap,
    this.poleNumber,
    this.poleHeight,
    this.noOfLine33Kv,
    this.noOfLine11Kv,
    this.noOfLineP4Kv,
    this.startingDate,
    this.endingDate,
    this.activationStatusId,
    this.verificationStateId,
    this.remarks,
  });

  factory Poles.fromJson(Map<String, dynamic> json) {
    return Poles(
      poleId: json['poleId'] as int?,
      zoneId: json['zoneId'] as int?,
      circleId: json['circleId'] as int?,
      sndId: json['sndId'] as int?,
      esuId: json['esuId'] as int?,
      poleTypeId: json['poleTypeId'] as int?,
      poleConditionId: json['poleConditionId'] as int?,
      surveyDate: json['surveyDate'] ?? '',
      surveyorName: json['surveyorName'] as String?,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      noOfWireHt: json['noOfWireHt'] as int?,
      noOfWireLt: json['noOfWireLt'] as int?,
      msjNo: json['msjNo'] as String?,
      sleeveNo: json['sleeveNo'] as String?,
      twistNo: json['twistNo'] as String?,
      streetLight: json['streetLight'] as bool?,
      transformerExist: json['transformerExist'] as bool?,
      commonPole: json['commonPole'] as bool?,
      tap: json['tap'] as bool?,
      poleNumber: json['poleNumber'] as String?,
      poleHeight: json['poleHeight'] != null
          ? (json['poleHeight'] as num).toDouble()
          : null,
      noOfLine33Kv: json['noOfLine33Kv'] as int?,
      noOfLine11Kv: json['noOfLine11Kv'] as int?,
      noOfLineP4Kv: json['noOfLineP4Kv'] as int?,
      startingDate: json['startingDate'] ?? '',
      endingDate: json['endingDate'] ?? '',
      activationStatusId: json['activationStatusId'] as int?,
      verificationStateId: json['verificationStateId'] as int?,
      remarks: json['remarks'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'poleId': poleId,
      'zoneId': zoneId,
      'circleId': circleId,
      'sndId': sndId,
      'esuId': esuId,
      'poleTypeId': poleTypeId,
      'poleConditionId': poleConditionId,
      'surveyDate': surveyDate,
      'surveyorName': surveyorName,
      'latitude': latitude,
      'longitude': longitude,
      'noOfWireHt': noOfWireHt,
      'noOfWireLt': noOfWireLt,
      'msjNo': msjNo,
      'sleeveNo': sleeveNo,
      'twistNo': twistNo,
      'streetLight': streetLight,
      'transformerExist': transformerExist,
      'commonPole': commonPole,
      'tap': tap,
      'poleNumber': poleNumber,
      'poleHeight': poleHeight,
      'noOfLine33Kv': noOfLine33Kv,
      'noOfLine11Kv': noOfLine11Kv,
      'noOfLineP4Kv': noOfLineP4Kv,
      'startingDate': startingDate,
      'endingDate': endingDate,
      'activationStatusId': activationStatusId,
      'verificationStateId': verificationStateId,
      'remarks': remarks,
    };
  }
}

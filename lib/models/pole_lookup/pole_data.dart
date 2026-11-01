class PoleFormData {
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

  PoleFormData({
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
}
class FeederWireFormData {
  int? poleDetailsId;
  int? poleId;
  String? poleCode;
  int? feederLineId;
  String? poleUid;
  String? feederLineUid;
  int? zoneId;
  int? circleId;
  int? sndId;
  int? esuId;
  int? substationId;
  int? feederWiseSerialNo;
  String? poleNo;
  String? previousPoleNo;
  int? lineTypeId;
  String? backSpan; // Nullable field
  int? typeOfWireId;
  double? wireLength; // Nullable field
  int? wireConditionId;
  String? phaseAId;
  String? phaseBId;
  String? phaseCId;
  bool? neutral;
  String? poleUniqueCode;
  bool? isRightPole;

  FeederWireFormData({
    this.poleDetailsId,
    this.poleId,
    this.poleCode,      
    this.feederLineId,
    this.poleUid,
    this.feederLineUid,
    this.zoneId,
    this.circleId,
    this.sndId,
    this.esuId,
    this.substationId,
    this.feederWiseSerialNo,
    this.poleNo,
    this.previousPoleNo,
    this.lineTypeId,
    this.backSpan,
    this.typeOfWireId,
    this.wireLength,
    this.wireConditionId,
    this.phaseAId,
    this.phaseBId,
    this.phaseCId,
    this.neutral,
    this.poleUniqueCode,
    this.isRightPole,
  });
}
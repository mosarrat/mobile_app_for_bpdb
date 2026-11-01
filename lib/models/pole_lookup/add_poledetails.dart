class PoleDetailInfo {
  int poleDetailsId;
  int poleId;
  String poleCode;
  int feederLineId;
  String? poleUid;
  String? feederLineUid;
  int zoneId;
  int circleId;
  int sndId;
  int? esuId;
  int substationId;
  int? feederWiseSerialNo;
  String poleNo;
  String previousPoleNo;
  int lineTypeId;
  String? backSpan; // Nullable field
  int typeOfWireId;
  double? wireLength; // Nullable field
  int wireConditionId;
  String? phaseAId;
  String? phaseBId;
  String? phaseCId;
  bool? neutral;
  String? poleUniqueCode;
  bool? isRightPole;

  PoleDetailInfo({
    required this.poleDetailsId,
    required this.poleId,
    required this.poleCode,
    required this.feederLineId,
    this.poleUid,
    this.feederLineUid,
    required this.zoneId,
    required this.circleId,
    required this.sndId,
    this.esuId,
    required this.substationId,
    this.feederWiseSerialNo,
    required this.poleNo,
    required this.previousPoleNo,
    required this.lineTypeId,
    this.backSpan,
    required this.typeOfWireId,
    this.wireLength,
    required this.wireConditionId,
    this.phaseAId,
    this.phaseBId,
    this.phaseCId,
    this.neutral,
    this.poleUniqueCode,
    this.isRightPole,
  });

  // Factory constructor for JSON deserialization
  factory PoleDetailInfo.fromJson(Map<String, dynamic> json) {
    return PoleDetailInfo(
      poleDetailsId: json['poleDetailsId'] ?? 0, 
      poleId: json['poleId'] ?? 0,               
      poleCode: json['poleCode'] ?? '',          
      feederLineId: json['feederLineId'] ?? 0,  
      poleUid: json['poleUid'],            
      feederLineUid: json['feederLineUid'],
      zoneId: json['zoneId'] ?? 0,               
      circleId: json['circleId'] ?? 0,           
      sndId: json['sndId'] ?? 0, 
      esuId: json['esuId'],                
      substationId: json['substationId'] ?? 0,   
      feederWiseSerialNo: json['feederWiseSerialNo'],
      poleNo: json['poleNo'] ?? '',              
      previousPoleNo: json['previousPoleNo'] ?? '', 
      lineTypeId: json['lineTypeId'] ?? 0,      
      backSpan: json['backSpan'],                 
      typeOfWireId: json['typeOfWireId'] ?? 0,  
      wireLength: json['wireLength']?.toDouble(), 
      wireConditionId: json['wireConditionId'] ?? 0, 
      phaseAId: json['phaseAId'] ?? '',          
      phaseBId: json['phaseBId'] ?? '',          
      phaseCId: json['phaseCId'] ?? '',          
      neutral: json['neutral'],         
      poleUniqueCode: json['poleUniqueCode'], 
      isRightPole: json['isRightPole'], 
    );
  }

  // Method to convert the object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'poleDetailsId': poleDetailsId,
      'poleId': poleId,
      'poleCode': poleCode,
      'feederLineId': feederLineId,
      'poleUid': poleUid,
      'feederLineUid': feederLineUid,
      'zoneId': zoneId,
      'circleId': circleId,
      'sndId': sndId,
      'esuId': esuId,
      'substationId': substationId,
      'feederWiseSerialNo': feederWiseSerialNo,
      'poleNo': poleNo,
      'previousPoleNo': previousPoleNo,
      'lineTypeId': lineTypeId,
      'backSpan': backSpan,
      'typeOfWireId': typeOfWireId,
      'wireLength': wireLength,
      'wireConditionId': wireConditionId,
      'phaseAId': phaseAId,
      'phaseBId': phaseBId,
      'phaseCId': phaseCId,
      'neutral': neutral,
      'poleUniqueCode': poleUniqueCode,
      'isRightPole': isRightPole,
    };
  }
}

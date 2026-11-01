class PoleSection {
  final int? poleSectionId;
  final int? zoneId;
  final dynamic zoneInfo;
  final int? circleId;
  final dynamic circleInfo;
  final int? sndId;
  final dynamic sndInfo;
  final int? esuId;
  final dynamic esuInfo;
  final int? feederLineId;
  final dynamic feederLineInfo;
  final String? sectionName;
  final String? areaName;
  final bool dtExist;
  final dynamic dtRating;
  final dynamic voltLavel;
  final DateTime? surveyDate;
  final String? remarks;
  final int? verificationStateId;
  final dynamic dataVerificationState;

  PoleSection({
    this.poleSectionId,
    this.zoneId,
    this.zoneInfo,
    this.circleId,
    this.circleInfo,
    this.sndId,
    this.sndInfo,
    this.esuId,
    this.esuInfo,
    this.feederLineId,
    this.feederLineInfo,
    this.sectionName,
    this.areaName,
    required this.dtExist,
    this.dtRating,
    this.voltLavel,
    this.surveyDate,
    this.remarks,
    this.verificationStateId,
    this.dataVerificationState,
  });

  factory PoleSection.fromJson(Map<String, dynamic> json) {
    return PoleSection(
      poleSectionId: json['poleSectionId'],
      zoneId: json['zoneId'],
      zoneInfo: json['zoneInfo'],
      circleId: json['circleId'],
      circleInfo: json['circleInfo'],
      sndId: json['sndId'],
      sndInfo: json['sndInfo'],
      esuId: json['esuId'],
      esuInfo: json['esuInfo'],
      feederLineId: json['feederLineId'],
      feederLineInfo: json['feederLineInfo'],
      sectionName: json['sectionName'],
      areaName: json['areaName'],
      dtExist: json['dtExist'] ?? false,
      dtRating: json['dtRating'], 
      voltLavel: json['voltLavel'],
      surveyDate: json['surveyDate'] != null
          ? DateTime.parse(json['surveyDate'])
          : null,
      remarks: json['remarks'],
      verificationStateId: json['verificationStateId'],
      dataVerificationState: json['dataVerificationState'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'poleSectionId': poleSectionId,
      'zoneId': zoneId,
      'zoneInfo': zoneInfo,
      'circleId': circleId,
      'circleInfo': circleInfo,
      'sndId': sndId,
      'sndInfo': sndInfo,
      'esuId': esuId,
      'esuInfo': esuInfo,
      'feederLineId': feederLineId,
      'feederLineInfo': feederLineInfo,
      'sectionName': sectionName,
      'areaName': areaName,
      'dtExist': dtExist,
      'dtRating': dtRating,
      'voltLavel': voltLavel,
      'surveyDate': surveyDate?.toIso8601String(),
      'remarks': remarks,
      'verificationStateId': verificationStateId,
      'dataVerificationState': dataVerificationState,
    };
  }
}
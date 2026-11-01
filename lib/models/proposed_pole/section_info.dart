class SectionInfo {
  final int? poleSectionId;
  final int? zoneId;
  final String? zoneName;
  final int? circleId;
  final String? circleName;
  final int? sndId;
  final String? snDName;
  final String? esuName;
  final int? feederlineId;
  final String? feederlineName;
  final dynamic voltLavel;
  final String? sectionName;
  final DateTime? surveyDate;
  final int? verificationStateId;

  SectionInfo({
    this.poleSectionId,
    this.zoneId,
    this.zoneName,
    this.circleId,
    this.circleName,
    this.sndId,
    this.snDName,
    this.esuName,
    this.feederlineId,
    this.feederlineName,
    this.voltLavel,
    this.sectionName,
    this.surveyDate,
    this.verificationStateId,
  });

  factory SectionInfo.fromJson(Map<String, dynamic> json) {
    return SectionInfo(
      poleSectionId: json['poleSectionId'] as int?,
      zoneId: json['zoneId'] as int?,
      zoneName: json['zoneName'] as String?,
      circleId: json['circleId'] as int?,
      circleName: json['circleName'] as String?,
      sndId: json['sndId'] as int?,
      snDName: json['snDName'] as String?,
      esuName: json['esuName'] as String?,
      feederlineId: json['feederlineId'] as int?,
      feederlineName: json['feederlineName'] as String?,
      voltLavel: json['voltLavel'],
      sectionName: json['sectionName'] as String?,
      surveyDate: json['surveyDate'] != null
          ? DateTime.parse(json['surveyDate'])
          : null,
      verificationStateId: json['verificationStateId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'poleSectionId': poleSectionId,
      'zoneId': zoneId,
      'zoneName': zoneName,
      'circleId': circleId,
      'circleName': circleName,
      'sndId': sndId,
      'snDName': snDName,
      'esuName': esuName,
      'feederlineId': feederlineId,
      'feederlineName': feederlineName,
      'voltLavel': voltLavel,
      'sectionName': sectionName,
      'surveyDate': surveyDate?.toIso8601String(),
      'verificationStateId': verificationStateId,
    };
  }
}
class MapFeederLine {
  final int? feederLineId;
  final String? feederlinetypeId;
  final String? sndId;
  final String?  sourceSubstationId;
  final String? destinationSubstationId;
  final int? feederLineCode;
  final String? feederlineName;

  MapFeederLine({
    this.feederLineId,
    this.feederlinetypeId,
    this.sndId,
    this.sourceSubstationId,
    this.destinationSubstationId,
    this.feederLineCode,
    this.feederlineName,
  });

  factory MapFeederLine.fromJson(Map<String, dynamic> json) {
    return MapFeederLine(
      feederLineId: json['feederLineId'] as int?,
      //feederlinetypeId: json['feederlinetypeId'] as int?,
      feederlinetypeId: json['feederLineTypeId'] as String?,
      sndId: json['sndId'] as String?,
      sourceSubstationId: json['sourceSubstationId'] as String?,
      destinationSubstationId: json['destinationSubstationId'] as String?,
      feederLineCode: json['feederLineCode'] as int?,
      feederlineName: json['feederlineName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'feederLineId': feederLineId,
      'feederlinetypeId': feederlinetypeId,
      'sndId': sndId,
      'sourceSubstationId': sourceSubstationId,
      'destinationSubstationId': destinationSubstationId,
      'feederLineCode': feederLineCode,
      'feederlineName': feederlineName,
    };
  }
}

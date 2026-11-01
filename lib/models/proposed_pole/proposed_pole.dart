class ProposedPole {
  final String? poleId;
  final String? poleNo;
  final String? poleName;
  final double? poleHeight;
  final int? poleSectionId;
  final dynamic proposedPoleSection;
  final int? poleTypeId;
  final dynamic poleType;
  final String? areaName;
  final String? remarks;
  double? latitude;
  double? longitude;
  final int? activationStatusId;
  final dynamic dataActivationStatus;

  ProposedPole({
    this.poleId,
    this.poleNo,
    this.poleName,
    this.poleHeight,
    this.poleSectionId,
    this.proposedPoleSection,
    this.poleTypeId,
    this.poleType,
    this.areaName,
    this.remarks,
    this.latitude,
    this.longitude,
    this.activationStatusId,
    this.dataActivationStatus,
  });

  factory ProposedPole.fromJson(Map<String, dynamic> json) {
    return ProposedPole(
      poleId: json['poleId'],
      poleNo: json['poleNo'],
      poleName: json['poleName'],
      poleHeight: (json['poleHeight'] as num?)?.toDouble(),
      poleSectionId: json['poleSectionId'],
      proposedPoleSection: json['proposedPoleSection'],
      poleTypeId: json['poleTypeId'],
      poleType: json['poleType'],
      areaName: json['areaName'],
      remarks: json['remarks'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      activationStatusId: json['activationStatusId'],
      dataActivationStatus: json['dataActivationStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'poleId': poleId,
      'poleNo': poleNo,
      'poleName': poleName,
      'poleHeight': poleHeight,
      'poleSectionId': poleSectionId,
      'proposedPoleSection': proposedPoleSection,
      'poleTypeId': poleTypeId,
      'poleType': poleType,
      'areaName': areaName,
      'remarks': remarks,
      'latitude': latitude,
      'longitude': longitude,
      'activationStatusId': activationStatusId,
      'dataActivationStatus': dataActivationStatus,
    };
  }
}

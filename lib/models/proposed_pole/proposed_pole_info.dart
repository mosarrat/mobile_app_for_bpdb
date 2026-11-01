class PoposedPoleIListnfo {
  final int poleId;
  final String? poleNo;
  final String? poleName;
  final String? poleTypeName;
  final String? sectionName;
  final double? poleHeight;
  final String? areaName;
  final String? remarks;
  final double? latitude;
  final double? longitude;
  final int? activationStatusId;

  PoposedPoleIListnfo({
    required this.poleId,
    this.poleNo,
    this.poleName,
    this.poleTypeName,
    this.sectionName,
    this.poleHeight,
    this.areaName,
    this.remarks,
    this.latitude,
    this.longitude,
    this.activationStatusId,
  });

  factory PoposedPoleIListnfo.fromJson(Map<String, dynamic> json) {
    return PoposedPoleIListnfo(
      poleId: json['poleId'],
      poleNo: json['poleNo'],
      poleName: json['poleName'],
      poleTypeName: json['poleTypeName'],
      sectionName: json['sectionName'],
      poleHeight: (json['poleHeight'] as num?)?.toDouble(),
      areaName: json['areaName'],
      remarks: json['remarks'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      activationStatusId: json['activationStatusId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'poleId': poleId,
      'poleNo': poleNo,
      'poleName': poleName,
      'poleTypeName': poleTypeName,
      'sectionName': sectionName,
      'poleHeight': poleHeight,
      'areaName': areaName,
      'remarks': remarks,
      'latitude': latitude,
      'longitude': longitude,
      'activationStatusId': activationStatusId,
    };
  }
}

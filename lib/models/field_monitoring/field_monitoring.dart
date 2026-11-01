class FieldMonitoringData {
  final int? applicationId;
  final String? applicationTrackingNumber;
  final String? applicantName;
  final String? applicantNid;
  final String? applicantMobile;
  final bool? isLandDocumentOk;
  final double? meterLatitude;
  final double? meterLongitude;
  final bool? hasPreviousConnection;
  final String? arrearStatus;
  final double? distanceFromNearestPole;
  final double? estimatedLoad;
  final DateTime? submitDate;

  FieldMonitoringData({
    this.applicationId,
    this.applicationTrackingNumber,
    this.applicantName,
    this.applicantNid,
    this.applicantMobile,
    this.isLandDocumentOk,
    this.meterLatitude,
    this.meterLongitude,
    this.hasPreviousConnection,
    this.arrearStatus,
    this.distanceFromNearestPole,
    this.estimatedLoad,
    this.submitDate,
  });

  /// ✅ From JSON (GET API)
  factory FieldMonitoringData.fromJson(Map<String, dynamic> json) {
    return FieldMonitoringData(
      applicationId: json['applicationId'],
      applicationTrackingNumber: json['applicationTrackingNumber'],
      applicantName: json['applicantName'],
      applicantNid: json['applicantNid'],
      applicantMobile: json['applicantMobile'],
      isLandDocumentOk: json['isLandDocumentOk'],
      meterLatitude: json['meterLatitude'] != null
          ? (json['meterLatitude'] as num).toDouble()
          : null,
      meterLongitude: json['meterLongitude'] != null
          ? (json['meterLongitude'] as num).toDouble()
          : null,
      hasPreviousConnection: json['hasPreviousConnection'],
      arrearStatus: json['arrearStatus'],
      distanceFromNearestPole: json['distanceFromNearestPole'] != null
          ? (json['distanceFromNearestPole'] as num).toDouble()
          : null,
      estimatedLoad: json['estimatedLoad'] != null
          ? (json['estimatedLoad'] as num).toDouble()
          : null,
      submitDate: json['submitDate'] != null
          ? DateTime.parse(json['submitDate'])
          : null,
    );
  }

  /// ✅ To JSON (POST API)
  Map<String, dynamic> toJson() {
    return {
      "applicationId": applicationId,
      "applicationTrackingNumber": applicationTrackingNumber,
      "applicantName": applicantName,
      "applicantNid": applicantNid,
      "applicantMobile": applicantMobile,
      "isLandDocumentOk": isLandDocumentOk,
      "meterLatitude": meterLatitude,
      "meterLongitude": meterLongitude,
      "hasPreviousConnection": hasPreviousConnection,
      "arrearStatus": arrearStatus,
      "distanceFromNearestPole": distanceFromNearestPole,
      "estimatedLoad": estimatedLoad,
      "submitDate": submitDate?.toIso8601String(),
    };
  }
}
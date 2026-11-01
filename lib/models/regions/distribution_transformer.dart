class DistributionTransformer {
  final int? id;
  final String? distributionTransformerCode;
  final int? poleDetailsLeftId;
  final int? poleDetailsRightId;
  final String? dtLocationName;

  DistributionTransformer({
    this.id,
    this.distributionTransformerCode,
    this.poleDetailsLeftId,
    this.poleDetailsRightId,
    this.dtLocationName,
  });

  factory DistributionTransformer.fromJson(Map<String, dynamic> json) {
    return DistributionTransformer(
      id: json['id'] ?? 0,
      distributionTransformerCode: json['distributionTransformerCode'] ?? '',
      poleDetailsLeftId: json['poleDetailsLeftId'] ?? 0,
      poleDetailsRightId: json['poleDetailsRightId'] ?? 0,
      dtLocationName: json['dtLocationName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'distributionTransformerCode': distributionTransformerCode,
      'poleDetailsLeftId': poleDetailsLeftId,
      'poleDetailsRightId': poleDetailsRightId,
      'dtLocationName': dtLocationName,
    };
  }
}

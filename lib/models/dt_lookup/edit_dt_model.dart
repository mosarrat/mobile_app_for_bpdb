class DistributionTransformerEdit {
  final int id;
  final String? dtLocationName;
  final String? dtNumber;
  final String? nameof11KvFeeder;
  final String? nearestHoldingHouseNoShop;
  final int? bodyColorConditionId;
  final bool? oilLeakageYesOrNo;
  final int? dtConditionId;
  final String? conditionofTransformerSupportPoleLeft;
  final String? conditionofTransformerSupportPoleRight;
  final String? recommendation;
  final String? remarks;

  DistributionTransformerEdit({
    required this.id,
    this.dtLocationName,
    this.dtNumber,
    this.nameof11KvFeeder,
    this.nearestHoldingHouseNoShop,
    this.bodyColorConditionId,
    this.oilLeakageYesOrNo,
    this.dtConditionId,
    this.conditionofTransformerSupportPoleLeft,
    this.conditionofTransformerSupportPoleRight,
    this.recommendation,
    this.remarks,
  });

  factory DistributionTransformerEdit.fromJson(Map<String, dynamic> json) {
    return DistributionTransformerEdit(
      id: json['id'] ?? 0,
      dtLocationName: json['dtLocationName'],
      dtNumber: json['dtNumber'],
      nameof11KvFeeder: json['nameof11KvFeeder'],
      nearestHoldingHouseNoShop: json['nearestHoldingHouseNoShop'],
      bodyColorConditionId: json['bodyColorConditionId'],
      oilLeakageYesOrNo: json['oilLeakageYesOrNo'],
      dtConditionId: json['dtConditionId'],
      conditionofTransformerSupportPoleLeft:
          json['conditionofTransformerSupportPoleLeft'],
      conditionofTransformerSupportPoleRight:
          json['conditionofTransformerSupportPoleRight'],
      recommendation: json['recommendation'],
      remarks: json['remarks'],
    );
  }
}

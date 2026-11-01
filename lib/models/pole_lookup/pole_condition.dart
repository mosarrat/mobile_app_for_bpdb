class PoleCondition {
  int? poleConditionId;
  String? conditionName;

  PoleCondition({
    this.poleConditionId,
    this.conditionName,
  });

  factory PoleCondition.fromJson(Map<String, dynamic> json) {
    return PoleCondition(
      poleConditionId: json['poleConditionId'] as int?,
      conditionName: json['conditionName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'poleConditionId': poleConditionId,
      'conditionName': conditionName,
    };
  }
}
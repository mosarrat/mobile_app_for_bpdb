class PoleType {
  int? poleTypeId;
  String? poleTypeName;

  PoleType({
    this.poleTypeId,
    this.poleTypeName,
  });

  factory PoleType.fromJson(Map<String, dynamic> json) {
    return PoleType(
      poleTypeId: json['poleTypeId'] as int?,
      poleTypeName: json['poleTypeName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'poleTypeId': poleTypeId,
      'poleTypeName': poleTypeName,
    };
  }
}
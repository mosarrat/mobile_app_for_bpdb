class PhasingCode {
  final int phasingCodeId;
  final String phasingCodeName;

  PhasingCode({
    required this.phasingCodeId,
    required this.phasingCodeName,
  });

  factory PhasingCode.fromJson(Map<String, dynamic> json) {
    return PhasingCode(
      phasingCodeId: json['phasingCodeId'],
      phasingCodeName: json['phasingCodeName'],
    );
  }
  // Method to convert an instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'phasingCodeId': phasingCodeId,
      'phasingCodeName': phasingCodeName,
    };
  }
}
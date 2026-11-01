class NextNumberResponse {
  final String nextNumber;

  NextNumberResponse({required this.nextNumber});

  factory NextNumberResponse.fromJson(Map<String, dynamic> json) {
    return NextNumberResponse(
      nextNumber: json['nextNumber'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nextNumber': nextNumber,
    };
  }
}
class NextPoleResponse {
  final int sndId;
  final String nextPoleNo;

  NextPoleResponse({
    required this.sndId,
    required this.nextPoleNo,
  });

  factory NextPoleResponse.fromJson(Map<String, dynamic> json) {
    return NextPoleResponse(
      sndId: json['sndId'] as int,
      nextPoleNo: json['nextPoleNo'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sndId': sndId,
      'nextPoleNo': nextPoleNo,
    };
  }
}
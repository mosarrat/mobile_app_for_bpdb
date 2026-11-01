class PoleDetailsUpdate {
  final int poleDetailsId;
  final int substationId;
  final int feederLineId;
  final int lineTypeId;
  final int typeOfWireId;
  final String poleNo;
  final String previousPoleNo;
  final double? wireLength;
  final double? backSpan;

  PoleDetailsUpdate({
    required this.poleDetailsId,
    required this.substationId,
    required this.feederLineId,
    required this.lineTypeId,
    required this.typeOfWireId,
    required this.poleNo,
    required this.previousPoleNo,
    this.wireLength,
    this.backSpan,
  });

  Map<String, dynamic> toJson() => {
    'poleDetailsId': poleDetailsId,
    'substationId': substationId,
    'feederLineId': feederLineId,
    'lineTypeId': lineTypeId,
    'typeOfWireId': typeOfWireId,
    'poleNo': poleNo,
    'previousPoleNo': previousPoleNo,
    'wireLength': wireLength,
    'backSpan': backSpan,
  };
}
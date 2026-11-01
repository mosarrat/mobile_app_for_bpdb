class StructureType {
  final int structureTypeId;
  final String structureTypeName;

  StructureType({
    required this.structureTypeId,
    required this.structureTypeName,
  });

  factory StructureType.fromJson(Map<String, dynamic> json) {
    return StructureType(
      structureTypeId: json['structureTypeId'],
      structureTypeName: json['structureTypeName'],
    );
  }
  // Method to convert an instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'structureTypeId': structureTypeId,
      'structureTypeName': structureTypeName,
    };
  }
}
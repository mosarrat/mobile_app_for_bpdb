class FeederLinesById {
  String zoneId;
  String circleId;
  String sndId;
  dynamic esuId;
  String sourceSubstationId;
  String destinationSubstationId;
  int feederLineId;
  String feederLineCode;  
  String feederlineName;
  bool isGrid;
  String feederLineTypeId;
  String feederConductorTypeId;
  double nominalVoltage;
  dynamic feederLocation;
  dynamic feederMeterNumber;
  dynamic meterCurrentRating;
  dynamic meterVoltageRating;
  dynamic maximumDemand;
  dynamic peakDemand;
  dynamic maximumLoad;
  dynamic sanctionedLoad;
  bool isBulkCustomer;
  dynamic bulkCustomerName;
  bool isPgcbGrid;
  dynamic remarks;

  FeederLinesById({
    required this.zoneId,
    required this.circleId,
    required this.sndId,
    this.esuId,
    required this.sourceSubstationId,
    required this.destinationSubstationId,
    required this.feederLineId,
    required this.feederLineCode,  // Change to required
    required this.feederlineName,
    required this.isGrid,
    required this.feederLineTypeId,
    required this.feederConductorTypeId,
    required this.nominalVoltage,
    this.feederLocation,
    this.feederMeterNumber,
    this.meterCurrentRating,
    this.meterVoltageRating,
    this.maximumDemand,
    this.peakDemand,
    this.maximumLoad,
    this.sanctionedLoad,
    required this.isBulkCustomer,
    this.bulkCustomerName,
    required this.isPgcbGrid,
    this.remarks,
  });

  factory FeederLinesById.fromJson(Map<String, dynamic> json) {
    return FeederLinesById(
      zoneId: json['zoneId'] ?? '',
      circleId: json['circleId'] ?? '',
      sndId: json['sndId'] ?? '',
      esuId: json['esuId'],
      sourceSubstationId: json['sourceSubstationId'] ?? '',
      destinationSubstationId: json['destinationSubstationId'] ?? '',
      feederLineId: json['feederLineId'] ?? 0,
      feederLineCode: json['feederLineCode'].toString(),  // Ensure conversion to String
      feederlineName: json['feederlineName'] ?? '',
      isGrid: json['isGrid'] ?? false,
      feederLineTypeId: json['feederLineTypeId'] ?? '',
      feederConductorTypeId: json['feederConductorTypeId'] ?? '',
      nominalVoltage: (json['nominalVoltage'] as num?)?.toDouble() ?? 0.0,
      feederLocation: json['feederLocation'],
      feederMeterNumber: json['feederMeterNumber'],
      meterCurrentRating: json['meterCurrentRating'],
      meterVoltageRating: json['meterVoltageRating'],
      maximumDemand: json['maximumDemand'],
      peakDemand: json['peakDemand'],
      maximumLoad: json['maximumLoad'],
      sanctionedLoad: json['sanctionedLoad'],
      isBulkCustomer: json['isBulkCustomer'] ?? false,
      bulkCustomerName: json['bulkCustomerName'],
      isPgcbGrid: json['isPgcbGrid'] ?? false,
      remarks: json['remarks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'zoneId': zoneId,
      'circleId': circleId,
      'sndId': sndId,
      'esuId': esuId,
      'sourceSubstationId': sourceSubstationId,
      'destinationSubstationId': destinationSubstationId,
      'feederLineId': feederLineId,
      'feederLineCode': feederLineCode,  // Ensure conversion to String
      'feederlineName': feederlineName,
      'isGrid': isGrid,
      'feederLineTypeId': feederLineTypeId,
      'feederConductorTypeId': feederConductorTypeId,
      'nominalVoltage': nominalVoltage,
      'feederLocation': feederLocation,
      'feederMeterNumber': feederMeterNumber,
      'meterCurrentRating': meterCurrentRating,
      'meterVoltageRating': meterVoltageRating,
      'maximumDemand': maximumDemand,
      'peakDemand': peakDemand,
      'maximumLoad': maximumLoad,
      'sanctionedLoad': sanctionedLoad,
      'isBulkCustomer': isBulkCustomer,
      'bulkCustomerName': bulkCustomerName,
      'isPgcbGrid': isPgcbGrid,
      'remarks': remarks,
    };
  }
}

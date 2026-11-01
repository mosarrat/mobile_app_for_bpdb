// class FeederLines {
//   int feederLineId;
//   String feederLineCode;
//   int zoneId;
//   dynamic zoneInfo;
//   int circleId;
//   dynamic circleInfo;
//   int sndId;
//   dynamic sndInfo;
//   dynamic esuId;
//   dynamic esuInfo;
//   int sourceSubstationId;
//   dynamic sourceSubstation;
//   int destinationSubstationId;
//   dynamic destinationSubstation;
//   dynamic servicesPointId;
//   dynamic feederLineToServicesPoint;
//   String feederlineName;
//   bool isGrid;
//   int gridSubstationInputId;
//   dynamic sourceGridId;
//   dynamic feederLineToGrid;
//   String feederLineUId;
//   int feederLineTypeId;
//   dynamic feederLineType;
//   int feederConductorTypeId;
//   dynamic feederConductorType;
//   double nominalVoltage;
//   dynamic feederLocation;
//   dynamic feederMeterNumber;
//   dynamic meterCurrentRating;
//   dynamic meterVoltageRating;
//   dynamic maximumDemand;
//   dynamic peakDemand;
//   dynamic maximumLoad;
//   dynamic sanctionedLoad;
//   bool isBulkCustomer;
//   dynamic bulkCustomerName;
//   bool isPgcbGrid;
//   String startingDate;
//   dynamic endingDate;
//   int activationStatusId;
//   dynamic dataActivationStatus;
//   int verificationStateId;
//   dynamic dataVerificationState;
//   dynamic remarks;
//   bool isPermittedToVerify;
//   bool isPermittedToApprove;
//   bool isEditAvailable;
//   dynamic poles;
//   int feederLength;

//   FeederLines({
//     required this.feederLineId,
//     required this.feederLineCode,
//     required this.zoneId,
//     this.zoneInfo,
//     required this.circleId,
//     this.circleInfo,
//     required this.sndId,
//     this.sndInfo,
//     this.esuId,
//     this.esuInfo,
//     required this.sourceSubstationId,
//     this.sourceSubstation,
//     required this.destinationSubstationId,
//     this.destinationSubstation,
//     this.servicesPointId,
//     this.feederLineToServicesPoint,
//     required this.feederlineName,
//     required this.isGrid,
//     required this.gridSubstationInputId,
//     this.sourceGridId,
//     this.feederLineToGrid,
//     required this.feederLineUId,
//     required this.feederLineTypeId,
//     this.feederLineType,
//     required this.feederConductorTypeId,
//     this.feederConductorType,
//     required this.nominalVoltage,
//     this.feederLocation,
//     this.feederMeterNumber,
//     this.meterCurrentRating,
//     this.meterVoltageRating,
//     this.maximumDemand,
//     this.peakDemand,
//     this.maximumLoad,
//     this.sanctionedLoad,
//     required this.isBulkCustomer,
//     this.bulkCustomerName,
//     required this.isPgcbGrid,
//     required this.startingDate,
//     this.endingDate,
//     required this.activationStatusId,
//     this.dataActivationStatus,
//     required this.verificationStateId,
//     this.dataVerificationState,
//     this.remarks,
//     required this.isPermittedToVerify,
//     required this.isPermittedToApprove,
//     required this.isEditAvailable,
//     this.poles,
//     required this.feederLength,
//   });

//   factory FeederLines.fromJson(Map<String, dynamic> json) {
//     return FeederLines(
//       feederLineId: json['feederLineId'] ?? 0,
//       feederLineCode: json['feederLineCode'] ?? '',
//       zoneId: json['zoneId'] ?? 0,
//       zoneInfo: json['zoneInfo'],
//       circleId: json['circleId'] ?? 0,
//       circleInfo: json['circleInfo'],
//       sndId: json['sndId'] ?? 0,
//       sndInfo: json['sndInfo'],
//       esuId: json['esuId'],
//       esuInfo: json['esuInfo'],
//       sourceSubstationId: json['sourceSubstationId'] ?? 0,
//       sourceSubstation: json['sourceSubstation'],
//       destinationSubstationId: json['destinationSubstationId'] ?? 0,
//       destinationSubstation: json['destinationSubstation'],
//       servicesPointId: json['servicesPointId'],
//       feederLineToServicesPoint: json['feederLineToServicesPoint'],
//       feederlineName: json['feederlineName'] ?? '',
//       isGrid: json['isGrid'] ?? false,
//       gridSubstationInputId: json['gridSubstationInputId'] ?? 0,
//       sourceGridId: json['sourceGridId'],
//       feederLineToGrid: json['feederLineToGrid'],
//       feederLineUId: json['feederLineUId'] ?? '',
//       feederLineTypeId: json['feederLineTypeId'] ?? 0,
//       feederLineType: json['feederLineType'],
//       feederConductorTypeId: json['feederConductorTypeId'] ?? 0,
//       feederConductorType: json['feederConductorType'],
//       nominalVoltage: (json['nominalVoltage'] as num?)?.toDouble() ?? 0.0,
//       feederLocation: json['feederLocation'],
//       feederMeterNumber: json['feederMeterNumber'],
//       meterCurrentRating: json['meterCurrentRating'],
//       meterVoltageRating: json['meterVoltageRating'],
//       maximumDemand: json['maximumDemand'],
//       peakDemand: json['peakDemand'],
//       maximumLoad: json['maximumLoad'],
//       sanctionedLoad: json['sanctionedLoad'],
//       isBulkCustomer: json['isBulkCustomer'] ?? false,
//       bulkCustomerName: json['bulkCustomerName'],
//       isPgcbGrid: json['isPgcbGrid'] ?? false,
//       startingDate: json['startingDate'] ?? '',
//       endingDate: json['endingDate'],
//       activationStatusId: json['activationStatusId'] ?? 0,
//       dataActivationStatus: json['dataActivationStatus'],
//       verificationStateId: json['verificationStateId'] ?? 0,
//       dataVerificationState: json['dataVerificationState'],
//       remarks: json['remarks'],
//       isPermittedToVerify: json['isPermittedToVerify'] ?? false,
//       isPermittedToApprove: json['isPermittedToApprove'] ?? false,
//       isEditAvailable: json['isEditAvailable'] ?? false,
//       poles: json['poles'],
//       feederLength: json['feederLength'] ?? 0,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'feederLineId': feederLineId,
//       'feederLineCode': feederLineCode,
//       'zoneId': zoneId,
//       'zoneInfo': zoneInfo,
//       'circleId': circleId,
//       'circleInfo': circleInfo,
//       'sndId': sndId,
//       'sndInfo': sndInfo,
//       'esuId': esuId,
//       'esuInfo': esuInfo,
//       'sourceSubstationId': sourceSubstationId,
//       'sourceSubstation': sourceSubstation,
//       'destinationSubstationId': destinationSubstationId,
//       'destinationSubstation': destinationSubstation,
//       'servicesPointId': servicesPointId,
//       'feederLineToServicesPoint': feederLineToServicesPoint,
//       'feederlineName': feederlineName,
//       'isGrid': isGrid,
//       'gridSubstationInputId': gridSubstationInputId,
//       'sourceGridId': sourceGridId,
//       'feederLineToGrid': feederLineToGrid,
//       'feederLineUId': feederLineUId,
//       'feederLineTypeId': feederLineTypeId,
//       'feederLineType': feederLineType,
//       'feederConductorTypeId': feederConductorTypeId,
//       'feederConductorType': feederConductorType,
//       'nominalVoltage': nominalVoltage,
//       'feederLocation': feederLocation,
//       'feederMeterNumber': feederMeterNumber,
//       'meterCurrentRating': meterCurrentRating,
//       'meterVoltageRating': meterVoltageRating,
//       'maximumDemand': maximumDemand,
//       'peakDemand': peakDemand,
//       'maximumLoad': maximumLoad,
//       'sanctionedLoad': sanctionedLoad,
//       'isBulkCustomer': isBulkCustomer,
//       'bulkCustomerName': bulkCustomerName,
//       'isPgcbGrid': isPgcbGrid,
//       'startingDate': startingDate,
//       'endingDate': endingDate,
//       'activationStatusId': activationStatusId,
//       'dataActivationStatus': dataActivationStatus,
//       'verificationStateId': verificationStateId,
//       'dataVerificationState': dataVerificationState,
//       'remarks': remarks,
//       'isPermittedToVerify': isPermittedToVerify,
//       'isPermittedToApprove': isPermittedToApprove,
//       'isEditAvailable': isEditAvailable,
//       'poles': poles,
//       'feederLength': feederLength,
//     };
//   }
// }

// class FeederLines {
//   int feederLineId;
//   String? feederLineCode;
//   int zoneId;
//   dynamic zoneInfo;
//   int circleId;
//   dynamic circleInfo;
//   int sndId;
//   dynamic sndInfo;
//   int? esuId;
//   dynamic esuInfo;
//   int? sourceSubstationId;
//   dynamic sourceSubstation;
//   int? destinationSubstationId;
//   dynamic destinationSubstation;
//   int? servicesPointId;
//   dynamic feederLineToServicesPoint;
//   String? feederlineName;
//   bool isGrid;
//   int? gridSubstationInputId;
//   int? sourceGridId;
//   dynamic feederLineToGrid;
//   String? feederLineUId;
//   int? feederLineTypeId;
//   dynamic feederLineType;
//   int? feederConductorTypeId;
//   dynamic feederConductorType;
//   double? nominalVoltage;
//   dynamic feederLocation;
//   String? feederMeterNumber;
//   double? feederLength;
//   dynamic meterCurrentRating;
//   dynamic meterVoltageRating;
//   dynamic maximumDemand;
//   dynamic peakDemand;
//   dynamic maximumLoad;
//   dynamic sanctionedLoad;
//   bool isBulkCustomer;
//   String? bulkCustomerName;
//   bool? isPgcbGrid;
//   String? startingDate;
//   String? endingDate;
//   int? activationStatusId;
//   dynamic dataActivationStatus;
//   int? verificationStateId;
//   dynamic dataVerificationState;
//   String? remarks;
//   bool? isPermittedToVerify;
//   bool? isPermittedToApprove;
//   bool? isEditAvailable;
//   dynamic poles;
//   double? feederLengthCal;

//   FeederLines({
//     required this.feederLineId,
//     this.feederLineCode,
//     required this.zoneId,
//     this.zoneInfo,
//     required this.circleId,
//     this.circleInfo,
//     required this.sndId,
//     this.sndInfo,
//     this.esuId,
//     this.esuInfo,
//     this.sourceSubstationId,
//     this.sourceSubstation,
//     this.destinationSubstationId,
//     this.destinationSubstation,
//     this.servicesPointId,
//     this.feederLineToServicesPoint,
//     this.feederlineName,
//     required this.isGrid,
//     this.gridSubstationInputId,
//     this.sourceGridId,
//     this.feederLineToGrid,
//     this.feederLineUId,
//     this.feederLineTypeId,
//     this.feederLineType,
//     this.feederConductorTypeId,
//     this.feederConductorType,
//     this.nominalVoltage,
//     this.feederLocation,
//     this.feederMeterNumber,
//     this.feederLength,
//     this.meterCurrentRating,
//     this.meterVoltageRating,
//     this.maximumDemand,
//     this.peakDemand,
//     this.maximumLoad,
//     this.sanctionedLoad,
//     required this.isBulkCustomer,
//     this.bulkCustomerName,
//     this.isPgcbGrid,
//     this.startingDate,
//     this.endingDate,
//     this.activationStatusId,
//     this.dataActivationStatus,
//     this.verificationStateId,
//     this.dataVerificationState,
//     this.remarks,
//     this.isPermittedToVerify,
//     this.isPermittedToApprove,
//     this.isEditAvailable,
//     this.poles,
//     this.feederLengthCal,
//   });

//   factory FeederLines.fromJson(Map<String, dynamic> json) {
//     return FeederLines(
//       feederLineId: json['feederLineId'],
//       feederLineCode: json['feederLineCode'],
//       zoneId: json['zoneId'],
//       zoneInfo: json['zoneInfo'],
//       circleId: json['circleId'],
//       circleInfo: json['circleInfo'],
//       sndId: json['sndId'],
//       sndInfo: json['sndInfo'],
//       esuId: json['esuId'],
//       esuInfo: json['esuInfo'],
//       sourceSubstationId: json['sourceSubstationId'],
//       sourceSubstation: json['sourceSubstation'],
//       destinationSubstationId: json['destinationSubstationId'],
//       destinationSubstation: json['destinationSubstation'],
//       servicesPointId: json['servicesPointId'],
//       feederLineToServicesPoint: json['feederLineToServicesPoint'],
//       feederlineName: json['feederlineName'],
//       isGrid: json['isGrid'],
//       gridSubstationInputId: json['gridSubstationInputId'],
//       sourceGridId: json['sourceGridId'],
//       feederLineToGrid: json['feederLineToGrid'],
//       feederLineUId: json['feederLineUId'],
//       feederLineTypeId: json['feederLineTypeId'],
//       feederLineType: json['feederLineType'],
//       feederConductorTypeId: json['feederConductorTypeId'],
//       feederConductorType: json['feederConductorType'],
//       nominalVoltage: json['nominalVoltage']?.toDouble(),
//       feederLocation: json['feederLocation'],
//       feederMeterNumber: json['feederMeterNumber'],
//       feederLength: json['feederLength']?.toDouble(),
//       meterCurrentRating: json['meterCurrentRating'],
//       meterVoltageRating: json['meterVoltageRating'],
//       maximumDemand: json['maximumDemand'],
//       peakDemand: json['peakDemand'],
//       maximumLoad: json['maximumLoad'],
//       sanctionedLoad: json['sanctionedLoad'],
//       isBulkCustomer: json['isBulkCustomer'],
//       bulkCustomerName: json['bulkCustomerName'],
//       isPgcbGrid: json['isPgcbGrid'],
//       // startingDate: json['startingDate'] != null
//       //     ? DateTime.parse(json['startingDate'])
//       //     : null,
//       // endingDate: json['endingDate'] != null
//       //     ? DateTime.parse(json['endingDate'])
//       //     : null,
//       startingDate: json['startingDate'] ?? '',
//       endingDate: json['endingDate'],
//       activationStatusId: json['activationStatusId'],
//       dataActivationStatus: json['dataActivationStatus'],
//       verificationStateId: json['verificationStateId'],
//       dataVerificationState: json['dataVerificationState'],
//       remarks: json['remarks'],
//       isPermittedToVerify: json['isPermittedToVerify'],
//       isPermittedToApprove: json['isPermittedToApprove'],
//       isEditAvailable: json['isEditAvailable'],
//       poles: json['poles'],
//       feederLengthCal: json['feederLengthCal']?.toDouble(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'feederLineId': feederLineId,
//       'feederLineCode': feederLineCode,
//       'zoneId': zoneId,
//       'zoneInfo': zoneInfo,
//       'circleId': circleId,
//       'circleInfo': circleInfo,
//       'sndId': sndId,
//       'sndInfo': sndInfo,
//       'esuId': esuId,
//       'esuInfo': esuInfo,
//       'sourceSubstationId': sourceSubstationId,
//       'sourceSubstation': sourceSubstation,
//       'destinationSubstationId': destinationSubstationId,
//       'destinationSubstation': destinationSubstation,
//       'servicesPointId': servicesPointId,
//       'feederLineToServicesPoint': feederLineToServicesPoint,
//       'feederlineName': feederlineName,
//       'isGrid': isGrid,
//       'gridSubstationInputId': gridSubstationInputId,
//       'sourceGridId': sourceGridId,
//       'feederLineToGrid': feederLineToGrid,
//       'feederLineUId': feederLineUId,
//       'feederLineTypeId': feederLineTypeId,
//       'feederLineType': feederLineType,
//       'feederConductorTypeId': feederConductorTypeId,
//       'feederConductorType': feederConductorType,
//       'nominalVoltage': nominalVoltage,
//       'feederLocation': feederLocation,
//       'feederMeterNumber': feederMeterNumber,
//       'feederLength': feederLength,
//       'meterCurrentRating': meterCurrentRating,
//       'meterVoltageRating': meterVoltageRating,
//       'maximumDemand': maximumDemand,
//       'peakDemand': peakDemand,
//       'maximumLoad': maximumLoad,
//       'sanctionedLoad': sanctionedLoad,
//       'isBulkCustomer': isBulkCustomer,
//       'bulkCustomerName': bulkCustomerName,
//       'isPgcbGrid': isPgcbGrid,
//       'startingDate': startingDate,
//       'endingDate': endingDate,
//       'activationStatusId': activationStatusId,
//       'dataActivationStatus': dataActivationStatus,
//       'verificationStateId': verificationStateId,
//       'dataVerificationState': dataVerificationState,
//       'remarks': remarks,
//       'isPermittedToVerify': isPermittedToVerify,
//       'isPermittedToApprove': isPermittedToApprove,
//       'isEditAvailable': isEditAvailable,
//       'poles': poles,
//       'feederLengthCal': feederLengthCal,
//     };
//   }
// }


class FeederLines {
  int feederLineId;
  String? feederLineCode;
  String? feederlineName;
  String? feederLineUId;
  bool isGrid;
  double? nominalVoltage;
  double? feederLength;
  String? feederLocation;
  String? feederMeterNumber;
  dynamic meterCurrentRating;
  dynamic meterVoltageRating;
  dynamic maximumDemand;
  dynamic peakDemand;
  dynamic maximumLoad;
  dynamic sanctionedLoad;
  bool isBulkCustomer;
  String? bulkCustomerName;
  bool? isPgcbGrid;
  String? startingDate;
  String? endingDate;
  String? remarks;
  int? sourceDtId;
  
  int zoneId;
  String? zoneName;
  int circleId;
  String? circleName;
  int sndId;
  String? snDName;
  int? esuId;
  String? esuName;
  int? sourceSubstationId;
  String? sourceSubstationName;
  int? destinationSubstationId;
  String? destinationSubstationName;

  int? feederLineTypeId;
  String? feederLineTypeName;
  int? feederConductorTypeId;
  String? feederConductorTypeName;
  int? activationStatusId;
  String? activationStatusName;
  int? verificationStateId;
  String? verificationStateName;
  int? operatingSndId;
  String? operatingSndName;
  int? gridSubstationInputId;
  bool? isPermittedToVerify;
  bool? isPermittedToApprove;
  bool? isEditAvailable;

  FeederLines({
    required this.feederLineId,
    this.feederLineCode,
    this.feederlineName,
    this.feederLineUId,
    required this.isGrid,
    this.nominalVoltage,
    this.feederLength,
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
    this.isPgcbGrid,
    this.startingDate,
    this.endingDate,
    this.remarks,
    this.sourceDtId,
    required this.zoneId,
    this.zoneName,
    required this.circleId,
    this.circleName,
    required this.sndId,
    this.snDName,
    this.esuId,
    this.esuName,
    this.sourceSubstationId,
    this.sourceSubstationName,
    this.destinationSubstationId,
    this.destinationSubstationName,
    this.feederLineTypeId,
    this.feederLineTypeName,
    this.feederConductorTypeId,
    this.feederConductorTypeName,
    this.activationStatusId,
    this.activationStatusName,
    this.verificationStateId,
    this.verificationStateName,
    this.operatingSndId,
    this.operatingSndName,
    this.gridSubstationInputId,
    this.isPermittedToVerify,
    this.isPermittedToApprove,
    this.isEditAvailable,
  });

  factory FeederLines.fromJson(Map<String, dynamic> json) {
    return FeederLines(
      feederLineId: json['feederLineId'] ?? 0,
      feederLineCode: json['feederLineCode'],
      feederlineName: json['feederlineName'],
      feederLineUId: json['feederLineUId'],
      isGrid: json['isGrid'] ?? false,
      nominalVoltage: (json['nominalVoltage'] as num?)?.toDouble(),
      feederLength: (json['feederLength'] as num?)?.toDouble(),
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
      isPgcbGrid: json['isPgcbGrid'],
      startingDate: json['startingDate'],
      endingDate: json['endingDate'],
      remarks: json['remarks'],
      sourceDtId: json['sourceDtId'],
      zoneId: json['zoneId'] ?? 0,
      zoneName: json['zoneName'],
      circleId: json['circleId'] ?? 0,
      circleName: json['circleName'],
      sndId: json['sndId'] ?? 0,
      snDName: json['snDName'],
      esuId: json['esuId'],
      esuName: json['esuName'],
      sourceSubstationId: json['sourceSubstationId'],
      sourceSubstationName: json['sourceSubstationName'],
      destinationSubstationId: json['destinationSubstationId'],
      destinationSubstationName: json['destinationSubstationName'],
      feederLineTypeId: json['feederLineTypeId'],
      feederLineTypeName: json['feederLineTypeName'],
      feederConductorTypeId: json['feederConductorTypeId'],
      feederConductorTypeName: json['feederConductorTypeName'],
      activationStatusId: json['activationStatusId'],
      activationStatusName: json['activationStatusName'],
      verificationStateId: json['verificationStateId'],
      verificationStateName: json['verificationStateName'],
      operatingSndId: json['operatingSndId'],
      operatingSndName: json['operatingSndName'],
      gridSubstationInputId: json['gridSubstationInputId'],
      isPermittedToVerify: json['isPermittedToVerify'],
      isPermittedToApprove: json['isPermittedToApprove'],
      isEditAvailable: json['isEditAvailable'],
    );
  }

  Map<String, dynamic> toJson() => {
        'feederLineId': feederLineId,
        'feederLineCode': feederLineCode,
        'feederlineName': feederlineName,
        'feederLineUId': feederLineUId,
        'isGrid': isGrid,
        'nominalVoltage': nominalVoltage,
        'feederLength': feederLength,
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
        'startingDate': startingDate,
        'endingDate': endingDate,
        'remarks': remarks,
        'sourceDtId': sourceDtId,
        'zoneId': zoneId,
        'zoneName': zoneName,
        'circleId': circleId,
        'circleName': circleName,
        'sndId': sndId,
        'snDName': snDName,
        'esuId': esuId,
        'esuName': esuName,
        'sourceSubstationId': sourceSubstationId,
        'sourceSubstationName': sourceSubstationName,
        'destinationSubstationId': destinationSubstationId,
        'destinationSubstationName': destinationSubstationName,
        'feederLineTypeId': feederLineTypeId,
        'feederLineTypeName': feederLineTypeName,
        'feederConductorTypeId': feederConductorTypeId,
        'feederConductorTypeName': feederConductorTypeName,
        'activationStatusId': activationStatusId,
        'activationStatusName': activationStatusName,
        'verificationStateId': verificationStateId,
        'verificationStateName': verificationStateName,
        'operatingSndId': operatingSndId,
        'operatingSndName': operatingSndName,
        'gridSubstationInputId': gridSubstationInputId,
        'isPermittedToVerify': isPermittedToVerify,
        'isPermittedToApprove': isPermittedToApprove,
        'isEditAvailable': isEditAvailable,
      };
}



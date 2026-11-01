class Consumer {
  final int consumerId;
  final int servicesPointId;
  final String zoneName;
  final String circleName;
  final String snDName;
  final String? esuName;
  final String substationName;
  final String feederlineName;
  final int dtId;
  final int substationId;
  final int feederLineId;
  final int poleDetailsId;
  final String customerName;
  final String? customerNameBng;
  final String? customerNid;
  final String? fatherName;
  final String? mobileNo;
  final String? email;
  final String consumerNo;
  final int? tariffCategoryId;
  final int tariffSubCategoryId;
  final String tariff;
  final int phasingCodeTypeId;
  final String? phasingCodeName;
  final int consumerTypeId;
  final String? consumerTypeName;
  final int operatingVoltageId;
  final String? operatingVoltageName;
  final DateTime? installDate;
  final int connectionStatusId;
  final String? connectionStatusName;
  final int connectionTypeId;
  final int meterTypeId;
  final String? meterTypeName;
  final String meterNumber;
  final String? meterModel;
  final String meterManufacturer;
  final double sanctionedLoad;
  final double connectedLoad;
  final int? businessTypeId;
  final String? businessTypeName;
  final String? othersBusiness;
  final String accountNumber;
  final String specialCode;
  final String specialType;
  final int locationId;
  final String? billGroup;
  final String? bookNumber;
  final double? omfKwh;
  final double? meterReading;
  final int serviceCableSize;
  final String? poleNo;
  final int serviceCableTypeId;
  final String? serviceCableTypeName;
  final String? customerAddress;
  final String unionGeoCode;
  final String? plotNo;
  final String? buildingAptNo;
  final String? premiseName;
  final DateTime? surveyDate;
  final double latitude;
  final double longitude;
  final int? structureId;
  final String? structureMapNo;
  final int? structureTypeId;
  final int numberOfFloor;
  final double? distanceFromSp;
  final double? distanceFromDt;
  final DateTime? startingDate;
  final DateTime? endingDate;
  final int activationStatusId;
  final int verificationStateId;
  final String? remarks;

  Consumer({
    required this.consumerId,
    required this.servicesPointId,
    required this.zoneName,
    required this.circleName,
    required this.snDName,
    this.esuName,
    required this.substationName,
    required this.feederlineName,
    required this.dtId,
    required this.substationId,
    required this.feederLineId,
    required this.poleDetailsId,
    required this.customerName,
    this.customerNameBng,
    this.customerNid,
    this.fatherName,
    this.mobileNo,
    this.email,
    required this.consumerNo,
    this.tariffCategoryId,
    required this.tariffSubCategoryId,
    required this.tariff,
    required this.phasingCodeTypeId,
    this.phasingCodeName,
    required this.consumerTypeId,
    this.consumerTypeName,
    required this.operatingVoltageId,
    this.operatingVoltageName,
    this.installDate,
    required this.connectionStatusId,
    this.connectionStatusName,
    required this.connectionTypeId,
    required this.meterTypeId,
    this.meterTypeName,
    required this.meterNumber,
    this.meterModel,
    required this.meterManufacturer,
    required this.sanctionedLoad,
    required this.connectedLoad,
    this.businessTypeId,
    this.businessTypeName,
    this.othersBusiness,
    required this.accountNumber,
    required this.specialCode,
    required this.specialType,
    required this.locationId,
    this.billGroup,
    this.bookNumber,
    this.omfKwh,
    this.meterReading,
    required this.serviceCableSize,
    this.poleNo,
    required this.serviceCableTypeId,
    this.serviceCableTypeName,
    this.customerAddress,
    required this.unionGeoCode,
    this.plotNo,
    this.buildingAptNo,
    this.premiseName,
    this.surveyDate,
    required this.latitude,
    required this.longitude,
    this.structureId,
    this.structureMapNo,
    this.structureTypeId,
    required this.numberOfFloor,
    this.distanceFromSp,
    this.distanceFromDt,
    this.startingDate,
    this.endingDate,
    required this.activationStatusId,
    required this.verificationStateId,
    this.remarks,
  });

  factory Consumer.fromJson(Map<String, dynamic> json) {
    return Consumer(
      consumerId: json['consumerId'] ?? 0,
      servicesPointId: json['servicesPointId'] ?? 0,
      zoneName: json['zoneName'] ?? '',
      circleName: json['circleName'] ?? '',
      snDName: json['snDName'] ?? '',
      esuName: json['esuName'],
      substationName: json['substationName'] ?? '',
      feederlineName: json['feederlineName'] ?? '',
      dtId: json['dtId'] ?? 0,
      substationId: json['substationId'] ?? 0,
      feederLineId: json['feederLineId'] ?? 0,
      poleDetailsId: json['poleDetailsId'] ?? 0,
      customerName: json['customerName'] ?? '',
      customerNameBng: json['customerNameBng'],
      customerNid: json['customerNid'],
      fatherName: json['fatherName'],
      mobileNo: json['mobileNo'],
      email: json['email'],
      consumerNo: json['consumerNo'] ?? '',
      tariffCategoryId: json['tariffCategoryId'] != null
          ? int.tryParse(json['tariffCategoryId'].toString())
          : null,
      tariffSubCategoryId: json['tariffSubCategoryId'] ?? 0,
      tariff: json['tariff'] ?? '',
      phasingCodeTypeId: json['phasingCodeTypeId'] ?? 0,
      phasingCodeName: json['phasingCodeName'] ?? '',
      consumerTypeId: json['consumerTypeId'] ?? 0,
      consumerTypeName: json['consumerTypeName'] ?? '',
      operatingVoltageId: json['operatingVoltageId'] ?? 0,
      operatingVoltageName: json['operatingVoltageName'] ?? '',
      installDate: json['installDate'] != null
          ? DateTime.parse(json['installDate'])
          : null,
      connectionStatusId: json['connectionStatusId'] ?? 0,
      connectionStatusName: json['connectionStatusName'] ?? '',
      connectionTypeId: json['connectionTypeId'] ?? 0,
      meterTypeId: json['meterTypeId'] ?? 0,
      meterTypeName: json['meterTypeName'] ?? '',
      meterNumber: json['meterNumber'] ?? '',
      meterModel: json['meterModel'],
      meterManufacturer: json['meterManufacturer'] ?? '',
      sanctionedLoad: json['sanctionedLoad']?.toDouble() ?? 0.0,
      connectedLoad: json['connectedLoad']?.toDouble() ?? 0.0,
      businessTypeId: json['businessTypeId'] != null
          ? int.tryParse(json['businessTypeId'].toString())
          : null,
      businessTypeName: json['businessTypeName'] ?? '',
      othersBusiness: json['othersBusiness'],
      accountNumber: json['accountNumber'] ?? '',
      specialCode: json['specialCode'] ?? '',
      specialType: json['specialType'] ?? '',
      locationId: json['locationId'] ?? 0,
      billGroup: json['billGroup'],
      bookNumber: json['bookNumber'],
      omfKwh: json['omfKwh']?.toDouble(),
      meterReading: json['meterReading']?.toDouble(),
      serviceCableSize: json['serviceCableSize'] ?? 0,
      poleNo: json['poleNo'],
      serviceCableTypeId: json['serviceCableTypeId'] ?? 0,
      serviceCableTypeName: json['serviceCableTypeName'],
      customerAddress: json['customerAddress'],
      unionGeoCode: json['unionGeoCode'] ?? '',
      plotNo: json['plotNo'],
      buildingAptNo: json['buildingAptNo'],
      premiseName: json['premiseName'],
      surveyDate: json['surveyDate'] != null
          ? DateTime.parse(json['surveyDate'])
          : null,
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      structureId: json['structureId'] != null
          ? int.tryParse(json['structureId'].toString())
          : null,
      structureMapNo: json['structureMapNo'],
      structureTypeId: json['structureTypeId'] != null
          ? int.tryParse(json['structureTypeId'].toString())
          : null,
      numberOfFloor: json['numberOfFloor'] ?? 0,
      distanceFromSp: json['distanceFromSp']?.toDouble(),
      distanceFromDt: json['distanceFromDt']?.toDouble(),
      startingDate: json['startingDate'] != null
          ? DateTime.parse(json['startingDate'])
          : null,
      endingDate: json['endingDate'] != null
          ? DateTime.parse(json['endingDate'])
          : null,
      activationStatusId: json['activationStatusId'] ?? 0,
      verificationStateId: json['verificationStateId'] ?? 0,
      remarks: json['remarks'],
    );
  }
}

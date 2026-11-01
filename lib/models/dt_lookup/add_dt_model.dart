class DistributionTransformer {
  final int id;
  final String distributionTransformerCode;
  final String? dtLocationName;
  final int? poleLeftId;
  final int poleDetailsLeftId;
  final int? poleDetailsRightId;
  final int feederLineId;
  final int zoneId;
  final int circleId;
  final int sndId;
  final int? esuId;
  final int substationId;
  final String? dtNumber;
  final String? nameOf33Bs11KvSubstation;
  final String? nameof11KvFeeder;
  final String? sndIdentificationNo;
  final String? nearestHoldingHouseNoShop;
  final String? existingPoleNumberIfAny;
  final int? installedConditionPadPoleMounted;
  final int? installedPlaceIndoorOutdoor;
  final String? contactNo;
  final int? transformerOwnerId;
  final double? transformerKvaRating;
  final String? yearOfManufacturing;
  final String? nameofManufacturer;
  final String? transformerSerialNo;
  final String? ratedHtVoltage;
  final String? ratedLTVoltage;
  final String? ratedHTCurrent;
  final String? ratedLTCurrent;
  final String? controlVoltage;
  final String? motorVoltageforspringcharge;
  final String? ratedVoltage;
  final int? bodyColorConditionId;
  final String? nameOfBodyColor;
  final bool oilLeakageYesOrNo;
  final String? placeOfOilLeakageMark;
  final int? platformMaterialId;
  final int? dtConditionId;
  final int? typeofTransformerSupportPoleLeft;
  final String? conditionofTransformerSupportPoleLeft;
  final int? typeofTransformerSupportPoleRight;
  final String? conditionofTransformerSupportPoleRight;
  final bool htBushingRPhaseOil;
  final int? htBushingRPhaseGood;
  final String? htBushingRPhaseColor;
  final bool htBushingYPhaseOil;
  final int? htBushingYPhaseGood;
  final String? htBushingYPhaseColor;
  final bool htBushingBPhaseOil;
  final int? htBushingBPhaseGood;
  final String? htBushingBPhaseColor;
  final bool htBushingNPhaseOil;
  final int? htBushingNPhaseGood;
  final String? htBushingNPhaseColor;
  final bool ltBushingRPhaseOil;
  final int? ltBushingRPhaseGood;
  final String? ltBushingRPhaseColor;
  final bool ltBushingYPhaseOil;
  final int? ltBushingYPhaseGood;
  final String? ltBushingYPhaseColor;
  final bool ltBushingBPhaseOil;
  final int? ltBushingBPhaseGood;
  final String? ltBushingBPhaseColor;
  final bool ltBushingNPhaseOil;
  final int? ltBushingNPhaseGood;
  final String? ltBushingNPhaseColor;
  final String? wireSizeofHTDrop;
  final int? conditionofHTDropGoodbsBad;
  final String? wirebsCableSizeofLTDropCKT1;
  final int? conditionofLTDropGoodbsBadCKT1;
  final String? wirebsCableSizeofLTDropCKT2;
  final int? conditionofLTDropGoodbsBadCKT2;
  final String? earthingLead1;
  final String? earthingLead1Size;
  final String? earthingLead1Material;
  final int? earthingLead1ConditionStandard;
  final String? earthingLead2;
  final String? earthingLead2Size;
  final String? earthingLead2Material;
  final int? earthingLead2ConditionStandard;
  final String? dayPeak;
  final String? dateAndtime1;
  final String? voltage1;
  final String? ryVoltageVolt1;
  final String? ybVoltageVolt1;
  final String? rbVoltageVolt1;
  final String? rnVoltageVolt1;
  final String? ynVoltageVolt1;
  final String? bnVoltageVolt1;
  final String? leakageVoltageBodyEarthVolt1;
  final String? rPhaseCurrentAmps1Ckt1;
  final String? rPhaseCurrentAmps1Ckt2;
  final String? rPhaseCurrentAmps1Ckt3;
  final String? yPhaseCurrentAmps1Ckt1;
  final String? yPhaseCurrentAmps1Ckt2;
  final String? yPhaseCurrentAmps1Ckt3;
  final String? bPhaseCurrentAmps1Ckt1;
  final String? bPhaseCurrentAmps1Ckt2;
  final String? bPhaseCurrentAmps1Ckt3;
  final String? neutralCurrentAmps1Ckt1;
  final String? neutralCurrentAmps1Ckt2;
  final String? neutralCurrentAmps1Ckt3;
  final String? calculatedDayPeakkVA;
  final String? eveningPeak;
  final String? dateAndTime2;
  final String? voltage2;
  final String? ryVoltageVolt2;
  final String? ybVoltageVolt2;
  final String? rbVoltageVolt2;
  final String? calculatedEveningPeakkVA;
  final bool dropOutFuseExistbsNotExistRphase;
  final bool dropOutFuseExistbsNotExistYphase;
  final bool dropOutFuseExistbsNotExistBphase;
  final int? conditionofDropOutFuseRphase;
  final int? conditionofDropOutFuseYphase;
  final int? conditionofDropOutFuseBphase;
  final bool lightningArrestorRphase;
  final bool lightningArrestorYphase;
  final bool lightningArrestorBphase;
  final int? conditionofLightingArrestorRphase;
  final int? conditionofLightingArrestorYphase;
  final int? conditionofLightingArrestorBphase;
  final bool distributionBoxExistbsnotExist;
  final int? conditionofDistributionBox;
  final int? noOfMCCB;
  final String? manufacturerTypeOriginofMCCBforCircuit1;
  final String? manufacturerTypeOriginofMCCBforCircuit2;
  final String? ampereRatingasPerNamePlateofMCCBforCKT1;
  final String? ampereRatingasPerNameplateOfMCCBForCKT2;
  final int? conditionofMCCBforCircuit1;
  final int? conditionofMCCBforCircuit2;
  final String? recommendation;
  final String? lastMaintenanceDate;
  final String? startingDate;
  final String? endingDate;
  final int activationStatusId;
  final String? dataActivationStatus;
  final int verificationStateId;
  final String? dataVerificationState;
  final String? remarks;
  

  DistributionTransformer({
    required this.id,
    required this.distributionTransformerCode,
    required this.dtLocationName,
    required this.poleLeftId,
    required this.poleDetailsLeftId,
    required this.poleDetailsRightId,
    required this.feederLineId,
    required this.zoneId,
    required this.circleId,
    required this.sndId,
    this.esuId,
    required this.substationId,
    this.dtNumber,
    this.nameOf33Bs11KvSubstation,
    this.nameof11KvFeeder,
    this.sndIdentificationNo,
    this.nearestHoldingHouseNoShop,
    this.existingPoleNumberIfAny,
    this.installedConditionPadPoleMounted,
    this.installedPlaceIndoorOutdoor,
    this.contactNo,
    this.transformerOwnerId,
    required this.transformerKvaRating,
    this.yearOfManufacturing,
    this.nameofManufacturer,
    this.transformerSerialNo,
    this.ratedHtVoltage,
    this.ratedLTVoltage,
    this.ratedHTCurrent,
    this.ratedLTCurrent,
    this.controlVoltage,
    this.motorVoltageforspringcharge,
    this.ratedVoltage,
    this.bodyColorConditionId,
    this.nameOfBodyColor,
    required this.oilLeakageYesOrNo,
    this.placeOfOilLeakageMark,
    this.platformMaterialId,
    this.dtConditionId,
    this.typeofTransformerSupportPoleLeft,
    this.conditionofTransformerSupportPoleLeft,
    this.typeofTransformerSupportPoleRight,
    this.conditionofTransformerSupportPoleRight,
    required this.htBushingRPhaseOil,
    this.htBushingRPhaseGood,
    this.htBushingRPhaseColor,
    required this.htBushingYPhaseOil,
    this.htBushingYPhaseGood,
    this.htBushingYPhaseColor,
    required this.htBushingBPhaseOil,
    this.htBushingBPhaseGood,
    this.htBushingBPhaseColor,
    required this.htBushingNPhaseOil,
    this.htBushingNPhaseGood,
    this.htBushingNPhaseColor,
    required this.ltBushingRPhaseOil,
    this.ltBushingRPhaseGood,
    this.ltBushingRPhaseColor,
    required this.ltBushingYPhaseOil,
    this.ltBushingYPhaseGood,
    this.ltBushingYPhaseColor,
    required this.ltBushingBPhaseOil,
    this.ltBushingBPhaseGood,
    this.ltBushingBPhaseColor,
    required this.ltBushingNPhaseOil,
    this.ltBushingNPhaseGood,
    this.ltBushingNPhaseColor,
    this.wireSizeofHTDrop,
    this.conditionofHTDropGoodbsBad,
    this.wirebsCableSizeofLTDropCKT1,
    this.conditionofLTDropGoodbsBadCKT1,
    this.wirebsCableSizeofLTDropCKT2,
    this.conditionofLTDropGoodbsBadCKT2,
    this.earthingLead1,
    this.earthingLead1Size,
    this.earthingLead1Material,
    this.earthingLead1ConditionStandard,
    this.earthingLead2,
    this.earthingLead2Size,
    this.earthingLead2Material,
    this.earthingLead2ConditionStandard,
    this.dayPeak,
    this.dateAndtime1,
    this.voltage1,
    this.ryVoltageVolt1,
    this.ybVoltageVolt1,
    this.rbVoltageVolt1,
    this.rnVoltageVolt1,
    this.ynVoltageVolt1,
    this.bnVoltageVolt1,
    this.leakageVoltageBodyEarthVolt1,
    this.rPhaseCurrentAmps1Ckt1,
    this.rPhaseCurrentAmps1Ckt2,
    this.rPhaseCurrentAmps1Ckt3,
    this.yPhaseCurrentAmps1Ckt1,
    this.yPhaseCurrentAmps1Ckt2,
    this.yPhaseCurrentAmps1Ckt3,
    this.bPhaseCurrentAmps1Ckt1,
    this.bPhaseCurrentAmps1Ckt2,
    this.bPhaseCurrentAmps1Ckt3,
    this.neutralCurrentAmps1Ckt1,
    this.neutralCurrentAmps1Ckt2,
    this.neutralCurrentAmps1Ckt3,
    this.calculatedDayPeakkVA,
    this.eveningPeak,
    this.dateAndTime2,
    this.voltage2,
    this.ryVoltageVolt2,
    this.ybVoltageVolt2,
    this.rbVoltageVolt2,
    this.calculatedEveningPeakkVA,
    required this.dropOutFuseExistbsNotExistRphase,
    required this.dropOutFuseExistbsNotExistYphase,
    required this.dropOutFuseExistbsNotExistBphase,
    this.conditionofDropOutFuseRphase,
    this.conditionofDropOutFuseYphase,
    this.conditionofDropOutFuseBphase,
    required this.lightningArrestorRphase,
    required this.lightningArrestorYphase,
    required this.lightningArrestorBphase,
    this.conditionofLightingArrestorRphase,
    this.conditionofLightingArrestorYphase,
    this.conditionofLightingArrestorBphase,
    required this.distributionBoxExistbsnotExist,
    this.conditionofDistributionBox,
    this.noOfMCCB,
    this.manufacturerTypeOriginofMCCBforCircuit1,
    this.manufacturerTypeOriginofMCCBforCircuit2,
    this.ampereRatingasPerNamePlateofMCCBforCKT1,
    this.ampereRatingasPerNameplateOfMCCBForCKT2,
    this.conditionofMCCBforCircuit1,
    this.conditionofMCCBforCircuit2,
    this.recommendation,
    this.lastMaintenanceDate,
    required this.startingDate,
    this.endingDate,
    required this.activationStatusId,
    this.dataActivationStatus,
    required this.verificationStateId,
    this.dataVerificationState,
    this.remarks,
  });

  factory DistributionTransformer.fromJson(Map<String, dynamic> json) {
    return DistributionTransformer(
      id: json['id'],
      distributionTransformerCode: json['distributionTransformerCode'],
      dtLocationName: json['dtLocationName'],
      poleLeftId: json['poleLeftId'],
      poleDetailsLeftId: json['poleDetailsLeftId'],
      poleDetailsRightId: json['poleDetailsRightId'],
      feederLineId: json['feederLineId'],
      zoneId: json['zoneId'],
      circleId: json['circleId'],
      sndId: json['sndId'],
      esuId: json['esuId'],
      substationId: json['substationId'],
      dtNumber: json['dtNumber'],
      nameOf33Bs11KvSubstation: json['nameOf33Bs11KvSubstation'],
      nameof11KvFeeder: json['nameof11KvFeeder'],
      sndIdentificationNo: json['sndIdentificationNo'],
      nearestHoldingHouseNoShop: json['nearestHoldingHouseNoShop'],
      existingPoleNumberIfAny: json['existingPoleNumberIfAny'],
      installedConditionPadPoleMounted: json['installedConditionPadPoleMounted'],
      installedPlaceIndoorOutdoor: json['installedPlaceIndoorOutdoor'],
      contactNo: json['contactNo'],
      transformerOwnerId: json['transformerOwnerId'],
      transformerKvaRating: json['transformerKvaRating'],
      yearOfManufacturing: json['yearOfManufacturing'],
      nameofManufacturer: json['nameofManufacturer'],
      transformerSerialNo: json['transformerSerialNo'],
      ratedHtVoltage: json['ratedHtVoltage'],
      ratedLTVoltage: json['ratedLTVoltage'],
      ratedHTCurrent: json['ratedHTCurrent'],
      ratedLTCurrent: json['ratedLTCurrent'],
      controlVoltage: json['controlVoltage'],
      motorVoltageforspringcharge: json['motorVoltageforspringcharge'],
      ratedVoltage: json['ratedVoltage'],
      bodyColorConditionId: json['bodyColorConditionId'],
      nameOfBodyColor: json['nameOfBodyColor'],
      oilLeakageYesOrNo: json['oilLeakageYesOrNo'],
      placeOfOilLeakageMark: json['placeOfOilLeakageMark'],
      platformMaterialId: json['platformMaterialId'],
      dtConditionId: json['dtConditionId'],
      typeofTransformerSupportPoleLeft: json['typeofTransformerSupportPoleLeft'],
      conditionofTransformerSupportPoleLeft: json['conditionofTransformerSupportPoleLeft'],
      typeofTransformerSupportPoleRight: json['typeofTransformerSupportPoleRight'],
      conditionofTransformerSupportPoleRight: json['conditionofTransformerSupportPoleRight'],
      htBushingRPhaseOil: json['htBushingRPhaseOil'],
      htBushingRPhaseGood: json['htBushingRPhaseGood'],
      htBushingRPhaseColor: json['htBushingRPhaseColor'],
      htBushingYPhaseOil: json['htBushingYPhaseOil'],
      htBushingYPhaseGood: json['htBushingYPhaseGood'],
      htBushingYPhaseColor: json['htBushingYPhaseColor'],
      htBushingBPhaseOil: json['htBushingBPhaseOil'],
      htBushingBPhaseGood: json['htBushingBPhaseGood'],
      htBushingBPhaseColor: json['htBushingBPhaseColor'],
      htBushingNPhaseOil: json['htBushingNPhaseOil'],
      htBushingNPhaseGood: json['htBushingNPhaseGood'],
      htBushingNPhaseColor: json['htBushingNPhaseColor'],
      ltBushingRPhaseOil: json['ltBushingRPhaseOil'],
      ltBushingRPhaseGood: json['ltBushingRPhaseGood'],
      ltBushingRPhaseColor: json['ltBushingRPhaseColor'],
      ltBushingYPhaseOil: json['ltBushingYPhaseOil'],
      ltBushingYPhaseGood: json['ltBushingYPhaseGood'],
      ltBushingYPhaseColor: json['ltBushingYPhaseColor'],
      ltBushingBPhaseOil: json['ltBushingBPhaseOil'],
      ltBushingBPhaseGood: json['ltBushingBPhaseGood'],
      ltBushingBPhaseColor: json['ltBushingBPhaseColor'],
      ltBushingNPhaseOil: json['ltBushingNPhaseOil'],
      ltBushingNPhaseGood: json['ltBushingNPhaseGood'],
      ltBushingNPhaseColor: json['ltBushingNPhaseColor'],
      wireSizeofHTDrop: json['wireSizeofHTDrop'],
      conditionofHTDropGoodbsBad: json['conditionofHTDropGoodbsBad'],
      wirebsCableSizeofLTDropCKT1: json['wirebsCableSizeofLTDropCKT1'],
      conditionofLTDropGoodbsBadCKT1: json['conditionofLTDropGoodbsBadCKT1'],
      wirebsCableSizeofLTDropCKT2: json['wirebsCableSizeofLTDropCKT2'],
      conditionofLTDropGoodbsBadCKT2: json['conditionofLTDropGoodbsBadCKT2'],
      earthingLead1: json['earthingLead1'],
      earthingLead1Size: json['earthingLead1Size'],
      earthingLead1Material: json['earthingLead1Material'],
      earthingLead1ConditionStandard: json['earthingLead1ConditionStandard'],
      earthingLead2: json['earthingLead2'],
      earthingLead2Size: json['earthingLead2Size'],
      earthingLead2Material: json['earthingLead2Material'],
      earthingLead2ConditionStandard: json['earthingLead2ConditionStandard'],
      dayPeak: json['dayPeak'],
      dateAndtime1: json['dateAndtime1'],
      voltage1: json['voltage1'],
      ryVoltageVolt1: json['ryVoltageVolt1'],
      ybVoltageVolt1: json['ybVoltageVolt1'],
      rbVoltageVolt1: json['rbVoltageVolt1'],
      rnVoltageVolt1: json['rnVoltageVolt1'],
      ynVoltageVolt1: json['ynVoltageVolt1'],
      bnVoltageVolt1: json['bnVoltageVolt1'],
      leakageVoltageBodyEarthVolt1: json['leakageVoltageBodyEarthVolt1'],
      rPhaseCurrentAmps1Ckt1: json['rPhaseCurrentAmps1Ckt1'],
      rPhaseCurrentAmps1Ckt2: json['rPhaseCurrentAmps1Ckt2'],
      rPhaseCurrentAmps1Ckt3: json['rPhaseCurrentAmps1Ckt3'],
      yPhaseCurrentAmps1Ckt1: json['yPhaseCurrentAmps1Ckt1'],
      yPhaseCurrentAmps1Ckt2: json['yPhaseCurrentAmps1Ckt2'],
      yPhaseCurrentAmps1Ckt3: json['yPhaseCurrentAmps1Ckt3'],
      bPhaseCurrentAmps1Ckt1: json['bPhaseCurrentAmps1Ckt1'],
      bPhaseCurrentAmps1Ckt2: json['bPhaseCurrentAmps1Ckt2'],
      bPhaseCurrentAmps1Ckt3: json['bPhaseCurrentAmps1Ckt3'],
      neutralCurrentAmps1Ckt1: json['neutralCurrentAmps1Ckt1'],
      neutralCurrentAmps1Ckt2: json['neutralCurrentAmps1Ckt2'],
      neutralCurrentAmps1Ckt3: json['neutralCurrentAmps1Ckt3'],
      calculatedDayPeakkVA: json['calculatedDayPeakkVA'],
      eveningPeak: json['eveningPeak'],
      dateAndTime2: json['dateAndTime2'],
      voltage2: json['voltage2'],
      ryVoltageVolt2: json['ryVoltageVolt2'],
      ybVoltageVolt2: json['ybVoltageVolt2'],
      rbVoltageVolt2: json['rbVoltageVolt2'],
      calculatedEveningPeakkVA: json['calculatedEveningPeakkVA'],
      dropOutFuseExistbsNotExistRphase: json['dropOutFuseExistbsNotExistRphase'],
      dropOutFuseExistbsNotExistYphase: json['dropOutFuseExistbsNotExistYphase'],
      dropOutFuseExistbsNotExistBphase: json['dropOutFuseExistbsNotExistBphase'],
      conditionofDropOutFuseRphase: json['conditionofDropOutFuseRphase'],
      conditionofDropOutFuseYphase: json['conditionofDropOutFuseYphase'],
      conditionofDropOutFuseBphase: json['conditionofDropOutFuseBphase'],
      lightningArrestorRphase: json['lightningArrestorRphase'],
      lightningArrestorYphase: json['lightningArrestorYphase'],
      lightningArrestorBphase: json['lightningArrestorBphase'],
      conditionofLightingArrestorRphase: json['conditionofLightingArrestorRphase'],
      conditionofLightingArrestorYphase: json['conditionofLightingArrestorYphase'],
      conditionofLightingArrestorBphase: json['conditionofLightingArrestorBphase'],
      distributionBoxExistbsnotExist: json['distributionBoxExistbsnotExist'],
      conditionofDistributionBox: json['conditionofDistributionBox'],
      noOfMCCB: json['noOfMCCB'],
      manufacturerTypeOriginofMCCBforCircuit1: json['manufacturerTypeOriginofMCCBforCircuit1'],
      manufacturerTypeOriginofMCCBforCircuit2: json['manufacturerTypeOriginofMCCBforCircuit2'],
      ampereRatingasPerNamePlateofMCCBforCKT1: json['ampereRatingasPerNamePlateofMCCBforCKT1'],
      ampereRatingasPerNameplateOfMCCBForCKT2: json['ampereRatingasPerNameplateOfMCCBForCKT2'],
      conditionofMCCBforCircuit1: json['conditionofMCCBforCircuit1'],
      conditionofMCCBforCircuit2: json['conditionofMCCBforCircuit2'],
      recommendation: json['recommendation'],
      lastMaintenanceDate: json['lastMaintenanceDate'],
      startingDate: json['startingDate'],
      endingDate: json['endingDate'],
      activationStatusId: json['activationStatusId'],
      dataActivationStatus: json['dataActivationStatus'],
      verificationStateId: json['verificationStateId'],
      dataVerificationState: json['dataVerificationState'],
      remarks: json['remarks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'distributionTransformerCode': distributionTransformerCode,
      'dtLocationName': dtLocationName,
      'poleLeftId': poleLeftId,
      'poleDetailsLeftId': poleDetailsLeftId,
      'poleDetailsRightId': poleDetailsRightId,
      'feederLineId': feederLineId,
      'zoneId': zoneId,
      'circleId': circleId,
      'sndId': sndId,
      'esuId': esuId,
      'substationId': substationId,
      'dtNumber': dtNumber,
      'nameOf33Bs11KvSubstation': nameOf33Bs11KvSubstation,
      'nameof11KvFeeder': nameof11KvFeeder,
      'sndIdentificationNo': sndIdentificationNo,
      'nearestHoldingHouseNoShop': nearestHoldingHouseNoShop,
      'existingPoleNumberIfAny': existingPoleNumberIfAny,
      'installedConditionPadPoleMounted': installedConditionPadPoleMounted,
      'installedPlaceIndoorOutdoor': installedPlaceIndoorOutdoor,
      'contactNo': contactNo,
      'transformerOwnerId': transformerOwnerId,
      'transformerKvaRating': transformerKvaRating,
      'yearOfManufacturing': yearOfManufacturing,
      'nameofManufacturer': nameofManufacturer,
      'transformerSerialNo': transformerSerialNo,
      'ratedHtVoltage': ratedHtVoltage,
      'ratedLTVoltage': ratedLTVoltage,
      'ratedHTCurrent': ratedHTCurrent,
      'ratedLTCurrent': ratedLTCurrent,
      'controlVoltage': controlVoltage,
      'motorVoltageforspringcharge': motorVoltageforspringcharge,
      'ratedVoltage': ratedVoltage,
      'bodyColorConditionId': bodyColorConditionId,
      'nameOfBodyColor': nameOfBodyColor,
      'oilLeakageYesOrNo': oilLeakageYesOrNo,
      'placeOfOilLeakageMark': placeOfOilLeakageMark,
      'platformMaterialId': platformMaterialId,
      'dtConditionId': dtConditionId,
      'typeofTransformerSupportPoleLeft': typeofTransformerSupportPoleLeft,
      'conditionofTransformerSupportPoleLeft': conditionofTransformerSupportPoleLeft,
      'typeofTransformerSupportPoleRight': typeofTransformerSupportPoleRight,
      'conditionofTransformerSupportPoleRight': conditionofTransformerSupportPoleRight,
      'htBushingRPhaseOil': htBushingRPhaseOil,
      'htBushingRPhaseGood': htBushingRPhaseGood,
      'htBushingRPhaseColor': htBushingRPhaseColor,
      'htBushingYPhaseOil': htBushingYPhaseOil,
      'htBushingYPhaseGood': htBushingYPhaseGood,
      'htBushingYPhaseColor': htBushingYPhaseColor,
      'htBushingBPhaseOil': htBushingBPhaseOil,
      'htBushingBPhaseGood': htBushingBPhaseGood,
      'htBushingBPhaseColor': htBushingBPhaseColor,
      'htBushingNPhaseOil': htBushingNPhaseOil,
      'htBushingNPhaseGood': htBushingNPhaseGood,
      'htBushingNPhaseColor': htBushingNPhaseColor,
      'ltBushingRPhaseOil': ltBushingRPhaseOil,
      'ltBushingRPhaseGood': ltBushingRPhaseGood,
      'ltBushingRPhaseColor': ltBushingRPhaseColor,
      'ltBushingYPhaseOil': ltBushingYPhaseOil,
      'ltBushingYPhaseGood': ltBushingYPhaseGood,
      'ltBushingYPhaseColor': ltBushingYPhaseColor,
      'ltBushingBPhaseOil': ltBushingBPhaseOil,
      'ltBushingBPhaseGood': ltBushingBPhaseGood,
      'ltBushingBPhaseColor': ltBushingBPhaseColor,
      'ltBushingNPhaseOil': ltBushingNPhaseOil,
      'ltBushingNPhaseGood': ltBushingNPhaseGood,
      'ltBushingNPhaseColor': ltBushingNPhaseColor,
      'wireSizeofHTDrop': wireSizeofHTDrop,
      'conditionofHTDropGoodbsBad': conditionofHTDropGoodbsBad,
      'wirebsCableSizeofLTDropCKT1': wirebsCableSizeofLTDropCKT1,
      'conditionofLTDropGoodbsBadCKT1': conditionofLTDropGoodbsBadCKT1,
      'wirebsCableSizeofLTDropCKT2': wirebsCableSizeofLTDropCKT2,
      'conditionofLTDropGoodbsBadCKT2': conditionofLTDropGoodbsBadCKT2,
      'earthingLead1': earthingLead1,
      'earthingLead1Size': earthingLead1Size,
      'earthingLead1Material': earthingLead1Material,
      'earthingLead1ConditionStandard': earthingLead1ConditionStandard,
      'earthingLead2': earthingLead2,
      'earthingLead2Size': earthingLead2Size,
      'earthingLead2Material': earthingLead2Material,
      'earthingLead2ConditionStandard': earthingLead2ConditionStandard,
      'dayPeak': dayPeak,
      'dateAndtime1': dateAndtime1,
      'voltage1': voltage1,
      'ryVoltageVolt1': ryVoltageVolt1,
      'ybVoltageVolt1': ybVoltageVolt1,
      'rbVoltageVolt1': rbVoltageVolt1,
      'rnVoltageVolt1': rnVoltageVolt1,
      'ynVoltageVolt1': ynVoltageVolt1,
      'bnVoltageVolt1': bnVoltageVolt1,
      'leakageVoltageBodyEarthVolt1': leakageVoltageBodyEarthVolt1,
      'rPhaseCurrentAmps1Ckt1': rPhaseCurrentAmps1Ckt1,
      'rPhaseCurrentAmps1Ckt2': rPhaseCurrentAmps1Ckt2,
      'rPhaseCurrentAmps1Ckt3': rPhaseCurrentAmps1Ckt3,
      'yPhaseCurrentAmps1Ckt1': yPhaseCurrentAmps1Ckt1,
      'yPhaseCurrentAmps1Ckt2': yPhaseCurrentAmps1Ckt2,
      'yPhaseCurrentAmps1Ckt3': yPhaseCurrentAmps1Ckt3,
      'bPhaseCurrentAmps1Ckt1': bPhaseCurrentAmps1Ckt1,
      'bPhaseCurrentAmps1Ckt2': bPhaseCurrentAmps1Ckt2,
      'bPhaseCurrentAmps1Ckt3': bPhaseCurrentAmps1Ckt3,
      'neutralCurrentAmps1Ckt1': neutralCurrentAmps1Ckt1,
      'neutralCurrentAmps1Ckt2': neutralCurrentAmps1Ckt2,
      'neutralCurrentAmps1Ckt3': neutralCurrentAmps1Ckt3,
      'calculatedDayPeakkVA': calculatedDayPeakkVA,
      'eveningPeak': eveningPeak,
      'dateAndTime2': dateAndTime2,
      'voltage2': voltage2,
      'ryVoltageVolt2': ryVoltageVolt2,
      'ybVoltageVolt2': ybVoltageVolt2,
      'rbVoltageVolt2': rbVoltageVolt2,
      'calculatedEveningPeakkVA': calculatedEveningPeakkVA,
      'dropOutFuseExistbsNotExistRphase': dropOutFuseExistbsNotExistRphase,
      'dropOutFuseExistbsNotExistYphase': dropOutFuseExistbsNotExistYphase,
      'dropOutFuseExistbsNotExistBphase': dropOutFuseExistbsNotExistBphase,
      'conditionofDropOutFuseRphase': conditionofDropOutFuseRphase,
      'conditionofDropOutFuseYphase': conditionofDropOutFuseYphase,
      'conditionofDropOutFuseBphase': conditionofDropOutFuseBphase,
      'lightningArrestorRphase': lightningArrestorRphase,
      'lightningArrestorYphase': lightningArrestorYphase,
      'lightningArrestorBphase': lightningArrestorBphase,
      'conditionofLightingArrestorRphase': conditionofLightingArrestorRphase,
      'conditionofLightingArrestorYphase': conditionofLightingArrestorYphase,
      'conditionofLightingArrestorBphase': conditionofLightingArrestorBphase,
      'distributionBoxExistbsnotExist': distributionBoxExistbsnotExist,
      'conditionofDistributionBox': conditionofDistributionBox,
      'noOfMCCB': noOfMCCB,
      'manufacturerTypeOriginofMCCBforCircuit1': manufacturerTypeOriginofMCCBforCircuit1,
      'manufacturerTypeOriginofMCCBforCircuit2': manufacturerTypeOriginofMCCBforCircuit2,
      'ampereRatingasPerNamePlateofMCCBforCKT1': ampereRatingasPerNamePlateofMCCBforCKT1,
      'ampereRatingasPerNameplateOfMCCBForCKT2': ampereRatingasPerNameplateOfMCCBForCKT2,
      'conditionofMCCBforCircuit1': conditionofMCCBforCircuit1,
      'conditionofMCCBforCircuit2': conditionofMCCBforCircuit2,
      'recommendation': recommendation,
      'lastMaintenanceDate': lastMaintenanceDate,
      'startingDate': startingDate,
      'endingDate': endingDate,
      'activationStatusId': activationStatusId,
      'dataActivationStatus': dataActivationStatus,
      'verificationStateId': verificationStateId,
      'dataVerificationState': dataVerificationState,
      'remarks': remarks,
    };
  }
}

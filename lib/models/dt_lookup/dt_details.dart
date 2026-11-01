// class Transformer {
//   int? id;
//   String? distributionTransformerCode;
//   String? dtLocationName;
//   String? zoneName;
//   String? circleName;
//   String? snDName;
//   String? esuName;
//   String? substationName;
//   String? feederlineName;
//   int? substationId;
//   int? feederlineId;
//   String? poleLeftCode;
//   String? poleRightCode;
//   double? latitude;
//   double? longitude;
//   double? transformerKvaRating;
//   String? contractNo;
//   double? ratedHtVoltage;
//   double? ratedLTVoltage;
//   double? ratedLTCurrent;
//   double? ratedHTCurrent;

//   Transformer({
//     this.id,
//     this.distributionTransformerCode,
//     this.dtLocationName,
//     this.zoneName,
//     this.circleName,
//     this.snDName,
//     this.esuName,
//     this.substationName,
//     this.feederlineName,
//     this.substationId,
//     this.feederlineId,
//     this.poleLeftCode,
//     this.poleRightCode,
//     this.latitude,
//     this.longitude,
//     this.transformerKvaRating,
//     this.contractNo,
//     this.ratedHtVoltage,
//     this.ratedLTVoltage,
//     this.ratedLTCurrent,
//     this.ratedHTCurrent,
//   });

//   // Factory constructor to parse from JSON
//   factory Transformer.fromJson(Map<String, dynamic> json) {
//     return Transformer(
//       id: json['id'],
//       distributionTransformerCode: json['distributionTransformerCode'],
//       dtLocationName: json['dtLocationName'],
//       zoneName: json['zoneName'],
//       circleName: json['circleName'],
//       snDName: json['snDName'],
//       esuName: json['esuName'],
//       substationName: json['substationName'],
//       feederlineName: json['feederlineName'],
//       substationId: json['substationId'],
//       feederlineId: json['feederlineId'],
//       poleLeftCode: json['poleLeftCode'],
//       poleRightCode: json['poleRightCode'],
//       latitude: (json['latitude'] != null) ? json['latitude'].toDouble() : null,
//       longitude: (json['longitude'] != null) ? json['longitude'].toDouble() : null,
//       transformerKvaRating: (json['transformerKvaRating'] != null) ? json['transformerKvaRating'].toDouble() : null,
//       contractNo: json['contractNo'],
//       ratedHtVoltage: (json['ratedHtVoltage'] != null) ? json['ratedHtVoltage'].toDouble() : null,
//       ratedLTVoltage: (json['ratedLTVoltage'] != null) ? json['ratedLTVoltage'].toDouble() : null,
//       ratedLTCurrent: (json['ratedLTCurrent'] != null) ? json['ratedLTCurrent'].toDouble() : null,
//       ratedHTCurrent: (json['ratedHTCurrent'] != null) ? json['ratedHTCurrent'].toDouble() : null,
//     );
//   }

//   // Convert the model back to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'distributionTransformerCode': distributionTransformerCode,
//       'dtLocationName': dtLocationName,
//       'zoneName': zoneName,
//       'circleName': circleName,
//       'snDName': snDName,
//       'esuName': esuName,
//       'substationName': substationName,
//       'feederlineName': feederlineName,
//       'substationId': substationId,
//       'feederlineId': feederlineId,
//       'poleLeftCode': poleLeftCode,
//       'poleRightCode': poleRightCode,
//       'latitude': latitude,
//       'longitude': longitude,
//       'transformerKvaRating': transformerKvaRating,
//       'contractNo': contractNo,
//       'ratedHtVoltage': ratedHtVoltage,
//       'ratedLTVoltage': ratedLTVoltage,
//       'ratedLTCurrent': ratedLTCurrent,
//       'ratedHTCurrent': ratedHTCurrent,
//     };
//   }
// }

class Transformer {
  int? id;
  String? distributionTransformerCode;
  String? dtLocationName;
  int? zoneId;
  String? zoneName;
  int? circleId;
  String? circleName;
  int? snDId;
  String? snDName;
  String? esuName;
  String? substationName;
  String? feederlineName;
  int? substationId;
  int? feederlineId;
  String? poleLeftCode;
  String? poleRightCode;
  double? latitude;
  double? longitude;
  double? transformerKvaRating;
  String? contractNo;
  double? ratedHtVoltage;
  double? ratedLTVoltage;
  double? ratedLTCurrent;
  double? ratedHTCurrent;
  String? nearestHoldingHouseNoShop;
  String? installedConditionName;
  String? installedPlaceName;
  String? transformerOwnerName;
  String? nameofManufacturer;

  Transformer({
    this.id,
    this.distributionTransformerCode,
    this.dtLocationName,
    this.zoneId,
    this.zoneName,
    this.circleId,
    this.circleName,
    this.snDId,
    this.snDName,
    this.esuName,
    this.substationName,
    this.feederlineName,
    this.substationId,
    this.feederlineId,
    this.poleLeftCode,
    this.poleRightCode,
    this.latitude,
    this.longitude,
    this.transformerKvaRating,
    this.contractNo,
    this.ratedHtVoltage,
    this.ratedLTVoltage,
    this.ratedLTCurrent,
    this.ratedHTCurrent,
    this.nearestHoldingHouseNoShop,
    this.installedConditionName,
    this.installedPlaceName,
    this.transformerOwnerName,
    this.nameofManufacturer,
  });

  factory Transformer.fromJson(Map<String, dynamic> json) {
    return Transformer(
      id: json['id'],
      distributionTransformerCode: json['distributionTransformerCode'],
      dtLocationName: json['dtLocationName'],
      zoneId: json['zoneId'],
      circleId: json['circleId'],
      snDId: json['snDId'],
      zoneName: json['zoneName'],
      circleName: json['circleName'],
      snDName: json['snDName'],
      esuName: json['esuName'],
      substationName: json['substationName'],
      feederlineName: json['feederlineName'],
      substationId: json['substationId'],
      feederlineId: json['feederlineId'],
      poleLeftCode: json['poleLeftCode'],
      poleRightCode: json['poleRightCode'],
      latitude: (json['latitude'] != null) ? json['latitude'].toDouble() : null,
      longitude: (json['longitude'] != null) ? json['longitude'].toDouble() : null,
      transformerKvaRating: (json['transformerKvaRating'] != null) ? json['transformerKvaRating'].toDouble() : null,
      contractNo: json['contractNo'],
      ratedHtVoltage: (json['ratedHtVoltage'] != null) ? json['ratedHtVoltage'].toDouble() : null,
      ratedLTVoltage: (json['ratedLTVoltage'] != null) ? json['ratedLTVoltage'].toDouble() : null,
      ratedLTCurrent: (json['ratedLTCurrent'] != null) ? json['ratedLTCurrent'].toDouble() : null,
      ratedHTCurrent: (json['ratedHTCurrent'] != null) ? json['ratedHTCurrent'].toDouble() : null,
      nearestHoldingHouseNoShop: json['nearestHoldingHouseNoShop'],
      installedConditionName: json['installedConditionName'],
      installedPlaceName: json['installedPlaceName'],
      transformerOwnerName: json['transformerOwnerName'],
      nameofManufacturer: json['nameofManufacturer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'distributionTransformerCode': distributionTransformerCode,
      'dtLocationName': dtLocationName,
      'zoneId': zoneId,
      'circleId': circleId,
      'snDId': snDId,
      'zoneName': zoneName,
      'circleName': circleName,
      'snDName': snDName,
      'esuName': esuName,
      'substationName': substationName,
      'feederlineName': feederlineName,
      'substationId': substationId,
      'feederlineId': feederlineId,
      'poleLeftCode': poleLeftCode,
      'poleRightCode': poleRightCode,
      'latitude': latitude,
      'longitude': longitude,
      'transformerKvaRating': transformerKvaRating,
      'contractNo': contractNo,
      'ratedHtVoltage': ratedHtVoltage,
      'ratedLTVoltage': ratedLTVoltage,
      'ratedLTCurrent': ratedLTCurrent,
      'ratedHTCurrent': ratedHTCurrent,
      'nearestHoldingHouseNoShop': nearestHoldingHouseNoShop,
      'installedConditionName': installedConditionName,
      'installedPlaceName': installedPlaceName,
      'transformerOwnerName': transformerOwnerName,
      'nameofManufacturer': nameofManufacturer,
    };
  }
}

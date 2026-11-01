import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../constants/constant.dart';
//import '../models/app_config.dart';
import '../models/dt_lookup/Support_pole_type.dart';
import '../models/dt_lookup/add_dt_model.dart';
import '../models/dt_lookup/body_color_condition.dart';
import '../models/dt_lookup/dt_condition.dart';
import '../models/dt_lookup/edit_dt_model.dart';
import '../models/dt_lookup/installed_condition.dart';
import '../models/dt_lookup/installed_place.dart';
import '../models/dt_lookup/platform_material.dart';
import '../models/dt_lookup/support_pole_condition.dart';
import '../models/dt_lookup/transformer_owner.dart';
import '../models/dt_lookup/dt_details.dart';
import '../models/dt_lookup/dt_info.dart';

class CallDTApi {
  Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  void showMessage(String message, String type) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: type.contains('error') ? Colors.red : Colors.grey[800],
      textColor: type.contains('error') ? Colors.yellow : Colors.white,
      fontSize: 20.0,
    );
  }

  //--Fetch DT Info--//
  Future<List<TransformerDetails>> fetchDT({
    int? substation,
    int? feederLineId,
  }) async {
    final String? token = globalToken;
    if (token == null) {
      throw Exception('Token is missing. User is not authenticated.');
    }
    final String apiUrl = '$myAPILink/api/DistributionTransformers';
    print("substationId=$substation&feederLineId=$feederLineId'");
    final Uri uri = Uri.parse(
      feederLineId != 0
          ? '$apiUrl/search${feederLineId != null ? '?substationId=$substation&feederLineId=$feederLineId' : ''}'
          //? '$apiUrl/search${feederLineId != null ? '?feederLineId=$feederLineId' : ''}'
          : '$apiUrl/search${substation != null ? '?substationId=$substation' : ''}',
    );

    // debugPrint('$uri');

    try {
      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<TransformerDetails> dts =
            data.map((json) => TransformerDetails.fromJson(json))
            .toList()
            .reversed
            .toList();
        return dts;
      } else {
        throw Exception(
            'Failed to load DT Info! Status code: ${response.statusCode}');
      }
    } catch (e) {
      //print('Error caught: $e');
      throw Exception('Failed to load DT Info: $e');
    }
  }
  //--Fetch DT Info--//

  //--DT Details--//
  Future<List<Transformer>> fetchDTByDetailsId(int id) async {
    final String? token = globalToken;
    if (token == null) {
      throw Exception('Token is missing. User is not authenticated.');
    }
    final response = await http.get(
        Uri.parse('$myAPILink/api/DistributionTransformers/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<Transformer>((json) => Transformer.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load Dt info');
    }
  }
  //--DT Details--//

  //--DT Condition--//
  Future<List<DTCondition>> fetchDTCondition() async {
    final response = await http.get(Uri.parse('$myAPILink/api/DtConditions'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<DTCondition>((json) => DTCondition.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load DT Condition Type');
    }
  }
  //--DT Condition--//

  //--Installed Condition--//
  Future<List<InstalledCondition>> installedCondition() async {
    final response =
        await http.get(Uri.parse('$myAPILink/api/InstalledConditions'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<InstalledCondition>((json) => InstalledCondition.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load Installed Condition Type');
    }
  }
  //--Installed Condition--//

  //--Installed Placed--//
  Future<List<InstalledPlaced>> installPlaced() async {
    final response =
        await http.get(Uri.parse('$myAPILink/api/InstalledPlaces'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<InstalledPlaced>((json) => InstalledPlaced.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load Installed Place');
    }
  }
  //--Installed Placed--//

  //--Installed Placed--//
  Future<List<TransformerOwner>> transformerOwner() async {
    final response =
        await http.get(Uri.parse('$myAPILink/api/TransformerOwners'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<TransformerOwner>((json) => TransformerOwner.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load Transformer Owners');
    }
  }
  //--Installed Placed--//

  //--Body Color Conditions--//
  Future<List<BodyColorCondition>> bodyColorCondition() async {
    final response =
        await http.get(Uri.parse('$myAPILink/api/BodyColorConditions'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<BodyColorCondition>((json) => BodyColorCondition.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load Body Color Conditions');
    }
  }
  //--Body Color Conditions--//

  //--Platfrom Meterial--//
  Future<List<PlatfromMeterial>> platformMaterial() async {
    final response =
        await http.get(Uri.parse('$myAPILink/api/PlatformMaterials'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<PlatfromMeterial>((json) => PlatfromMeterial.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load Platfrom Meterial');
    }
  }
  //--Platfrom Meterial--//

  //--Support Pole Type--//
  Future<List<SupportPoleType>> typeOfSupportPole() async {
    final response =
        await http.get(Uri.parse('$myAPILink/api/SupportPoleTypes'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<SupportPoleType>((json) => SupportPoleType.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load Support Pole Types');
    }
  }
  //--Support Pole Type--//

  //--Support Pole Condition--//
  Future<List<SupportPoleCondition>> supportPoleCondition() async {
    final response =
        await http.get(Uri.parse('$myAPILink/api/SupportPoleConditions'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<SupportPoleCondition>(
              (json) => SupportPoleCondition.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load Support Pole Condition');
    }
  }
  //--Support Pole Condition--//

  //-- DT Max Id --//
  Future<int> fetchMaxDTId() async {
    final String? token = globalToken;
    try {
      final response = await http.get(
        Uri.parse('$myAPILink/api/DistributionTransformers/maxId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return int.parse(response.body);
      } else {
        throw 'Failed to fetch maxId';
      }
    } catch (e) {
      throw 'Error fetching maxId: $e';
    }
  }
  //-- DT Max Id --//

  //--Add DT--//
  Future<DistributionTransformer> createDT(DistributionTransformer dt) async {
    final String? token = globalToken;
    if (token == null) {
      throw Exception('Token is missing. User is not authenticated.');
    }
    final requestData = {
      'zoneId': dt.zoneId != 0 ? dt.zoneId : null,
      'circleId': dt.circleId != 0 ? dt.circleId : null,
      'sndId': dt.sndId != 0 ? dt.sndId : null,
      'esuId': dt.esuId != 0 ? dt.esuId : null,
      'substationId': dt.substationId != 0 ? dt.substationId : null,
      'feederLineId': dt.feederLineId != 0 ? dt.feederLineId : null,
      'poleLeftId': dt.poleLeftId != 0 ? dt.poleLeftId : null,
      'poleDetailsLeftId':
          dt.poleDetailsLeftId != 0 ? dt.poleDetailsLeftId : null,
      'poleDetailsRightId':
          dt.poleDetailsRightId != 0 ? dt.poleDetailsRightId : null,
      'id': dt.id != 0 ? dt.id : null,
      'distributionTransformerCode': dt.distributionTransformerCode != ''
          ? dt.distributionTransformerCode
          : null,
      'dtLocationName': dt.dtLocationName != '' ? dt.dtLocationName : null,
      'dtNumber': dt.dtNumber != '' ? dt.dtNumber : null,
      'dtConditionId': dt.dtConditionId != 0 ? dt.dtConditionId : null,
      'nameOf33Bs11KvSubstation': dt.nameOf33Bs11KvSubstation,
      'nameof11KvFeeder': dt.nameof11KvFeeder,
      'sndIdentificationNo': dt.sndIdentificationNo,
      'nearestHoldingHouseNoShop': dt.nearestHoldingHouseNoShop,
      'existingPoleNumberIfAny': dt.existingPoleNumberIfAny,
      'installedConditionPadPoleMounted': dt.installedConditionPadPoleMounted,
      'installedPlaceIndoorOutdoor': dt.installedPlaceIndoorOutdoor,
      'transformerOwnerId':
          dt.transformerOwnerId != 0 ? dt.transformerOwnerId : null,
      'transformerKvaRating':
          dt.transformerKvaRating != 0 ? dt.transformerKvaRating : null,
      'contactNo': dt.contactNo,
      'yearOfManufacturing':
          dt.yearOfManufacturing != '' ? dt.yearOfManufacturing : null,
      'nameofManufacturer': dt.nameofManufacturer,
      'transformerSerialNo': dt.transformerSerialNo,
      'bodyColorConditionId':
          dt.bodyColorConditionId != 0 ? dt.bodyColorConditionId : null,
      'nameOfBodyColor': dt.nameOfBodyColor,
      'oilLeakageYesOrNo': dt.oilLeakageYesOrNo,
      'placeOfOilLeakageMark': dt.placeOfOilLeakageMark,
      'platformMaterialId':
          dt.platformMaterialId != 0 ? dt.platformMaterialId : null,
      'typeofTransformerSupportPoleLeft': dt.typeofTransformerSupportPoleLeft,
      'conditionofTransformerSupportPoleLeft':
          dt.conditionofTransformerSupportPoleLeft,
      'typeofTransformerSupportPoleRight': dt.typeofTransformerSupportPoleRight,
      'conditionofTransformerSupportPoleRight':
          dt.conditionofTransformerSupportPoleRight,
      'ratedVoltage': dt.ratedVoltage != '' ? dt.ratedVoltage : null,
      'ratedHtVoltage': dt.ratedHtVoltage != '' ? dt.ratedHtVoltage : null,
      'ratedLTVoltage': dt.ratedLTVoltage != '' ? dt.ratedLTVoltage : null,
      'ratedHTCurrent': dt.ratedHTCurrent != '' ? dt.ratedHTCurrent : null,
      'ratedLTCurrent': dt.ratedLTCurrent != '' ? dt.ratedLTCurrent : null,
      'controlVoltage': dt.controlVoltage != '' ? dt.controlVoltage : null,
      'motorVoltageforspringcharge': dt.motorVoltageforspringcharge,
      'voltage1': dt.voltage1 != '' ? dt.voltage1 : null,
      'ryVoltageVolt1': dt.ryVoltageVolt1 != '' ? dt.ryVoltageVolt1 : null,
      'ybVoltageVolt1': dt.ybVoltageVolt1 != '' ? dt.ybVoltageVolt1 : null,
      'rbVoltageVolt1': dt.rbVoltageVolt1 != '' ? dt.rbVoltageVolt1 : null,
      'rnVoltageVolt1': dt.rnVoltageVolt1 != '' ? dt.rnVoltageVolt1 : null,
      'ynVoltageVolt1': dt.ynVoltageVolt1 != '' ? dt.ynVoltageVolt1 : null,
      'bnVoltageVolt1': dt.bnVoltageVolt1 != '' ? dt.bnVoltageVolt1 : null,
      'leakageVoltageBodyEarthVolt1': dt.leakageVoltageBodyEarthVolt1 != ''
          ? dt.leakageVoltageBodyEarthVolt1
          : null,
      'voltage2': dt.voltage2 != '' ? dt.voltage2 : null,
      'ryVoltageVolt2': dt.ryVoltageVolt2 != '' ? dt.ryVoltageVolt2 : null,
      'ybVoltageVolt2': dt.ybVoltageVolt2 != '' ? dt.ybVoltageVolt2 : null,
      'rbVoltageVolt2': dt.rbVoltageVolt2 != '' ? dt.rbVoltageVolt2 : null,
      'htBushingRPhaseOil': dt.htBushingRPhaseOil,
      'htBushingRPhaseGood': dt.htBushingRPhaseGood,
      'htBushingRPhaseColor': dt.htBushingRPhaseColor,
      'htBushingYPhaseOil': dt.htBushingYPhaseOil,
      'htBushingYPhaseGood': dt.htBushingYPhaseGood,
      'htBushingYPhaseColor': dt.htBushingYPhaseColor,
      'htBushingBPhaseOil': dt.htBushingBPhaseOil,
      'htBushingBPhaseGood': dt.htBushingBPhaseGood,
      'htBushingBPhaseColor': dt.htBushingBPhaseColor,
      'htBushingNPhaseOil': dt.htBushingNPhaseOil,
      'htBushingNPhaseGood': dt.htBushingNPhaseGood,
      'htBushingNPhaseColor': dt.htBushingNPhaseColor,
      'ltBushingRPhaseOil': dt.ltBushingRPhaseOil,
      'ltBushingRPhaseGood': dt.ltBushingRPhaseGood,
      'ltBushingRPhaseColor': dt.ltBushingRPhaseColor,
      'ltBushingYPhaseOil': dt.ltBushingYPhaseOil,
      'ltBushingYPhaseGood': dt.ltBushingYPhaseGood,
      'ltBushingYPhaseColor': dt.ltBushingYPhaseColor,
      'ltBushingBPhaseOil': dt.ltBushingBPhaseOil,
      'ltBushingBPhaseGood': dt.ltBushingBPhaseGood,
      'ltBushingBPhaseColor': dt.ltBushingBPhaseColor,
      'ltBushingNPhaseOil': dt.ltBushingNPhaseOil,
      'ltBushingNPhaseGood': dt.ltBushingNPhaseGood,
      'ltBushingNPhaseColor': dt.ltBushingNPhaseColor,
      'wireSizeofHTDrop': dt.wireSizeofHTDrop,
      'conditionofHTDropGoodbsBad': dt.conditionofHTDropGoodbsBad != ''
          ? dt.conditionofHTDropGoodbsBad
          : null,
      'wirebsCableSizeofLTDropCKT1': dt.wirebsCableSizeofLTDropCKT1,
      'conditionofLTDropGoodbsBadCKT1': dt.conditionofLTDropGoodbsBadCKT1 != ''
          ? dt.conditionofLTDropGoodbsBadCKT1
          : null,
      'wirebsCableSizeofLTDropCKT2': dt.wirebsCableSizeofLTDropCKT2,
      'conditionofLTDropGoodbsBadCKT2': dt.conditionofLTDropGoodbsBadCKT2 != ''
          ? dt.conditionofLTDropGoodbsBadCKT2
          : null,
      'earthingLead1': dt.earthingLead1,
      'earthingLead1Size': dt.earthingLead1Size,
      'earthingLead1Material': dt.earthingLead1Material,
      'earthingLead1ConditionStandard': dt.earthingLead1ConditionStandard != ''
          ? dt.earthingLead1ConditionStandard
          : null,
      'earthingLead2': dt.earthingLead2,
      'earthingLead2Size': dt.earthingLead2Size,
      'earthingLead2Material': dt.earthingLead2Material,
      'earthingLead2ConditionStandard': dt.earthingLead2ConditionStandard != ''
          ? dt.earthingLead2ConditionStandard
          : null,
      'dayPeak': dt.dayPeak != '' ? dt.dayPeak : null,
      'dateAndtime1': dt.dateAndtime1,
      'rPhaseCurrentAmps1Ckt1':
          dt.rPhaseCurrentAmps1Ckt1 != '' ? dt.rPhaseCurrentAmps1Ckt1 : null,
      'rPhaseCurrentAmps1Ckt2':
          dt.rPhaseCurrentAmps1Ckt2 != '' ? dt.rPhaseCurrentAmps1Ckt2 : null,
      'rPhaseCurrentAmps1Ckt3':
          dt.rPhaseCurrentAmps1Ckt3 != '' ? dt.rPhaseCurrentAmps1Ckt3 : null,
      'yPhaseCurrentAmps1Ckt1':
          dt.yPhaseCurrentAmps1Ckt1 != '' ? dt.yPhaseCurrentAmps1Ckt1 : null,
      'yPhaseCurrentAmps1Ckt2':
          dt.yPhaseCurrentAmps1Ckt2 != '' ? dt.yPhaseCurrentAmps1Ckt2 : null,
      'yPhaseCurrentAmps1Ckt3':
          dt.yPhaseCurrentAmps1Ckt3 != '' ? dt.yPhaseCurrentAmps1Ckt3 : null,
      'bPhaseCurrentAmps1Ckt1':
          dt.bPhaseCurrentAmps1Ckt1 != '' ? dt.bPhaseCurrentAmps1Ckt1 : null,
      'bPhaseCurrentAmps1Ckt2':
          dt.bPhaseCurrentAmps1Ckt2 != '' ? dt.bPhaseCurrentAmps1Ckt2 : null,
      'bPhaseCurrentAmps1Ckt3':
          dt.bPhaseCurrentAmps1Ckt3 != '' ? dt.bPhaseCurrentAmps1Ckt3 : null,
      'neutralCurrentAmps1Ckt1':
          dt.neutralCurrentAmps1Ckt1 != '' ? dt.neutralCurrentAmps1Ckt1 : null,
      'neutralCurrentAmps1Ckt2':
          dt.neutralCurrentAmps1Ckt2 != '' ? dt.neutralCurrentAmps1Ckt2 : null,
      'neutralCurrentAmps1Ckt3':
          dt.neutralCurrentAmps1Ckt3 != '' ? dt.neutralCurrentAmps1Ckt3 : null,
      'calculatedDayPeakkVA':
          dt.calculatedDayPeakkVA != '' ? dt.calculatedDayPeakkVA : null,
      'calculatedEveningPeakkVA': dt.calculatedEveningPeakkVA != ''
          ? dt.calculatedEveningPeakkVA
          : null,
      'eveningPeak': dt.eveningPeak != '' ? dt.eveningPeak : null,
      'dateAndTime2': dt.dateAndTime2,
      'dropOutFuseExistbsNotExistRphase': dt.dropOutFuseExistbsNotExistRphase,
      'dropOutFuseExistbsNotExistYphase': dt.dropOutFuseExistbsNotExistYphase,
      'dropOutFuseExistbsNotExistBphase': dt.dropOutFuseExistbsNotExistBphase,
      'conditionofDropOutFuseRphase': dt.conditionofDropOutFuseRphase,
      'conditionofDropOutFuseYphase': dt.conditionofDropOutFuseYphase,
      'conditionofDropOutFuseBphase': dt.conditionofDropOutFuseBphase,
      'lightningArrestorRphase': dt.lightningArrestorRphase,
      'lightningArrestorYphase': dt.lightningArrestorYphase,
      'lightningArrestorBphase': dt.lightningArrestorBphase,
      'conditionofLightingArrestorRphase': dt.conditionofLightingArrestorRphase,
      'conditionofLightingArrestorYphase': dt.conditionofLightingArrestorYphase,
      'conditionofLightingArrestorBphase': dt.conditionofLightingArrestorBphase,
      'distributionBoxExistbsnotExist': dt.distributionBoxExistbsnotExist,
      'conditionofDistributionBox': dt.conditionofDistributionBox,
      'noOfMCCB': dt.noOfMCCB,
      'manufacturerTypeOriginofMCCBforCircuit1':
          dt.manufacturerTypeOriginofMCCBforCircuit1 != ''
              ? dt.manufacturerTypeOriginofMCCBforCircuit1
              : null,
      'manufacturerTypeOriginofMCCBforCircuit2':
          dt.manufacturerTypeOriginofMCCBforCircuit2 != ''
              ? dt.manufacturerTypeOriginofMCCBforCircuit2
              : null,
      'ampereRatingasPerNamePlateofMCCBforCKT1':
          dt.ampereRatingasPerNamePlateofMCCBforCKT1 != ''
              ? dt.ampereRatingasPerNamePlateofMCCBforCKT1
              : null,
      'ampereRatingasPerNameplateOfMCCBForCKT2':
          dt.ampereRatingasPerNameplateOfMCCBForCKT2 != ''
              ? dt.ampereRatingasPerNameplateOfMCCBForCKT2
              : null,
      'conditionofMCCBforCircuit1': dt.conditionofMCCBforCircuit1,
      'conditionofMCCBforCircuit2': dt.conditionofMCCBforCircuit1,
      'recommendation': dt.recommendation,
      'lastMaintenanceDate': dt.lastMaintenanceDate,
      'startingDate': dt.startingDate,
      'remarks': dt.remarks,
      'activationStatusId': dt.activationStatusId,
      'verificationStateId': dt.verificationStateId,
    };

    // debugPrint('Request Data: $requestData');
    // return Future.error('Stopped execution for debugging.');
    try {
      final response = await http.post(
        Uri.parse('$myAPILink/api/DistributionTransformers'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestData),
      );
      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return DistributionTransformer.fromJson(jsonResponse);
      } else {
        //print('Error response body: ${response.body}');
        final responseBody = jsonDecode(response.body);
        final errors = responseBody['errors'];
        final fieldName = errors.keys.first;
        //print('Field causing error: $fieldName');
        throw "$fieldName";
      }
    } catch (e) {
      throw 'Failed to create dt. Please Check $e';
    }
  }
  //--Add DT--//

  //--DT Details For Edit--//
  // Future<DistributionTransformerEdit> fetchDTForEdit(int id) async {
  //   print('Fetching DT details for ID: $id');
  //   final String? token = globalToken;
  //   if (token == null) {
  //     throw Exception('Token is missing. User is not authenticated.');
  //   }
  //   final response = await http.get(
  //       Uri.parse('$myAPILink/api/DistributionTransformers/$id'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       });
  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = jsonDecode(response.body);

  //     if (data.isNotEmpty) {
  //       // Assuming the first item in the list is the consumer data you're interested in
  //       return DistributionTransformerEdit.fromJson(data[0]);
  //     } else {
  //       throw Exception('No Distribution Transformer data found');
  //     }
  //   } else {
  //     throw Exception('Failed to load Distribution Transformer info');
  //   }
  // }
  Future<DistributionTransformerEdit> fetchDTForEdit(int id) async {
    final String? token = globalToken;
    if (token == null) {
      throw Exception('Token is missing. User is not authenticated.');
    }

    final response = await http.get(
      Uri.parse('$myAPILink/api/DistributionTransformers/searchDt?id=$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // ✅ Handle both cases: list or single object
      if (data is List && data.isNotEmpty) {
        return DistributionTransformerEdit.fromJson(data.first);
      } else if (data is Map<String, dynamic>) {
        return DistributionTransformerEdit.fromJson(data);
      } else {
        throw Exception('Unexpected API response format');
      }
    } else {
      throw Exception('Failed to load Distribution Transformer data: ${response.statusCode}');
    }
  }


  Future<void> updateDt(DistributionTransformerEdit updatedDtDetails,
  ) async {
    final String? token = globalToken;
    if (token == null) {
      throw Exception('Token is missing. User is not authenticated.');
    }

    final dtRequestData = {
      'id': updatedDtDetails.id,
      'dtLocationName': updatedDtDetails.dtLocationName,
      'dtNumber': updatedDtDetails.dtNumber,
      'nameof11KvFeeder': updatedDtDetails.nameof11KvFeeder,
      'nearestHoldingHouseNoShop':
          updatedDtDetails.nearestHoldingHouseNoShop,
      'dtConditionId': updatedDtDetails.dtConditionId,
      'bodyColorConditionId': updatedDtDetails.bodyColorConditionId,
      'oilLeakageYesOrNo': updatedDtDetails.oilLeakageYesOrNo,
      'conditionofTransformerSupportPoleLeft':
          updatedDtDetails.conditionofTransformerSupportPoleLeft,
      'conditionofTransformerSupportPoleRight':
          updatedDtDetails.conditionofTransformerSupportPoleRight,
      'recommendation': updatedDtDetails.recommendation,
      'remarks': updatedDtDetails.remarks,
    };

    try {
      // 🔹 1. Update PoleDetails
      final dtDetailsUrl = Uri.parse(
          '$myAPILink/api/DistributionTransformers/${updatedDtDetails.id}');
      print('➡️ PUT $dtDetailsUrl');
      print('📦 Body: ${jsonEncode(dtRequestData)}');

      final poleDetailsResponse = await http.put(
        dtDetailsUrl,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(dtRequestData),
      );

      // print('🔁 PoleDetails Response: ${poleDetailsResponse.statusCode}');
      // print('🧾 PoleDetails Body: ${poleDetailsResponse.body}');

      if (poleDetailsResponse.statusCode != 200 &&
          poleDetailsResponse.statusCode != 204) {
        throw Exception(
            'Failed to update PoleDetails. Status: ${poleDetailsResponse.statusCode}, '
            'Response: ${poleDetailsResponse.body}');
      }

    } catch (e, stackTrace) {
      print('❌ Error updating pole: $e');
      print('📍 Stack trace: $stackTrace');
      rethrow;
    }
  }

  //--DT Details For Edit --//

}

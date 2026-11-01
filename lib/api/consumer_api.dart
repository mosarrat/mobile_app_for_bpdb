import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../constants/constant.dart';
import '../models/Login/login.dart';
import '../models/app_config.dart';
// import '../models/consumer_form_lookup/consumer_list.dart';
import '../models/consumer_lookup/consumer_edit.dart';
import '../models/consumer_lookup/consumers.dart';
import '../models/consumer_form_lookup/connection_status.dart';
import '../models/consumer_form_lookup/connection_type.dart';
import '../models/consumer_form_lookup/location.dart';
import '../models/consumer_form_lookup/meter_type.dart';
import '../models/consumer_form_lookup/opreating_voltage.dart';
import '../models/consumer_form_lookup/phasing_code.dart';
import '../models/consumer_form_lookup/service_cabletype.dart';
import '../models/consumer_form_lookup/structure_type.dart';
import '../models/consumer_form_lookup/tarif_subcatagory.dart';
import '../models/consumer_form_lookup/consumer_type.dart';
// import '../models/consumer_lookup/consumers.dart';
import '../models/regions/distribution_transformer.dart';
import '../models/regions/esu_info.dart';
import '../models/consumer_form_lookup/tariff_category.dart';
import '../models/consumer_form_lookup/bussiness_type.dart';
import '../models/regions/service_point.dart';
// import '../models/consumer_lookup/single_consumers.dart';
// Consumer Info

class CallConsumerApi {
  Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
    //return true;
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

  Future<void> getOnlineTime() async {
    if (!(await isConnected())) {
      throw Exception('No internet connection!');
    }

    final response = await http.get(Uri.parse(timeAPILink));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      TimeData timeData = TimeData.fromJson(data);

      DateTime dateTime = DateTime.parse(timeData.datetime);
      onlineTime = DateFormat('dd-MM-yy hh:mm:ss a').format(dateTime.toLocal());
      //return timeData;
    } else {
      throw Exception('Failed to load time data!');
    }
  }

  ///// ESU ID /////
  Future<List<EsuInfo>> fetchEsuInfo(int sndId) async {
    //print('Fetching ESU info for SND ID: $sndId');
    User? user = globalUser;
    int? userEsuId = user?.EsuId;
    // final response = await http
    //     .get(Uri.parse('$myAPILink/api/EsuInfoes/search?sndId=$sndId'));
    String apiUrl = userEsuId != null
        ? '$myAPILink/api/EsuInfoes/$userEsuId'
        : '$myAPILink/api/EsuInfoes/search?sndId=$sndId';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // final List<dynamic> data = jsonDecode(response.body);
      // return data.map<EsuInfo>((json) => EsuInfo.fromJson(json)).toList();
      final data = jsonDecode(response.body);
      if (userEsuId != null) {
        // Response for a single zone (Map object)
        return [EsuInfo.fromJson(data)];
      } else {
        // Response for multiple zones (List)
        final List<dynamic> sndList = data;
        return sndList.map<EsuInfo>((json) => EsuInfo.fromJson(json)).toList();
      }
    } else {
      throw Exception('Failed to load ESU info');
    }
  }

  ///// ESU ID /////
  Future<List<ConsumerType>> fetchConsumerType() async {
    final response = await http.get(Uri.parse('$myAPILink/api/ConsumerTypes'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<ConsumerType>((json) => ConsumerType.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load Consumer Type');
    }
  }

  Future<List<TariffCategory>> fetchTariffCategory() async {
    final response =
        await http.get(Uri.parse('$myAPILink/api/TariffCategories'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<TariffCategory>((json) => TariffCategory.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load Tariff Category');
    }
  }

  Future<List<SubCategory>> fetchTariffSubcategory() async {
    final response =
        await http.get(Uri.parse('$myAPILink/api/TariffSubCategories'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<SubCategory>((json) => SubCategory.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load Tariff Sub Category');
    }
  }

  Future<List<MeterType>> fetchMeterType() async {
    final response = await http.get(Uri.parse('$myAPILink/api/MeterTypes'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map<MeterType>((json) => MeterType.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Meter Type');
    }
  }

  Future<List<PhasingCode>> fetchPhasingCode() async {
    final response =
        await http.get(Uri.parse('$myAPILink/api/PhasingCodeTypes'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<PhasingCode>((json) => PhasingCode.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load Phasing Type');
    }
  }

  Future<List<ConnectionStatus>> fetchConnectionStatus() async {
    final response =
        await http.get(Uri.parse('$myAPILink/api/ConnectionStatus'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<ConnectionStatus>((json) => ConnectionStatus.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load Connection Status');
    }
  }

  Future<List<ConnectionType>> fetchConnectiontype() async {
    final response =
        await http.get(Uri.parse('$myAPILink/api/ConnectionTypes'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<ConnectionType>((json) => ConnectionType.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load Connection Status');
    }
  }

  Future<List<Locations>> fetchLocations() async {
    final response = await http.get(Uri.parse('$myAPILink/api/Locations'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map<Locations>((json) => Locations.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Location');
    }
  }

  Future<List<SurviceCableType>> fetchServiceCableType() async {
    final response =
        await http.get(Uri.parse('$myAPILink/api/ServiceCableTypes'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<SurviceCableType>((json) => SurviceCableType.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load Connection Status');
    }
  }

  Future<List<OperatingVoltage>> fetchOperatingVoltage() async {
    final response =
        await http.get(Uri.parse('$myAPILink/api/OperatingVoltages'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<OperatingVoltage>((json) => OperatingVoltage.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load Operating Voltage');
    }
  }

  Future<List<BusinessType>> fetchBusinessType() async {
    final response = await http.get(Uri.parse('$myAPILink/api/BusinessTypes'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<BusinessType>((json) => BusinessType.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load Bussiness Type');
    }
  }

  Future<List<StructureType>> fetchStructureType() async {
    final response = await http.get(Uri.parse('$myAPILink/api/StructureTypes'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<StructureType>((json) => StructureType.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load Structure Type');
    }
  }

  Future<List<Consumers>> fetchConsumers({
    // int? feederLineId,
    // String? consumerNo,
    String? field,
    String? value,
  }) async {
    final String apiUrl = '$myAPILink/api/Consumers';
    final String? token = globalToken;
    if (token == null) {
      throw Exception('Token is missing. User is not authenticated.');
    }
    // final Uri uri = Uri.parse(
    //   consumerNo != null && consumerNo.isNotEmpty
    //       ? '$apiUrl/$consumerNo'
    //       // : '$apiUrl/search${feederLineId != null ? '?feederLineId=$feederLineId' : ''}',
    //       : '$apiUrl/searchByfeederLineId${feederLineId != null ? '?id=$feederLineId' : ''}',
    // );
    final Uri uri =
        Uri.parse('$apiUrl/consumerSearch?field=$field&value=$value');

    //print('Constructed URI: $uri');

    try {
      //final response = await http.get(uri);
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      // print('Response status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        //debugPrint(response.body);
        List<dynamic> data = jsonDecode(response.body);
        //print('Response data: $data');

        List<Consumers> consumers =
            data.map((json) => Consumers.fromJson(json))
            .toList()
            .reversed
            .toList();
        // print('Parsed Consumers: $consumers');

        return consumers;
      } else {
        throw Exception(
            'Failed to load consumers! Status code: ${response.statusCode}');
      }
    } catch (e) {
      // print('$e');
      throw Exception('Failed to load consumers: $e');
    }
  }

  Future<int> fetchMaxConsumerId() async {
    final String? token = globalToken;
    if (token == null) {
      throw Exception('Token is missing. User is not authenticated.');
    }
    try {
      final response = await http.get(
        Uri.parse('$myAPILink/api/Consumers/maxId'),
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

  Future<Consumers> createConsumer(Consumers consumer) async {
    /// Condition Checking ///
    final String? token = globalToken;
    if (token == null) {
      throw Exception('Token is missing. User is not authenticated.');
    }
    final requestData = {
      'zoneId': consumer.zoneId != 0 ? consumer.zoneId : null,
      'circleId': consumer.circleId != 0 ? consumer.circleId : null,
      'sndId': consumer.sndId != 0 ? consumer.sndId : null,
      'esuId': consumer.esuId != 0 ? consumer.esuId : null,
      'substationId': consumer.substationId != 0 ? consumer.substationId : null,
      'feederLineId': consumer.feederLineId != 0 ? consumer.feederLineId : null,
      'poleDetailsId':
          consumer.poleDetailsId != 0 ? consumer.poleDetailsId : null,
      'servicesPointId':
          consumer.servicesPointId != 0 ? consumer.servicesPointId : null,
      'dtId': consumer.dtId != 0 ? consumer.dtId : null,
      'feederUId': consumer.feederUId != 0 ? consumer.feederUId : null,
      'unionGeoCode': consumer.unionGeoCode,
      'consumerId': consumer.consumerId,
      'customerName': consumer.customerName,
      'customerNameBng': consumer.customerNameBng,
      'fatherName': consumer.fatherName,
      'customerNid': consumer.customerNid,
      'mobileNo': consumer.mobileNo,
      'email': consumer.email != "" ? consumer.email : null,
      'consumerNo': consumer.consumerNo,
      'accountNumber': consumer.accountNumber,
      'consumerTypeId':
          consumer.consumerTypeId != 0 ? consumer.consumerTypeId : null,
      'customerAddress': consumer.customerAddress,
      'plotNo': consumer.plotNo,
      'buildingAptNo': consumer.buildingAptNo,
      'premiseName': consumer.premiseName,
      'numberOfFloor':
          consumer.numberOfFloor != 0 ? consumer.numberOfFloor : null,
      'tariffCategoryId':
          consumer.tariffCategoryId != 0 ? consumer.tariffCategoryId : null,
      'tariffSubCategoryId': consumer.tariffSubCategoryId != 0
          ? consumer.tariffSubCategoryId
          : null,
      'meterTypeId': consumer.meterTypeId != 0 ? consumer.meterTypeId : null,
      'meterModel': consumer.meterModel,
      'meterNumber': consumer.meterNumber,
      'meterManufacturer': consumer.meterManufacturer,
      'meterReading': consumer.meterReading != 0 ? consumer.meterReading : null,
      'phasingCodeTypeId':
          consumer.phasingCodeTypeId != 0 ? consumer.phasingCodeTypeId : null,
      'operatingVoltageId':
          consumer.operatingVoltageId != 0 ? consumer.operatingVoltageId : null,
      'installDate': consumer.installDate != "" ? consumer.installDate : null,
      'connectionStatusId':
          consumer.connectionStatusId != 0 ? consumer.connectionStatusId : null,
      'connectionTypeId':
          consumer.connectionTypeId != 0 ? consumer.connectionTypeId : null,
      'sanctionedLoad':
          consumer.sanctionedLoad != 0 ? consumer.sanctionedLoad : null,
      'connectedLoad':
          consumer.connectedLoad != 0 ? consumer.connectedLoad : null,
      'businessTypeId':
          consumer.businessTypeId != 0 ? consumer.businessTypeId : null,
      'othersBusiness': consumer.othersBusiness,
      'specialCode': consumer.specialCode,
      'specialType': consumer.specialType,
      'locationId': consumer.locationId != 0 ? consumer.locationId : null,
      'billGroup': consumer.billGroup,
      'bookNumber': consumer.bookNumber,
      'omfKwh': consumer.omfKwh != 0.0 ? consumer.omfKwh : null,
      'serviceCableSize':
          consumer.serviceCableSize != 0.0 ? consumer.serviceCableSize : null,
      'serviceCableTypeId': consumer.serviceCableTypeId != 0.0
          ? consumer.serviceCableTypeId
          : null,
      'surveyDate': consumer.surveyDate,
      'latitude': consumer.latitude,
      'longitude': consumer.longitude,
      'structureId': consumer.structureId != '' ? consumer.structureId : null,
      'structureMapNo':
          consumer.structureMapNo != '' ? consumer.structureMapNo : null,
      'structureTypeId':
          consumer.structureTypeId != 0 ? consumer.structureTypeId : null,
      'startingDate': consumer.startingDate,
      'remarks': consumer.remarks,
      'activationStatusId': consumer.activationStatusId,
      'verificationStateId': consumer.verificationStateId,
      'distance_from_sp': consumer.distance_from_sp,
    };
    // debugPrint('Request Data: $requestData');
    // return Future.error('Stopped execution for debugging.');
    try {
      final response = await http.post(
        Uri.parse('$myAPILink/api/Consumers'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestData),
      );
      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return Consumers.fromJson(jsonResponse);
      } else {
        final responseBody = jsonDecode(response.body);
        final errors = responseBody['errors'];
        final fieldName = errors.keys.first;
        //print('Field causing error: $fieldName');
        throw "$fieldName";
      }
    } catch (e) {
      if (e is FormatException) {
        throw 'Consumer Number Is Required to Be Unique';
      } else {
        throw 'Failed to create consumer. Please Check $e';
      }
      //throw 'Failed to create consumer. Please Check $e';
    }
    //}
  }

  // -- (13-11-25) -- //
  Future<List<ServicePoint>> fetchServicePointsByFeeder(int feederId) async {
    final String? token = globalToken;
    final response = await http.get(
      Uri.parse(
          '$myAPILink/api/ServicePoints/searchByFeeder?feederId=$feederId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      // If data is empty, you can set a specific message or code here
      if (data.isEmpty) {
        // Handle the no data case (you can return an empty list or throw a custom exception)
        throw 'No service points available for the selected pole.';
      }

      return data
          .map<ServicePoint>((json) => ServicePoint.fromJson(json))
          .toList();
    } else {
      throw Exception(
          'Failed to load service points info. Status code: ${response.statusCode}');
    }
  }

  Future<List<DistributionTransformer>> fetchDistributionTransformersByFeeder(
      int feederId) async {
    final String? token = globalToken;
    final response = await http.get(
      Uri.parse(
          '$myAPILink/api/DistributionTransformers/search?feederId=$feederId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    //print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<DistributionTransformer>(
              (json) => DistributionTransformer.fromJson(json))
          .toList();
    } else {
      throw Exception('Distribution Transformer not found for the selected feeder.');
    }
  }
  // -- (13-11-25) -- //

  // Future<Consumers> updateConsumer(Consumers consumer) async {
  //   //print("union: ${consumer.unionGeoCode}");
  //   final String? token = globalToken;
  //   if (token == null) {
  //     throw Exception('Token is missing. User is not authenticated.');
  //   }
  //   final requestData = {
  //     'zoneId': consumer.zoneId != 0 ? consumer.zoneId : null,
  //     'circleId': consumer.circleId != 0 ? consumer.circleId : null,
  //     'sndId': consumer.sndId != 0 ? consumer.sndId : null,
  //     'esuId': consumer.esuId != 0 ? consumer.esuId : null,
  //     'substationId': consumer.substationId != 0 ? consumer.substationId : null,
  //     'feederLineId': consumer.feederLineId != 0 ? consumer.feederLineId : null,
  //     'poleDetailsId':
  //         consumer.poleDetailsId != 0 ? consumer.poleDetailsId : null,
  //     'servicesPointId':
  //         consumer.servicesPointId != 0 ? consumer.servicesPointId : null,
  //     'dtId': consumer.dtId != 0 ? consumer.dtId : null,
  //     'feederUId': consumer.feederUId != 0 ? consumer.feederUId : null,
  //     'unionGeoCode':
  //         consumer.unionGeoCode != '' ? consumer.unionGeoCode : null,
  //     'consumerId': consumer.consumerId,
  //     'customerName': consumer.customerName,
  //     'customerNameBng': consumer.customerNameBng,
  //     'fatherName': consumer.fatherName,
  //     'customerNid': consumer.customerNid,
  //     'mobileNo': consumer.mobileNo,
  //     'email': consumer.email,
  //     'consumerNo': consumer.consumerNo,
  //     'accountNumber': consumer.accountNumber,
  //     'consumerTypeId':
  //         consumer.consumerTypeId != 0 ? consumer.consumerTypeId : null,
  //     'customerAddress': consumer.customerAddress,
  //     'plotNo': consumer.plotNo,
  //     'buildingAptNo': consumer.buildingAptNo,
  //     'premiseName': consumer.premiseName,
  //     'numberOfFloor':
  //         consumer.numberOfFloor != 0 ? consumer.numberOfFloor : null,
  //     'tariffCategoryId':
  //         consumer.tariffCategoryId != 0 ? consumer.tariffCategoryId : null,
  //     'tariffSubCategoryId': consumer.tariffSubCategoryId != 0
  //         ? consumer.tariffSubCategoryId
  //         : null,
  //     'meterTypeId': consumer.meterTypeId != 0 ? consumer.meterTypeId : null,
  //     'meterModel': consumer.meterModel,
  //     'meterNumber': consumer.meterNumber,
  //     'meterManufacturer': consumer.meterManufacturer,
  //     'meterReading': consumer.meterReading != 0 ? consumer.meterReading : null,
  //     'phasingCodeTypeId':
  //         consumer.phasingCodeTypeId != 0 ? consumer.phasingCodeTypeId : null,
  //     'operatingVoltageId':
  //         consumer.operatingVoltageId != 0 ? consumer.operatingVoltageId : null,
  //     'installDate': consumer.installDate,
  //     'connectionStatusId':
  //         consumer.connectionStatusId != 0 ? consumer.connectionStatusId : null,
  //     'connectionTypeId':
  //         consumer.connectionTypeId != 0 ? consumer.connectionTypeId : null,
  //     'sanctionedLoad':
  //         consumer.sanctionedLoad != 0 ? consumer.sanctionedLoad : null,
  //     'connectedLoad':
  //         consumer.connectedLoad != 0 ? consumer.connectedLoad : null,
  //     'businessTypeId':
  //         consumer.businessTypeId != 0 ? consumer.businessTypeId : null,
  //     'othersBusiness': consumer.othersBusiness,
  //     'specialCode': consumer.specialCode,
  //     'specialType': consumer.specialType,
  //     'locationId': consumer.locationId != 0 ? consumer.locationId : null,
  //     'billGroup': consumer.billGroup,
  //     'bookNumber': consumer.bookNumber,
  //     'omfKwh': consumer.omfKwh != 0.0 ? consumer.omfKwh : null,
  //     'serviceCableSize':
  //         consumer.serviceCableSize != 0.0 ? consumer.serviceCableSize : null,
  //     'serviceCableTypeId': consumer.serviceCableTypeId != 0.0
  //         ? consumer.serviceCableTypeId
  //         : null,
  //     'surveyDate': consumer.surveyDate,
  //     'latitude': consumer.latitude,
  //     'longitude': consumer.longitude,
  //     'structureId': consumer.structureId != '' ? consumer.structureId : null,
  //     'structureMapNo':
  //         consumer.structureMapNo != '' ? consumer.structureMapNo : null,
  //     'structureTypeId':
  //         consumer.structureTypeId != 0 ? consumer.structureTypeId : null,
  //     'startingDate': consumer.startingDate,
  //     'remarks': consumer.remarks,
  //     'activationStatusId': consumer.activationStatusId,
  //     'verificationStateId': consumer.verificationStateId,
  //     'distance_from_sp': consumer.distance_from_sp,
  //   };
  //   try {
  //     final response = await http.put(
  //       Uri.parse('$myAPILink/api/Consumers/${consumer.consumerNo}'),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Accept": "application/json",
  //         'Authorization': 'Bearer $token',
  //       },
  //       body: jsonEncode(requestData),
  //     );
  //     //print(response.statusCode);
  //     if (response.statusCode == 200) {
  //       if (response.body.isNotEmpty) {
  //         final jsonResponse = jsonDecode(response.body);
  //         return Consumers.fromJson(jsonResponse);
  //       } else {
  //         throw Exception("Expected JSON response body is empty");
  //       }
  //     } else if (response.statusCode == 204) {
  //       return consumer;
  //     } else {
  //       if (response.statusCode == 500) {
  //         final errorResponse = response.body.isNotEmpty
  //             ? jsonDecode(response.body)
  //             : {'title': 'Unknown Error', 'traceId': 'N/A'};
  //         throw Exception(
  //             "Failed to update data. Status Code: ${response.statusCode}, Response Body: ${errorResponse['title']}, Trace ID: ${errorResponse['traceId']}");
  //       } else {
  //         final responseBody = jsonDecode(response.body);
  //         final errors = responseBody['errors'];
  //         final fieldName = errors.keys.first;
  //         //print('Field causing error: $fieldName');
  //         throw "$fieldName";
  //       }
  //     }
  //   } catch (error) {
  //     //print("Error: $error");
  //     throw "Please Check $error";
  //   }
  // }

  Future<void> deleteData(String consumerNo) async {
    try {
      final response = await http.delete(
        Uri.parse('$myAPILink/api/Consumers/$consumerNo'),
        headers: {"Accept": "application/json"},
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print("Successfully deleted Consumer No: $consumerNo");
      } else {
        final errorResponse = response.body.isNotEmpty
            ? jsonDecode(response.body)
            : {'title': 'Unknown Error', 'traceId': 'N/A'};
        throw Exception(
            "Failed to delete data. Status Code: ${response.statusCode}, Response Body: ${errorResponse['title']}, Trace ID: ${errorResponse['traceId']}");
      }
    } catch (error) {
      print("Error: $error");
      throw Exception("An error occurred: $error");
    }
  }

  Future<Consumers> fetchConsumerById(String consumerNo) async {
    final String? token = globalToken;
    if (token == null) {
      throw Exception('Token is missing. User is not authenticated.');
    }
    // print('$myAPILink/api/Consumers/$consumerNo');
    final response = await http.get(
      Uri.parse('$myAPILink/api/Consumers/$consumerNo'),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      if (data.isNotEmpty) {
        // Assuming the first item in the list is the consumer data you're interested in
        return Consumers.fromJson(data[0]);
      } else {
        throw Exception('No consumer data found');
      }
    } else {
      throw Exception('Failed to load consumer info');
    }
  }

  // Future<ConsumerUpdate> fetchConsumerForUpdate(int consumerId) async {
  //   final String? token = globalToken;
  //   if (token == null) {
  //     throw Exception('Token is missing. User is not authenticated.');
  //   }
  //   // print('$myAPILink/api/Consumers/$consumerNo');
  //   final response = await http.get(
  //     Uri.parse('$myAPILink/api/Consumers/searchConsumerEdit?id=$consumerId'),
  //     headers: {
  //       "Content-Type": "application/json",
  //       "Accept": "application/json",
  //       'Authorization': 'Bearer $token',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = jsonDecode(response.body);

  //     if (data.isNotEmpty) {
  //       // Assuming the first item in the list is the consumer data you're interested in
  //       return ConsumerUpdate.fromJson(data[0]);
  //     } else {
  //       throw Exception('No consumer data found');
  //     }
  //   } else {
  //     throw Exception('Failed to load consumer info');
  //   }
  // }

  Future<ConsumerUpdate> fetchConsumerForUpdate(int consumerId) async {
    //print('Fetching consumer data for update. Consumer ID: $consumerId');
    final String? token = globalToken;
    if (token == null) {
      throw Exception('Token is missing. User is not authenticated.');
    }

    final response = await http.get(
      Uri.parse('$myAPILink/api/Consumers/searchConsumerEdit?id=$consumerId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print('response body: ${response.body}'); // Debugging line to check the response format
      final data = jsonDecode(response.body);

      // ✅ Handle both cases: list or single object
      if (data is List && data.isNotEmpty) {
        return ConsumerUpdate.fromJson(data.first);
      } else if (data is Map<String, dynamic>) {
        return ConsumerUpdate.fromJson(data);
      } else {
        throw Exception('Unexpected API response format');
      }
    } else {
      throw Exception(
          'Failed to load Distribution Transformer data: ${response.statusCode}');
    }
  }

  Future<void> updateConsumer(
    ConsumerUpdate updatedConsumer,
  ) async {
    final String? token = globalToken;
    if (token == null) {
      throw Exception('Token is missing. User is not authenticated.');
    }

    final consumerRequestData = {
      'consumerId': updatedConsumer.consumerId,
      'consumerNo': updatedConsumer.consumerNo,
      'substationId': updatedConsumer.substationId,
      'feederLineId': updatedConsumer.feederLineId,
      'servicesPointId': updatedConsumer.servicesPointId,
      'dtId': updatedConsumer.dtId,
      'customerName': updatedConsumer.customerName,
      'customerNameBng': updatedConsumer.customerNameBng,
      'fatherName': updatedConsumer.fatherName,
      'customerNid': updatedConsumer.customerNid,
      'mobileNo': updatedConsumer.mobileNo,
      'email': (updatedConsumer.email == null || updatedConsumer.email!.isEmpty)
          ? null
          : updatedConsumer.email,
      'customerAddress': updatedConsumer.customerAddress,
      'metertypeId': updatedConsumer.meterTypeId,
      'meterModel': updatedConsumer.meterModel,
      'meterNumber': updatedConsumer.meterNumber,
      'meterManufacturer': updatedConsumer.meterManufacturer,
      'phasingCodeTypeId': updatedConsumer.phasingCodeTypeId,
      'locationId': updatedConsumer.locationId,
      'omfKwh': updatedConsumer.omfKwh,
    };

    try {
      // 🔹 1. Update PoleDetails
      final dtDetailsUrl =
          Uri.parse('$myAPILink/api/Consumers/${updatedConsumer.consumerId}');
      // print('➡️ PUT $dtDetailsUrl');
      //print('📦 Body: ${jsonEncode(consumerRequestData)}');

      final consumerResponse = await http.put(
        dtDetailsUrl,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(consumerRequestData),
      );

      // print('🔁 PoleDetails Response: ${consumerResponse.statusCode}');
      // print('🧾 PoleDetails Body: ${consumerResponse.body}');

      if (consumerResponse.statusCode != 200 &&
          consumerResponse.statusCode != 204) {
        throw Exception(
            'Failed to update ConsumerDetails. Status: ${consumerResponse.statusCode}, '
            'Response: ${consumerResponse.body}');
      }
    } catch (e, stackTrace) {
      print('❌ Error updating pole: $e');
      print('📍 Stack trace: $stackTrace');
      rethrow;
    }
  }
}

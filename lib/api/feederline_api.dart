import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../constants/constant.dart';
import '../models/Login/login.dart';
import '../models/app_config.dart';
//feederline model link
import '../models/feederlines_lookup/feederline.dart';
import '../models/feederlines_lookup/feederline_byid.dart';
import '../models/regions/esu_info.dart';
import '../models/regions/feeder_line.dart';
import '../models/regions/feederline_conductor.dart';
import '../models/regions/feederlinetype.dart';

class CallApiService {
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

  User? user = globalUser;
  ///// ESU ID /////
  Future<List<EsuInfo>> fetchEsuInfo(int sndId) async {
    final response = await http
        .get(Uri.parse('$myAPILink/api/EsuInfoes/search?sndId=$sndId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map<EsuInfo>((json) => EsuInfo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load SnD info');
    }
  }

  ///// ESU ID /////
  ///////----Feederline Type
  Future<List<FeederLineType>> fetchFeederLineTypeInfo() async {
    final response =
        await http.get(Uri.parse('$myAPILink/api/FeederLineTypes'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<FeederLineType>((json) => FeederLineType.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load Feeder Line Type info');
    }
  }

  Future<List<FeederConductorType>> fetchFeederlineConductor() async {
    final response =
        await http.get(Uri.parse('$myAPILink/api/FeederConductorTypes'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<FeederConductorType>(
              (json) => FeederConductorType.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load Feeder Line Conductor Type');
    }
  }

  ///////////-----Feeder line-----//////////
  Future<List<FeederLines>> fetchFeederLines(int id) async {
    final String? token = globalToken;
    String url;
    
    if (token == null) {
      throw Exception('Token is missing. User is not authenticated.');
    }
    if (id != 0) {
      url = '$myAPILink/api/FeederLines/searchBySnD?sndId=$id';
    } else {
      url = '$myAPILink/api/FeederLines';
    }
    final response =
        await http.get(Uri.parse(url), 
        headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      }
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<FeederLines>((json) => FeederLines.fromJson(json))
          .toList()
          .reversed
          .toList();
    } else {
      throw Exception('Failed to load Feeder Lines');
    }
  }

  Future<List<FeederLine>> fetchFeederLinesBySubstation(
      int substationId) async {
    final response = await http.get(Uri.parse(
        '$myAPILink/api/FeederLines/search?substationId=$substationId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map<FeederLine>((json) => FeederLine.fromJson(json)).toList();
      // List<dynamic> body = jsonDecode(response.body);
      // List<FeederLines> allDatas = body.map((dynamic item) => FeederLines.fromJson(item)).toList();
      // List<FeederLines> filteredDatas = allDatas.where((data) => data.feederLineId > 1900).toList();
      // return filteredDatas;
    } else {
      throw Exception('Failed to load Feeder Lines');
    }
  }

  Future<FeederLinesById> fetchFeederLineDetails(int feederLineId) async {
    final String? token = globalToken;
    if (token == null) {
      throw Exception('Token is missing. User is not authenticated.');
    }
    final response = await http
        .get(Uri.parse('$myAPILink/api/FeederLines/$feederLineId'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    // print("Request URL: $myAPILink/api/FeederLines/$feederLineId");
    // print("Request Status: ${response.statusCode}");
    // print("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<dynamic> list = jsonResponse;
      var feederLineData =
          list.firstWhere((element) => element['feederLineId'] == feederLineId);
      return FeederLinesById.fromJson(feederLineData);
      // return FeederLines.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load feeder line');
    }
  }

  Future<FeederLines> createData(FeederLines feederlines) async {
    if ((feederlines.feederLineId).toString() == "") {
      throw 'Please Provide Feeder Line Id';
    } else {
      final requestData = {
        'feederLineId': feederlines.feederLineId,
        'feederlineName': feederlines.feederlineName,
        'zoneId': feederlines.zoneId,
        'circleId': feederlines.circleId,
        'sndId': feederlines.sndId,
        'esuId': feederlines.esuId,
        'sourceSubstationId': feederlines.sourceSubstationId,
        'destinationSubstationId': feederlines.destinationSubstationId,
        'feederLineCode': feederlines.feederLineCode,
        'isGrid': feederlines.isGrid,
        'gridSubstationInputId': feederlines.gridSubstationInputId,
        'feederLineUId': feederlines.feederLineUId,
        'feederLineTypeId': feederlines.feederLineTypeId,
        'feederConductorTypeId': feederlines.feederConductorTypeId,
        'nominalVoltage': feederlines.nominalVoltage,
        'feederLocation': feederlines.feederLocation,
        'feederMeterNumber': feederlines.feederMeterNumber,
        'meterCurrentRating': feederlines.meterCurrentRating,
        'meterVoltageRating': feederlines.meterVoltageRating,
        'maximumDemand': feederlines.maximumDemand,
        'peakDemand': feederlines.peakDemand,
        'maximumLoad': feederlines.maximumLoad,
        'sanctionedLoad': feederlines.sanctionedLoad,
        'isBulkCustomer': feederlines.isBulkCustomer,
        'bulkCustomerName': feederlines.bulkCustomerName,
        'isPgcbGrid': feederlines.isPgcbGrid,
        'startingDate': feederlines.startingDate,
        'activationStatusId': feederlines.activationStatusId,
        'verificationStateId': feederlines.verificationStateId,
        'isPermittedToVerify': feederlines.isPermittedToVerify,
        'isPermittedToApprove': feederlines.isPermittedToApprove,
        'isEditAvailable': feederlines.isEditAvailable,
        'feederLength': feederlines.feederLength,
        'remarks': feederlines.remarks,
      };
      // debugPrint('Request Data: $requestData');
      // return Future.error('Stopped execution for debugging.');
      try {
        final response = await http.post(
          Uri.parse('$myAPILink/api/FeederLines'),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: jsonEncode(requestData),
        );
        // print("Request Status: ${response.statusCode}");
        // print("Response Body: ${response.body}");
        if (response.statusCode == 201) {
          final jsonResponse = jsonDecode(response.body);
          return FeederLines.fromJson(jsonResponse);
        } else {
          final responseBody = jsonDecode(response.body);
          final errors = responseBody['errors'];
          final fieldName = errors.keys.first;
          //print('Field causing error: $fieldName');
          throw "$fieldName";
        }
      } catch (e) {
        throw Exception("Failed to add New Feeder Line Data. Status Code: $e");
      }
    }
  }

  Future<FeederLines> updateFeederLine(FeederLines feederlines) async {
    final String? token = globalToken;
    if (token == null) {
      throw Exception('Token is missing. User is not authenticated.');
    }

    final requestData = {
      'feederLineId': feederlines.feederLineId,
      'feederlineName': feederlines.feederlineName,
      'zoneId': feederlines.zoneId,
      'circleId': feederlines.circleId,
      'sndId': feederlines.sndId,
      'esuId': feederlines.esuId,
      'sourceSubstationId': feederlines.sourceSubstationId,
      'destinationSubstationId': feederlines.destinationSubstationId,
      'feederLineCode': feederlines.feederLineCode,
      'isGrid': feederlines.isGrid,
      'gridSubstationInputId': feederlines.gridSubstationInputId,
      'feederLineUId': feederlines.feederLineUId,
      'feederLineTypeId': feederlines.feederLineTypeId,
      'feederConductorTypeId': feederlines.feederConductorTypeId,
      'nominalVoltage': feederlines.nominalVoltage,
      'feederLocation': feederlines.feederLocation,
      'feederMeterNumber': feederlines.feederMeterNumber,
      'meterCurrentRating': feederlines.meterCurrentRating,
      'meterVoltageRating': feederlines.meterVoltageRating,
      'maximumDemand': feederlines.maximumDemand,
      'peakDemand': feederlines.peakDemand,
      'maximumLoad': feederlines.maximumLoad,
      'sanctionedLoad': feederlines.sanctionedLoad,
      'isBulkCustomer': feederlines.isBulkCustomer,
      'bulkCustomerName': feederlines.bulkCustomerName,
      'isPgcbGrid': feederlines.isPgcbGrid,
      'startingDate': feederlines.startingDate,
      'activationStatusId': feederlines.activationStatusId,
      'verificationStateId': feederlines.verificationStateId,
      'isPermittedToVerify': feederlines.isPermittedToVerify,
      'isPermittedToApprove': feederlines.isPermittedToApprove,
      'isEditAvailable': feederlines.isEditAvailable,
      'feederLength': feederlines.feederLength,
      'remarks': feederlines.remarks,
    };
    //debugPrint('Request Data: $requestData');
    // return Future.error('Stopped execution for debugging.');
    try {
      final response = await http.put(
        Uri.parse('$myAPILink/api/FeederLines/${feederlines.feederLineId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestData),
      );
      // print("Request URL: $myAPILink/api/FeederLines/${feederlines.feederLineId}");
      // print("Request Status: ${response.statusCode}");
      // print("Response Body: ${response.body}");
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final jsonResponse = jsonDecode(response.body);
          return FeederLines.fromJson(jsonResponse);
        } else {
          throw Exception("Expected JSON response body is empty");
        }
      } else if (response.statusCode == 204) {
        return feederlines;
      } else {
        final errorResponse = response.body.isNotEmpty
            ? jsonDecode(response.body)
            : {'title': 'Unknown Error', 'traceId': 'N/A'};
        throw Exception(
            "Failed to update data. Status Code: ${response.statusCode}, Response Body: ${errorResponse['title']}, Trace ID: ${errorResponse['traceId']}");
      }
    } catch (error) {
      print("Error: $error");
      throw Exception("An error occurred: $error");
    }
  }

  Future<void> deleteData(int feederLineId) async {
    try {
      final response = await http.delete(
        Uri.parse('$myAPILink/api/FeederLines/$feederLineId'),
        headers: {"Accept": "application/json"},
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print("Successfully deleted Feeder Line with ID: $feederLineId");
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

  //--DT Details--//
  Future<List<FeederLine>> fetchFeederlineById(int id) async {
    final String? token = globalToken;
    if (token == null) {
      throw Exception('Token is missing. User is not authenticated.');
    }
    final response =
        await http.get(Uri.parse('$myAPILink/api/FeederLines/$id'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map<FeederLine>((json) => FeederLine.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load FeederLine info');
    }
  }
  //--DT Details--//
}

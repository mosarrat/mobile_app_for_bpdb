import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../constants/constant.dart';
import '../models/Login/login.dart';
import '../models/field_monitoring/field_monitoring.dart';

class CallFieldMonitoringApi {
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

  User? user = globalUser;
  final String? token = globalToken;

  

  Future<List<FieldMonitoringData>> fetchFMData() async {
    final String? token = globalToken;
    String url = '$myAPILink/api/FieldMonitoring';
    if (token == null) {
      throw Exception('Token is missing. User is not authenticated.');
    }

    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<FieldMonitoringData>((json) => FieldMonitoringData.fromJson(json))
          .toList()
          .reversed
          .toList();
    } else {
      throw Exception(response.body);
    }
  }



  Future<FieldMonitoringData> createFieldMonitoringData(FieldMonitoringData monitoringData) async {
    final String? token = globalToken;
    if (token == null) {
      throw Exception('Token is missing. User is not authenticated.');
    }
    final requestData = {
      'applicationTrackingNumber': monitoringData.applicationTrackingNumber,
      'applicantName': monitoringData.applicantName,
      'applicantNid': monitoringData.applicantNid,
      'applicantMobile': monitoringData.applicantMobile,
      'isLandDocumentOk': monitoringData.isLandDocumentOk,
      'meterLatitude': monitoringData.meterLatitude,
      'meterLongitude': monitoringData.meterLongitude,
      'hasPreviousConnection': monitoringData.hasPreviousConnection,
      'arrearStatus': monitoringData.arrearStatus,
      'distanceFromNearestPole': monitoringData.distanceFromNearestPole,
      'estimatedLoad': monitoringData.estimatedLoad,
      'submitDate': monitoringData.submitDate
      ?.toIso8601String()
      .split('T')
      .first,
    };
    print('Request Data: $requestData');
    try {
      final response = await http.post(
        Uri.parse('$myAPILink/api/FieldMonitoring'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestData),
      );


      // print("Status Code: ${response.statusCode}");
      // print("Raw Response: ${response.body}");

      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return FieldMonitoringData.fromJson(jsonResponse);
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
  }


  Future<List<FieldMonitoringData>> fetchFMByDetailsId(int id) async {
    final String? token = globalToken;
    String url = '$myAPILink/api/FieldMonitoring/$id';
    print("Fetching details for ID: $id from URL: $url");
    if (token == null) {
      throw Exception('Token is missing. User is not authenticated.');
    }
    final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is List) {
        return decoded
            .map<FieldMonitoringData>((json) => FieldMonitoringData.fromJson(json))
            .toList();
      } else {
        return [FieldMonitoringData.fromJson(decoded)];
      }
    } else {
      throw Exception('Failed to load Dt info');
    }
  }

}

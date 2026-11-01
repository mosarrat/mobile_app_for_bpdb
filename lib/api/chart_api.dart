import 'dart:convert';
// import 'package:connectivity/connectivity.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:intl/intl.dart';
import '../../constants/constant.dart';
import '../models/charts_lookups/pie_chart.dart';
import '../models/charts_lookups/bar_chart.dart';
import '../models/regions/feederlinetype.dart';

Future<List<ZoneData>> PieData(String? selectedData) async {
  String url;
  final String? token = globalToken;

  if (token == null) {
    throw Exception('Token is missing. User is not authenticated.');
  }
  if (selectedData == "1") {
    url = '$myAPILink/api/Consumers/consumerPiechart';
  } else {
        url = '$myAPILink/api/Consumers/polePiechart';
  }
  final response = await http.get(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      'Authorization': 'Bearer $token',
    },
  );
  
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map<ZoneData>((json) => ZoneData.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load Data');
  }
}


Future<List<ZoneReport>> BarData(String? selectedBarData) async {
  String url;
  final String? token = globalToken;

  if (token == null) {
    throw Exception('Token is missing. User is not authenticated.');
  }
  if (selectedBarData == "1") {
    url = '$myAPILink/api/Consumers/consumerGraph';
  } else {
    url = '$myAPILink/api/Consumers/poleGraph';
  }
  final response = await http.get(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      'Authorization': 'Bearer $token',
    },
  );
  
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map<ZoneReport>((json) => ZoneReport.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load Data');
  }
}

Future<List<FeederLineType>> fetchFeederLineTypeInfo() async {
  final response = await http.get(Uri.parse('$myAPILink/api/FeederLineTypes'));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map<FeederLineType>((json) {
      return FeederLineType(
        feederLineTypeId: 0,
        feederLineTypeName: json['feederLineTypeName'] ?? '', 
      );
    }).toList();
  } else {
    throw Exception('Failed to load Feeder Line Type info');
  }
}


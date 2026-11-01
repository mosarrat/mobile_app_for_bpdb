import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../constants/constant.dart';
import '../models/Login/login.dart';
import '../models/region_delails_lookup/esu.dart';
import '../models/region_delails_lookup/substation.dart';
import '../models/regions/circle.dart';
import '../models/regions/snd_info.dart';
import '../models/regions/zone.dart';

class CallRegionApi {
  Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
    //return true;
  }

  User? user = globalUser;
  void showMessage(String message, String type) {}

  Future<List<Zone>> fetchZoneInfo() async {
    final response = await http.get(Uri.parse('$myAPILink/api/ZoneInfoes'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map<Zone>((json) => Zone.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load zone info');
    }
  }

  Future<Zone> fetchZoneDetails(int id) async {
    final response = await http.get(Uri.parse('$myAPILink/api/ZoneInfoes/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Zone.fromJson(data);
    } else {
      throw Exception('Failed to load zone info');
    }
  }

  Future<List<Circles>> fetchCircleInfo(int zoneId) async {
    final response = await http
        .get(Uri.parse('$myAPILink/api/CircleInfoes/search?zoneId=$zoneId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map<Circles>((json) => Circles.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load circle info');
    }
  }

  Future<Circles> fetchCircleDetails(int id) async {
    final response =
        await http.get(Uri.parse('$myAPILink/api/CircleInfoes/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Circles.fromJson(data);
    } else {
      throw Exception('Failed to load Circle info');
    }
  }

  Future<List<SndInfo>> fetchSndInfo(int circleId) async {
    final response = await http
        .get(Uri.parse('$myAPILink/api/SndInfoes/search?circleId=$circleId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map<SndInfo>((json) => SndInfo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Snd info');
    }
  }

  Future<SndInfo> fetchSndDetails(int id) async {
    final response = await http.get(Uri.parse('$myAPILink/api/SndInfoes/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return SndInfo.fromJson(data);
    } else {
      throw Exception('Failed to load Snd info');
    }
  }

  Future<List<Esu>> fetchEsuInfo(int sndId) async {
    final response = await http
        .get(Uri.parse('$myAPILink/api/EsuInfoes/search?sndId=$sndId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map<Esu>((json) => Esu.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Esu info');
    }
  }

  Future<Esu> fetchEsuDetails(int id) async {
    final response = await http.get(Uri.parse('$myAPILink/api/EsuInfoes/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Esu.fromJson(data);
    } else {
      throw Exception('Failed to load Esu info');
    }
  }

  Future<List<Substations>> fetchSubstationInfo(String id) async {
    String data;
    String url;

    // if (user?.EsuId != null) {
    //   data = 'esu_${user?.EsuId}';
    //   url = '$myAPILink/api/Substations/searchByAdminInfo?data=${data}';
    // }
    // else if (user?.SndId != null) {
    //   data = 'snd_${user?.SndId}';
    //   url = '$myAPILink/api/Substations/searchByAdminInfo?data=${data}';
    // }
    // else if (user?.CircleId != null) {
    //   data = 'circle_${user?.CircleId}';
    //   url = '$myAPILink/api/Substations/searchByAdminInfo?data=${data}';
    // }
    // else if (user?.ZoneId != null) {
    //   data = 'zone_${user?.ZoneId}';
    //   url = '$myAPILink/api/Substations/searchByAdminInfo?data=${data}';
    // }
    if (id !="") {
      // data = 'snd_$id';
      url = '$myAPILink/api/Substations/searchByAdminInfo?data=$id';
    } else {
      data = '';
      url = '$myAPILink/api/Substations';
    }
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<Substations>((json) => Substations.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load Substation info');
    }
  }

  Future<Substations> fetchSubstationDetails(int id) async {
    final response =
        await http.get(Uri.parse('$myAPILink/api/Substations/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Substations.fromJson(data);
    } else {
      throw Exception('Failed to load Esu info');
    }
  }
}

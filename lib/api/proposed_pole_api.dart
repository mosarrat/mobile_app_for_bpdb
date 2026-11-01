import 'dart:convert';

// import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:bpdb_gis_app/models/proposed_pole/proposed_pole.dart';
import 'package:bpdb_gis_app/models/proposed_pole/proposed_pole_sec.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../constants/constant.dart';
import '../models/Login/login.dart';
import '../models/proposed_pole/next_pole_no.dart';
import '../models/proposed_pole/next_section_number.dart';
import '../models/proposed_pole/proposed_pole_info.dart';
import '../models/proposed_pole/section_info.dart';
import '../models/regions/feeder_line.dart';

class CallProposedPoleApi {
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

  Future<List<FeederLine>> fetchFeederLineBySnD(int sndId) async {
    final response = await http.get(
      Uri.parse('$myAPILink/api/FeederLines/searchBySnD?sndId=$sndId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map<FeederLine>((json) => FeederLine.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load feeder lines info');
    }
  }

  Future<List<FeederLine>> fetchFeederLineByEsu(int esuId) async {
    final response = await http.get(
      Uri.parse('$myAPILink/api/FeederLines/searchByESU?esuId=$esuId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map<FeederLine>((json) => FeederLine.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load feeder lines info');
    }
  }

  // Future<bool> addProposedPole(
  //   List<ProposedPole> proposedPoles,
  //   PoleSection poleSection,
  // ) async {
  //   try {
  //     // Step 1: Post PoleSection
  //     final sectionResponse = await http.post(
  //       Uri.parse('$myAPILink/api/ProposedPoleSections'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //       body: jsonEncode({
  //         "zoneId": poleSection.zoneId,
  //         "circleId": poleSection.circleId,
  //         "sndId": poleSection.sndId,
  //         "esuId": poleSection.esuId,
  //         "feederLineId": poleSection.feederLineId,
  //         "sectionName": poleSection.sectionName,
  //         "areaName": poleSection.areaName,
  //         "dtExist": poleSection.dtExist,
  //         "dtRating": poleSection.dtRating,
  //         "voltLavel": poleSection.voltLavel,
  //         "surveyDate": poleSection.surveyDate?.toIso8601String(),
  //       }),
  //     );

  //     if (sectionResponse.statusCode == 200 ||
  //         sectionResponse.statusCode == 201) {
  //       final responseData = jsonDecode(sectionResponse.body);
  //       final int newPoleSectionId = responseData['poleSectionId'];

  //       // Step 2: Post each ProposedPole
  //       for (var pole in proposedPoles) {
  //         final poleResponse = await http.post(
  //           Uri.parse('$myAPILink/api/ProposedPoles'),
  //           headers: {
  //             'Content-Type': 'application/json',
  //             'Authorization': 'Bearer $token',
  //           },
  //           body: jsonEncode({
  //             "poleNo": pole.poleNo,
  //             "poleSectionId": newPoleSectionId,
  //             "poleTypeId": pole.poleTypeId,
  //             "poleName": pole.poleName,
  //             "poleHeight": pole.poleHeight,
  //             "remarks": pole.remarks,
  //             "areaName": pole.areaName,
  //             "latitude": pole.latitude,
  //             "longitude": pole.longitude,
  //             "activationStatusId": pole.activationStatusId,
  //           }),
  //         );

  //         if (poleResponse.statusCode != 200 &&
  //             poleResponse.statusCode != 201) {
  //           print('Failed to add pole: ${poleResponse.body}');
  //           return false;
  //         }
  //       }

  //       return true; // All poles and section added successfully
  //     } else {
  //       print('Failed to add pole section: ${sectionResponse.body}');
  //       return false;
  //     }
  //   } catch (e) {
  //     print('Error in addProposedPole: $e');
  //     return false;
  //   }
  // }

  Future<bool> addProposedPole(
    List<ProposedPole> proposedPoles,
    PoleSection poleSection,
  ) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final sectionPayload = {
      "zoneId": poleSection.zoneId,
      "circleId": poleSection.circleId,
      "sndId": poleSection.sndId,
      "esuId": poleSection.esuId,
      "feederLineId": poleSection.feederLineId,
      "sectionName": poleSection.sectionName,
      "areaName": poleSection.areaName,
      "dtExist": poleSection.dtExist,
      "dtRating": poleSection.dtRating,
      "voltLavel": poleSection.voltLavel,
      "surveyDate": poleSection.surveyDate?.toIso8601String(),
    };
    debugPrint('POST ProposedPoleSections: ${jsonEncode(sectionPayload)}');

    final sectionResponse = await http.post(
      Uri.parse('$myAPILink/api/ProposedPoleSections'),
      headers: headers,
      body: jsonEncode(sectionPayload),
    );

    if (sectionResponse.statusCode != 200 && sectionResponse.statusCode != 201) {
      throw Exception(
          'Section save failed (${sectionResponse.statusCode}): ${sectionResponse.body}');
    }

    final int newPoleSectionId =
        jsonDecode(sectionResponse.body)['poleSectionId'];

    for (final pole in proposedPoles) {
      final polePayload = {
        "poleNo": pole.poleNo,
        "poleSectionId": newPoleSectionId,
        "poleTypeId": pole.poleTypeId,
        "poleName": pole.poleName,
        "poleHeight": pole.poleHeight,
        "remarks": pole.remarks,
        "areaName": pole.areaName,
        "latitude": pole.latitude,
        "longitude": pole.longitude,
        "activationStatusId": pole.activationStatusId,
      };
      debugPrint('POST ProposedPoles: ${jsonEncode(polePayload)}');

      final poleResponse = await http.post(
        Uri.parse('$myAPILink/api/ProposedPoles'),
        headers: headers,
        body: jsonEncode(polePayload),
      );

      if (poleResponse.statusCode != 200 && poleResponse.statusCode != 201) {
        throw Exception(
            'Pole ${pole.poleNo} save failed (${poleResponse.statusCode}): ${poleResponse.body}');
      }
    }
    return true;
  }

  /*
  Future<List<SectionInfo>> fetchSectionWisePoles() async {
    final String? token = globalToken;
    if (token == null) {
      throw Exception('Token is missing. User is not authenticated.');
    }
    final response =
      await http.get(Uri.parse('$myAPILink/api/ProposedPoleSections'), 
      headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<SectionInfo>((json) => SectionInfo.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load Pole Sections: ${response.statusCode}');
    }
  }
  */
  Future<List<SectionInfo>> fetchSectionWisePoles() async {
    final String? token = globalToken;
    String url;
    if (token == null) {
      throw Exception('Token is missing. User is not authenticated.');
    }

    if (user?.SndId != null) {
      url =
          '$myAPILink/api/ProposedPoleSections/searchBySnD?sndId=${user!.SndId}';
    } else if (user?.EsuId != null) {
      url =
          '$myAPILink/api/ProposedPoleSections/searchByESU?esuId=${user!.EsuId}';
    } else {
      url = '$myAPILink/api/ProposedPoleSections';
    }
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<SectionInfo>((json) => SectionInfo.fromJson(json))
          .toList()
          .reversed
          .toList();
    } else {
      throw Exception(response.body);
    }
  }

  Future<List<PoposedPoleIListnfo>> fetchProposedPolesBySectionId(
      int sectionId) async {
    if (token == null) {
      throw Exception('Token is missing. User is not authenticated.');
    }
    final response = await http.get(
        Uri.parse(
            '$myAPILink/api/ProposedPoles/searchBySection?section=$sectionId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<PoposedPoleIListnfo>(
              (json) => PoposedPoleIListnfo.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load Pole Sections: ${response.statusCode}');
    }
  }

  // Future<List<ArcGISPoint>> fetchPolesLocationBySectionId(int sectionId) async {
  //   final response = await http.get(
  //       Uri.parse(
  //           '$myAPILink/api/ProposedPoles/searchBySection?section=$sectionId'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       });

  //   if (response.statusCode == 200) {
  //     final List<dynamic> decoded = jsonDecode(response.body);
  //     final List<PoposedPoleIListnfo> poles =
  //         decoded.map((json) => PoposedPoleIListnfo.fromJson(json)).toList();

  //     final List<ArcGISPoint> points = poles
  //         .where((p) => p.latitude != null && p.longitude != null)
  //         .map(
  //           (p) => ArcGISPoint(
  //             x: p.longitude!,
  //             y: p.latitude!,
  //             spatialReference: SpatialReference.wgs84,
  //           ),
  //         )
  //         .toList();

  //     return points;
  //   } else {
  //     throw Exception('Failed to fetch poles');
  //   }
  // }

  Future<List<PoposedPoleIListnfo>> fetchPolesInfoBySectionId(
      int sectionId) async {
    final response = await http.get(
      Uri.parse(
          '$myAPILink/api/ProposedPoles/searchBySection?section=$sectionId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> decoded = jsonDecode(response.body);
      return decoded.map((json) => PoposedPoleIListnfo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch pole info');
    }
  }

  Future<NextPoleResponse> fetchNextPoleBySnD(int sndId) async {
    final response = await http.get(
      Uri.parse('$myAPILink/api/ProposedPoles/searchBySnd?snd=$sndId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return NextPoleResponse.fromJson(data);
    } else {
      throw Exception('Failed to fetch next pole number');
    }
  }

  Future<NextNumberResponse> fetchNextSecBySnD(int sndId) async {
    final response = await http.get(
      Uri.parse('$myAPILink/api/ProposedPoles/searchSecBySnd?snd=$sndId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return NextNumberResponse.fromJson(data);
    } else {
      throw Exception('Failed to fetch next pole number');
    }
  }

  Future<void> deleteProposedPole(int poleId) async {
    print("Attempting to delete Proposed Pole with ID: $poleId");
    if (token == null) {
      throw Exception('Token is missing. User is not authenticated.');
    }
    try {
      final response = await http.delete(
        Uri.parse('$myAPILink/api/ProposedPoles/$poleId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        //print("Successfully deleted Proposed Pole ID: $poleId");
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
}

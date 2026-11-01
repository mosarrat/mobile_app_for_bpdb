import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../constants/constant.dart';
import '../models/Login/login.dart';
import '../models/app_config.dart';
import '../models/consumer_lookup/tariff_sub_category.dart';
import '../models/consumer_lookup/single_consumers.dart';

import '../models/pole_lookup/pole_data_for_map.dart';
import '../models/region_delails_lookup/substation.dart';
import '../models/regions/distribution_transformer.dart';
// import '../models/regions/esu_info.dart';
import '../models/regions/feeder_line.dart';
// import '../models/regions/feederlinetype.dart';
import '../models/regions/pole.dart';
import '../models/regions/service_point.dart';
import '../models/regions/substation.dart';
import '../models/regions/zone.dart';
import '../models/regions/circle.dart';
import '../models/regions/snd_info.dart';
//feederline model link
// import '../models/feederlines_lookup/feederline.dart';

class CallApi {
  Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
    //return true;
  }

  void showMessage(String message, String type) {
    // Fluttertoast.showToast(
    //   msg: message,
    //   toastLength: Toast.LENGTH_LONG,
    //   gravity: ToastGravity.BOTTOM,
    //   backgroundColor: type.contains('error') ? Colors.red : Colors.grey[800],
    //   textColor: type.contains('error') ? Colors.yellow : Colors.white,
    //   fontSize: 20.0,
    // );
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

  //#region  :: API Calling
  // Future<Map<String, dynamic>> fetchDashboardCounting() async {
  //   final String? token = globalToken;

  //   if (token == null) {
  //     throw Exception('Token is missing. User is not authenticated.');
  //   }
  //   final response =
  //       await http.get(
  //         Uri.parse('$myAPILink/api/Consumers/count'),
  //         headers: {
  //           "Content-Type": "application/json",
  //           "Accept": "application/json",
  //           'Authorization': 'Bearer $token',
  //         },
  //       );

  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body);
  //   } else {
  //     throw Exception('Failed to load counting!');
  //   }
  // }
  Future<String> fetchDashboardCounting() async {
    final String? token = globalToken;

    if (token == null) {
      throw Exception('Token is missing. User is not authenticated.');
    }

    final response = await http.get(
      Uri.parse('$myAPILink/api/Consumers/count'),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final cleanedResponse = response.body.trim();
      try {
        //print('Cleaned response: $cleanedResponse');

        final decodedResponse = jsonDecode(cleanedResponse);

        // print('Decoded response: $decodedResponse');
        // print('Decoded response type: ${decodedResponse.runtimeType}');
        return decodedResponse;
      } catch (e) {
        throw Exception('Failed to parse response body: $e');
      }
    } else {
      throw Exception(
          'Failed to load counting! Status code: ${response.statusCode}');
    }
  }

  // Future<List<Zone>> fetchZoneInfo() async {
  //   User? user = globalUser;
  //   int? userZoneId = user?.ZoneId;
  //   final response = await http.get(Uri.parse('$myAPILink/api/ZoneInfoes'));

  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = jsonDecode(response.body);
  //     return data.map<Zone>((json) => Zone.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load zone info');
  //   }
  // }

  Future<List<Zone>> fetchZoneInfo() async {
    User? user = globalUser;
    int? userZoneId = user?.ZoneId;

    // Determine the API URL
    String apiUrl = userZoneId != null
        ? '$myAPILink/api/ZoneInfoes/$userZoneId'
        : '$myAPILink/api/ZoneInfoes';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (userZoneId != null) {
        // Response for a single zone (Map object)
        return [Zone.fromJson(data)];
      } else {
        // Response for multiple zones (List)
        final List<dynamic> zoneList = data;
        return zoneList.map<Zone>((json) => Zone.fromJson(json)).toList();
      }
    } else {
      throw Exception('Failed to load zone info');
    }
  }

//////////////////////------Map Daetails-------///////////////////////////
  Future<void> fetchZoneDetailsInfo(int zoneId) async {
    final response =
        await http.get(Uri.parse('$myAPILink/api/ZoneInfoes/$zoneId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final zone = Zone.fromJson(data);
      GlobalVariables.centerLatitude = zone.centerLatitude;
      GlobalVariables.centerLongitude = zone.centerLongitude;
      GlobalVariables.defaultZoomLevel = zone.defaultZoomLevel.toDouble();
    } else {
      throw Exception('Failed to load Zone info');
    }
  }

  Future<void> fetchCircleDetailsInfo(int circleId) async {
    final response =
        await http.get(Uri.parse('$myAPILink/api/CircleInfoes/$circleId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      final circle = Circles.fromJson(data);
      GlobalVariables.centerLatitude = circle.centerLatitude;
      GlobalVariables.centerLongitude = circle.centerLongitude;
      GlobalVariables.defaultZoomLevel = circle.defaultZoomLevel?.toDouble();
    } else {
      throw Exception('Failed to load Zone info');
    }
  }

  Future<void> fetchSndDetailsInfo(int sndId) async {
    final response =
        await http.get(Uri.parse('$myAPILink/api/SndInfoes/$sndId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      final snd = SndInfo.fromJson(data);
      GlobalVariables.centerLatitude = snd.centerLatitude;
      GlobalVariables.centerLongitude = snd.centerLongitude;
      GlobalVariables.defaultZoomLevel = snd.defaultZoomLevel?.toDouble();
    } else {
      throw Exception('Failed to load Zone info');
    }
  }

  Future<void> fetchSubstationDetailsInfo(int substationId) async {
    final response =
        await http.get(Uri.parse('$myAPILink/api/Substations/$substationId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      final circle = Substations.fromJson(data);
      GlobalVariables.centerLatitude = circle.latitude;
      GlobalVariables.centerLongitude = circle.longitude;
      GlobalVariables.defaultZoomLevel = circle.defaultZoomLevel?.toDouble();
    } else {
      throw Exception('Failed to load Zone info');
    }
  }
//////////////////////------Map Daetails-------///////////////////////////

  // Future<List<Circles>> fetchCircleInfo(int zoneId) async {
  //   final response = await http
  //       .get(Uri.parse('$myAPILink/api/CircleInfoes/search?zoneId=$zoneId'));

  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = jsonDecode(response.body);
  //     return data.map<Circles>((json) => Circles.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load circle info');
  //   }
  // }
  Future<List<Circles>> fetchCircleInfo(int zoneId) async {
    User? user = globalUser;
    int? userCircleId = user?.CircleId;

    // Determine the API URL
    String apiUrl = userCircleId != null
        ? '$myAPILink/api/CircleInfoes/$userCircleId'
        : '$myAPILink/api/CircleInfoes/search?zoneId=$zoneId';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (userCircleId != null) {
        // Response for a single zone (Map object)
        return [Circles.fromJson(data)];
      } else {
        // Response for multiple zones (List)
        final List<dynamic> circleList = data;
        return circleList
            .map<Circles>((json) => Circles.fromJson(json))
            .toList();
      }
    } else {
      throw Exception('Failed to load Circle info');
    }
  }

  // Future<List<SndInfo>> fetchSnDInfo(int circleId) async {
  //   final response = await http
  //       .get(Uri.parse('$myAPILink/api/SndInfoes/search?circleId=$circleId'));

  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = jsonDecode(response.body);
  //     return data.map<SndInfo>((json) => SndInfo.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load SnD info');
  //   }
  // }
  Future<List<SndInfo>> fetchSnDInfo(int circleId) async {
    User? user = globalUser;
    int? userSndId = user?.SndId;

    // Determine the API URL
    String apiUrl = userSndId != null
        ? '$myAPILink/api/SndInfoes/$userSndId'
        : '$myAPILink/api/SndInfoes/search?circleId=$circleId';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (userSndId != null) {
        // Response for a single zone (Map object)
        return [SndInfo.fromJson(data)];
      } else {
        // Response for multiple zones (List)
        final List<dynamic> sndList = data;
        return sndList.map<SndInfo>((json) => SndInfo.fromJson(json)).toList();
      }
    } else {
      throw Exception('Failed to load SND info');
    }
  }

  Future<List<Substation>> fetchSubstationInfo(int sndId) async {
    final response = await http
        //.get(Uri.parse('http://10.55.5.10/bpdb-app/api/Substations/search?sndId=$sndId'));
        .get(Uri.parse('$myAPILink/api/Substations/search?sndId=$sndId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map<Substation>((json) => Substation.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load substations info');
    }
  }

  Future<List<Substation>> fetchSubstationInfoByEsu(int esuId) async {
    // print('Fetching substations for ESU ID: $esuId');
    final response = await http
        .get(Uri.parse('$myAPILink/api/Substations/searchByEsu?esuId=$esuId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map<Substation>((json) => Substation.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load substations info');
    }
  }

  Future<List<FeederLine>> fetchFeederLineInfo(int substationId) async {
    final String? token = globalToken;
    final response = await http.get(
      Uri.parse('$myAPILink/api/FeederLines/search?substationId=$substationId'),
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

  Future<List<Pole>> fetchPoleInfo(int feederId) async {
    final String? token = globalToken;
    final response = await http.get(
      Uri.parse('$myAPILink/api/PoleDetails/search?feederLineId=$feederId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map<Pole>((json) => Pole.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load feeder lines info');
    }
  }

  Future<List<PoleForMap>> fetchPoleMapInfo(int feederId) async {
    final String? token = globalToken;
    final String apiUrl =
        '$myAPILink/api/PoleDetails/searchForMap?feederLineId=$feederId';
        // print('Fetching pole map info from API: $apiUrl');
    final response = await http.get(
      Uri.parse('$myAPILink/api/PoleDetails/searchForMap?feederLineId=$feederId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  // print("STATUS: ${response.statusCode}");
  // print("BODY: ${response.body}");
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map<PoleForMap>((json) => PoleForMap.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load pole map info');
    }
  }

  // Future<List<ServicePoint>> fetchServicePoints(int poleId) async {
  //   final response = await http.get(
  //       Uri.parse('$myAPILink/api/ServicePoints/search?poleDetailId=$poleId'));

  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = jsonDecode(response.body);
  //     return data
  //         .map<ServicePoint>((json) => ServicePoint.fromJson(json))
  //         .toList();
  //   } else {
  //     throw Exception('Failed to load feeder lines info');
  //   }
  // }

  Future<List<ServicePoint>> fetchServicePoints(int poleId) async {
    final String? token = globalToken;
    final response = await http.get(
      Uri.parse('$myAPILink/api/ServicePoints/search?poleDetailId=$poleId'),
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

  Future<List<DistributionTransformer>> fetchDistributionTransformers(int? poleId) async {
    final String? token = globalToken;
    final String url = '$myAPILink/api/DistributionTransformers/searchByPole?poleId=$poleId';
    print('URL: $url');
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('Response: ${jsonDecode(response.body)}');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<DistributionTransformer>(
              (json) => DistributionTransformer.fromJson(json))
          .toList();
    } 
    else {
      throw Exception('No distribution transformers found for the selected pole');
    }
  }

  // Future<List<Consumer>> fetchConsumers({
  //   required int feederLineId,
  // }) async {
  //   final String apiUrl = '$myAPILink/api/Consumers/search';
  //   final Uri uri = Uri.parse(
  //     '$apiUrl?feederLineId=$feederLineId',
  //   );

  //   try {
  //     final response = await http.get(uri);

  //     if (response.statusCode == 200) {
  //       List<dynamic> data = jsonDecode(response.body);
  //       List<Consumer> consumers =
  //           data.map((json) => Consumer.fromJson(json)).toList();
  //       return consumers;
  //     } else {
  //       throw Exception(
  //           'Failed to load consumers! Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to load consumers: $e');
  //   }
  // }

  Future<Consumer> fetchConsumerDetail({required String consumerNo}) async {
    final String apiUrl = '$myAPILink/api/Consumers/$consumerNo';
    final Uri uri = Uri.parse(apiUrl);
    final String? token = globalToken;
    if (token == null) {
      throw Exception('Token is missing. User is not authenticated.');
    }

    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);

        if (data is Map<String, dynamic>) {
          return Consumer.fromJson(data);
        } else if (data is List<dynamic> && data.isNotEmpty) {
          return Consumer.fromJson(data[0]);
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception(
            'Failed to load consumer! Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load consumer: $e');
    }
  }

  //Consumer Lookup API
  //
  Future<List<TariffSubCategory>> fetchTariffSubCategories() async {
    final response =
        await http.get(Uri.parse('$myAPILink/api/TariffSubCategories'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<TariffSubCategory>((json) => TariffSubCategory.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load Tariff Sub-Categories');
    }
  }

  Future<void> addTariffSubCategory(TariffSubCategory tariffSubCategory) async {
    final response = await http.post(
      Uri.parse('$myAPILink/api/TariffSubCategories'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(tariffSubCategory.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add sub category');
    }
  }

  Future<void> updateTariffSubCategory(
      TariffSubCategory tariffSubCategory) async {
    final response = await http.put(
      Uri.parse(
          '$myAPILink/api/TariffSubCategories/${tariffSubCategory.subCategoryId}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(tariffSubCategory.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update sub category');
    }
  }

  Future<void> deleteTariffSubCategory(int id) async {
    final response = await http.delete(
      Uri.parse('$myAPILink/api/TariffSubCategories/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete sub category');
    }
  }

  Future<Map<String, dynamic>> fetchHillCuttingPoints() async {
    const url = 'http://10.55.255.113/fod011-pub/api/map/hill_cutting_points';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load hill cutting points!');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw Exception('Failed to load hill cutting points!');
    }
  }

  //fetchZoneDetailsInfo(int i) {}

  //Future<List<TransformerDetails>> fetchDT({required int substation, required int feederLineId}) {}

  //#endregion

  // //#region :: JSON Data Calling
  // Future<List<RoadList>> fetchRoadListJson(String search) async {
  //   final String response =
  //       await rootBundle.loadString('assets/json/road_list.json');
  //   final List<dynamic> data = json.decode(response);

  //   return data
  //       .map<RoadList>((item) {
  //         return RoadList.fromJson({
  //           'roadNo': item['roadNo'],
  //           'roadName': item['roadNo'],
  //           'roadDetail': item['roadName'],
  //         });
  //       })
  //       .where((element) =>
  //           element.roadName.toLowerCase().startsWith(search.toLowerCase()))
  //       .toList();
  // }

  // Future<List<RoadLinkList>> fetchRoadLinkListJson(String roadNo) async {
  //   final String response =
  //       await rootBundle.loadString('assets/json/road_link_list.json');
  //   final List<dynamic> data = json.decode(response);

  //   return data
  //       .map<RoadLinkList>((item) {
  //         return RoadLinkList.fromJson({
  //           'roadNo': item['roadNo'],
  //           'linkNo': item['linkNo'],
  //           'trafficStationNumber': item['trafficStationNumber'],
  //           'linkName': item['linkName'],
  //           'startChainageKm': item['startChainageKm'],
  //           'endChainageKm': item['endChainageKm'],
  //         });
  //       })
  //       .where((element) => element.roadNo == roadNo)
  //       .toList();
  // }

  // Future<RoadLinkList?> fetchSingleRoadLinkJson(String linkNo) async {
  //   final String response =
  //       await rootBundle.loadString('assets/json/road_link_list.json');
  //   final List<dynamic> data = json.decode(response);

  //   final List<RoadLinkList> roadLinkLists = data
  //       .map<RoadLinkList>((item) {
  //         return RoadLinkList.fromJson({
  //           'roadNo': item['roadNo'],
  //           'linkNo': item['linkNo'],
  //           'trafficStationNumber': item['trafficStationNumber'],
  //           'linkName': item['linkName'],
  //           'startChainageKm': item['startChainageKm'],
  //           'endChainageKm': item['endChainageKm'],
  //         });
  //       })
  //       .where((element) => element.linkNo == linkNo)
  //       .toList();

  //   if (roadLinkLists.isNotEmpty) {
  //     return roadLinkLists.first;
  //   } else {
  //     return null;
  //   }
  // }

  // Future<List<RoadLinkDirectionList>> fetchRoadLinkDirectionListJson(
  //     String linkNo) async {
  //   final String response = await rootBundle
  //       .loadString('assets/json/road_link_direction_list.json');
  //   final List<dynamic> data = json.decode(response);

  //   return data
  //       .map<RoadLinkDirectionList>((item) {
  //         return RoadLinkDirectionList.fromJson({
  //           'roadNo': item['roadNo'],
  //           'linkNo': item['linkNo'],
  //           'linkName': item['linkName'],
  //         });
  //       })
  //       .where((element) => element.linkNo == linkNo)
  //       .toList();
  // }
  // //#endregion

  // // #region Survey Schedule API
  // Future<String> postSurveySchedule(SurveyScheduleConfig schedule) async {
  //   final url = Uri.parse('$myAPILink/api/Traffic/SurveySchedule');

  //   final response = await http.post(
  //     url,
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(schedule.toJson()),
  //   );

  //   if (response.statusCode == 200) {
  //     return response.body;
  //   } else {
  //     throw Exception('Failed to submit data: ${response.reasonPhrase}');
  //   }
  // }

  // Future<List<SurveyScheduleView>> fetchSurveySchedules(String id) async {
  //   String apiUrl = '';
  //   bool isUserTeamLeader = id.contains('team');

  //   if (isUserTeamLeader) {
  //     apiUrl = '$myAPILink/api/Traffic/GetSurveyScheduleList?userid=$id';
  //   } else {
  //     apiUrl = '$myAPILink/api/Traffic/GetSurveyScheduleList';
  //   }

  //   final response = await http.get(Uri.parse(apiUrl));

  //   if (response.statusCode == 200) {
  //     List<dynamic> data = json.decode(response.body);
  //     //print(data.toString());
  //     return data.map((item) => SurveyScheduleView.fromJson(item)).toList();
  //   } else {
  //     throw Exception('Failed to load survey schedules');
  //   }
  // }

  // // Future<List<SurveyScheduleView>> fetchSurveySchedulesByID(int id) async {
  // //   String apiUrl = '$myAPILink/api/Traffic/GetSingleSurveySchedule?id=$id}';
  // //   final response = await http.get(Uri.parse(apiUrl));

  // //   if (response.statusCode == 200) {
  // //     List<dynamic> data = json.decode(response.body);
  // //     return data.map((item) => SurveyScheduleView.fromJson(item)).toList();
  // //   } else {
  // //     throw Exception('Failed to load survey schedules');
  // //   }
  // // }

  // Future<SurveyScheduleView> fetchSurveySchedulesByID(int id) async {
  //   String apiUrl = '$myAPILink/api/Traffic/GetSingleSurveySchedule?id=$id';
  //   final response = await http.get(Uri.parse(apiUrl));

  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> data = json.decode(response.body);
  //     return SurveyScheduleView.fromJson(data);
  //   } else {
  //     throw Exception('Failed to load survey schedule');
  //   }
  // }

  // // #endregion
}

import 'dart:convert';
import '../constants/constant.dart';
import '../models/Login/login.dart';
import '../models/map_models/newfeederline.dart';
import '../models/regions/zone.dart';
import '../models/regions/circle.dart';
import '../models/regions/snd_info.dart';
import '../models/regions/esu_info.dart';
import '../models/regions/substation.dart';
import '../models/regions/feeder_line.dart';
import '../models/regions/Pole.dart';

import 'package:http/http.dart' as http;

import '../models/region_delails_lookup/esu.dart';
import '../models/region_delails_lookup/substation.dart';

class MapApi {
  static Future<List<Zone>> fetchZoneInfo() async {
    User? user = globalUser;
    int? userZoneId = user?.ZoneId;

    // Determine the API URL
    String apiUrl = userZoneId != null
        ? '$myAPILink/api/ZoneInfoes/$userZoneId'
        : '$myAPILink/api/ZoneInfoes';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Zone.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load zones');
    }
  }

  static Future<List<Circles>> fetchCircleInfo(String zoneId) async {
    final response = await http
        .get(Uri.parse('$myAPILink/api/CircleInfoes/search?zoneId=$zoneId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Circles.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load circles');
    }
  }

  static Future<List<SndInfo>> fetchSnDInfo(String circleId) async {
    final response = await http
        .get(Uri.parse('$myAPILink/api/SndInfoes/search?circleId=$circleId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => SndInfo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load SND info');
    }
  }

  static Future<List<EsuInfo>> fetchEsuInfo(String sndId) async {
    final response = await http
        .get(Uri.parse('$myAPILink/api/EsuInfoes/search?sndId=$sndId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => EsuInfo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load ESU info');
    }
  }

  static Future<List<Substation>> fetchSubstationInfo(String sndId) async {
    final response = await http
        .get(Uri.parse('$myAPILink/api/Substations/search?sndId=$sndId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Substation.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load substations');
    }
  }

  //------------ERA------------
  static Future<List<FeederLine>> fetchFeederLineInfo(
      String substationId) async {
    final String? token = globalToken;
    // final response = await http.get(Uri.parse('$myAPILink/api/FeederLines/search?substationId=$substationId'));
    final response = await http.get(
      Uri.parse('$myAPILink/api/FeederLines/search?substationId=$substationId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => FeederLine.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load feeder lines info');
    }
  }

  static Future<List<Pole>> fetchPoleInfo(String feederId) async {
    final String? token = globalToken;
    //final response = await http.get(Uri.parse('$myAPILink/api/PoleDetails/search?feederLineId=$feederId'));
    final response = await http.get(
      Uri.parse('$myAPILink/api/PoleDetails/search?feederLineId=$feederId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Pole.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Poles info');
    }
  }

  static Future<MapFeederLine> fetchFeederLineDetailsInfo(int feederId) async {
    final String? token = globalToken;

    final response = await http.get(
      Uri.parse('$myAPILink/api/FeederLines/$feederId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        return MapFeederLine.fromJson(data.first);
      } else {
        throw Exception('No feeder line data found.');
      }
    } else {
      throw Exception('Failed to load feeder lines info');
    }
  }

  static Future<Pole> fetchPoleDetailsInfo(int poleId) async {
    final String? token = globalToken;

    final response = await http.get(
      Uri.parse('$myAPILink/api/PoleDetails/$poleId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        return Pole.fromJson(data.first);
      } else {
        throw Exception('No feeder line data found.');
      }
    } else {
      throw Exception('Failed to load feeder lines info');
    }
  }

//------------ERA-----------------
  static Future<void> fetchZoneDetailsInfo(int zoneId) async {
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

  static Future<void> fetchCircleDetailsInfo(int circleId) async {
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

  static Future<void> fetchSndDetailsInfo(int sndId) async {
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

  static Future<void> fetchEsuDetailsInfo(int esuId) async {
    final response =
        await http.get(Uri.parse('$myAPILink/api/EsuInfoes/$esuId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      final esu = Esu.fromJson(data);
      GlobalVariables.centerLatitude = esu.centerLatitude;
      GlobalVariables.centerLongitude = esu.centerLongitude;
      GlobalVariables.defaultZoomLevel = esu.defaultZoomLevel?.toDouble();
    } else {
      throw Exception('Failed to load Esu Details info');
    }
  }

  static Future<void> fetchSubstationDetailsInfo(int substationId) async {
    final response =
        await http.get(Uri.parse('$myAPILink/api/Substations/$substationId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      final circle = Substations.fromJson(data);
      GlobalVariables.centerLatitude = circle.latitude;
      GlobalVariables.centerLongitude = circle.longitude;
      GlobalVariables.defaultZoomLevel = circle.defaultZoomLevel?.toDouble();
    } else {
      throw Exception('Failed to load Substation Details info');
    }
  }

  static Future<List<String>> fetchConsumerList(int feederLineId) async {
    print('Fetching consumer list for feeder line ID: $feederLineId');
    final String? token = globalToken;
    print("Token: $token");
    if (token == null) {
      throw Exception('Token is missing. User is not authenticated.');
    }
    final response = await http.get(
      Uri.parse(
          '$myAPILink/api/Consumers/searchByfeederLineId?id=$feederLineId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data.containsKey('data') && data['data'] is List) {
        List<dynamic> consumers = data['data'];
        List<String> consumerNos =
            consumers.map((item) => item['consumer_no'].toString()).toList();

        return consumerNos;
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to fetch consumers');
    }
  }

  Future<Map<String, dynamic>> fetchZoneById(Object id) async {
    final response = await http.get(Uri.parse('$myAPILink/api/ZoneInfoes/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data is List ? data.first : data;
    } else {
      throw Exception('Failed to fetch zone info');
    }
  }

  Future<Map<String, dynamic>> fetchCircleById(Object id) async {
    final response =
        await http.get(Uri.parse('$myAPILink/api/CircleInfoes/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data is List ? data.first : data;
    } else {
      throw Exception('Failed to fetch circle info');
    }
  }

  Future<Map<String, dynamic>> fetchSndById(Object id) async {
    final response = await http.get(Uri.parse('$myAPILink/api/SndInfoes/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data is List ? data.first : data;
    } else {
      throw Exception('Failed to fetch snd info');
    }
  }

  Future<Map<String, dynamic>> fetchEsuById(Object id) async {
    final response = await http.get(Uri.parse('$myAPILink/api/EsuInfoes/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data is List ? data.first : data;
    } else {
      throw Exception('Failed to fetch esu info');
    }
  }

  Future<Map<String, dynamic>> fetchSubstationById(Object id) async {
    final response =
        await http.get(Uri.parse('$myAPILink/api/Substations/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data is List ? data.first : data;
    } else {
      throw Exception('Failed to fetch substation info');
    }
  }

  Future<Map<String, dynamic>> fetchFeederlineById(Object id) async {
    final String? token = globalToken;
    if (token == null) {
      throw Exception('Token is missing. User is not authenticated.');
    }
    final response = await http.get(
      Uri.parse('$myAPILink/api/FeederLines/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is List) {
        if (data.isEmpty) {
          throw Exception('FeederLine with ID $id not found (empty list).');
        }
        return data.first;
      } else if (data is Map<String, dynamic>) {
        return data;
      } else {
        throw Exception('Unexpected data format: ${data.runtimeType}');
      }
    } else {
      throw Exception(
          'Failed to fetch feederline info. Status: ${response.statusCode}');
    }
  }

  // Future<Map<String, dynamic>> fetchPoleDetailsById(Object id) async {
  //   final String? token = globalToken;
  //   if (token == null) {
  //     throw Exception('Token is missing. User is not authenticated.');
  //   }
  //   final response = await http.get(Uri.parse('$myAPILink/api/PoleDetails/$id'),
  //     headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //   );

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);

  //     if (data is List) {
  //       if (data.isEmpty) {
  //         throw Exception('FeederLine with ID $id not found (empty list).');
  //       }
  //       return data.first;
  //     } else if (data is Map<String, dynamic>) {
  //       return data;
  //     } else {
  //       throw Exception('Unexpected data format: ${data.runtimeType}');
  //     }
  //   } else {
  //     throw Exception('Failed to fetch feederline info. Status: ${response.statusCode}');
  //   }
  // }
  Future<Map<String, dynamic>> fetchPoleDetailsById(Object id) async {
    final String? token = globalToken;
    if (token == null) {
      throw Exception('Token is missing. User is not authenticated.');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    // Call both APIs in parallel
    final poleDetailsFuture = http.get(
      Uri.parse('$myAPILink/api/PoleDetails/$id'),
      headers: headers,
    );
    final polesFuture = http.get(
      Uri.parse('$myAPILink/api/Poles/$id'),
      headers: headers,
    );

    final responses = await Future.wait([poleDetailsFuture, polesFuture]);

    // Handle PoleDetails
    if (responses[0].statusCode != 200) {
      throw Exception(
          'Failed to fetch PoleDetails. Status: ${responses[0].statusCode}');
    }
    final data1 = jsonDecode(responses[0].body);
    final poleDetails = (data1 is List && data1.isNotEmpty)
        ? data1.first
        : (data1 is Map<String, dynamic> ? data1 : {});

    // Handle Poles
    if (responses[1].statusCode != 200) {
      throw Exception(
          'Failed to fetch Poles. Status: ${responses[1].statusCode}');
    }
    final data2 = jsonDecode(responses[1].body);
    final poles = (data2 is List && data2.isNotEmpty)
        ? data2.first
        : (data2 is Map<String, dynamic> ? data2 : {});

    // Return combined result
    return {
      'poleDetails': poleDetails,
      'poles': poles,
    };
  }

  Future<Map<String, dynamic>> fetchDtById(Object id) async {
    print('Fetching DT with ID: $id');
    final String? token = globalToken;
    if (token == null) {
      throw Exception('Token is missing. User is not authenticated.');
    }
    final response = await http.get(
      Uri.parse('$myAPILink/api/DistributionTransformers/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is List) {
        if (data.isEmpty) {
          throw Exception('FeederLine with ID $id not found (empty list).');
        }
        return data.first;
      } else if (data is Map<String, dynamic>) {
        return data;
      } else {
        throw Exception('Unexpected data format: ${data.runtimeType}');
      }
    } else {
      throw Exception(
          'Failed to fetch feederline info. Status: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> fetchConsumerById(Object id) async {
    final String? token = globalToken;
    if (token == null) {
      throw Exception('Token is missing. User is not authenticated.');
    }
    final response = await http.get(
      Uri.parse('$myAPILink/api/Consumers/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is List) {
        if (data.isEmpty) {
          throw Exception('FeederLine with ID $id not found (empty list).');
        }
        return data.first;
      } else if (data is Map<String, dynamic>) {
        return data;
      } else {
        throw Exception('Unexpected data format: ${data.runtimeType}');
      }
    } else {
      throw Exception(
          'Failed to fetch feederline info. Status: ${response.statusCode}');
    }
  }

  // Future<List<String>> fetchConsumersInRange(String lat, String lon, String radius) async {
  //   final String? token = globalToken;
  //   if (token == null) {
  //     throw Exception('Token is missing. User is not authenticated.');
  //   }
  //   try {
  //     final uri = Uri.parse("$myAPILink/api/Consumers/buffersearch?lat=$lat&lon=$lon&radius=$radius");
  //     final response = await http.get(uri,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);

  //       // API returns a list of consumers, extract consumerNo
  //       if (data is List) {
  //         return data
  //             .map((item) => item['consumerNo']?.toString())
  //             .where((no) => no != null && no.isNotEmpty)
  //             .cast<String>()
  //             .toList();
  //       } else {
  //         return [];
  //       }
  //     } else {
  //       throw Exception('Failed to load consumers: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print("Error fetching consumers: $e");
  //     return [];
  //   }
  // }

  Future<List<String>> fetchConsumersInRange(
      String lat, String lon, String radius) async {
    final String? token = globalToken;
    if (token == null) {
      throw Exception('Token is missing. User is not authenticated.');
    }
    try {
      final uri = Uri.parse(
          "$myAPILink/api/Consumers/buffersearch?lat=$lat&lon=$lon&radius=$radius");
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      // print("🔗 Fetching: $uri");
      // print("📥 Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List) {
          return data
              .map((item) => item['consumerNo']?.toString())
              .where((no) => no != null && no.isNotEmpty)
              .cast<String>()
              .toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to load consumers: ${response.statusCode}');
      }
    } catch (e) {
      print("❌ Error fetching consumers: $e");
      return [];
    }
  }

  static Future<Map<String, dynamic>> fetchPostpaidBillingInfo(
      String consumerNo, String locationCode) async {
    final response = await http.get(Uri.parse(
        'http://119.40.95.184:2024/api/GIS/get-customer-arrear?customerNo=$consumerNo&locationCode=$locationCode'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      if (data.isNotEmpty) {
        return data.first; 
      } else {
        throw Exception('No consumer data found');
      }
    } else {
      throw Exception('Failed to load Postpaid Billing Info');
    }
  }


  static Future<List<Map<String, dynamic>>> fetchPrepaidBillingInfo(
    String consumerNo, String meterNo) async {
    final String? token = globalToken;
    if (token == null) {
      throw Exception('Token is missing. User is not authenticated.');
    }

    final url =
        '$myAPILink/api/Consumers/GetConsumerOrders?consumerNo=$consumerNo&meterNo=$meterNo';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final body = response.body.trim();

      if (body.isEmpty || body == "[]" || body == "null") {
        throw Exception('No consumer data found');
      }

      dynamic decoded;
      try {
        decoded = jsonDecode(body);
      } catch (e) {
        throw Exception('Invalid JSON format: $e');
      }

      if (decoded is List && decoded.isNotEmpty) {
        return decoded.cast<Map<String, dynamic>>();
      } else {
        throw Exception('No consumer data found');
      }
    } else {
      throw Exception(
          'Failed to load Prepaid Billing Info (Status ${response.statusCode})');
    }
  }
}

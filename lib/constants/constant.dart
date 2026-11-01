// ignore_for_file: file_names

// String audioPath = 'sounds/tap.mp3';
// String removeAudioPath = 'sounds/remove.mp3';
import '../models/Login/login.dart';

//String myAPILink = "http://10.55.55.141/bpdb-app"; //http://10.55.5.19/bpdb-app
//String myAPILink = "https://ims.cegisbd.com/bpdb_training"; //online - (For training)
//String myAPILink = "http://10.55.55.141/bpdb-app";
//String myAPILink = "https://web.bpdbgis.gov.bd";
//String myAPILink = "https://ims.cegisbd.com/rhd005"; //live
String timeAPILink = "https://worldtimeapi.org/api/timezone/Asia/Dhaka";
String onlineTime = "00:00:00";
String poleImgPath =
    "https://ims.cegisbd.com/bpdb/ComponentPicture/Pole/pole_main";
// int taskSchedulerMinutes = 5;
// int maxCollectionHour = 48;
// int maxTimeToEditScheduleInHour = 1;

// String userId = 'app_user';

// int userLevelId = 0;

String LoginTime = '';
User? globalUser;
String? globalToken;
bool isMapReset = false;

class GlobalVariables {
  static double? centerLatitude;
  static double? centerLongitude;
  static double? defaultZoomLevel;
}

class defaultViewPoint {
  static final double latitude = 23.6850;
  static final double longitude = 90.3563;
  static final double scale = 5000000;
}

class consemerRange {
  static double? lat;
  static double? long;
  static double? range;
}

double zoomToScale(int zoomLevel) {
  const double initialScale = 591657527.591555;
  return initialScale / (1 << zoomLevel); // 1 << zoomLevel = 2^zoomLevel
}

class AppConfig {
  static String? apiUrl;
}

// ---- For Firebase Remote Config ---- //
String? myAPILink = AppConfig.apiUrl;
// ---- For Firebase Remote Config ---- //
class AppConfig {
  final String keyName;
  final String keyValue;

  AppConfig({required this.keyName, required this.keyValue});

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      keyName: json['keyName'] as String,
      keyValue: json['keyValue'] as String,
    );
  }
}

class TimeData {
  final String abbreviation;
  final String clientIp;
  final String datetime;
  final int dayOfWeek;
  final int dayOfYear;
  final bool dst;
  final int dstOffset;
  final int rawOffset;
  final String timezone;
  final int unixtime;
  final String utcDatetime;
  final String utcOffset;
  final int weekNumber;

  TimeData({
    required this.abbreviation,
    required this.clientIp,
    required this.datetime,
    required this.dayOfWeek,
    required this.dayOfYear,
    required this.dst,
    required this.dstOffset,
    required this.rawOffset,
    required this.timezone,
    required this.unixtime,
    required this.utcDatetime,
    required this.utcOffset,
    required this.weekNumber,
  });

  factory TimeData.fromJson(Map<String, dynamic> json) {
    return TimeData(
      abbreviation: json['abbreviation'] as String,
      clientIp: json['client_ip'] as String,
      datetime: json['datetime'] as String,
      dayOfWeek: json['day_of_week'] as int,
      dayOfYear: json['day_of_year'] as int,
      dst: json['dst'] as bool,
      dstOffset: json['dst_offset'] as int,
      rawOffset: json['raw_offset'] as int,
      timezone: json['timezone'] as String,
      unixtime: json['unixtime'] as int,
      utcDatetime: json['utc_datetime'] as String,
      utcOffset: json['utc_offset'] as String,
      weekNumber: json['week_number'] as int,
    );
  }
}

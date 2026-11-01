class ZoneReport {
  final String name;
  final List<TypeCount> typeCount;

  ZoneReport({required this.name, required this.typeCount});

  // Factory constructor to create an instance from JSON
  factory ZoneReport.fromJson(Map<String, dynamic> json) {
    var list = json['typeCount'] as List;
    List<TypeCount> typeCountList = list.map((i) => TypeCount.fromJson(i)).toList();

    return ZoneReport(
      name: json['name'],
      typeCount: typeCountList,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'typeCount': typeCount.map((e) => e.toJson()).toList(),
    };
  }
}

class TypeCount {
  final String type;
  final int count;

  TypeCount({required this.type, required this.count});

  // Factory constructor to create an instance from JSON
  factory TypeCount.fromJson(Map<String, dynamic> json) {
    return TypeCount(
      type: json['type'],
      count: json['count'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'count': count,
    };
  }
}

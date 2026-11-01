class TariffCategory {
  final int categoryId;
  final String categoryName;

  TariffCategory({
    required this.categoryId,
    required this.categoryName,
  });

  factory TariffCategory.fromJson(Map<String, dynamic> json) {
    return TariffCategory(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
    );
  }
  // Method to convert an instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
    };
  }
}
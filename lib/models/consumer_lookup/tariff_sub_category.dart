class TariffSubCategory {
  final int subCategoryId;
  final int categoryId;
  final String subCategoryName;
  

  TariffSubCategory({
    required this.subCategoryId,
    required this.categoryId,
    required this.subCategoryName,

  });

  factory TariffSubCategory.fromJson(Map<String, dynamic> json) {
    return TariffSubCategory(
      subCategoryId: json['subCategoryId'],
      categoryId: json['categoryId'],
      subCategoryName: json['subCategoryName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subCategoryId': subCategoryId,
      'categoryId': categoryId,
      'subCategoryName': subCategoryName,
    };
  }
}

class TariffCategoryS {
  final int categoryId;
  final String categoryName;

  TariffCategoryS({
    required this.categoryId,
    required this.categoryName,
  });

  factory TariffCategoryS.fromJson(Map<String, dynamic> json) {
    return TariffCategoryS(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
    };
  }
}

class SubCategory {
  final int subCategoryId;
  final int categoryId;
  final TariffCategoryS tariffCategory;
  final String subCategoryName;

  SubCategory({
    required this.subCategoryId,
    required this.categoryId,
    required this.tariffCategory,
    required this.subCategoryName,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      subCategoryId: json['subCategoryId'],
      categoryId: json['categoryId'],
      tariffCategory: TariffCategoryS.fromJson(json['tariffCategory']),
      subCategoryName: json['subCategoryName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subCategoryId': subCategoryId,
      'categoryId': categoryId,
      'tariffCategory': tariffCategory.toJson(),
      'subCategoryName': subCategoryName,
    };
  }
}


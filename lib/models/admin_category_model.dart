class AdminCategoryModel {
  final int id;
  final String name;

  AdminCategoryModel({
    required this.id,
    required this.name,
  });

  factory AdminCategoryModel.fromJson(Map<String, dynamic> json) {
    return AdminCategoryModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
    };
  }
}
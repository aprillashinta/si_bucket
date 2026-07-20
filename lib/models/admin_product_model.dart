class AdminProductModel {
  final int? id;
  final int categoryId;
  final String? categoryName;
  final String name;
  final String description;
  final int price;
  final int stock;
  final String image;

  AdminProductModel({
    this.id,
    required this.categoryId,
    this.categoryName,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.image,
  });

  factory AdminProductModel.fromJson(Map<String, dynamic> json) {
    return AdminProductModel(
      id: json["id"],
      categoryId: json["category_id"] ?? 0,
      categoryName: json["category"]?["name"],
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      price: json["price"] ?? 0,
      stock: json["stock"] ?? 0,
      image: json["image"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "category_id": categoryId,
      "name": name,
      "description": description,
      "price": price,
      "stock": stock,
      "image": image,
    };
  }
}
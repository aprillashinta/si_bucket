class ProductModel {
  final int id;
  final int categoryId;
  final String name;
  final String description;
  final int price;
  final int stock;
  final String image;

  ProductModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"],
      categoryId: json["category_id"],
      name: json["name"],
      description: json["description"] ?? "",
      price: json["price"],
      stock: json["stock"],
      image: json["image"] ?? "",
    );
  }
}
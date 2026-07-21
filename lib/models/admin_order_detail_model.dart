class AdminOrderDetailModel {
  final int id;
  final int productId;
  final int quantity;
  final int price;
  final int subtotal;

  final String productName;
  final String productImage;

  AdminOrderDetailModel({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.subtotal,
    required this.productName,
    required this.productImage,
  });

  factory AdminOrderDetailModel.fromJson(
      Map<String, dynamic> json) {
    return AdminOrderDetailModel(
      id: json["id"] ?? 0,
      productId: json["product_id"] ?? 0,
      quantity: json["quantity"] ?? 0,
      price: json["price"] ?? 0,
      subtotal: json["subtotal"] ?? 0,
      productName:
          json["product"]?["name"] ?? "-",
      productImage:
          json["product"]?["image"] ?? "",
    );
  }
}
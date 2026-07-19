class OrderItemModel {
  final int id;
  final int orderId;
  final int productId;
  final int quantity;
  final int price;
  final int subtotal;
  final String productName;
  final String productImage;

  OrderItemModel({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.subtotal,
    required this.productName,
    required this.productImage,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json["id"],
      orderId: json["order_id"],
      productId: json["product_id"],
      quantity: json["quantity"],
      price: json["price"],
      subtotal: json["subtotal"],
      productName: json["product"]?["name"] ?? "",
      productImage: json["product"]?["image"] ?? "",
    );
  }
}
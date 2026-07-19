import 'order_item_model.dart';

class OrderModel {
  final int id;
  final int userId;
  final String recipientName;
  final String phone;
  final String shippingAddress;
  final String paymentMethod;
  final String notes;
  final int totalPrice;
  final String status;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.userId,
    required this.recipientName,
    required this.phone,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.notes,
    required this.totalPrice,
    required this.status,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json["id"],
      userId: json["user_id"],
      recipientName: json["recipient_name"] ?? "",
      phone: json["phone"] ?? "",
      shippingAddress: json["shipping_address"] ?? "",
      paymentMethod: json["payment_method"] ?? "",
      notes: json["notes"] ?? "",
      totalPrice: json["total_price"],
      status: json["status"],
      items: json["items"] == null
          ? []
          : (json["items"] as List)
              .map((e) => OrderItemModel.fromJson(e))
              .toList(),
    );
  }
}
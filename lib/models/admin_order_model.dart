class AdminOrderModel {
  final int id;
  final int userId;

  final String recipientName;
  final String phone;
  final String shippingAddress;
  final String notes;
  final String paymentMethod;

  final int totalPrice;
  final String status;
  final String createdAt;

  final String customerName;
  final String customerEmail;
  final String customerPhone;

  AdminOrderModel({
    required this.id,
    required this.userId,
    required this.recipientName,
    required this.phone,
    required this.shippingAddress,
    required this.notes,
    required this.paymentMethod,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
  });

  factory AdminOrderModel.fromJson(Map<String, dynamic> json) {
    return AdminOrderModel(
      id: json["id"] ?? 0,
      userId: json["user_id"] ?? 0,
      recipientName: json["recipient_name"] ?? "",
      phone: json["phone"] ?? "",
      shippingAddress: json["shipping_address"] ?? "",
      notes: json["notes"] ?? "",
      paymentMethod: json["payment_method"] ?? "",
      totalPrice: json["total_price"] ?? 0,
      status: json["status"] ?? "",
      createdAt: json["createdAt"] ?? "",
      customerName: json["user"]?["name"] ?? "-",
      customerEmail: json["user"]?["email"] ?? "-",
      customerPhone: json["user"]?["phone"] ?? "-",
    );
  }
}
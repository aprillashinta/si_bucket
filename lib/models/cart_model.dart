import 'product_model.dart';

class CartModel {
  final int id;
  final int userId;
  final int productId;
  final int quantity;
  final ProductModel product;

  CartModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.product,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json["id"],
      userId: json["user_id"],
      productId: json["product_id"],
      quantity: json["quantity"],
      product: ProductModel.fromJson(json["product"]),
    );
  }
}
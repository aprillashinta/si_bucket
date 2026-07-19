import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_service.dart';
import 'auth_service.dart';
import '../models/cart_model.dart';

class CartService {
  Future<List<CartModel>> getCart() async {
    final token = await AuthService().getToken();

    final response = await http.get(
      Uri.parse(ApiService.cart),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      final List data = body["data"];

      return data.map((e) => CartModel.fromJson(e)).toList();
    } else {
      throw Exception("Gagal mengambil data keranjang");
    }
  }

  Future<void> addToCart({
    required int productId,
    required int quantity,
  }) async {
    final token = await AuthService().getToken();

    final response = await http.post(
      Uri.parse(ApiService.cart),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "product_id": productId,
        "quantity": quantity,
      }),
    );

    if (response.statusCode != 200 &&
        response.statusCode != 201) {
      final body = jsonDecode(response.body);
      throw Exception(body["message"]);
    }
  }

  Future<void> updateCart({
    required int cartId,
    required int quantity,
  }) async {
    final token = await AuthService().getToken();

    final response = await http.put(
      Uri.parse("${ApiService.cart}/$cartId"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "quantity": quantity,
      }),
    );

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(body["message"]);
    }
  }

  Future<void> deleteCart(int cartId) async {
    final token = await AuthService().getToken();

    final response = await http.delete(
      Uri.parse("${ApiService.cart}/$cartId"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(body["message"]);
    }
  }
}
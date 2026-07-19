import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/order_model.dart';
import 'api_service.dart';
import 'auth_service.dart';

class OrderService {
  Future<void> checkout({
    required String recipientName,
    required String phone,
    required String shippingAddress,
    required String paymentMethod,
    String notes = "",
  }) async {
    final token = await AuthService().getToken();

    print("TOKEN = $token");
    print("URL = ${ApiService.order}/checkout");
    final response = await http.post(
      Uri.parse("${ApiService.order}/checkout"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "recipient_name": recipientName,
        "phone": phone,
        "shipping_address": shippingAddress,
        "payment_method": paymentMethod,
        "notes": notes,
      }),
    );
    print("STATUS = ${response.statusCode}");
    print("BODY = ${response.body}");

    print("========== CHECKOUT ==========");
    print("URL    : ${ApiService.order}/checkout");
    print("STATUS : ${response.statusCode}");
    print("BODY   : ${response.body}");
    print("==============================");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    }

    try {
      final body = jsonDecode(response.body);
      throw Exception(body["message"]);
    } catch (_) {
      throw Exception(
        "Server mengembalikan response yang bukan JSON.\n\nStatus: ${response.statusCode}\n\n${response.body}",
      );
    }
  }

  Future<List<OrderModel>> getOrders() async {
    final token = await AuthService().getToken();

    final response = await http.get(
      Uri.parse(ApiService.order),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      final List data = body["data"];

      return data.map((e) => OrderModel.fromJson(e)).toList();
    }

    throw Exception("Gagal mengambil data order");
  }

  Future<OrderModel> getOrderDetail(int id) async {
    final token = await AuthService().getToken();

    final response = await http.get(
      Uri.parse("${ApiService.order}/$id"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      return OrderModel.fromJson(body["data"]);
    }

    throw Exception("Gagal mengambil detail order");
  }

  Future<void> cancelOrder(int id) async {
    final token = await AuthService().getToken();

    final response = await http.put(
      Uri.parse("${ApiService.order}/$id/cancel"),
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

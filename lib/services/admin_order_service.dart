import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/admin_order_model.dart';
import 'api_service.dart';

class AdminOrderService {
  Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${prefs.getString("token")}",
    };
  }

  Future<List<AdminOrderModel>> getOrders() async {
    final response = await http.get(
      Uri.parse("${ApiService.baseUrl}/admin/orders"),
      headers: await _headers(),
    );

    final json = jsonDecode(response.body);

    if (json["success"] == true) {
      return (json["data"] as List)
          .map((e) => AdminOrderModel.fromJson(e))
          .toList();
    }

    return [];
  }

  Future<AdminOrderModel?> getOrderById(int id) async {
    final response = await http.get(
      Uri.parse("${ApiService.baseUrl}/admin/orders/$id"),
      headers: await _headers(),
    );

    final json = jsonDecode(response.body);

    if (json["success"] == true) {
      return AdminOrderModel.fromJson(json["data"]);
    }

    return null;
  }

  Future<bool> updateStatus(
    int id,
    String status,
  ) async {
    final response = await http.put(
      Uri.parse("${ApiService.baseUrl}/admin/orders/$id/status"),
      headers: await _headers(),
      body: jsonEncode({
        "status": status,
      }),
    );

    final json = jsonDecode(response.body);

    return json["success"] == true;
  }
}
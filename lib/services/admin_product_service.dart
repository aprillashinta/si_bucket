import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/admin_product_model.dart';
import 'api_service.dart';

class AdminProductService {
  Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${prefs.getString("token")}",
    };
  }

  Future<List<AdminProductModel>> getProducts() async {
    final response = await http.get(
      Uri.parse("${ApiService.baseUrl}/admin/products"),
      headers: await _headers(),
    );

    final json = jsonDecode(response.body);

    if (json["success"] == true) {
      return (json["data"] as List)
          .map((e) => AdminProductModel.fromJson(e))
          .toList();
    }

    return [];
  }

  Future<AdminProductModel?> getProductById(int id) async {
    final response = await http.get(
      Uri.parse("${ApiService.baseUrl}/admin/products/$id"),
      headers: await _headers(),
    );

    final json = jsonDecode(response.body);

    if (json["success"] == true) {
      return AdminProductModel.fromJson(json["data"]);
    }

    return null;
  }

  Future<bool> createProduct(AdminProductModel product) async {
    final response = await http.post(
      Uri.parse("${ApiService.baseUrl}/admin/products"),
      headers: await _headers(),
      body: jsonEncode(product.toJson()),
    );

    final json = jsonDecode(response.body);

    return json["success"] == true;
  }

  Future<bool> updateProduct(
    int id,
    AdminProductModel product,
  ) async {
    final response = await http.put(
      Uri.parse("${ApiService.baseUrl}/admin/products/$id"),
      headers: await _headers(),
      body: jsonEncode(product.toJson()),
    );

    final json = jsonDecode(response.body);

    return json["success"] == true;
  }

  Future<bool> deleteProduct(int id) async {
    final response = await http.delete(
      Uri.parse("${ApiService.baseUrl}/admin/products/$id"),
      headers: await _headers(),
    );

    final json = jsonDecode(response.body);

    return json["success"] == true;
  }
}
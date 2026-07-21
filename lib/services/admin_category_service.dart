import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/admin_category_model.dart';
import 'api_service.dart';

class AdminCategoryService {
  Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${prefs.getString("token")}",
    };
  }

  Future<List<AdminCategoryModel>> getCategories() async {
    final response = await http.get(
      Uri.parse("${ApiService.baseUrl}/admin/categories"),
      headers: await _headers(),
    );

    final json = jsonDecode(response.body);

    if (json["success"] == true) {
      return (json["data"] as List)
          .map((e) => AdminCategoryModel.fromJson(e))
          .toList();
    }

    return [];
  }

  Future<AdminCategoryModel?> getCategoryById(int id) async {
    final response = await http.get(
      Uri.parse("${ApiService.baseUrl}/admin/categories/$id"),
      headers: await _headers(),
    );

    final json = jsonDecode(response.body);

    if (json["success"] == true) {
      return AdminCategoryModel.fromJson(json["data"]);
    }

    return null;
  }

  Future<bool> createCategory(AdminCategoryModel category) async {
    final response = await http.post(
      Uri.parse("${ApiService.baseUrl}/admin/categories"),
      headers: await _headers(),
      body: jsonEncode(category.toJson()),
    );

    final json = jsonDecode(response.body);

    return json["success"] == true;
  }

  Future<bool> updateCategory(
    int id,
    AdminCategoryModel category,
  ) async {
    final response = await http.put(
      Uri.parse("${ApiService.baseUrl}/admin/categories/$id"),
      headers: await _headers(),
      body: jsonEncode(category.toJson()),
    );

    final json = jsonDecode(response.body);

    return json["success"] == true;
  }

  Future<bool> deleteCategory(int id) async {
    final response = await http.delete(
      Uri.parse("${ApiService.baseUrl}/admin/categories/$id"),
      headers: await _headers(),
    );

    final json = jsonDecode(response.body);

    return json["success"] == true;
  }
}
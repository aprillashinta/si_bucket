import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/admin_user_model.dart';
import 'api_service.dart';

class AdminUserService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  Future<List<AdminUserModel>> getUsers() async {
    try {
      final token = await _getToken();

      final response = await http.get(
        Uri.parse("${ApiService.baseUrl}/admin/users"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        return (json["data"] as List)
            .map((e) => AdminUserModel.fromJson(e))
            .toList();
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  Future<AdminUserModel?> getUserById(int id) async {
    try {
      final token = await _getToken();

      final response = await http.get(
        Uri.parse("${ApiService.baseUrl}/admin/users/$id"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        return AdminUserModel.fromJson(json["data"]);
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateUser(AdminUserModel user) async {
    try {
      final token = await _getToken();

      final response = await http.put(
        Uri.parse("${ApiService.baseUrl}/admin/users/${user.id}"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(user.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteUser(int id) async {
    try {
      final token = await _getToken();

      final response = await http.delete(
        Uri.parse("${ApiService.baseUrl}/admin/users/$id"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
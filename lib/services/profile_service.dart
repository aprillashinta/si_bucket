import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/profile_model.dart';
import 'api_service.dart';
import 'auth_service.dart';

class ProfileService {
  Future<ProfileModel> getProfile() async {
    final token = await AuthService().getToken();

    final response = await http.get(
      Uri.parse(ApiService.profile),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      return ProfileModel.fromJson(body["data"]);
    }

    throw Exception("Gagal mengambil data profile");
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    required String address,
  }) async {
    final token = await AuthService().getToken();

    final response = await http.put(
      Uri.parse(ApiService.profile),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "name": name,
        "phone": phone,
        "address": address,
      }),
    );

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);

      throw Exception(body["message"]);
    }
  }

  Future<void> logout() async {
    await AuthService().logout();
  }
}
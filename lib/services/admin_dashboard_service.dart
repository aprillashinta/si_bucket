import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/admin_dashboard_model.dart';
import 'api_service.dart';

class AdminDashboardService {
  Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${prefs.getString("token")}",
    };
  }

  Future<AdminDashboardModel?> getDashboard() async {
    final response = await http.get(
      Uri.parse("${ApiService.baseUrl}/admin/dashboard"),
      headers: await _headers(),
    );

    final json = jsonDecode(response.body);

    if (json["success"] == true) {
      return AdminDashboardModel.fromJson(json["data"]);
    }

    return null;
  }
}
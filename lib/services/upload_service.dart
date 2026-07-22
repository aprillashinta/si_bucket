import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';

class UploadService {
  Future<String?> uploadImage(File imageFile) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");

    final request = http.MultipartRequest(
      "POST",
      Uri.parse("${ApiService.baseUrl}/upload"),
    );

    request.headers["Authorization"] = "Bearer $token";

    request.files.add(
      await http.MultipartFile.fromPath(
        "image",
        imageFile.path,
      ),
    );

    final response = await request.send();

    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();

      final json = jsonDecode(body);

      return json["path"];
    }

    return null;
  }
}
import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import 'api_service.dart';

class ProductService {
  Future<List<ProductModel>> getProducts({String search = ""}) async {
    final Uri url = Uri.parse(
      "${ApiService.product}?search=$search",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      final List data = body["data"];

      return data
          .map((item) => ProductModel.fromJson(item))
          .toList();
    } else {
      throw Exception("Gagal mengambil data produk");
    }
  }

  Future<ProductModel> getProductById(int id) async {
    final Uri url = Uri.parse(
      "${ApiService.product}/$id",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      return ProductModel.fromJson(body["data"]);
    } else {
      throw Exception("Gagal mengambil detail produk");
    }
  }
}
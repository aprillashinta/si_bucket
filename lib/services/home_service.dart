import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/category_model.dart';
import '../models/product_model.dart';
import 'api_service.dart';

class HomeService {

  Future<List<CategoryModel>> getCategories() async {

    final response = await http.get(
      Uri.parse(ApiService.category),
    );

    final json = jsonDecode(response.body);

    List data = json["data"];

    return data
        .map(
          (e) => CategoryModel.fromJson(e),
        )
        .toList();

  }

  Future<List<ProductModel>> getProducts() async {

    final response = await http.get(
      Uri.parse(ApiService.product),
    );

    final json = jsonDecode(response.body);

    List data = json["data"];

    return data
        .map(
          (e) => ProductModel.fromJson(e),
        )
        .toList();

  }

}
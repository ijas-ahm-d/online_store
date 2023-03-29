import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:store_api/const/api_const.dart';
import 'package:store_api/models/categories_model.dart';
import 'package:store_api/models/products_model.dart';
import 'package:store_api/models/users_model.dart';

class ApiHandler {
  static Future<List<dynamic>> getData({required String target,String? limit}) async {
    try {
      
      var uri = Uri.https(
        baseUrl,
        "api/v1/$target",
        target=="products"?{
          "offset":"0",
          "limit": limit,
        }
        : {}
      );
      var response = await http.get(uri);
      var data = jsonDecode(response.body);
      List tempList = [];
      if (response.statusCode != 200) {
        throw data["message"];
      }
      for (var value in data) {
        tempList.add(value);
      }
      return tempList;
    } catch (error) {
      log('An error occured $error');
      throw error.toString();
    }
  }

  //===============  All products  ====================\\
  static Future<List<ProductModel>> getAllProducts({required String limit}) async {
    List temp = await getData(target: "products",limit: limit);
    return ProductModel.productFromSnapshot(temp);
  }

  //===============  All Categories  ====================\\
  static Future<List<CategoriesModel>> getAllCategories() async {
    List temp = await getData(target: "categories");
    return CategoriesModel.categoriesFromSnapshot(temp);
  }

  //===============  All Users  ====================\\
  static Future<List<UsersModel>> getAllUSers() async {
    List temp = await getData(target: "users");
    return UsersModel.usersFromSnapshot(temp);
  }

  //===============  Single product details  ====================\\
  static Future<ProductModel> getProductById({required String id}) async {
    try {
      var uri = Uri.https(baseUrl, "api/v1/products/$id");
      var response = await http.get(uri);
      var data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw data["message"];
      }
      return ProductModel.fromJson(data);
    } catch (error) {
      log("An error occured while getting product info");
      throw error.toString();
    }
  }
}

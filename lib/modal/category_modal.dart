import 'dart:convert';

import 'package:expensenoted/constant.dart';
import 'package:expensenoted/interceptor.dart';
import 'package:http_interceptor/http/intercepted_http.dart';

class EntryCategory {
  final String name;
  final String path;
  bool selected = false;

  EntryCategory({required this.name, required this.path});

  factory EntryCategory.fromJson(Map<String, dynamic> json) {
    return EntryCategory(
      name: json['name'].toString(),
      path: json['path'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "path": path,
    };
  }

  static Future<List<EntryCategory>> getAllCategories() async {
    Uri uri = Uri.parse('$domain/categories');
    List<EntryCategory> categories = [];
    final httpI = InterceptedHttp.build(interceptors: [
      LoggingInterceptor(),
    ]);
    try {
      final response = await httpI.get(uri);

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);

        categories =
            (json as List).map((e) => EntryCategory.fromJson(e)).toList();

        return categories;
      }
    } catch (_) {
      throw Exception('categories not found');
    }

    return categories;
  }

  static Future<List<EntryCategory>> getUserCategories(
      List<EntryCategory> userCat) async {
    final categories = await getAllCategories();

    // ignore: avoid_function_literals_in_foreach_calls
    categories.forEach((element) {
      // ignore: avoid_function_literals_in_foreach_calls
      userCat.forEach((e) {
        if (e.name == element.name) {
          element.selected = true;
        }
      });
    });

    return categories;
  }
}

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:wordsearch_quiz/models/category.dart';

class CategoryRepository {
  List<Category> _categories = [];
  bool _loaded = false;

  List<Category> get categories => _categories;
  bool get isLoaded => _loaded;

  Future<void> load() async {
    if (_loaded) return;
    final jsonStr = await rootBundle.loadString('assets/data/categories.json');
    final list = json.decode(jsonStr) as List<dynamic>;
    _categories = list.map((e) => Category.fromJson(e as Map<String, dynamic>)).toList();
    _loaded = true;
  }

  Category? getBySlug(String slug) {
    try {
      return _categories.firstWhere((c) => c.slug == slug);
    } catch (_) {
      return null;
    }
  }

  Category? getById(String id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}

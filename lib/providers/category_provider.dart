import 'package:flutter/foundation.dart';
import 'package:wordsearch_quiz/data/category_repository.dart';
import 'package:wordsearch_quiz/models/category.dart' as models;

class CategoryProvider extends ChangeNotifier {
  final CategoryRepository _repo = CategoryRepository();
  bool _isLoading = true;

  bool get isLoading => _isLoading;
  List<models.Category> get categories => _repo.categories;

  Future<void> load() async {
    await _repo.load();
    _isLoading = false;
    notifyListeners();
  }

  models.Category? getBySlug(String slug) => _repo.getBySlug(slug);
  models.Category? getById(String id) => _repo.getById(id);
}

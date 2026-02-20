import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:wordsearch_quiz/models/puzzle.dart';

class PuzzleRepository {
  List<Puzzle> _puzzles = [];
  bool _loaded = false;

  List<Puzzle> get puzzles => _puzzles;
  bool get isLoaded => _loaded;

  Future<void> load() async {
    if (_loaded) return;
    final jsonStr = await rootBundle.loadString('assets/data/puzzles.json');
    final list = json.decode(jsonStr) as List<dynamic>;
    _puzzles = list.map((e) => Puzzle.fromJson(e as Map<String, dynamic>)).toList();
    _loaded = true;
  }

  List<Puzzle> getByCategory(String categorySlug) {
    return _puzzles.where((p) => p.categorySlug == categorySlug).toList();
  }

  Puzzle? getBySlug(String categorySlug, String slug) {
    try {
      return _puzzles.firstWhere(
        (p) => p.categorySlug == categorySlug && p.slug == slug,
      );
    } catch (_) {
      return null;
    }
  }

  Puzzle? getById(String id) {
    try {
      return _puzzles.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Puzzle> search(String query) {
    final q = query.toLowerCase();
    return _puzzles.where((p) {
      return p.title.toLowerCase().contains(q) ||
          p.categoryName.toLowerCase().contains(q) ||
          p.words.any((w) => w.toLowerCase().contains(q));
    }).toList();
  }

  List<Puzzle> getPopular({int limit = 10}) {
    final sorted = [..._puzzles]..sort((a, b) => b.plays.compareTo(a.plays));
    return sorted.take(limit).toList();
  }

  List<Puzzle> getRandom({int limit = 10}) {
    final shuffled = [..._puzzles]..shuffle();
    return shuffled.take(limit).toList();
  }

  Puzzle? getNextPuzzle(Puzzle current) {
    final categoryPuzzles = getByCategory(current.categorySlug);
    final idx = categoryPuzzles.indexWhere((p) => p.id == current.id);
    if (idx >= 0 && idx < categoryPuzzles.length - 1) {
      return categoryPuzzles[idx + 1];
    }
    return null;
  }
}

import 'package:flutter/foundation.dart';
import 'package:wordsearch_quiz/data/puzzle_repository.dart';
import 'package:wordsearch_quiz/models/puzzle.dart';

class PuzzleProvider extends ChangeNotifier {
  final PuzzleRepository _repo = PuzzleRepository();
  bool _isLoading = true;

  bool get isLoading => _isLoading;
  List<Puzzle> get puzzles => _repo.puzzles;

  Future<void> load() async {
    await _repo.load();
    _isLoading = false;
    notifyListeners();
  }

  List<Puzzle> getByCategory(String slug) => _repo.getByCategory(slug);
  Puzzle? getBySlug(String catSlug, String slug) => _repo.getBySlug(catSlug, slug);
  List<Puzzle> search(String query) => _repo.search(query);
  List<Puzzle> getPopular({int limit = 10}) => _repo.getPopular(limit: limit);
  List<Puzzle> getRandom({int limit = 10}) => _repo.getRandom(limit: limit);
  Puzzle? getNextPuzzle(Puzzle current) => _repo.getNextPuzzle(current);
}

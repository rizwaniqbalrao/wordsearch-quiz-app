import 'package:flutter/foundation.dart';
import 'package:wordsearch_quiz/core/puzzle_generator.dart';
import 'package:wordsearch_quiz/models/puzzle.dart';
import 'package:wordsearch_quiz/models/puzzle_grid.dart';

class MakerProvider extends ChangeNotifier {
  String _title = '';
  String _wordsText = '';
  int _gridSize = 12;
  Difficulty _difficulty = Difficulty.medium;
  bool _allowDiagonals = true;
  bool _allowReverse = true;
  PuzzleGrid? _previewGrid;
  bool _showAnswers = false;

  String get title => _title;
  String get wordsText => _wordsText;
  int get gridSize => _gridSize;
  Difficulty get difficulty => _difficulty;
  bool get allowDiagonals => _allowDiagonals;
  bool get allowReverse => _allowReverse;
  PuzzleGrid? get previewGrid => _previewGrid;
  bool get showAnswers => _showAnswers;

  List<String> get wordsList {
    return _wordsText
        .split(RegExp(r'[,\n]'))
        .map((w) => w.trim().toUpperCase())
        .where((w) => w.isNotEmpty && RegExp(r'^[A-Z]+$').hasMatch(w))
        .toList();
  }

  int get wordCount => wordsList.length;

  void setTitle(String title) {
    _title = title;
    notifyListeners();
  }

  void setWordsText(String text) {
    _wordsText = text;
    notifyListeners();
  }

  void setGridSize(int size) {
    _gridSize = size.clamp(8, 20);
    notifyListeners();
  }

  void setDifficulty(Difficulty difficulty) {
    _difficulty = difficulty;
    notifyListeners();
  }

  void toggleDiagonals() {
    _allowDiagonals = !_allowDiagonals;
    notifyListeners();
  }

  void toggleReverse() {
    _allowReverse = !_allowReverse;
    notifyListeners();
  }

  void toggleShowAnswers() {
    _showAnswers = !_showAnswers;
    notifyListeners();
  }

  void generatePreview() {
    final words = wordsList;
    if (words.isEmpty) return;

    _previewGrid = generatePuzzleGrid(
      words,
      _gridSize,
      _difficulty,
      allowDiagonals: _allowDiagonals,
      allowReverse: _allowReverse,
    );
    notifyListeners();
  }

  void reset() {
    _title = '';
    _wordsText = '';
    _gridSize = 12;
    _difficulty = Difficulty.medium;
    _allowDiagonals = true;
    _allowReverse = true;
    _previewGrid = null;
    _showAnswers = false;
    notifyListeners();
  }
}

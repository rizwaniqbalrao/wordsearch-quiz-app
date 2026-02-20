import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wordsearch_quiz/config/theme.dart';
import 'package:wordsearch_quiz/core/puzzle_generator.dart';
import 'package:wordsearch_quiz/models/puzzle.dart';
import 'package:wordsearch_quiz/models/puzzle_grid.dart';

class GameProvider extends ChangeNotifier {
  Puzzle? _currentPuzzle;
  PuzzleGrid? _puzzleGrid;
  final List<String> _foundWords = [];
  bool _isComplete = false;
  bool _showAnswers = false;

  // Selection state
  CellPosition? _startCell;
  CellPosition? _endCell;
  List<CellPosition> _selectedCells = [];
  final Set<String> _foundCellKeys = {};

  // Color mapping: cell key -> color for found words (each word gets unique color)
  final Map<String, Color> _cellColors = {};

  // Timer
  Timer? _timer;
  int _elapsedSeconds = 0;

  // Getters
  Puzzle? get currentPuzzle => _currentPuzzle;
  PuzzleGrid? get puzzleGrid => _puzzleGrid;
  List<String> get foundWords => List.unmodifiable(_foundWords);
  bool get isComplete => _isComplete;
  bool get showAnswers => _showAnswers;
  CellPosition? get startCell => _startCell;
  List<CellPosition> get selectedCells => _selectedCells;
  Set<String> get foundCellKeys => _foundCellKeys;
  int get elapsedSeconds => _elapsedSeconds;
  int get totalWords => _currentPuzzle?.words.length ?? 0;
  int get foundCount => _foundWords.length;
  double get progress => totalWords > 0 ? foundCount / totalWords : 0;

  Color? getCellFoundColor(int row, int col) {
    return _cellColors['$row-$col'];
  }

  void loadPuzzle(Puzzle puzzle) {
    _currentPuzzle = puzzle;
    _foundWords.clear();
    _isComplete = false;
    _showAnswers = false;
    _selectedCells = [];
    _startCell = null;
    _endCell = null;
    _foundCellKeys.clear();
    _cellColors.clear();
    _elapsedSeconds = 0;

    _puzzleGrid = generatePuzzleGrid(
      puzzle.words,
      puzzle.gridSize,
      puzzle.difficulty,
    );

    _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_isComplete) {
        _elapsedSeconds++;
        notifyListeners();
      }
    });
  }

  void startSelection(int row, int col) {
    _startCell = CellPosition(row, col);
    _endCell = CellPosition(row, col);
    _selectedCells = [CellPosition(row, col)];
    notifyListeners();
  }

  void updateSelection(int row, int col) {
    if (_startCell == null) return;
    _endCell = CellPosition(row, col);
    _selectedCells = _calculateSelectedCells(_startCell!, CellPosition(row, col));
    notifyListeners();
  }

  void endSelection() {
    if (_startCell == null || _endCell == null || _puzzleGrid == null) {
      _clearSelection();
      return;
    }

    final foundWord = checkWord(
      _puzzleGrid!.grid,
      _puzzleGrid!.wordPlacements,
      _startCell!.row,
      _startCell!.col,
      _endCell!.row,
      _endCell!.col,
    );

    if (foundWord != null && !_foundWords.contains(foundWord)) {
      _foundWords.add(foundWord);
      // Assign a unique color to this word's cells
      final colorIndex = (_foundWords.length - 1) % AppColors.foundColors.length;
      final color = AppColors.foundColors[colorIndex];
      _updateFoundCellsWithColor(foundWord, color);

      if (_foundWords.length == _puzzleGrid!.wordPlacements.length) {
        _isComplete = true;
        _timer?.cancel();
      }
    }

    _clearSelection();
  }

  void _clearSelection() {
    _startCell = null;
    _endCell = null;
    _selectedCells = [];
    notifyListeners();
  }

  void _updateFoundCellsWithColor(String word, Color color) {
    for (final placement in _puzzleGrid!.wordPlacements) {
      if (placement.word == word) {
        for (final cell in getWordCells(placement)) {
          _foundCellKeys.add(cell.key);
          _cellColors[cell.key] = color;
        }
      }
    }
  }

  void toggleShowAnswers() {
    _showAnswers = !_showAnswers;
    notifyListeners();
  }

  void resetPuzzle() {
    if (_currentPuzzle != null) {
      loadPuzzle(_currentPuzzle!);
    }
  }

  List<CellPosition> _calculateSelectedCells(CellPosition start, CellPosition end) {
    final rowDiff = end.row - start.row;
    final colDiff = end.col - start.col;
    final absRow = rowDiff.abs();
    final absCol = colDiff.abs();

    // Only allow straight lines
    if (absRow != 0 && absCol != 0 && absRow != absCol) {
      return [start];
    }

    final length = (absRow > absCol ? absRow : absCol) + 1;
    final dr = rowDiff == 0 ? 0 : rowDiff ~/ absRow;
    final dc = colDiff == 0 ? 0 : colDiff ~/ absCol;

    return List.generate(length, (i) {
      return CellPosition(start.row + i * dr, start.col + i * dc);
    });
  }

  bool isCellSelected(int row, int col) {
    return _selectedCells.any((c) => c.row == row && c.col == col);
  }

  bool isCellFound(int row, int col) {
    return _foundCellKeys.contains('$row-$col');
  }

  bool isCellAnswer(int row, int col) {
    if (!_showAnswers || _puzzleGrid == null) return false;
    return _puzzleGrid!.wordPlacements.any((p) {
      return getWordCells(p).any((c) => c.row == row && c.col == col);
    });
  }

  String get selectedText {
    if (_puzzleGrid == null) return '';
    return _selectedCells
        .map((c) => _puzzleGrid!.grid[c.row][c.col])
        .join('');
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

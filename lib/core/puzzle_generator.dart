import 'dart:math';

import 'package:wordsearch_quiz/core/direction.dart';
import 'package:wordsearch_quiz/models/puzzle.dart';
import 'package:wordsearch_quiz/models/puzzle_grid.dart';

const _easyDirections = [Direction.horizontal, Direction.vertical];
const _mediumDirections = [
  Direction.horizontal,
  Direction.vertical,
  Direction.horizontalReverse,
  Direction.verticalReverse,
];

List<Direction> _getAvailableDirections(
  Difficulty difficulty, {
  bool allowDiagonals = true,
  bool allowReverse = true,
}) {
  List<Direction> directions;
  switch (difficulty) {
    case Difficulty.easy:
      directions = [..._easyDirections];
    case Difficulty.medium:
      directions = [..._mediumDirections];
    case Difficulty.hard:
      directions = [...Direction.values];
  }

  if (!allowDiagonals) {
    directions.removeWhere((d) => d.name.contains('diagonal') || d.name.contains('Diagonal'));
  }
  if (!allowReverse) {
    directions.removeWhere((d) => d.name.contains('reverse') || d.name.contains('Reverse'));
  }

  return directions;
}

bool _canPlaceWord(
  List<List<String>> grid,
  String word,
  int startRow,
  int startCol,
  Direction direction,
) {
  final gridSize = grid.length;
  for (var i = 0; i < word.length; i++) {
    final row = startRow + i * direction.dr;
    final col = startCol + i * direction.dc;
    if (row < 0 || row >= gridSize || col < 0 || col >= gridSize) return false;
    final cell = grid[row][col];
    if (cell.isNotEmpty && cell != word[i]) return false;
  }
  return true;
}

void _placeWord(
  List<List<String>> grid,
  String word,
  int startRow,
  int startCol,
  Direction direction,
) {
  for (var i = 0; i < word.length; i++) {
    final row = startRow + i * direction.dr;
    final col = startCol + i * direction.dc;
    grid[row][col] = word[i];
  }
}

List<T> _shuffled<T>(List<T> list) {
  final shuffled = [...list];
  final random = Random();
  for (var i = shuffled.length - 1; i > 0; i--) {
    final j = random.nextInt(i + 1);
    final temp = shuffled[i];
    shuffled[i] = shuffled[j];
    shuffled[j] = temp;
  }
  return shuffled;
}

PuzzleGrid generatePuzzleGrid(
  List<String> words,
  int gridSize,
  Difficulty difficulty, {
  bool allowDiagonals = true,
  bool allowReverse = true,
}) {
  final random = Random();

  // Initialize empty grid
  final grid = List.generate(gridSize, (_) => List.filled(gridSize, ''));
  final wordPlacements = <WordPlacement>[];
  final availableDirections = _getAvailableDirections(
    difficulty,
    allowDiagonals: allowDiagonals,
    allowReverse: allowReverse,
  );

  // Sort words by length (longest first), clean up
  final sortedWords = words
      .map((w) => w.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), ''))
      .where((w) => w.isNotEmpty && w.length <= gridSize)
      .toList()
    ..sort((a, b) => b.length.compareTo(a.length));

  // Try to place each word
  for (final word in sortedWords) {
    var placed = false;
    final directions = _shuffled(availableDirections);
    final maxAttempts = gridSize * gridSize * directions.length;
    var attempts = 0;

    while (!placed && attempts < maxAttempts) {
      final direction = directions[attempts % directions.length];
      final startRow = random.nextInt(gridSize);
      final startCol = random.nextInt(gridSize);

      if (_canPlaceWord(grid, word, startRow, startCol, direction)) {
        _placeWord(grid, word, startRow, startCol, direction);
        wordPlacements.add(WordPlacement(
          word: word,
          startRow: startRow,
          startCol: startCol,
          direction: direction,
        ));
        placed = true;
      }
      attempts++;
    }
  }

  // Fill remaining cells with random letters
  const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  for (var row = 0; row < gridSize; row++) {
    for (var col = 0; col < gridSize; col++) {
      if (grid[row][col].isEmpty) {
        grid[row][col] = letters[random.nextInt(letters.length)];
      }
    }
  }

  return PuzzleGrid(grid: grid, wordPlacements: wordPlacements);
}

String? checkWord(
  List<List<String>> grid,
  List<WordPlacement> wordPlacements,
  int startRow,
  int startCol,
  int endRow,
  int endCol,
) {
  final rowDiff = endRow - startRow;
  final colDiff = endCol - startCol;
  final length = max(rowDiff.abs(), colDiff.abs()) + 1;

  final dr = rowDiff == 0 ? 0 : rowDiff ~/ rowDiff.abs();
  final dc = colDiff == 0 ? 0 : colDiff ~/ colDiff.abs();

  final buffer = StringBuffer();
  for (var i = 0; i < length; i++) {
    final row = startRow + i * dr;
    final col = startCol + i * dc;
    if (row >= 0 && row < grid.length && col >= 0 && col < grid[0].length) {
      buffer.write(grid[row][col]);
    }
  }

  final selectedWord = buffer.toString();
  final reversedWord = selectedWord.split('').reversed.join('');

  for (final placement in wordPlacements) {
    if (placement.found) continue;
    if (selectedWord == placement.word || reversedWord == placement.word) {
      return placement.word;
    }
  }

  return null;
}

List<CellPosition> getWordCells(WordPlacement placement) {
  final cells = <CellPosition>[];
  for (var i = 0; i < placement.word.length; i++) {
    cells.add(CellPosition(
      placement.startRow + i * placement.direction.dr,
      placement.startCol + i * placement.direction.dc,
    ));
  }
  return cells;
}

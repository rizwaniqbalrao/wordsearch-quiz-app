import 'package:wordsearch_quiz/core/direction.dart';

class WordPlacement {
  final String word;
  final int startRow;
  final int startCol;
  final Direction direction;
  bool found;

  WordPlacement({
    required this.word,
    required this.startRow,
    required this.startCol,
    required this.direction,
    this.found = false,
  });
}

class PuzzleGrid {
  final List<List<String>> grid;
  final List<WordPlacement> wordPlacements;

  const PuzzleGrid({
    required this.grid,
    required this.wordPlacements,
  });

  int get size => grid.length;
}

class CellPosition {
  final int row;
  final int col;

  const CellPosition(this.row, this.col);

  @override
  bool operator ==(Object other) =>
      other is CellPosition && other.row == row && other.col == col;

  @override
  int get hashCode => row.hashCode ^ col.hashCode;

  String get key => '$row-$col';
}

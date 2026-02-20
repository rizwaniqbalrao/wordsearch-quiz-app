import 'package:flutter/material.dart';
import 'package:wordsearch_quiz/config/theme.dart';
import 'package:wordsearch_quiz/models/puzzle_grid.dart';
import 'package:wordsearch_quiz/providers/game_provider.dart';

class WordSearchGridWidget extends StatelessWidget {
  final PuzzleGrid puzzleGrid;
  final GameProvider gameProvider;

  const WordSearchGridWidget({
    super.key,
    required this.puzzleGrid,
    required this.gameProvider,
  });

  @override
  Widget build(BuildContext context) {
    final grid = puzzleGrid.grid;
    final gridSize = grid.length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableSize = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;
        final cellSize = (availableSize - 16) / gridSize;
        final fontSize = (cellSize * 0.45).clamp(10.0, 22.0);

        return Center(
          child: SizedBox(
            width: cellSize * gridSize + 16,
            height: cellSize * gridSize + 16,
            child: GestureDetector(
              onPanStart: (details) {
                final pos = _getCellPosition(details.localPosition, cellSize, gridSize);
                if (pos != null) gameProvider.startSelection(pos.row, pos.col);
              },
              onPanUpdate: (details) {
                final pos = _getCellPosition(details.localPosition, cellSize, gridSize);
                if (pos != null) gameProvider.updateSelection(pos.row, pos.col);
              },
              onPanEnd: (_) => gameProvider.endSelection(),
              onPanCancel: () => gameProvider.endSelection(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.purple.withValues(alpha: 0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: List.generate(gridSize, (row) {
                    return Expanded(
                      child: Row(
                        children: List.generate(gridSize, (col) {
                          final letter = grid[row][col];
                          final isSelected = gameProvider.isCellSelected(row, col);
                          final isFound = gameProvider.isCellFound(row, col);
                          final isAnswer = gameProvider.isCellAnswer(row, col);
                          final foundColor = gameProvider.getCellFoundColor(row, col);

                          Color bgColor;
                          Color textColor;

                          if (isFound && foundColor != null) {
                            bgColor = foundColor;
                            textColor = Colors.white;
                          } else if (isSelected) {
                            bgColor = AppColors.hotPink;
                            textColor = Colors.white;
                          } else if (isAnswer) {
                            bgColor = AppColors.amber.withValues(alpha: 0.4);
                            textColor = const Color(0xFF92400E);
                          } else {
                            bgColor = Colors.transparent;
                            textColor = const Color(0xFF2D1B69);
                          }

                          return Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Text(
                                  letter,
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.w800,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  CellPosition? _getCellPosition(Offset position, double cellSize, int gridSize) {
    final col = ((position.dx - 8) / cellSize).floor();
    final row = ((position.dy - 8) / cellSize).floor();
    if (row >= 0 && row < gridSize && col >= 0 && col < gridSize) {
      return CellPosition(row, col);
    }
    return null;
  }
}

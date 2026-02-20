import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordsearch_quiz/models/puzzle.dart';
import 'package:wordsearch_quiz/providers/maker_provider.dart';
import 'package:wordsearch_quiz/screens/game/widgets/word_search_grid.dart';
import 'package:wordsearch_quiz/providers/game_provider.dart';

class MakerScreen extends StatelessWidget {
  const MakerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final maker = context.watch<MakerProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Puzzle Maker'),
        actions: [
          if (maker.previewGrid != null)
            IconButton(
              icon: Icon(maker.showAnswers ? Icons.visibility_off : Icons.visibility),
              onPressed: maker.toggleShowAnswers,
              tooltip: 'Toggle Answers',
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: maker.reset,
            tooltip: 'Reset',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Input
            TextField(
              decoration: const InputDecoration(
                labelText: 'Puzzle Title',
                hintText: 'Enter a title for your puzzle',
              ),
              onChanged: maker.setTitle,
            ),
            const SizedBox(height: 16),

            // Words Input
            TextField(
              decoration: InputDecoration(
                labelText: 'Words (one per line or comma-separated)',
                hintText: 'HELLO\nWORLD\nFLUTTER',
                helperText: '${maker.wordCount} words added (max 30)',
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              onChanged: maker.setWordsText,
            ),
            const SizedBox(height: 16),

            // Grid Size Slider
            Text('Grid Size: ${maker.gridSize}x${maker.gridSize}',
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
            Slider(
              value: maker.gridSize.toDouble(),
              min: 8,
              max: 20,
              divisions: 12,
              label: '${maker.gridSize}',
              onChanged: (v) => maker.setGridSize(v.toInt()),
            ),

            // Difficulty
            Text('Difficulty', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            SegmentedButton<Difficulty>(
              segments: const [
                ButtonSegment(value: Difficulty.easy, label: Text('Easy')),
                ButtonSegment(value: Difficulty.medium, label: Text('Medium')),
                ButtonSegment(value: Difficulty.hard, label: Text('Hard')),
              ],
              selected: {maker.difficulty},
              onSelectionChanged: (s) => maker.setDifficulty(s.first),
            ),
            const SizedBox(height: 16),

            // Options
            SwitchListTile(
              title: const Text('Allow Diagonals'),
              value: maker.allowDiagonals,
              onChanged: (_) => maker.toggleDiagonals(),
              contentPadding: EdgeInsets.zero,
            ),
            SwitchListTile(
              title: const Text('Allow Reverse'),
              value: maker.allowReverse,
              onChanged: (_) => maker.toggleReverse(),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 16),

            // Generate Button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: maker.wordCount > 0 ? maker.generatePreview : null,
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Generate Puzzle'),
              ),
            ),
            const SizedBox(height: 24),

            // Preview
            if (maker.previewGrid != null) ...[
              Text('Preview', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              AspectRatio(
                aspectRatio: 1,
                child: WordSearchGridWidget(
                  puzzleGrid: maker.previewGrid!,
                  gameProvider: context.read<GameProvider>(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

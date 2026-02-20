import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wordsearch_quiz/config/theme.dart';
import 'package:wordsearch_quiz/core/utils.dart';
import 'package:wordsearch_quiz/providers/game_provider.dart';
import 'package:wordsearch_quiz/providers/puzzle_provider.dart';
import 'package:wordsearch_quiz/providers/stats_provider.dart';
import 'package:wordsearch_quiz/screens/game/widgets/word_search_grid.dart';
import 'package:wordsearch_quiz/screens/game/widgets/word_list_widget.dart';
import 'package:wordsearch_quiz/screens/game/widgets/completion_dialog.dart';

class GameScreen extends StatefulWidget {
  final String categorySlug;
  final String puzzleSlug;

  const GameScreen({
    super.key,
    required this.categorySlug,
    required this.puzzleSlug,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _completionShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final puzzleProvider = context.read<PuzzleProvider>();
      final puzzle = puzzleProvider.getBySlug(widget.categorySlug, widget.puzzleSlug);
      if (puzzle != null) {
        context.read<GameProvider>().loadPuzzle(puzzle);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();
    final puzzle = game.currentPuzzle;

    if (puzzle == null || game.puzzleGrid == null) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFE0F0), Color(0xFFE8D5FF), Color(0xFFD5E8FF)],
            ),
          ),
          child: const Center(child: CircularProgressIndicator(color: AppColors.hotPink)),
        ),
      );
    }

    if (game.isComplete && !_completionShown) {
      _completionShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Record completion in stats
        context.read<StatsProvider>().recordPuzzleCompleted(
          categoryName: puzzle.categoryName,
          timeTaken: game.elapsedSeconds,
        );
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => CompletionDialog(
            time: game.elapsedSeconds,
            wordCount: game.totalWords,
            onPlayNext: () {
              Navigator.of(context).pop();
              _completionShown = false;
              final next = context.read<PuzzleProvider>().getNextPuzzle(puzzle);
              if (next != null) {
                context.pushReplacement('/puzzle/${next.categorySlug}/${next.slug}');
              }
            },
            onBackToCategory: () {
              Navigator.of(context).pop();
              context.pop();
            },
            onPlayAgain: () {
              Navigator.of(context).pop();
              _completionShown = false;
              game.resetPuzzle();
            },
          ),
        );
      });
    }

    final gradColors = AppTheme.difficultyGradient(puzzle.difficulty.name);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFE0F0), Color(0xFFE8D5FF), Color(0xFFD5E8FF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF2D1B69), size: 22),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            puzzle.title,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF2D1B69)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(puzzle.categoryName, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: gradColors),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: gradColors[0].withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.timer_rounded, size: 16, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(formatTime(game.elapsedSeconds), style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Word Chips at top
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                child: WordListWidget(words: puzzle.words, foundWords: game.foundWords),
              ),

              // Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: WordSearchGridWidget(puzzleGrid: game.puzzleGrid!, gameProvider: game),
                ),
              ),

              // Bottom Actions
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: AppColors.purple.withValues(alpha: 0.1), blurRadius: 8)],
                        ),
                        child: Row(
                          children: [
                            Text('${game.foundCount}/${game.totalWords}', style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF2D1B69), fontSize: 16)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(value: game.progress, minHeight: 8, backgroundColor: const Color(0xFFE8D5FF), valueColor: const AlwaysStoppedAnimation(AppColors.hotPink)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    _ActionButton(
                      icon: game.showAnswers ? Icons.visibility_off_rounded : Icons.lightbulb_rounded,
                      gradient: game.showAnswers ? [AppColors.amber, AppColors.orange] : [AppColors.purple, AppColors.skyBlue],
                      onTap: game.toggleShowAnswers,
                    ),
                    const SizedBox(width: 8),
                    _ActionButton(
                      icon: Icons.refresh_rounded,
                      gradient: const [AppColors.hotPink, AppColors.coral],
                      onTap: () { _completionShown = false; game.resetPuzzle(); },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.gradient, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: gradient[0].withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}

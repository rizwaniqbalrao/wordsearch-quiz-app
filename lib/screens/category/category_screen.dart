import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wordsearch_quiz/config/theme.dart';
import 'package:wordsearch_quiz/providers/category_provider.dart';
import 'package:wordsearch_quiz/providers/puzzle_provider.dart';

class CategoryScreen extends StatelessWidget {
  final String slug;

  const CategoryScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();
    final puzzleProvider = context.watch<PuzzleProvider>();
    final category = categoryProvider.getBySlug(slug);
    final puzzles = puzzleProvider.getByCategory(slug);
    final catIndex = categoryProvider.categories.indexWhere((c) => c.slug == slug);
    final gradient = AppTheme.categoryGradient(catIndex >= 0 ? catIndex : 0);

    if (category == null) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFE0F0), Color(0xFFE8D5FF), Color(0xFFD5E8FF)],
            ),
          ),
          child: const Center(child: Text('Category not found')),
        ),
      );
    }

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
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradient,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: gradient[0].withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 22),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.name,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${puzzles.length} puzzles',
                            style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.85), fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Icon(AppTheme.categoryIcon(category.icon), color: Colors.white.withValues(alpha: 0.5), size: 40),
                  ],
                ),
              ),

              // Puzzle List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: puzzles.length,
                  itemBuilder: (context, index) {
                    final puzzle = puzzles[index];
                    final diffGrad = AppTheme.difficultyGradient(puzzle.difficulty.name);

                    return GestureDetector(
                      onTap: () => context.push('/puzzle/${puzzle.categorySlug}/${puzzle.slug}'),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: diffGrad[0].withValues(alpha: 0.12),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: diffGrad),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Center(
                                child: Text(
                                  '${puzzle.gridSize}',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    puzzle.title,
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Color(0xFF2D1B69)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${puzzle.words.length} words - ${puzzle.gridSize}x${puzzle.gridSize}',
                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: diffGrad),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                puzzle.difficulty.name.toUpperCase(),
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

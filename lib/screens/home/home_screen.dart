import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wordsearch_quiz/config/theme.dart';
import 'package:wordsearch_quiz/providers/category_provider.dart';
import 'package:wordsearch_quiz/providers/puzzle_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CategoryProvider>();
    final puzzles = context.watch<PuzzleProvider>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: categories.isLoading || puzzles.isLoading
          ? Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFFE0F0), Color(0xFFE8D5FF), Color(0xFFD5E8FF)],
                ),
              ),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.hotPink),
              ),
            )
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFFE0F0), Color(0xFFE8D5FF), Color(0xFFD5E8FF)],
                ),
              ),
              child: SafeArea(
                child: CustomScrollView(
                  slivers: [
                    // Top Bar
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [AppColors.hotPink, AppColors.purple],
                                ),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.hotPink.withValues(alpha: 0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.grid_view_rounded, color: Colors.white, size: 24),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Word Search',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF2D1B69),
                                    ),
                                  ),
                                  Text(
                                    'Quiz',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.hotPink,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _GlowIconButton(
                              icon: Icons.search_rounded,
                              color: AppColors.skyBlue,
                              onTap: () => context.push('/search'),
                            ),
                            const SizedBox(width: 8),
                            _GlowIconButton(
                              icon: Icons.bar_chart_rounded,
                              color: AppColors.green,
                              onTap: () => context.push('/stats'),
                            ),
                            const SizedBox(width: 8),
                            _GlowIconButton(
                              icon: Icons.settings_rounded,
                              color: AppColors.purple,
                              onTap: () => context.push('/settings'),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Hero Card
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFFF2D87),
                              Color(0xFFD500F9),
                              Color(0xFF7C4DFF),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.hotPink.withValues(alpha: 0.4),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              '2,092+',
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              'Word Search Puzzles',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '25 Categories - All Difficulties',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.85),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                final random = puzzles.getRandom(limit: 1);
                                if (random.isNotEmpty) {
                                  context.push('/puzzle/${random.first.categorySlug}/${random.first.slug}');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.hotPink,
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                elevation: 0,
                                textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.play_arrow_rounded, size: 22),
                                  SizedBox(width: 6),
                                  Text('Play Random'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Quick Actions
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: _QuickActionCard(
                                icon: Icons.create_rounded,
                                label: 'Puzzle Maker',
                                gradient: const [AppColors.orange, AppColors.amber],
                                onTap: () => context.push('/maker'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _QuickActionCard(
                                icon: Icons.sports_esports_rounded,
                                label: 'Hangman',
                                gradient: const [AppColors.purple, AppColors.skyBlue],
                                onTap: () => context.push('/hangman'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Categories Header
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
                        child: Text(
                          'Categories',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2D1B69),
                          ),
                        ),
                      ),
                    ),

                    // Category Grid
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final cat = categories.categories[index];
                            final gradient = AppTheme.categoryGradient(index);
                            return _CategoryCard(
                              name: cat.name,
                              count: cat.puzzleCount,
                              icon: AppTheme.categoryIcon(cat.icon),
                              gradient: gradient,
                              onTap: () => context.push('/category/${cat.slug}'),
                            );
                          },
                          childCount: categories.categories.length,
                        ),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.85,
                        ),
                      ),
                    ),

                    // Popular Puzzles Header
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 28, 20, 12),
                        child: Text(
                          'Popular Puzzles',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2D1B69),
                          ),
                        ),
                      ),
                    ),

                    // Popular Puzzles
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final popular = puzzles.getPopular(limit: 10);
                            if (index >= popular.length) return null;
                            final puzzle = popular[index];
                            final gradColors = AppTheme.difficultyGradient(puzzle.difficulty.name);

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
                                      color: gradColors[0].withValues(alpha: 0.15),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 46,
                                      height: 46,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: gradColors),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: const Icon(Icons.grid_view_rounded, color: Colors.white, size: 22),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            puzzle.title,
                                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${puzzle.categoryName} - ${puzzle.words.length} words',
                                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: gradColors),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        puzzle.difficulty.name.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          childCount: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _GlowIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _GlowIconButton({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String name;
  final int count;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.name,
    required this.count,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradient),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D1B69),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: gradient[0],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

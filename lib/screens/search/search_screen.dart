import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wordsearch_quiz/config/theme.dart';
import 'package:wordsearch_quiz/models/puzzle.dart';
import 'package:wordsearch_quiz/providers/puzzle_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';
  List<Puzzle> _results = [];

  void _search(String query) {
    setState(() {
      _query = query;
      if (query.length >= 2) {
        _results = context.read<PuzzleProvider>().search(query);
      } else {
        _results = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
              // Search Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [BoxShadow(color: AppColors.purple.withValues(alpha: 0.1), blurRadius: 8)],
                        ),
                        child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF2D1B69), size: 22),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: AppColors.hotPink.withValues(alpha: 0.1), blurRadius: 12)],
                        ),
                        child: TextField(
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: 'Search puzzles...',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            border: InputBorder.none,
                            icon: Icon(Icons.search, color: AppColors.hotPink.withValues(alpha: 0.6)),
                          ),
                          onChanged: _search,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Results
              Expanded(
                child: _query.length < 2
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [AppColors.purple.withValues(alpha: 0.15), AppColors.skyBlue.withValues(alpha: 0.15)]),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.search_rounded, size: 48, color: AppColors.purple),
                            ),
                            const SizedBox(height: 16),
                            Text('Search 2,092+ puzzles', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
                          ],
                        ),
                      )
                    : _results.isEmpty
                        ? Center(child: Text('No puzzles found for "$_query"', style: TextStyle(color: Colors.grey.shade600)))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _results.length,
                            itemBuilder: (context, index) {
                              final puzzle = _results[index];
                              final diffGrad = AppTheme.difficultyGradient(puzzle.difficulty.name);

                              return GestureDetector(
                                onTap: () => context.push('/puzzle/${puzzle.categorySlug}/${puzzle.slug}'),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: [BoxShadow(color: diffGrad[0].withValues(alpha: 0.12), blurRadius: 8, offset: const Offset(0, 3))],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 42, height: 42,
                                        decoration: BoxDecoration(gradient: LinearGradient(colors: diffGrad), borderRadius: BorderRadius.circular(12)),
                                        child: const Icon(Icons.grid_view_rounded, color: Colors.white, size: 20),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(puzzle.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF2D1B69)), maxLines: 1, overflow: TextOverflow.ellipsis),
                                            Text('${puzzle.categoryName} - ${puzzle.words.length} words', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(gradient: LinearGradient(colors: diffGrad), borderRadius: BorderRadius.circular(16)),
                                        child: Text(puzzle.difficulty.name.toUpperCase(), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white)),
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

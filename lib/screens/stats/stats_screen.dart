import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordsearch_quiz/providers/stats_provider.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = context.watch<StatsProvider>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Your Stats',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4f46e5), Color(0xFF7c3aed)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.bar_chart_rounded, size: 60, color: Colors.white30),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _StatCard(
                  icon: Icons.check_circle_rounded,
                  color: const Color(0xFF22c55e),
                  label: 'Puzzles Completed',
                  value: '${stats.puzzlesCompleted}',
                ),
                const SizedBox(height: 12),
                _StatCard(
                  icon: Icons.timer_rounded,
                  color: const Color(0xFF6366f1),
                  label: 'Total Time Played',
                  value: stats.puzzlesCompleted == 0 ? '0s' : stats.formattedTotalTime,
                ),
                const SizedBox(height: 12),
                _StatCard(
                  icon: Icons.local_fire_department_rounded,
                  color: const Color(0xFFf97316),
                  label: 'Current Streak',
                  value: '${stats.currentStreak} puzzles',
                ),
                const SizedBox(height: 12),
                _StatCard(
                  icon: Icons.emoji_events_rounded,
                  color: const Color(0xFFf59e0b),
                  label: 'Best Streak',
                  value: '${stats.bestStreak} puzzles',
                ),
                const SizedBox(height: 12),
                _StatCard(
                  icon: Icons.favorite_rounded,
                  color: const Color(0xFFec4899),
                  label: 'Favorite Category',
                  value: stats.favoriteCategory.isEmpty
                      ? 'Play more to see!'
                      : stats.favoriteCategory,
                ),
                const SizedBox(height: 24),
                if (stats.puzzlesCompleted > 0)
                  OutlinedButton.icon(
                    onPressed: () => _confirmReset(context, stats),
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Reset Statistics'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      minimumSize: const Size.fromHeight(48),
                    ),
                  ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmReset(BuildContext context, StatsProvider stats) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Statistics?'),
        content: const Text('This will permanently delete all your progress and statistics.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              stats.resetStats();
              Navigator.pop(ctx);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1e1b4b),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

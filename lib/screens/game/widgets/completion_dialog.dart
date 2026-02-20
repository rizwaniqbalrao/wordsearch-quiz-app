import 'package:flutter/material.dart';
import 'package:wordsearch_quiz/config/theme.dart';
import 'package:wordsearch_quiz/core/utils.dart';

class CompletionDialog extends StatelessWidget {
  final int time;
  final int wordCount;
  final VoidCallback onPlayNext;
  final VoidCallback onBackToCategory;
  final VoidCallback onPlayAgain;

  const CompletionDialog({
    super.key,
    required this.time,
    required this.wordCount,
    required this.onPlayNext,
    required this.onBackToCategory,
    required this.onPlayAgain,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.amber, AppColors.orange],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.amber.withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(Icons.emoji_events_rounded, size: 44, color: Colors.white),
          ),
          const SizedBox(height: 20),
          const Text(
            'Awesome!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Color(0xFF2D1B69),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You found all $wordCount words\nin ${formatTime(time)}',
            style: TextStyle(fontSize: 15, color: Colors.grey.shade600, height: 1.4),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.hotPink, AppColors.purple]),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: AppColors.hotPink.withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: ElevatedButton.icon(
                onPressed: onPlayNext,
                icon: const Icon(Icons.skip_next_rounded),
                label: const Text('Next Puzzle'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onPlayAgain,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Play Again'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.hotPink,
                side: const BorderSide(color: AppColors.hotPink, width: 2),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onBackToCategory,
            child: Text('Back to Category', style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

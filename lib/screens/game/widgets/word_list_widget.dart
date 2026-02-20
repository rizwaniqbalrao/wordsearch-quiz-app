import 'package:flutter/material.dart';
import 'package:wordsearch_quiz/config/theme.dart';

class WordListWidget extends StatelessWidget {
  final List<String> words;
  final List<String> foundWords;

  const WordListWidget({
    super.key,
    required this.words,
    required this.foundWords,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      alignment: WrapAlignment.center,
      children: words.asMap().entries.map((entry) {
        final word = entry.value;
        final isFound = foundWords.contains(word);
        final colorIndex = foundWords.indexOf(word);
        final chipColor = isFound
            ? AppColors.foundColors[colorIndex % AppColors.foundColors.length]
            : Colors.white;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isFound ? chipColor.withValues(alpha: 0.15) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isFound ? chipColor : Colors.grey.shade300,
              width: isFound ? 2 : 1,
            ),
          ),
          child: Text(
            word,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isFound ? chipColor : const Color(0xFF2D1B69),
              decoration: isFound ? TextDecoration.lineThrough : null,
              decorationColor: chipColor,
              decorationThickness: 2,
            ),
          ),
        );
      }).toList(),
    );
  }
}

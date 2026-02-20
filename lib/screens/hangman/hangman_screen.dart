import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordsearch_quiz/config/theme.dart';
import 'package:wordsearch_quiz/providers/hangman_provider.dart';

class HangmanScreen extends StatefulWidget {
  const HangmanScreen({super.key});

  @override
  State<HangmanScreen> createState() => _HangmanScreenState();
}

class _HangmanScreenState extends State<HangmanScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HangmanProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hangman = context.watch<HangmanProvider>();

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Header
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF2D1B69)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Text('Hangman', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF2D1B69))),
                  ],
                ),
                const SizedBox(height: 16),

                // Category Chips
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: hangman.availableCategories.asMap().entries.map((entry) {
                      final cat = entry.value;
                      final isSelected = cat == hangman.category;
                      final grad = AppTheme.categoryGradient(entry.key);

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => hangman.selectCategory(cat),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: isSelected ? LinearGradient(colors: grad) : null,
                              color: isSelected ? null : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: isSelected
                                  ? [BoxShadow(color: grad[0].withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))]
                                  : null,
                            ),
                            child: Text(cat, style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: isSelected ? Colors.white : const Color(0xFF2D1B69),
                              fontSize: 13,
                            )),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),

                // Hangman Drawing
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: AppColors.purple.withValues(alpha: 0.1), blurRadius: 16)],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 180,
                        child: CustomPaint(
                          size: const Size(200, 180),
                          painter: _HangmanPainter(wrongGuesses: hangman.wrongGuesses),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: hangman.wrongGuesses > 3
                                ? [AppColors.hotPink, AppColors.deepOrange]
                                : [AppColors.purple, AppColors.skyBlue],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${hangman.wrongGuesses}/${HangmanProvider.maxWrong} wrong',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Word Display
                Text(
                  hangman.displayWord,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 8,
                    color: Color(0xFF2D1B69),
                  ),
                ),
                const SizedBox(height: 20),

                // Game Over Messages
                if (hangman.state == HangmanState.won)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [AppColors.green.withValues(alpha: 0.15), AppColors.teal.withValues(alpha: 0.15)]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.celebration_rounded, size: 40, color: AppColors.green),
                        SizedBox(height: 8),
                        Text('You Won!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.green)),
                      ],
                    ),
                  ),
                if (hangman.state == HangmanState.lost)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [AppColors.hotPink.withValues(alpha: 0.15), AppColors.coral.withValues(alpha: 0.15)]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.sentiment_dissatisfied_rounded, size: 40, color: AppColors.hotPink),
                        const SizedBox(height: 8),
                        const Text('Game Over', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.hotPink)),
                        const SizedBox(height: 4),
                        Text('The word was: ${hangman.word}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2D1B69))),
                      ],
                    ),
                  ),

                if (hangman.state != HangmanState.playing) ...[
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppColors.hotPink, AppColors.purple]),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [BoxShadow(color: AppColors.hotPink.withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 4))],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: hangman.newGame,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('New Game'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                    ),
                  ),
                ],

                // Letter Keyboard
                if (hangman.state == HangmanState.playing) ...[
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    alignment: WrapAlignment.center,
                    children: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('').asMap().entries.map((entry) {
                      final letter = entry.value;
                      final guessed = hangman.guessedLetters.contains(letter);
                      final isInWord = hangman.word.contains(letter);
                      final grad = AppTheme.categoryGradient(entry.key % 10);

                      return SizedBox(
                        width: 42,
                        height: 42,
                        child: GestureDetector(
                          onTap: guessed ? null : () => hangman.guessLetter(letter),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: guessed
                                  ? (isInWord ? LinearGradient(colors: [AppColors.green, AppColors.teal]) : null)
                                  : LinearGradient(colors: [grad[0].withValues(alpha: 0.1), grad[1].withValues(alpha: 0.1)]),
                              color: guessed && !isInWord ? Colors.grey.shade200 : null,
                              borderRadius: BorderRadius.circular(10),
                              border: guessed ? null : Border.all(color: grad[0].withValues(alpha: 0.3)),
                            ),
                            child: Center(
                              child: Text(
                                letter,
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                  color: guessed
                                      ? (isInWord ? Colors.white : Colors.grey.shade400)
                                      : const Color(0xFF2D1B69),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HangmanPainter extends CustomPainter {
  final int wrongGuesses;

  _HangmanPainter({required this.wrongGuesses});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFBDBDBD)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(30, size.height - 20), Offset(80, size.height - 20), paint);
    canvas.drawLine(Offset(55, size.height - 20), const Offset(55, 20), paint);
    canvas.drawLine(const Offset(55, 20), const Offset(140, 20), paint);
    canvas.drawLine(const Offset(140, 20), const Offset(140, 40), paint);

    final bodyPaint = Paint()
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    if (wrongGuesses >= 1) {
      bodyPaint.color = AppColors.hotPink;
      canvas.drawCircle(const Offset(140, 55), 15, bodyPaint);
    }
    if (wrongGuesses >= 2) {
      bodyPaint.color = AppColors.purple;
      canvas.drawLine(const Offset(140, 70), const Offset(140, 120), bodyPaint);
    }
    if (wrongGuesses >= 3) {
      bodyPaint.color = AppColors.skyBlue;
      canvas.drawLine(const Offset(140, 85), const Offset(115, 105), bodyPaint);
    }
    if (wrongGuesses >= 4) {
      bodyPaint.color = AppColors.orange;
      canvas.drawLine(const Offset(140, 85), const Offset(165, 105), bodyPaint);
    }
    if (wrongGuesses >= 5) {
      bodyPaint.color = AppColors.green;
      canvas.drawLine(const Offset(140, 120), const Offset(115, 150), bodyPaint);
    }
    if (wrongGuesses >= 6) {
      bodyPaint.color = AppColors.deepOrange;
      canvas.drawLine(const Offset(140, 120), const Offset(165, 150), bodyPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _HangmanPainter oldDelegate) {
    return oldDelegate.wrongGuesses != wrongGuesses;
  }
}

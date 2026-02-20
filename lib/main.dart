import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordsearch_quiz/config/routes.dart';
import 'package:wordsearch_quiz/config/theme.dart';
import 'package:wordsearch_quiz/providers/category_provider.dart';
import 'package:wordsearch_quiz/providers/game_provider.dart';
import 'package:wordsearch_quiz/providers/hangman_provider.dart';
import 'package:wordsearch_quiz/providers/maker_provider.dart';
import 'package:wordsearch_quiz/providers/puzzle_provider.dart';
import 'package:wordsearch_quiz/providers/stats_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WordSearchQuizApp());
}

class WordSearchQuizApp extends StatelessWidget {
  const WordSearchQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PuzzleProvider()..load()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()..load()),
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(create: (_) => HangmanProvider()),
        ChangeNotifierProvider(create: (_) => MakerProvider()),
        ChangeNotifierProvider(create: (_) => StatsProvider()..load()),
      ],
      child: Consumer<StatsProvider>(
        builder: (context, stats, _) => MaterialApp.router(
          title: 'Word Search Quiz',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: stats.darkMode ? ThemeMode.dark : ThemeMode.light,
          routerConfig: router,
        ),
      ),
    );
  }
}

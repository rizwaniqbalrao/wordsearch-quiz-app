import 'package:go_router/go_router.dart';
import 'package:wordsearch_quiz/screens/home/home_screen.dart';
import 'package:wordsearch_quiz/screens/category/category_screen.dart';
import 'package:wordsearch_quiz/screens/game/game_screen.dart';
import 'package:wordsearch_quiz/screens/hangman/hangman_screen.dart';
import 'package:wordsearch_quiz/screens/maker/maker_screen.dart';
import 'package:wordsearch_quiz/screens/search/search_screen.dart';
import 'package:wordsearch_quiz/screens/stats/stats_screen.dart';
import 'package:wordsearch_quiz/screens/settings/settings_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/category/:slug',
      builder: (context, state) => CategoryScreen(
        slug: state.pathParameters['slug']!,
      ),
    ),
    GoRoute(
      path: '/puzzle/:category/:slug',
      builder: (context, state) => GameScreen(
        categorySlug: state.pathParameters['category']!,
        puzzleSlug: state.pathParameters['slug']!,
      ),
    ),
    GoRoute(
      path: '/hangman',
      builder: (context, state) => const HangmanScreen(),
    ),
    GoRoute(
      path: '/maker',
      builder: (context, state) => const MakerScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/stats',
      builder: (context, state) => const StatsScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);

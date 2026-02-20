import 'dart:math';

import 'package:flutter/foundation.dart';

enum HangmanState { playing, won, lost }

class HangmanProvider extends ChangeNotifier {
  static const _wordsByCategory = {
    'Animals': ['ELEPHANT', 'GIRAFFE', 'PENGUIN', 'DOLPHIN', 'KANGAROO', 'OCTOPUS', 'CHEETAH', 'GORILLA'],
    'Countries': ['AUSTRALIA', 'BRAZIL', 'CANADA', 'GERMANY', 'JAPAN', 'MEXICO', 'FRANCE', 'INDIA'],
    'Fruits': ['STRAWBERRY', 'PINEAPPLE', 'BLUEBERRY', 'WATERMELON', 'MANGO', 'CHERRY', 'BANANA', 'ORANGE'],
    'Sports': ['BASKETBALL', 'FOOTBALL', 'TENNIS', 'SWIMMING', 'BASEBALL', 'CRICKET', 'VOLLEYBALL', 'HOCKEY'],
    'Movies': ['INCEPTION', 'GLADIATOR', 'TITANIC', 'AVATAR', 'FROZEN', 'JAWS', 'ROCKY', 'BATMAN'],
  };

  String _category = 'Animals';
  String _word = '';
  final Set<String> _guessedLetters = {};
  int _wrongGuesses = 0;
  HangmanState _state = HangmanState.playing;
  static const int maxWrong = 6;

  String get category => _category;
  String get word => _word;
  Set<String> get guessedLetters => _guessedLetters;
  int get wrongGuesses => _wrongGuesses;
  HangmanState get state => _state;
  List<String> get availableCategories => _wordsByCategory.keys.toList();

  String get displayWord {
    return _word.split('').map((l) => _guessedLetters.contains(l) ? l : '_').join(' ');
  }

  bool get isWordRevealed {
    return _word.split('').every((l) => _guessedLetters.contains(l));
  }

  void selectCategory(String category) {
    _category = category;
    _startNewGame();
  }

  void _startNewGame() {
    final words = _wordsByCategory[_category]!;
    _word = words[Random().nextInt(words.length)];
    _guessedLetters.clear();
    _wrongGuesses = 0;
    _state = HangmanState.playing;
    notifyListeners();
  }

  void guessLetter(String letter) {
    if (_state != HangmanState.playing) return;
    if (_guessedLetters.contains(letter)) return;

    _guessedLetters.add(letter);

    if (!_word.contains(letter)) {
      _wrongGuesses++;
      if (_wrongGuesses >= maxWrong) {
        _state = HangmanState.lost;
      }
    } else if (isWordRevealed) {
      _state = HangmanState.won;
    }

    notifyListeners();
  }

  void newGame() => _startNewGame();

  void init() {
    if (_word.isEmpty) _startNewGame();
  }
}

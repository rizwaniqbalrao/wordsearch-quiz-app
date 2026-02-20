import 'package:flutter_test/flutter_test.dart';
import 'package:wordsearch_quiz/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const WordSearchQuizApp());
    // Allow async providers to load
    await tester.pump(const Duration(milliseconds: 100));
    // The app should render without crashing
    expect(find.byType(WordSearchQuizApp), findsOneWidget);
  });
}

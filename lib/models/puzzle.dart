enum Difficulty { easy, medium, hard }

class Puzzle {
  final String id;
  final String title;
  final String slug;
  final String categoryId;
  final String categoryName;
  final String categorySlug;
  final List<String> words;
  final Difficulty difficulty;
  final int gridSize;
  final String description;
  final String createdAt;
  final int plays;

  const Puzzle({
    required this.id,
    required this.title,
    required this.slug,
    required this.categoryId,
    required this.categoryName,
    required this.categorySlug,
    required this.words,
    required this.difficulty,
    required this.gridSize,
    required this.description,
    required this.createdAt,
    required this.plays,
  });

  factory Puzzle.fromJson(Map<String, dynamic> json) {
    return Puzzle(
      id: json['id'] as String,
      title: json['title'] as String,
      slug: json['slug'] as String,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      categorySlug: json['categorySlug'] as String,
      words: (json['words'] as List<dynamic>).cast<String>(),
      difficulty: Difficulty.values.firstWhere(
        (d) => d.name == json['difficulty'],
        orElse: () => Difficulty.medium,
      ),
      gridSize: json['gridSize'] as int,
      description: json['description'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      plays: json['plays'] as int? ?? 0,
    );
  }
}

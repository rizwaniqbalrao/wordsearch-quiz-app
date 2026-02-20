class Category {
  final String id;
  final String name;
  final String slug;
  final String description;
  final int puzzleCount;
  final String icon;

  const Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.puzzleCount,
    this.icon = 'category',
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String,
      puzzleCount: json['puzzleCount'] as int,
      icon: json['icon'] as String? ?? 'category',
    );
  }
}

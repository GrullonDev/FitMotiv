class Exercise {
  final String id;
  final String name;
  final String? description;
  final int? reps;
  final int? seconds;
  final String? videoUrl;
  final String? imageUrl;
  final String category;

  const Exercise({
    required this.id,
    required this.name,
    this.description,
    this.reps,
    this.seconds,
    this.videoUrl,
    this.imageUrl,
    required this.category,
  });

  bool get isTimeBased => seconds != null && seconds! > 0;
}

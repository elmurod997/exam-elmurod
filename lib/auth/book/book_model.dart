class BookModel {
  final String id;
  final String title;
  final String author;
  final String subtitle;
  final String image;
  final String duration;
  final String ideas;
  final String description;
  final List<String> tags;
  final List<Map<String, dynamic>> chapters;
  final String audioUrl; 

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.subtitle,
    required this.image,
    required this.duration,
    required this.ideas,
    required this.description,
    required this.tags,
    required this.chapters,
    required this.audioUrl, 
  });
}

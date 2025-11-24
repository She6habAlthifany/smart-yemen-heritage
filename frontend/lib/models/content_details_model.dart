class ContentDetails {
  final String id;
  final String contentId;
  final String title;
  final String description;
  final String languageCode;
  final String? imageUrl;

  ContentDetails({
    required this.id,
    required this.contentId,
    required this.title,
    required this.description,
    required this.languageCode,
    this.imageUrl,
  });

  factory ContentDetails.fromJson(Map<String, dynamic> json) {
    return ContentDetails(
      id: json['_id'],
      contentId: json['content_id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      languageCode: json['language_code'] ?? '',
      imageUrl: json['image_url'],
    );
  }
}

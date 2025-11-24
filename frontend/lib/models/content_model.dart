class Content {
  final String id;
  final String title;
  final String description;
  final String? address;
  final String? lat;
  final String? imageUrl;

  Content({
    required this.id,
    required this.title,
    required this.description,
    this.address,
    this.lat,
    this.imageUrl,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json['_id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      address: json['address'],
      lat: json['lat'],
      imageUrl: json['image_url'],
    );
  }
}

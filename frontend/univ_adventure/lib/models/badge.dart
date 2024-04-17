class Badge {
  final String name;
  final String imageUrl;

  Badge({
    required this.name, 
    required this.imageUrl,
  });

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      name: json['name'],
      imageUrl: json['imageUrl'],
    );
  }
}
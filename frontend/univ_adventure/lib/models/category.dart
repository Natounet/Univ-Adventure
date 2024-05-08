class Category {
  final int id;
  final String name;
  final String description;
  final int orderOnHomePage;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.orderOnHomePage,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      orderOnHomePage: json['orderOnHomePage'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'orderOnHomePage': orderOnHomePage,
    };
  }
}

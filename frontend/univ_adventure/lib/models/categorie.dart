enum Category implements Comparable<Category> {
  exploration(
    name: "Exploration",
    description:
        "Rends-toi dans des lieux utiles, inattendus, secrets ou insolites...",
    orderOnHomePage: 3,
    id: 0,
  ),
  proDuNumerique(
    name: "Pro du numérique",
    description:
        "Utilise des outils numériques pour t'aider dans ta vie étudiante...",
    orderOnHomePage: 3,
    id: 1,
  ),
  vieEtudiantes(
    name: "Vie étudiantes",
    description:
        "Des quêtes pour t'inciter à participer la vie étudiante rennaise",
    orderOnHomePage: 3,
    id: 2,
  ),
  quetesRecurrentes(
    name: "Quêtes Récurrentes",
    description:
        "Des quêtes qui reviennent régulièrement pour t'aider dans ta vie étudiante",
    orderOnHomePage: 1,
    id: 3,
  ),
  actualites(
    name: "Actualités",
    description: "Des quêtes qui viennent d'arriver à ne pas rater !",
    orderOnHomePage: 2,
    id: 4,
  );

  const Category({
    required this.name,
    required this.description,
    required this.orderOnHomePage,
    required this.id,
  });

  final String name;
  final String description;
  final int orderOnHomePage;
  final int id;

  @override
  int compareTo(Category other) {
    return orderOnHomePage.compareTo(other.orderOnHomePage);
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    switch (json["id"]) {
      case 0:
        return Category.exploration;
      case 1:
        return Category.proDuNumerique;
      case 2:
        return Category.vieEtudiantes;
      case 3:
        return Category.quetesRecurrentes;
      case 4:
        return Category.actualites;
      default:
        throw Exception("Unknown Categorie id: ${json["id"]}");
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
    };
  }
}

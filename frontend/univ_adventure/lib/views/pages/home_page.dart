import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:univ_adventure/components/QuestMiniature.dart';
import 'package:univ_adventure/components/quest_card_location.dart';
import 'package:univ_adventure/models/location.dart';
import 'package:univ_adventure/models/quest.dart';
import 'package:univ_adventure/services/user_manager.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final QuestLocation quest = QuestLocation(
      questId: "1",
      title: "Lac au connard",
      subtitle: "Rends-toi au lac au connard.. canard !",
      description:
          "Près de l'ISTIC et du batiment 12D ce trouve un petit lac artificiel très sympa.\nRends-y toi et active ta localisation pour valider la quête.",
      iconPath: "https://docs.flutter.dev/assets/images/dash/dash-fainting.gif",
      xp: 300,
      category: "Exploration",
      categoryLevel: 1,
      questType: "exploration",
      location: const Location(
        name: "lac-aux-connards",
        latitude: 48.115332,
        longitude: -1.637858,
      ),
      imagePath:
          "https://docs.flutter.dev/assets/images/dash/dash-fainting.gif",
      regularity: null,
    );

    final QuestForm quest2 = QuestForm(
      questId: "2",
      title: "Ton emploi du temps",
      subtitle: "Met ton emploi du temps dans ton téléphone !",
      description:
          "Rends-toi sur l'ENT de l'Université de Rennes, va dans ton emploi du temps, et récupère le lien de tes cours. Puis, télécharge une application comme TimeCalendar, et importe ton emploi du temps. Colle le lien de tes cours ici pour valider la quête.",
      iconPath: "https://docs.flutter.dev/assets/images/dash/dash-fainting.gif",
      xp: 300,
      category: "Pro du numérique",
      categoryLevel: 1,
      questType: "form",
      form: [("lien de l'emploi du temps", "???")],
      regularity: null,
    );

    final QuestLocation queteRU = QuestLocation(
      questId: "2",
      title: "Mange au RU",
      subtitle: "Rends-toi au RU et mange un bon repas !",
      description:
          "Rends-toi au RU et mange un bon repas. Active ta localisation pour valider la quête.",
      iconPath: "https://docs.flutter.dev/assets/images/dash/dash-fainting.gif",
      xp: 300,
      category: "Quêtes Récurrentes",
      categoryLevel: 1,
      questType: "form",
      location: const Location(
        name: "RU Astrolabe",
        latitude: 48.115332,
        longitude: -1.637858,
      ),
      imagePath:
          "https://docs.flutter.dev/assets/images/dash/dash-fainting.gif",
      regularity: const Duration(days: 1),
    );

    final QuestForm questNews = QuestForm(
      questId: "2",
      title: "Découvre la programmation du diapason",
      subtitle: "La programmation du diapason est sortie, va la lire !",
      description:
          "Rends-toi sur le site du diapason, et récupère le lien de la programmation. Colle le lien ici pour valider la quête.",
      iconPath: "https://docs.flutter.dev/assets/images/dash/dash-fainting.gif",
      xp: 300,
      category: "Actualités",
      categoryLevel: 1,
      questType: "form",
      form: [("lien de l'emploi du temps", "???")],
      regularity: null,
    );

    final List<Quest> allQuests = [
      quest,
      quest,
      quest,
      quest,
      quest2,
      quest2,
      queteRU,
      questNews,
    ];
    final Map<String, String> categoriesDescriptions = {
      "Quêtes Récurrentes":
          "Des quêtes jounalière, hebdomadaire ou qui reviennent régulièrement et te permettent de gagner des points et obtenir des infos",
      "Actualités": "Des quêtes qui viennent d'arriver à ne pas rater !",
      "Exploration":
          "Rends-toi dans des lieux utiles, inattendus, secrets ou insolites...",
      "Pro du numérique":
          "Utilise des outils numériques pour t'aider dans ta vie étudiante...",
      "Vie étudiantes":
          "Des quêtes pour t'inciter à participer la vie étudiante rennaise",
    };

    final Map<String, List<Quest>> questsByCategorie = allQuests.fold(
      <String, List<Quest>>{},
      (Map<String, List<Quest>> acc, Quest quest) {
        if (acc[quest.category] == null) {
          acc[quest.category] = [];
        }
        acc[quest.category]!.add(quest);
        return acc;
      },
    );

    questsByCategorie["Quêtes Récurrentes"]!.sort(
      (a, b) => a.regularity!.inSeconds.compareTo(b.regularity!.inSeconds),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Add this line
        children: [
          for (final category in questsByCategorie.keys)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Add this line
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Add this line
                  children: [
                    Text(
                      category,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      categoriesDescriptions[category] ?? "",
                      style: const TextStyle(fontSize: 11.0),
                    ),
                    const Divider(),
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final quest in questsByCategorie[category]!)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: QuestMiniature(quest: quest),
                        ),
                    ],
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:univ_adventure/components/QuestMiniature.dart';
import 'package:univ_adventure/components/quest_card_location.dart';
import 'package:univ_adventure/models/location.dart';
import 'package:univ_adventure/models/quest.dart';
import 'package:univ_adventure/services/user_manager.dart';

import '../../models/categorie.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    int currentLevel = 0;

    final QuestLocation quest = QuestLocation(
      questId: "1",
      title: "Lac au connard",
      subtitle: "Rends-toi au lac au connard.. canard !",
      description:
          "Près de l'ISTIC et du batiment 12D ce trouve un petit lac artificiel très sympa.\nRends-y toi et active ta localisation pour valider la quête.",
      iconPath: "https://docs.flutter.dev/assets/images/dash/dash-fainting.gif",
      xp: 300,
      category: Category.exploration,
      categoryLevel: 1,
      questType: "exploration",
      location: const Location(
        name: "lac-aux-connards",
        latitude: 48.115332,
        longitude: -1.637858,
      ),
      imagePath:
          "https://docs.flutter.dev/assets/images/dash/dash-fainting.gif",
      unlockLevel: 0,
      regularity: null,
    );

    final QuestForm quest2 = QuestForm(
      questId: "2",
      title: "Ton EDT",
      subtitle: "Met ton emploi du temps dans ton téléphone !",
      description:
          "Rends-toi sur l'ENT de l'Université de Rennes, va dans ton emploi du temps, et récupère le lien de tes cours. Puis, télécharge une application comme TimeCalendar, et importe ton emploi du temps. Colle le lien de tes cours ici pour valider la quête.",
      iconPath: "https://docs.flutter.dev/assets/images/dash/dash-fainting.gif",
      xp: 300,
      category: Category.proDuNumerique,
      categoryLevel: 1,
      questType: "form",
      form: [("lien de l'emploi du temps", "???")],
      unlockLevel: 0,
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
      category: Category.quetesRecurrentes,
      categoryLevel: 1,
      questType: "form",
      location: const Location(
        name: "RU Astrolabe",
        latitude: 48.115332,
        longitude: -1.637858,
      ),
      imagePath:
          "https://docs.flutter.dev/assets/images/dash/dash-fainting.gif",
      unlockLevel: 0,
      regularity: const Duration(days: 1),
    );

    final QuestForm questNews = QuestForm(
      questId: "2",
      title: "Programme Diapason !",
      subtitle: "La programmation du diapason est sortie, va la lire !",
      description:
          "Rends-toi sur le site du diapason, et récupère le lien de la programmation. Colle le lien ici pour valider la quête.",
      iconPath: "https://docs.flutter.dev/assets/images/dash/dash-fainting.gif",
      xp: 300,
      category: Category.actualites,
      categoryLevel: 1,
      questType: "form",
      form: [("lien de l'emploi du temps", "???")],
      unlockLevel: 0,
      regularity: null,
    );

    final QuestLocation questNiveau2 = QuestLocation(
      questId: "1",
      title: "Le Héron",
      subtitle: "Rends-toi au lac au connard.. canard !",
      description:
          "Près de l'ISTIC et du batiment 12D ce trouve un petit lac artificiel très sympa.\nRends-y toi et active ta localisation pour valider la quête.",
      iconPath: "https://docs.flutter.dev/assets/images/dash/dash-fainting.gif",
      xp: 300,
      category: Category.exploration,
      categoryLevel: 1,
      questType: "exploration",
      location: const Location(
        name: "lac-aux-connards",
        latitude: 48.115332,
        longitude: -1.637858,
      ),
      imagePath:
          "https://docs.flutter.dev/assets/images/dash/dash-fainting.gif",
      unlockLevel: 1,
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
      questNiveau2,
    ];

    final List<Category> categories =
        allQuests.map((e) => e.category).toSet().toList();
    categories.sort();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Add this line
        children: [
          for (final category in categories)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Add this line
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Add this line
                  children: [
                    Text(
                      category.name,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      category.description,
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    const Divider(),
                  ],
                ),
                // ShaderMask permet de faire un dégradé vers le transparent sur le bord droit de la liste
                ShaderMask(
                  shaderCallback: (Rect rect) {
                    return const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.transparent,
                          Colors.red
                        ],
                        stops: [
                          0.85,
                          1.0
                        ] // 10% purple, 80% transparent, 10% purple
                        ).createShader(rect);
                  },
                  blendMode: BlendMode.dstOut,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final quest in allQuests
                            .where((e) => e.category == category)
                            .toList())
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: QuestMiniature(
                              quest: quest,
                              currentLevel: currentLevel,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}

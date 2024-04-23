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
    );

    final List<Quest> allQuests = [quest, quest, quest, quest, quest2, quest2];
    final Map<String, String> categoriesDescriptions = {
      "Exploration":
          "Rends-toi dans des lieux utiles, inattendus, secrets ou insolites...",
      "Pro du numérique":
          "Utilise des outils numériques pour t'aider dans ta vie étudiante...",
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

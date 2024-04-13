// lib/views/pages/profile_page.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: Align(
          alignment: Alignment.topLeft,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: ExactAssetImage(
                  "frontend/univ_adventure/assets/images/backgroundProfile.svg",
                ),
              ),
            ),
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://img.freepik.com/psd-gratuit/personne-celebrant-son-orientation-sexuelle_23-2150115662.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Modifier'),
                        )
                      ]),
                      ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(
                          height: 200,
                        ),
                        child: const Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('Nom: ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text('Prénom: ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text('Email: ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text('Téléphone: ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text('Adresse: ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ]),
                      )
                    ])),
          ),
        ));
  }
}

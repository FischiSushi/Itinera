import 'package:flutter/material.dart';

import 'package:itinera/lecons_grammaire_data.dart';
import 'package:itinera/main.dart';
import 'package:itinera/screens/lecon_detail_screen.dart';

// ============================================================
// RECHERCHE DE LEÇONS DE GRAMMAIRE
// ============================================================
//
// Recherche par titre ou sous-titre sur l'ensemble des leçons, tous
// volumes confondus (contrairement au chemin, qui n'affiche que le volume
// courant) : utile pour retrouver rapidement un point de grammaire précis
// sans devoir naviguer unité par unité.

List<Lecon> rechercherLecons(String requete) {
  final normalisee = requete.trim().toLowerCase();
  if (normalisee.isEmpty) return [];

  return construireParcoursComplet().where((lecon) {
    return lecon.titre.toLowerCase().contains(normalisee) ||
        lecon.sousTitre.toLowerCase().contains(normalisee);
  }).toList();
}

class RechercheLeconsScreen extends StatefulWidget {
  const RechercheLeconsScreen({super.key});

  @override
  State<RechercheLeconsScreen> createState() => _RechercheLeconsScreenState();
}

class _RechercheLeconsScreenState extends State<RechercheLeconsScreen> {
  String recherche = '';

  @override
  Widget build(BuildContext context) {
    final resultats = rechercherLecons(recherche);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          style: const TextStyle(color: texteClair),
          decoration: InputDecoration(
            hintText: 'Rechercher une leçon...',
            hintStyle: TextStyle(color: texteClair.withValues(alpha: 0.6)),
            border: InputBorder.none,
          ),
          onChanged: (valeur) {
            setState(() {
              recherche = valeur;
            });
          },
        ),
      ),
      body: recherche.trim().isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'Tape le nom d\'un point de grammaire pour le retrouver, '
                  'quel que soit le volume.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: texteAttenue),
                ),
              ),
            )
          : resultats.isEmpty
          ? const Center(
              child: Text(
                'Aucune leçon ne correspond.',
                style: TextStyle(color: texteAttenue),
              ),
            )
          : ListView.builder(
              itemCount: resultats.length,
              itemBuilder: (context, index) {
                final lecon = resultats[index];
                final complete = leconEstCompletee(lecon);

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: complete
                        ? accentViolet
                        : accentViolet.withValues(alpha: 0.2),
                    child: Icon(
                      lecon.icone,
                      color: complete ? Colors.white : accentViolet,
                    ),
                  ),
                  title: Text(
                    lecon.titre,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${anneeDe(lecon.unite)} · ${lecon.sousTitre}',
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LeconDetailScreen(lecon: lecon),
                      ),
                    );
                    if (mounted) setState(() {});
                  },
                );
              },
            ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:itinera/main.dart';

// ============================================================
// SUCCÈS
// ============================================================

class SuccesScreen extends StatefulWidget {
  const SuccesScreen({super.key});

  @override
  State<SuccesScreen> createState() => _SuccesScreenState();
}

class _SuccesScreenState extends State<SuccesScreen> {
  @override
  void initState() {
    super.initState();
    verifierNouveauxSucces();
  }

  @override
  Widget build(BuildContext context) {
    final debloques = succesDebloques();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Succès'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(child: badgeDeniers(coins())),
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          for (final categorie in categoriesSucces) ...[
            _entetesCategorie(categorie, debloques),
            for (final succes in succesDisponibles.where(
              (s) => s.categorie == categorie,
            ))
              _carteSucces(succes, debloques.contains(succes.id)),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  Widget _entetesCategorie(String categorie, Set<String> debloques) {
    final succesDeCetteCategorie = succesDisponibles.where(
      (s) => s.categorie == categorie,
    );

    if (succesDeCetteCategorie.isEmpty) return const SizedBox.shrink();

    final termines = succesDeCetteCategorie
        .where((s) => debloques.contains(s.id))
        .length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            categorie,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: accentViolet,
            ),
          ),
          Text(
            '$termines / ${succesDeCetteCategorie.length}',
            style: const TextStyle(color: texteAttenue, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _carteSucces(Succes succes, bool debloque) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),

      child: ListTile(
        leading: Icon(
          debloque ? succes.icone : Icons.lock,
          color: debloque ? accentViolet : texteAttenue,
        ),

        title: Text(
          succes.titre,
          style: TextStyle(
            color: debloque ? texteClair : texteAttenue,
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Text(succes.description),

        trailing: debloque
            ? const Icon(Icons.check_circle, color: Colors.green)
            : (succes.recompense > 0
                  ? badgeDeniers(succes.recompense, rayon: 10)
                  : null),
      ),
    );
  }
}

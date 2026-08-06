import 'package:flutter/material.dart';

import 'package:itinera/main.dart';
import 'package:itinera/design/palette.dart';

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
      backgroundColor: designFond,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('Succès'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.diamond, size: 20, color: designOr),
                  const SizedBox(width: 6),
                  Text(
                    '${coins()} denier${coins() == 1 ? '' : 's'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      body: DecoratedBox(
        decoration: BoxDecoration(gradient: designGradientFond),
        child: ListView(
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
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: designAccent,
            ),
          ),
          Text(
            '$termines / ${succesDeCetteCategorie.length}',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _carteSucces(Succes succes, bool debloque) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: designBlanc,
        borderRadius: BorderRadius.circular(20),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          leading: Icon(
            debloque ? succes.icone : Icons.lock,
            color: debloque ? designAccent : designNoir.withValues(alpha: 0.35),
          ),

          title: Text(
            succes.titre,
            style: TextStyle(
              color: debloque ? designNoir : designNoir.withValues(alpha: 0.35),
              fontWeight: FontWeight.bold,
            ),
          ),

          subtitle: Text(
            succes.description,
            style: TextStyle(color: designNoir.withValues(alpha: 0.6)),
          ),

          trailing: debloque
              ? const Icon(Icons.check_circle, color: Colors.green)
              : (succes.recompense > 0
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.diamond, size: 16, color: designOrTexte),
                          const SizedBox(width: 4),
                          Text(
                            '${succes.recompense}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: designOrTexte,
                            ),
                          ),
                        ],
                      )
                    : null),
        ),
      ),
    );
  }
}

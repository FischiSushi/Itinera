import 'package:flutter/material.dart';

import 'package:itinera/latin/declinaison.dart';
import 'package:itinera/design/palette.dart';
import 'package:itinera/design/widgets.dart';
import 'package:itinera/screens/paradigme_detail_screen.dart';

class GenerateurDeclinaisonScreen extends StatefulWidget {
  const GenerateurDeclinaisonScreen({super.key});

  @override
  State<GenerateurDeclinaisonScreen> createState() =>
      _GenerateurDeclinaisonScreenState();
}

class _GenerateurDeclinaisonScreenState
    extends State<GenerateurDeclinaisonScreen> {
  late final List<ParadigmeNominal> _tous = paradigmesDisponibles()
    ..sort((a, b) => a.lemme.compareTo(b.lemme));

  String _recherche = '';

  List<ParadigmeNominal> get _filtres {
    if (_recherche.trim().isEmpty) return _tous;

    final q = _recherche.trim().toLowerCase();
    return _tous
        .where(
          (p) =>
              p.lemme.toLowerCase().contains(q) ||
              p.traduction.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtres = _filtres;

    return Scaffold(
      backgroundColor: designFond,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('Générateur de déclinaisons'),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: designGradientFond),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Chercher un nom (latin ou français)',
                ),
                onChanged: (valeur) => setState(() => _recherche = valeur),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${filtres.length} noms disponibles (1re, 2e, 4e et 5e déclinaisons)',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: filtres.isEmpty
                  ? const Center(
                      child: Text(
                        'Aucun résultat.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: filtres.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final p = filtres[i];
                        return carteActionDesign(
                          icone: Icons.text_fields,
                          titre: p.lemme,
                          sousTitre:
                              '${p.traduction} · ${p.declinaison}e déclinaison',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ParadigmeDetailScreen(paradigme: p),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

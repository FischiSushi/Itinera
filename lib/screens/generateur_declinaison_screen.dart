import 'package:flutter/material.dart';

import 'package:itinera/latin/declinaison.dart';
import 'package:itinera/main.dart' show texteAttenue;
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
      appBar: AppBar(title: const Text('Générateur de déclinaisons')),
      body: Column(
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
                style: TextStyle(color: texteAttenue, fontSize: 12),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filtres.isEmpty
                ? Center(
                    child: Text(
                      'Aucun résultat.',
                      style: TextStyle(color: texteAttenue),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtres.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final p = filtres[i];
                      return ListTile(
                        title: Text(p.lemme),
                        subtitle: Text('${p.traduction} · ${p.declinaison}e déclinaison'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ParadigmeDetailScreen(paradigme: p),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

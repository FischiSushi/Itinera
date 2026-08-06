import 'package:flutter/material.dart';

import 'package:itinera/main.dart';
import 'package:itinera/screens/ajouter_vocabulaire_screen.dart';
import 'package:itinera/design/palette.dart';
import 'package:itinera/design/widgets.dart';

// ============================================================
// MES TEXTES : ÉCRANS
// ============================================================

class MesTextesScreen extends StatefulWidget {
  const MesTextesScreen({super.key});

  @override
  State<MesTextesScreen> createState() => _MesTextesScreenState();
}

class _MesTextesScreenState extends State<MesTextesScreen> {
  Future<void> _supprimer(MonTexte texte) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer ce texte ?'),
          content: Text('« ${texte.titre} » sera définitivement supprimé.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );

    if (confirme == true) {
      supprimerMonTexte(texte.id);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final textes = mesTextes();

    return Scaffold(
      backgroundColor: designFond,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('Mes textes'),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: designAccent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Ajouter un texte'),
        onPressed: () async {
          final ajoute = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AjouterTexteScreen()),
          );

          if (ajoute == true) setState(() {});
        },
      ),

      body: DecoratedBox(
        decoration: BoxDecoration(gradient: designGradientFond),
        child: textes.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    'Pas encore de texte. Ajoute ton premier texte latin à '
                    'analyser !',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),

                itemCount: textes.length,

                itemBuilder: (context, index) {
                  final texte = textes[index];
                  final nombreMots = texte.texte
                      .split(RegExp(r'\s+'))
                      .where((m) => m.isNotEmpty)
                      .length;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CarteDesign(
                      padding: EdgeInsets.zero,
                      child: ListTile(
                        iconColor: designAccent,
                        textColor: designNoir,
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          texte.titre,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '$nombreMots mots · ${texte.tags.length} annoté(s)',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _supprimer(texte),
                        ),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AnalyseTexteScreen(texteId: texte.id),
                            ),
                          );
                          setState(() {});
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class AjouterTexteScreen extends StatefulWidget {
  const AjouterTexteScreen({super.key});

  @override
  State<AjouterTexteScreen> createState() => _AjouterTexteScreenState();
}

class _AjouterTexteScreenState extends State<AjouterTexteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titreController = TextEditingController();
  final _texteController = TextEditingController();

  @override
  void dispose() {
    _titreController.dispose();
    _texteController.dispose();
    super.dispose();
  }

  void _soumettre() {
    if (!_formKey.currentState!.validate()) return;

    ajouterMonTexte(_titreController.text.trim(), _texteController.text.trim());
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: designFond,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('Ajouter un texte'),
      ),

      body: DecoratedBox(
        decoration: BoxDecoration(gradient: designGradientFond),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _titreController,
                  decoration: const InputDecoration(labelText: 'Titre'),
                  validator: (valeur) =>
                      (valeur == null || valeur.trim().isEmpty)
                      ? 'Champ requis'
                      : null,
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _texteController,
                  decoration: const InputDecoration(
                    labelText: 'Texte latin',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 12,
                  minLines: 6,
                  validator: (valeur) =>
                      (valeur == null || valeur.trim().isEmpty)
                      ? 'Champ requis'
                      : null,
                ),

                const SizedBox(height: 24),

                ElevatedButton(
                  style: styleBoutonAccent,
                  onPressed: _soumettre,
                  child: const Text('Enregistrer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Fonctions grammaticales proposées pour le marquage (mêmes catégories que
// la leçon "Les fonctions dans la phrase") + leur abréviation d'affichage.
const _fonctionsDisponibles = [
  'Sujet',
  'COD',
  'COI',
  'CN',
  'CC de temps',
  'CC de lieu',
  'CC de manière',
  'CC de cause',
  'CC de moyen',
  'Apostrophe',
  'Attribut du sujet',
  'Apposition',
  'Autre',
];

const _abreviationsFonctions = {
  'Sujet': 'S',
  'COD': 'COD',
  'COI': 'COI',
  'CN': 'CN',
  'CC de temps': 'CCT',
  'CC de lieu': 'CCL',
  'CC de manière': 'CCM',
  'CC de cause': 'CCC',
  'CC de moyen': 'CCMoy',
  'Apostrophe': 'Apostr.',
  'Attribut du sujet': 'Attr.',
  'Apposition': 'Appos.',
  'Autre': '?',
};

String _motSansPonctuation(String mot) {
  return mot.replaceAll(RegExp('^[.,;:!?«»"\'()]+|[.,;:!?«»"\'()]+\$'), '');
}

class AnalyseTexteScreen extends StatefulWidget {
  final String texteId;

  const AnalyseTexteScreen({super.key, required this.texteId});

  @override
  State<AnalyseTexteScreen> createState() => _AnalyseTexteScreenState();
}

class _AnalyseTexteScreenState extends State<AnalyseTexteScreen> {
  late MonTexte _texte;

  @override
  void initState() {
    super.initState();
    _texte = mesTextes().firstWhere((t) => t.id == widget.texteId);
  }

  String? _fonctionPour(int index) {
    for (final tag in _texte.tags) {
      if (tag.index == index) return tag.fonction;
    }
    return null;
  }

  void _definirFonction(int index, String mot, String? fonction) {
    final nouveauxTags = _texte.tags.where((t) => t.index != index).toList();

    if (fonction != null) {
      nouveauxTags.add(TagMot(index: index, mot: mot, fonction: fonction));
    }

    setState(() {
      _texte = MonTexte(
        id: _texte.id,
        titre: _texte.titre,
        texte: _texte.texte,
        tags: nouveauxTags,
      );
    });

    mettreAJourTagsTexte(_texte.id, nouveauxTags);
  }

  Future<void> _ouvrirActionsMot(int index, String motBrut) async {
    final motPropre = _motSansPonctuation(motBrut);
    final fonctionActuelle = _fonctionPour(index);

    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    motPropre,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.search),
                title: const Text('Chercher le mot'),
                onTap: () => Navigator.pop(context, 'chercher'),
              ),
              ListTile(
                leading: const Icon(Icons.label_outline),
                title: const Text('Marquer sa fonction'),
                subtitle: fonctionActuelle != null
                    ? Text('Actuellement : $fonctionActuelle')
                    : null,
                onTap: () => Navigator.pop(context, 'fonction'),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );

    if (!mounted || action == null) return;

    if (action == 'chercher') {
      await _chercherMot(motPropre);
    } else if (action == 'fonction') {
      await _choisirFonction(index, motPropre, fonctionActuelle);
    }
  }

  Future<void> _choisirFonction(int index, String mot, String? actuelle) async {
    const retirer = '__retirer__';

    final choix = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Fonction de « $mot »',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final fonction in _fonctionsDisponibles)
                      ListTile(
                        title: Text(fonction),
                        trailing: actuelle == fonction
                            ? const Icon(Icons.check, color: accentViolet)
                            : null,
                        onTap: () => Navigator.pop(context, fonction),
                      ),
                    if (actuelle != null)
                      ListTile(
                        leading: const Icon(Icons.close, color: Colors.red),
                        title: const Text('Retirer le marquage'),
                        onTap: () => Navigator.pop(context, retirer),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );

    if (choix == null) return;

    _definirFonction(index, mot, choix == retirer ? null : choix);
  }

  Future<void> _chercherMot(String mot) async {
    final resultatsClasse = chercherDansVocabulaire(mot);

    if (!mounted) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mot,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                if (resultatsClasse.isNotEmpty) ...[
                  const Text(
                    'Dans ton vocabulaire de classe :',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: accentViolet,
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (final v in resultatsClasse)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text('${v.latin} — ${v.francais}'),
                    ),
                ] else ...[
                  const Text(
                    'Aucune correspondance trouvée.',
                    style: TextStyle(color: texteAttenue),
                  ),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Ajouter à mon vocabulaire'),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const AjouterVocabulaireScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final segments = RegExp(
      r'\S+|\s+',
    ).allMatches(_texte.texte).map((m) => m[0]!).toList();

    var indexMot = 0;
    final spans = <InlineSpan>[];

    for (final segment in segments) {
      if (segment.trim().isEmpty) {
        spans.add(
          TextSpan(text: segment, style: const TextStyle(fontSize: 17)),
        );
        continue;
      }

      final indexActuel = indexMot;
      indexMot++;
      final fonction = _fonctionPour(indexActuel);

      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: GestureDetector(
            onTap: () => _ouvrirActionsMot(indexActuel, segment),
            child: Text(
              fonction != null
                  ? '$segment${_abreviationsFonctions[fonction] ?? ''}'
                  : segment,
              style: TextStyle(
                fontSize: 17,
                height: 1.6,
                decoration: fonction != null ? TextDecoration.underline : null,
                decorationColor: designOr,
                color: fonction != null ? designOr : Colors.white,
                fontWeight: fonction != null ? FontWeight.bold : null,
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: designFond,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text(_texte.titre),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: designGradientFond),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Text.rich(
            TextSpan(children: spans, style: const TextStyle(height: 1.6)),
          ),
        ),
      ),
    );
  }
}

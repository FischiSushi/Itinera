import 'package:flutter/material.dart';

import 'package:itinera/main.dart';
import 'package:itinera/vocabulaire_data.dart';

// ============================================================
// AJOUTER UN MOT
// ============================================================

class AjouterVocabulaireScreen extends StatefulWidget {
  const AjouterVocabulaireScreen({super.key});

  @override
  State<AjouterVocabulaireScreen> createState() =>
      _AjouterVocabulaireScreenState();
}

class _AjouterVocabulaireScreenState extends State<AjouterVocabulaireScreen> {
  final _formKey = GlobalKey<FormState>();

  final _latinController = TextEditingController();
  final _francaisController = TextEditingController();
  final _etymologieController = TextEditingController();

  late TextEditingController _uniteController;
  late TextEditingController _categorieController;

  @override
  void dispose() {
    _latinController.dispose();
    _francaisController.dispose();
    _etymologieController.dispose();
    super.dispose();
  }

  void _soumettre() {
    if (!_formKey.currentState!.validate()) return;

    ajouterVocabulairePersonnalise(
      latin: _latinController.text.trim(),
      francais: _francaisController.text.trim(),
      unite: _uniteController.text.trim(),
      categorie: _categorieController.text.trim(),
      etymologie: _etymologieController.text,
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final unitesExistantes = vocabulaire
        .map((mot) => mot.unite)
        .toSet()
        .toList();

    final categoriesExistantes = vocabulaire
        .map((mot) => mot.categorie)
        .toSet()
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un mot')),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: ListView(
            children: [
              TextFormField(
                controller: _latinController,
                decoration: const InputDecoration(labelText: 'Latin'),
                validator: (valeur) => (valeur == null || valeur.trim().isEmpty)
                    ? 'Champ requis'
                    : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _francaisController,
                decoration: const InputDecoration(labelText: 'Français'),
                validator: (valeur) => (valeur == null || valeur.trim().isEmpty)
                    ? 'Champ requis'
                    : null,
              ),

              const SizedBox(height: 16),

              Autocomplete<String>(
                optionsBuilder: (textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return unitesExistantes;
                  }

                  return unitesExistantes.where(
                    (unite) => unite.toLowerCase().contains(
                      textEditingValue.text.toLowerCase(),
                    ),
                  );
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                      _uniteController = controller;

                      return TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          labelText: 'Unité',
                          helperText: 'Existante ou nouvelle',
                        ),
                        validator: (valeur) =>
                            (valeur == null || valeur.trim().isEmpty)
                            ? 'Champ requis'
                            : null,
                      );
                    },
              ),

              const SizedBox(height: 16),

              Autocomplete<String>(
                optionsBuilder: (textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return categoriesExistantes;
                  }

                  return categoriesExistantes.where(
                    (categorie) => categorie.toLowerCase().contains(
                      textEditingValue.text.toLowerCase(),
                    ),
                  );
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                      _categorieController = controller;

                      return TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          labelText: 'Catégorie',
                          helperText: 'Existante ou nouvelle',
                        ),
                        validator: (valeur) =>
                            (valeur == null || valeur.trim().isEmpty)
                            ? 'Champ requis'
                            : null,
                      );
                    },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _etymologieController,
                decoration: const InputDecoration(
                  labelText: 'Étymologie (optionnel)',
                ),
                maxLines: 2,
              ),

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _soumettre,
                child: const Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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

      body: ListView.builder(
        padding: const EdgeInsets.all(16),

        itemCount: succesDisponibles.length,

        itemBuilder: (context, index) {
          final succes = succesDisponibles[index];
          final debloque = debloques.contains(succes.id);

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
        },
      ),
    );
  }
}

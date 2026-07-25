import 'package:flutter/material.dart';

import 'package:itinera/locutions_data.dart';
import 'package:itinera/main.dart';

class LocutionsScreen extends StatelessWidget {
  const LocutionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phrases & proverbes')),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),

        itemCount: locutions.length,

        itemBuilder: (context, index) {
          final locution = locutions[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            clipBehavior: Clip.antiAlias,

            child: ExpansionTile(
              title: Text(
                locution.latin,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        locution.francais,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        locution.contexte,
                        style: const TextStyle(color: texteAttenue),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

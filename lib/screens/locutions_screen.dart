import 'package:flutter/material.dart';

import 'package:itinera/locutions_data.dart';
import 'package:itinera/design/palette.dart';

class LocutionsScreen extends StatelessWidget {
  const LocutionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: designFond,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('Phrases & proverbes'),
      ),

      body: DecoratedBox(
        decoration: BoxDecoration(gradient: designGradientFond),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),

          itemCount: locutions.length,

          itemBuilder: (context, index) {
            final locution = locutions[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: designBlanc,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  iconColor: designAccent,
                  collapsedIconColor: designNoir.withValues(alpha: 0.6),
                  title: Text(
                    locution.latin,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: designNoir,
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
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: designNoir,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            locution.contexte,
                            style: TextStyle(
                              color: designNoir.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

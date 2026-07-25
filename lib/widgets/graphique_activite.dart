import 'package:flutter/material.dart';

import 'package:itinera/main.dart' show accentViolet, texteAttenue, surfaceWidget;

// Petit graphique en barres : révisions par jour sur les N derniers jours.
// Série unique (pas de légende nécessaire) — le jour en cours ressort dans
// l'accent, l'historique reste dans une teinte atténuée de la même couleur.
class GraphiqueActivite extends StatefulWidget {
  final List<int> revisionsParJour;

  const GraphiqueActivite({super.key, required this.revisionsParJour});

  @override
  State<GraphiqueActivite> createState() => _GraphiqueActiviteState();
}

class _GraphiqueActiviteState extends State<GraphiqueActivite> {
  int? _jourSelectionne;

  static const _initialesJours = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

  DateTime _dateDuJour(int index) {
    final decalage = widget.revisionsParJour.length - 1 - index;
    return DateTime.now().subtract(Duration(days: decalage));
  }

  @override
  Widget build(BuildContext context) {
    final valeurs = widget.revisionsParJour;
    final dernierIndex = valeurs.length - 1;
    final indexAffiche = _jourSelectionne ?? dernierIndex;
    final maxValeur = valeurs.fold(0, (m, v) => v > m ? v : m);
    final total = valeurs.fold(0, (s, v) => s + v);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceWidget,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Activité récente',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '$total révisions',
                style: TextStyle(color: texteAttenue, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            indexAffiche == dernierIndex
                ? '${valeurs[indexAffiche]} aujourd\'hui'
                : '${valeurs[indexAffiche]} le ${_dateDuJour(indexAffiche).day}/${_dateDuJour(indexAffiche).month}',
            style: TextStyle(color: texteAttenue, fontSize: 12),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 92,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (int i = 0; i < valeurs.length; i++) ...[
                  if (i > 0) const SizedBox(width: 2),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setState(() => _jourSelectionne = i),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            height: maxValeur == 0
                                ? 4
                                : 4 + (valeurs[i] / maxValeur) * 60,
                            decoration: BoxDecoration(
                              color: i == indexAffiche
                                  ? accentViolet
                                  : accentViolet.withValues(alpha: 0.3),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _initialesJours[_dateDuJour(i).weekday - 1],
                            style: TextStyle(
                              fontSize: 10,
                              color: i == dernierIndex
                                  ? accentViolet
                                  : texteAttenue,
                              fontWeight: i == dernierIndex
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

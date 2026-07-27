import 'package:flutter_test/flutter_test.dart';
import 'package:fsrs/fsrs.dart' as fsrs;
import 'package:itinera/vocabulaire_data.dart';

// Chaque sens de révision (Latin -> Français / Français -> Latin) a sa
// propre carte FSRS (Vocabulaire.fsrsCards) : reconnaître un mot et le
// produire sont deux compétences différentes, donc réviser l'un ne doit
// pas faire progresser l'autre.

void main() {
  final scheduler = fsrs.Scheduler();

  Vocabulaire motDeTest() => Vocabulaire(
    latin: 'rosa',
    francais: 'rose',
    unite: 'test',
    categorie: 'Noms',
  );

  test('un mot neuf est neuf dans les deux sens', () {
    final mot = motDeTest();
    expect(mot.estNouveau, isTrue);
    expect(mot.carte(directionLatinVersFrancais).lastReview, isNull);
    expect(mot.carte(directionFrancaisVersLatin).lastReview, isNull);
  });

  test('réviser un sens ne touche pas l\'autre', () {
    final mot = motDeTest();

    final resultat = scheduler.reviewCard(
      mot.carte(directionLatinVersFrancais),
      fsrs.Rating.good,
    );
    mot.definirCarte(directionLatinVersFrancais, resultat.card);

    expect(mot.carte(directionLatinVersFrancais).lastReview, isNotNull);
    expect(mot.carte(directionFrancaisVersLatin).lastReview, isNull);

    // "estNouveau" ne redevient faux que si AU MOINS un sens a été révisé,
    // mais le mot n'est plus "neuf" au global dès qu'un sens a progressé.
    expect(mot.estNouveau, isFalse);
  });

  test('estDu est vrai si au moins un sens est en retard', () {
    final mot = motDeTest();
    final dansLeFutur = DateTime.now().toUtc().add(const Duration(days: 365));

    // Neuf : due par défaut est déjà passée (ou "maintenant"), donc dû.
    expect(mot.estDu(dansLeFutur), isTrue);

    // On avance artificiellement la carte Latin -> Français loin dans le
    // futur : elle seule ne devrait plus être due, mais l'autre sens
    // (toujours neuf) l'est toujours.
    final carteRepoussee = mot
        .carte(directionLatinVersFrancais)
        .copyWith(due: dansLeFutur.add(const Duration(days: 365)));
    mot.definirCarte(directionLatinVersFrancais, carteRepoussee);

    expect(mot.estDu(dansLeFutur), isTrue); // Français -> Latin encore dû
  });
}

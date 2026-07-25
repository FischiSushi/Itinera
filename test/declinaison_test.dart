import 'package:flutter_test/flutter_test.dart';
import 'package:itinera/latin/declinaison.dart';
import 'package:itinera/vocabulaire_data.dart';

Vocabulaire _nom(String latin) => Vocabulaire(
      latin: latin,
      francais: 'x',
      unite: 'test',
      categorie: 'Noms',
    );

void main() {
  test('1re déclinaison (aqua, ae, f.)', () {
    final p = genererParadigme(_nom('aqua, ae, f.'))!;
    expect(p.declinaison, 1);
    expect(p.singulier[Cas.nominatif], 'aqua');
    expect(p.singulier[Cas.genitif], 'aquae');
    expect(p.singulier[Cas.accusatif], 'aquam');
    expect(p.pluriel[Cas.genitif], 'aquarum');
    expect(p.pluriel[Cas.datif], 'aquis');
  });

  test('2e déclinaison masc. (dominus, i, m.)', () {
    final p = genererParadigme(_nom('dominus, i, m.'))!;
    expect(p.declinaison, 2);
    expect(p.singulier[Cas.vocatif], 'domine');
    expect(p.singulier[Cas.genitif], 'domini');
    expect(p.pluriel[Cas.accusatif], 'dominos');
    expect(p.pluriel[Cas.genitif], 'dominorum');
  });

  test('2e déclinaison neutre (bellum, i, n.)', () {
    final p = genererParadigme(_nom('bellum, i, n.'))!;
    expect(p.singulier[Cas.nominatif], 'bellum');
    expect(p.singulier[Cas.accusatif], 'bellum');
    expect(p.pluriel[Cas.nominatif], 'bella');
    expect(p.pluriel[Cas.genitif], 'bellorum');
  });

  test('2e déclinaison en -ius (filius, i, m.) : vocatif en -i', () {
    final p = genererParadigme(_nom('filius, i, m.'))!;
    expect(p.singulier[Cas.vocatif], 'fili');
  });

  test('2e déclinaison radical irrégulier (ager, agri, m.)', () {
    final p = genererParadigme(_nom('ager, agri, m.'))!;
    expect(p.singulier[Cas.nominatif], 'ager');
    expect(p.singulier[Cas.vocatif], 'ager');
    expect(p.singulier[Cas.genitif], 'agri');
    expect(p.singulier[Cas.accusatif], 'agrum');
    expect(p.pluriel[Cas.nominatif], 'agri');
  });

  test('4e déclinaison (manus, us, f.)', () {
    final p = genererParadigme(_nom('manus, us, f.'))!;
    expect(p.declinaison, 4);
    expect(p.singulier[Cas.genitif], 'manus');
    expect(p.singulier[Cas.datif], 'manui');
    expect(p.pluriel[Cas.datif], 'manibus');
  });

  test('5e déclinaison (res, ei, f.)', () {
    final p = genererParadigme(_nom('res, ei, f.'))!;
    expect(p.declinaison, 5);
    expect(p.singulier[Cas.genitif], 'rei');
    expect(p.singulier[Cas.accusatif], 'rem');
    expect(p.singulier[Cas.ablatif], 're');
    expect(p.pluriel[Cas.genitif], 'rerum');
  });

  test('3e déclinaison exclue (non fiable à reconstruire)', () {
    expect(genererParadigme(_nom('rex, regis, m.')), isNull);
    expect(genererParadigme(_nom('corpus, oris, n.')), isNull);
  });

  test('pluriel tantum exclu', () {
    expect(genererParadigme(_nom('gemelli, orum, m. pl.')), isNull);
  });

  test('locutions et non-noms exclus', () {
    expect(
      genererParadigme(
        Vocabulaire(
          latin: 'consilium capere + inf.',
          francais: 'x',
          unite: 'test',
          categorie: 'Verbes',
        ),
      ),
      isNull,
    );
  });
}

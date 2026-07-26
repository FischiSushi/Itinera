export 'lecons_core.dart';

import 'lecons_core.dart';
import 'lecons_data_1.dart';
import 'lecons_data_2.dart';
import 'lecons_data_3.dart';
import 'lecons_data_4.dart';
import 'lecons_data_5.dart';


final List<Lecon> parcoursLeconsGrammaire = [
  // Unité 1
  leconFonctionsPhrase,
  leconCasIntro,
  leconDeclinaison1,
  leconVerbeEtre,
  leconOrdreMots,
  leconMethodeAnalyse,
  // Unité 2, 3, ... (garder ces leçons groupées par unité : le chemin
  // affiche un séparateur à chaque changement d'unité, donc les leçons
  // d'une même unité doivent rester contiguës dans cette liste).
  leconPhraseSimpleComplexe,
  leconDeclinaison2,
  leconConjonctions,
  // Unité 3
  leconNeutre2eDecl,
  leconAdjectifs1reClasse,
  leconVerbeLatin,
  // Unité 4
  leconEsseComposes,
  leconInterrogationSimple,
  // Unité 5
  leconImparfaitActif,
  leconACI,
  // Unité 6
  leconEmploisEsse,
  leconVoixPassive,
  leconPassifFrancais,
  // Unité 7
  leconDeclinaison3,
  leconIndicatifParfait,
  leconInfinitifParfaitACI,
  // Unité 8
  leconAdjectifs2eClasse,
  leconParticipePresentActif,
  leconComparatifSuperlatif,
  // Unité 9
  leconSupinPPP,
  leconAblatifAbsolu,
  leconTechniqueTraductionAA,
  // Unité 10
  leconPronomIsEaId,
  leconPronomRelatif,
  leconEmploisRelatif,
  // Vol. II – Unité 1
  leconIndicatifFutur,
  leconFuturAnterieurPPF,
  leconSubordonneeConditionnelleIndicatif,
  // Vol. II – Unité 2
  leconDemonstratifsHicIsteIlle,
  leconCCTemps,
  leconCCLieu,
  // Vol. II – Unité 3
  leconDeclinaison4,
  leconPronomIdem,
  leconPronomIpse,
  // Vol. II – Unité 4
  leconInterrogatifsExclamatifs,
  leconParticipeInfinitifFuturs,
  // Vol. II – Unité 5
  leconPronomsPersonnelsPossessifs,
  leconReflechisDirectIndirect,
  leconAdjectifsNumeraux,
  // Vol. II – Unité 6
  leconDeclinaison5,
  leconSubjonctifPresentImparfait,
  leconCompletivesSubjonctif,
  // Vol. II – Unité 7
  leconUnusSolusTotusNullus,
  leconNemoNihil,
  leconNegationCoordinationSubordination,
  leconFerreComposes,
  // Vol. II – Unité 8
  leconSubjonctifParfaitPlusQueParfait,
  leconSubordonneesBut,
  leconSubordonneesConsequence,
  // Vol. II – Unité 9
  leconIreComposes,
  leconRappelPrefixesComposes,
  leconAliusAlterUter,
  // Vol. II – Unité 10
  leconImperatif,
  leconVelleNolleMalle,
  leconOrdreDefense,
  // Vol. III – Unité 1
  leconTempsParfaitPassif,
  leconFieri,
  leconConjonctionDum,
  // Vol. III – Unité 2
  leconPassifsPersonnelImpersonnelNCI,
  leconIndefinisQuidamAliquisQuis,
  leconComparaisonDeDeux,
  // Vol. III – Unité 3
  leconVerbesDeponents,
  leconAdverbesManiereQuam,
  leconAdjectifsRaresInusites,
  // Vol. III – Unité 4
  leconSystemesConditionnels,
  leconSubjonctifPropositionsPrincipales,
  leconDoubleDatif,
  // Vol. III – Unité 5
  leconSubordonneesRelativesComplements,
  leconComplementsProvenanceSeparationQualite,
  // Vol. III – Unité 6
  leconGerondif,
  leconAdjectifVerbalObligation,
  leconVerbesImpersonnels,
  // Vol. III – Unité 7
  leconConcession,
  leconComparaisonSubordonnee,
  // Vol. III – Unité 8
  leconInterrogationIndirecte,
  leconDiscoursIndirect,
  leconQuisqueQuicumqueQuisquis,
  // Vol. III – Unité 9
  leconCauseReelleAllegueeRepoussee,
  leconParticularitesAccord,
  leconAspectDuVerbe,
];

List<Lecon> construireParcoursComplet() => parcoursLeconsGrammaire;


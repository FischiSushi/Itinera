import 'package:flutter_tts/flutter_tts.dart';

// Aucun moteur TTS grand public ne propose de voix latine — l'italien est
// l'approximation la plus proche disponible partout (voyelles quasi
// identiques, "c"/"g" durs), donc c'est ce qu'on utilise pour prononcer
// le latin plutôt que de laisser la langue du système (souvent français)
// déformer les mots.
const _langueApprochante = 'it-IT';

class TtsService {
  TtsService._();

  static final TtsService instance = TtsService._();

  final FlutterTts _tts = FlutterTts();
  bool _pret = false;

  Future<void> _initialiser() async {
    if (_pret) return;
    await _tts.setLanguage(_langueApprochante);
    await _tts.setSpeechRate(0.4);
    _pret = true;
  }

  Future<void> prononcer(String texte) async {
    await _initialiser();
    await _tts.stop();
    await _tts.speak(texte);
  }
}

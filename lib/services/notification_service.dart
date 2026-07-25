import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

// Rappel quotidien pour protéger la série (streak). Un seul créneau
// horaire, activable/désactivable depuis les Paramètres — pas besoin de
// plus pour un rappel "n'oublie pas de réviser aujourd'hui".

const _rappelActifKey = 'rappelActif';
const _rappelHeureKey = 'rappelHeure';
const _rappelMinuteKey = 'rappelMinute';
const _rappelIdNotification = 1;

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialise = false;

  Future<void> _initialiser() async {
    if (_initialise) return;

    tz_data.initializeTimeZones();
    try {
      final fuseau = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(fuseau.identifier));
    } catch (_) {
      // Repli sur UTC si le fuseau natif n'est pas reconnu par le paquet
      // timezone : le rappel reste fonctionnel, juste pas garanti à
      // l'heure locale exacte.
    }

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
        macOS: DarwinInitializationSettings(),
      ),
    );

    _initialise = true;
  }

  bool rappelActif() {
    final box = Hive.box('vocabBox');
    return (box.get(_rappelActifKey) as bool?) ?? false;
  }

  TimeOfDayValeur heureRappel() {
    final box = Hive.box('vocabBox');
    return TimeOfDayValeur(
      heure: (box.get(_rappelHeureKey) as int?) ?? 19,
      minute: (box.get(_rappelMinuteKey) as int?) ?? 0,
    );
  }

  // Retourne false si la permission de notifier a été refusée : l'appelant
  // doit alors informer l'utilisateur plutôt que d'activer silencieusement.
  Future<bool> activerRappel({required int heure, required int minute}) async {
    await _initialiser();

    final autorise = await _demanderPermission();
    if (!autorise) return false;

    final box = Hive.box('vocabBox');
    await box.put(_rappelActifKey, true);
    await box.put(_rappelHeureKey, heure);
    await box.put(_rappelMinuteKey, minute);

    await _programmer(heure, minute);
    return true;
  }

  Future<void> desactiverRappel() async {
    await _initialiser();

    final box = Hive.box('vocabBox');
    await box.put(_rappelActifKey, false);
    await _plugin.cancel(id: _rappelIdNotification);
  }

  // À appeler au démarrage de l'app pour reprogrammer le rappel si
  // l'utilisateur l'avait activé lors d'une session précédente (les
  // notifications programmées ne survivent pas forcément à un redémarrage
  // de l'appareil sur toutes les plateformes).
  Future<void> reprogrammerSiActif() async {
    if (!rappelActif()) return;

    await _initialiser();
    final heure = heureRappel();
    await _programmer(heure.heure, heure.minute);
  }

  Future<bool> _demanderPermission() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      return (await android.requestNotificationsPermission()) ?? false;
    }

    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      return (await ios.requestPermissions(alert: true, badge: true, sound: true)) ??
          false;
    }

    final macos = _plugin.resolvePlatformSpecificImplementation<
        MacOSFlutterLocalNotificationsPlugin>();
    if (macos != null) {
      return (await macos.requestPermissions(alert: true, badge: true, sound: true)) ??
          false;
    }

    // Linux/Windows/web : pas de permission explicite à demander.
    return true;
  }

  Future<void> _programmer(int heure, int minute) async {
    final maintenant = tz.TZDateTime.now(tz.local);
    var date = tz.TZDateTime(
      tz.local,
      maintenant.year,
      maintenant.month,
      maintenant.day,
      heure,
      minute,
    );

    if (date.isBefore(maintenant)) {
      date = date.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      id: _rappelIdNotification,
      title: 'Série en jeu 🔥',
      body: 'Prends deux minutes pour réviser ton latin aujourd\'hui.',
      scheduledDate: date,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'rappel_serie',
          'Rappel de série',
          channelDescription: 'Rappel quotidien pour ne pas perdre ta série',
          importance: Importance.defaultImportance,
        ),
        iOS: DarwinNotificationDetails(),
        macOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}

class TimeOfDayValeur {
  final int heure;
  final int minute;
  const TimeOfDayValeur({required this.heure, required this.minute});
}

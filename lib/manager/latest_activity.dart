import 'dart:convert';
import 'dart:io';
import 'package:fitness/models/latest_activity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class LatestActivityManager {
  static final LatestActivityManager _instance = LatestActivityManager._internal();
  factory LatestActivityManager() => _instance;
  LatestActivityManager._internal();

  List<LatestActivity> _activities = [];
  late File _file;

  Future<void> initialize() async {
    final directory = await getApplicationDocumentsDirectory();
    _file = File(path.join(directory.path, 'latestActivityData.json'));
    await _ensureFileExists();
    await loadActivities();
  }

  Future<void> _ensureFileExists() async {
    if (!await _file.exists()) {
      try {
        await _file.create(recursive: true);
        await _file.writeAsString('[]'); // Initialise avec un tableau vide
      } catch (e) {
        print('Erreur lors de la création du fichier: $e');
        // Essayer de créer le répertoire parent si nécessaire
        final parent = Directory(path.dirname(_file.path));
        if (!await parent.exists()) {
          await parent.create(recursive: true);
          await _file.create(recursive: true);
          await _file.writeAsString('[]');
        }
      }
    }
  }

  Future<void> loadActivities() async {
    try {
      final contents = await _file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);
      _activities = jsonList.map((json) => LatestActivity.fromJson(json)).toList();
      sortActivitiesByCreatedAt(descending: false);
    } catch (e) {
      print('Error loading activities: $e');
      _activities = [];
    }
  }

  Future<void> saveActivities() async {
    try {
      final jsonList = _activities.map((activity) => activity.toJson()).toList();
      await _file.writeAsString(json.encode(jsonList));
    } catch (e) {
      print('Error saving activities: $e');
    }
  }

  void addActivity(LatestActivity activity) {
    // Génère un ID si non fourni
    activity.id ??= DateTime.now().millisecondsSinceEpoch;
    _activities.add(activity);
  }

  List<LatestActivity> get activities => List.unmodifiable(_activities);

  // Pour supprimer une activité
  void removeActivity(int id) {
    _activities.removeWhere((activity) => activity.id == id);
  }

  void sortActivitiesByCreatedAt({bool descending = true}) {
    _activities.sort((a, b) {
      final aDate = a.createdAt;
      final bDate = b.createdAt;

      // Gestion des valeurs null (placées à la fin)
      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return 1;
      if (bDate == null) return -1;

      // Comparaison normale
      return descending ? bDate.compareTo(aDate) : aDate.compareTo(bDate);
    });
  }
}
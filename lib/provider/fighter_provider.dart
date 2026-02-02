import 'package:cage/models/fighter_model.dart';
import 'package:cage/models/fighter_filter_model.dart';
import 'package:cage/models/user_model.dart';
import 'package:cage/repository/review_repository.dart';
import 'package:cage/services/firebase_cache_helper.dart';
import 'package:cage/utils/location_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FighterProvider with ChangeNotifier {
  List<UserModel> _fighters = [];
  bool _isLoading = false;
  String? _error;

  List<UserModel> get fighters => _fighters;
  bool get isLoading => _isLoading;
  String? get error => _error;

  static final _fightersQuery = FirebaseFirestore.instance
      .collection('userData')
      .where('role', isEqualTo: 'Fighter');

  /// Parse QuerySnapshot into fighters list (shared for cache + server).
  static List<UserModel> _parseFighters(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final Map<String, dynamic> data =
          (doc.data() as Map<String, dynamic>?) ?? <String, dynamic>{};
      DateTime createdAt;
      try {
        if (data['createdAt'] is Timestamp) {
          createdAt = (data['createdAt'] as Timestamp).toDate();
        } else if (data['createdAt'] is DateTime) {
          createdAt = data['createdAt'] as DateTime;
        } else {
          createdAt = DateTime.now();
        }
      } catch (_) {
        createdAt = DateTime.now();
      }

      FighterDataModel? fighterData;
      try {
        if (data['fighterData'] != null) {
          fighterData = FighterDataModel.fromMap(
            data['fighterData'] as Map<String, dynamic>,
          );
        } else {
          final fighterMap = <String, dynamic>{
            'age': data['age'] ?? 0,
            'coachContact': data['coachContact'] ?? '',
            'coachName': data['coachName'] ?? '',
            'fightingStyle': data['fightingStyle'],
            'fightWin': data['fightWin'] ?? 0,
            'fightsKnockout': data['fightsKnockout'] ?? 0,
            'fightsLose': data['fightsLose'] ?? 0,
            'fightsStyle': data['fightsStyle'] ?? 'options',
            'fullName': data['fullName'] ?? '',
            'height': data['height'] ?? '',
            'lastBlood': data['lastBlood'] ?? 0,
            'lastExam': data['lastExam'] ?? '0',
            'uploadProfile': data['uploadProfile'],
            'urlProfile': data['urlProfile'] ?? 'https',
            'weight': data['weight'],
          };
          fighterData = FighterDataModel.fromMap(fighterMap);
        }
      } catch (_) {
        // Keep fighterData null on parse error
      }

      return UserModel(
        id: doc.id,
        email: data['email'] as String? ?? '',
        createdAt: createdAt,
        roleData: fighterData,
      );
    }).toList();
  }

  /// Fetch fighters: show cache immediately if available, then refresh from server.
  Future<void> fetchFighters() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final cached = await FirebaseCacheHelper.getQueryFromCache(_fightersQuery);
      if (cached != null && cached.docs.isNotEmpty) {
        _fighters = _parseFighters(cached);
        _isLoading = false;
        notifyListeners();
        FirebaseCacheHelper.debugLog('Fighters: showing ${_fighters.length} from cache');
      }

      final snapshot = await FirebaseCacheHelper.getQueryFromServer(_fightersQuery);
      _fighters = _parseFighters(snapshot);
      _error = null;
    } catch (e) {
      if (_fighters.isEmpty) _error = e.toString();
      FirebaseCacheHelper.debugLog('Error fetching fighters: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<UserModel> searchFighters(String query) {
    if (query.isEmpty) return _fighters;
    return _fighters.where((fighter) {
      if (fighter.roleData is FighterDataModel) {
        final fd = fighter.roleData as FighterDataModel;
        return fd.fullName.toLowerCase().contains(query.toLowerCase());
      }
      return false;
    }).toList();
  }

  Future<List<UserModel>> filterFighters({
    required List<UserModel> fighters,
    required FighterFilterModel filter,
  }) async {
    List<UserModel> filtered = List.from(fighters);

    if (filter.fightingStyle != null && filter.fightingStyle!.isNotEmpty) {
      filtered = filtered.where((fighter) {
        if (fighter.roleData is FighterDataModel) {
          final fd = fighter.roleData as FighterDataModel;
          return fd.fightingStyle?.toLowerCase() ==
              filter.fightingStyle!.toLowerCase();
        }
        return false;
      }).toList();
    }

    if (filter.weight != null && filter.weight!.isNotEmpty) {
      filtered = filtered.where((fighter) {
        if (fighter.roleData is FighterDataModel) {
          final fd = fighter.roleData as FighterDataModel;
          final w = fd.weight ?? '';
          return w.toLowerCase().contains(filter.weight!.toLowerCase());
        }
        return false;
      }).toList();
    }

    if (filter.minRating != null && filter.maxRating != null) {
      final withRating = <UserModel>[];
      for (final fighter in filtered) {
        try {
          final rating = await ReviewRepository.getAverageRating(fighter.id);
          if (rating >= filter.minRating! && rating <= filter.maxRating!) {
            withRating.add(fighter);
          }
        } catch (_) {}
      }
      filtered = withRating;
    }

    if (filter.radiusInKm != null &&
        filter.userLatitude != null &&
        filter.userLongitude != null) {
      filtered = filtered.where((fighter) {
        if (fighter.roleData is FighterDataModel) {
          final fd = fighter.roleData as FighterDataModel;
          if (fd.latitude != null && fd.longitude != null) {
            final distance = LocationHelper.calculateDistance(
              filter.userLatitude!,
              filter.userLongitude!,
              fd.latitude!,
              fd.longitude!,
            );
            return (distance / 1000) <= filter.radiusInKm!;
          }
        }
        return false;
      }).toList();
    }

    if (filter.sortBy == 'new') {
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else if (filter.sortBy == 'old') {
      filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }

    return filtered;
  }

  UserModel? getFighterById(String id) {
    try {
      return _fighters.firstWhere((f) => f.id == id);
    } catch (_) {
      return null;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> refresh() async => fetchFighters();
}

import 'package:cage/models/promoter_filter_model.dart';
import 'package:cage/models/promoter_model.dart';
import 'package:cage/models/user_model.dart';
import 'package:cage/repository/review_repository.dart';
import 'package:cage/services/firebase_cache_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum SortOption {
  distance,
  rating,
  emailAZ,
  emailZA,
  newToOld,
  oldToNew,
}

class PromoterProvider with ChangeNotifier {
  List<UserModel> _promoters = [];
  bool _isLoading = false;
  String? _error;
  SortOption? _currentSort;

  List<UserModel> get promoters => _promoters;
  bool get isLoading => _isLoading;
  String? get error => _error;
  SortOption? get currentSort => _currentSort;

  static final _promotersQuery = FirebaseFirestore.instance
      .collection('userData')
      .where('role', isEqualTo: 'Promoter');

  static List<UserModel> _parsePromoters(QuerySnapshot snapshot) {
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

      PromoterDataModel? promoterData;
      try {
        if (data['promoterData'] != null) {
          promoterData = PromoterDataModel.fromMap(
            data['promoterData'] as Map<String, dynamic>,
          );
        } else {
          final promoterMap = <String, dynamic>{
            'companyAbout': data['companyAbout'],
            'companyLogo': data['companyLogo'],
            'companyName': data['companyName'],
            'contactEmail': data['contactEmail'],
            'contactNumber': data['contactNumber'],
            'eventHistory': data['eventHistory'],
            'prompterName': data['prompterName'],
            'location': data['location'],
            'numberOfEvents': data['numberOfEvents'],
          };
          promoterData = PromoterDataModel.fromMap(promoterMap);
        }
      } catch (_) {}

      return UserModel(
        id: doc.id,
        email: data['email'] as String? ?? '',
        createdAt: createdAt,
        roleData: promoterData,
      );
    }).toList();
  }

  Future<void> fetchPromoters() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final cached = await FirebaseCacheHelper.getQueryFromCache(_promotersQuery);
      if (cached != null && cached.docs.isNotEmpty) {
        _promoters = _parsePromoters(cached);
        _isLoading = false;
        notifyListeners();
        FirebaseCacheHelper.debugLog('Promoters: showing ${_promoters.length} from cache');
      }

      final snapshot = await FirebaseCacheHelper.getQueryFromServer(_promotersQuery);
      _promoters = _parsePromoters(snapshot);
      _error = null;
    } catch (e) {
      if (_promoters.isEmpty) _error = e.toString();
      FirebaseCacheHelper.debugLog('Error fetching promoters: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search promoters by company name and promoter name only
  List<UserModel> searchPromoters(String query) {
    if (query.isEmpty) return _promoters;

    final queryLower = query.toLowerCase().trim();

    return _promoters.where((promoter) {
      if (promoter.roleData is PromoterDataModel) {
        final promoterData = promoter.roleData as PromoterDataModel;
        final companyName = (promoterData.companyName ?? '').toLowerCase();
        final promoterName = (promoterData.prompterName ?? '').toLowerCase();
        return companyName.contains(queryLower) ||
            promoterName.contains(queryLower);
      }
      return false;
    }).toList();
  }

  // Get promoter by ID
  UserModel? getPromoterById(String id) {
    try {
      return _promoters.firstWhere((promoter) => promoter.id == id);
    } catch (e) {
      return null;
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Refresh data
  Future<void> refresh() async {
    await fetchPromoters();
  }




  // Sort and filter promoters (synchronous version)
  List<UserModel> getFilteredAndSortedPromoters({
    String searchQuery = '',
    SortOption? sortOption,
  }) {
    List<UserModel> filtered = searchQuery.isEmpty
        ? List.from(_promoters)
        : searchPromoters(searchQuery);

    // Apply sorting
    if (sortOption != null) {
      _currentSort = sortOption;
      filtered = _sortPromoters(filtered, sortOption);
    }

    return filtered;
  }

  // Sort promoters based on option
  List<UserModel> _sortPromoters(List<UserModel> promoters, SortOption sortOption) {
    final sorted = List<UserModel>.from(promoters);

    switch (sortOption) {
      case SortOption.emailAZ:
        sorted.sort((a, b) {
          final emailA = (a.roleData as PromoterDataModel?)?.contactEmail ?? '';
          final emailB = (b.roleData as PromoterDataModel?)?.contactEmail ?? '';
          return emailA.toLowerCase().compareTo(emailB.toLowerCase());
        });
        break;

      case SortOption.emailZA:
        sorted.sort((a, b) {
          final emailA = (a.roleData as PromoterDataModel?)?.contactEmail ?? '';
          final emailB = (b.roleData as PromoterDataModel?)?.contactEmail ?? '';
          return emailB.toLowerCase().compareTo(emailA.toLowerCase());
        });
        break;

      case SortOption.newToOld:
        sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;

      case SortOption.oldToNew:
        sorted.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;

      case SortOption.rating:
        // This will need async handling, so we'll sort by a placeholder for now
        // In the UI, we'll need to handle this differently
        break;

      case SortOption.distance:
        // This will need async handling for location
        break;
    }

    return sorted;
  }

  // Sort by rating (async version)
  Future<List<UserModel>> sortByRating(List<UserModel> promoters) async {
    final ratings = <String, double>{};
    
    for (final promoter in promoters) {
      final rating = await ReviewRepository.getAveragePromoterRating(promoter.id);
      ratings[promoter.id] = rating;
    }

    final sorted = List<UserModel>.from(promoters);
    sorted.sort((a, b) {
      final ratingA = ratings[a.id] ?? 0.0;
      final ratingB = ratings[b.id] ?? 0.0;
      return ratingB.compareTo(ratingA); // Descending (highest first)
    });

    return sorted;
  }

  // Filter promoters with comprehensive filters
  Future<List<UserModel>> filterPromoters({
    required List<UserModel> promoters,
    required PromoterFilterModel filter,
  }) async {
    List<UserModel> filtered = List.from(promoters);

    // Filter by rating range
    if (filter.minRating != null && filter.maxRating != null) {
      final filteredWithRating = <UserModel>[];
      for (var promoter in filtered) {
        try {
          final rating = await ReviewRepository.getAveragePromoterRating(promoter.id);
          // Check if rating is within the range (inclusive)
          if (rating >= filter.minRating! && rating <= filter.maxRating!) {
            filteredWithRating.add(promoter);
          }
        } catch (_) {}
      }
      filtered = filteredWithRating;
    }

    // Filter by minimum review count
    if (filter.minReviewCount != null && filter.minReviewCount! > 0) {
      final filteredWithReviewCount = <UserModel>[];
      for (var promoter in filtered) {
        try {
          final reviewCount = await ReviewRepository.getPromoterReviewsCount(promoter.id);
          if (reviewCount >= filter.minReviewCount!) {
            filteredWithReviewCount.add(promoter);
          }
        } catch (_) {}
      }
      filtered = filteredWithReviewCount;
    }

    // Filter by number of events (min and max)
    if (filter.minNumberOfEvents != null || filter.maxNumberOfEvents != null) {
      filtered = filtered.where((promoter) {
        if (promoter.roleData is PromoterDataModel) {
          final promoterData = promoter.roleData as PromoterDataModel;
          final numberOfEvents = promoterData.numberOfEvents ?? 0;
          
          if (filter.minNumberOfEvents != null && numberOfEvents < filter.minNumberOfEvents!) {
            return false;
          }
          if (filter.maxNumberOfEvents != null && numberOfEvents > filter.maxNumberOfEvents!) {
            return false;
          }
          return true;
        }
        return false;
      }).toList();
    }

    return filtered;
  }
}

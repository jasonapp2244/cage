import 'package:cage/models/promoter_model.dart';
import 'package:cage/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PromoterProvider with ChangeNotifier {
  List<UserModel> _promoters = [];
  bool _isLoading = false;
  String? _error;

  List<UserModel> get promoters => _promoters;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch all promoters from Firestore
  Future<void> fetchPromoters() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('Fetching promoters from Firestore...');
      final snapshot = await FirebaseFirestore.instance
          .collection('userData')
          .where('role', isEqualTo: 'Promoter')
          .get();

      print('Found ${snapshot.docs.length} promoters in Firestore');

      _promoters = snapshot.docs.map((doc) {
        final data = doc.data();
        print('Processing promoter document: ${doc.id}');
        print('Document data: $data');

        // Safe date parsing
        DateTime createdAt;
        try {
          if (data['createdAt'] is Timestamp) {
            createdAt = (data['createdAt'] as Timestamp).toDate();
          } else if (data['createdAt'] is DateTime) {
            createdAt = data['createdAt'] as DateTime;
          } else {
            createdAt = DateTime.now();
          }
        } catch (e) {
          createdAt = DateTime.now();
        }

        // Parse promoter data - try both promoterData and direct fields
        PromoterDataModel? promoterData;
        try {
          if (data['promoterData'] != null) {
            promoterData = PromoterDataModel.fromMap(data['promoterData']);
          } else {
            // Try to create promoter data from direct fields
            final promoterMap = {
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
            print('Created promoter map: $promoterMap');
            promoterData = PromoterDataModel.fromMap(promoterMap);
          }
        } catch (e) {
          print('Error parsing promoter data: $e');
          print('Data that caused error: ${data['promoterData'] ?? data}');
        }

        return UserModel(
          id: doc.id,
          email: data['email'] ?? '',
          createdAt: createdAt,
          roleData: promoterData,
        );
      }).toList();

      print('Successfully processed ${_promoters.length} promoters');
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error fetching promoters: $e');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search promoters by name
  List<UserModel> searchPromoters(String query) {
    if (query.isEmpty) return _promoters;

    return _promoters.where((promoter) {
      if (promoter.roleData is PromoterDataModel) {
        final promoterData = promoter.roleData as PromoterDataModel;
        final companyName = promoterData.companyName ?? '';
        final promoterName = promoterData.prompterName ?? '';
        return companyName.toLowerCase().contains(query.toLowerCase()) ||
            promoterName.toLowerCase().contains(query.toLowerCase());
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
}

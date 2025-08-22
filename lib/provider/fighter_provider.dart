import 'package:cage/models/fighter_model.dart';
import 'package:cage/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FighterProvider with ChangeNotifier {
  List<UserModel> _fighters = [];
  bool _isLoading = false;
  String? _error;

  List<UserModel> get fighters => _fighters;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch all fighters from Firestore
  Future<void> fetchFighters() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('Fetching fighters from Firestore...');
      final snapshot = await FirebaseFirestore.instance
          .collection('userData')
          .where('role', isEqualTo: 'Fighter')
          .get();

      print('Found ${snapshot.docs.length} fighters in Firestore');

      _fighters = snapshot.docs.map((doc) {
        final data = doc.data();
        print('Processing fighter document: ${doc.id}');
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

        // Parse fighter data - try both fighterData and direct fields
        FighterDataModel? fighterData;
        try {
          if (data['fighterData'] != null) {
            print('Found fighterData: ${data['fighterData']}');
            fighterData = FighterDataModel.fromMap(data['fighterData']);
          } else {
            // Try to create fighter data from direct fields
            print('No fighterData found, trying direct fields...');
            final fighterMap = {
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
            print('Created fighter map: $fighterMap');
            fighterData = FighterDataModel.fromMap(fighterMap);
          }
        } catch (e) {
          print('Error parsing fighter data: $e');
          print('Data that caused error: ${data['fighterData'] ?? data}');
        }

        return UserModel(
          id: doc.id,
          email: data['email'] ?? '',
          createdAt: createdAt,
          roleData: fighterData,
        );
      }).toList();

      print('Successfully processed ${_fighters.length} fighters');
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error fetching fighters: $e');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search fighters by name
  List<UserModel> searchFighters(String query) {
    if (query.isEmpty) return _fighters;

    return _fighters.where((fighter) {
      if (fighter.roleData is FighterDataModel) {
        final fighterData = fighter.roleData as FighterDataModel;
        return fighterData.fullName.toLowerCase().contains(query.toLowerCase());
      }
      return false;
    }).toList();
  }

  // Get fighter by ID
  UserModel? getFighterById(String id) {
    try {
      return _fighters.firstWhere((fighter) => fighter.id == id);
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
    await fetchFighters();
  }
}

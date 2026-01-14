import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cage/models/report_model.dart';
import 'package:cage/utils/routes/utils.dart';

class ReportRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'userReports';

  // Check if a user has already reported another user
  static Future<bool> hasAlreadyReported({
    required String reporterId,
    required String reportedUserId,
  }) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('reporterUserId', isEqualTo: reporterId)
          .where('reportedUserId', isEqualTo: reportedUserId)
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking if already reported: $e');
      return false;
    }
  }

  // Submit a report about a user
  static Future<void> submitReport({
    required String reportedUserId,
    required String reason,
    String? description,
  }) async {
    try {
      final reporterId = Utils.getCurrentUid();

      // Check if the user has already reported this user
      final alreadyReported = await hasAlreadyReported(
        reporterId: reporterId,
        reportedUserId: reportedUserId,
      );

      if (alreadyReported) {
        throw Exception('You have already reported this user. Each user can only report another user once.');
      }

      // Get reporter's information
      final reporterDoc = await _firestore
          .collection('userData')
          .doc(reporterId)
          .get();

      if (!reporterDoc.exists) {
        throw Exception('Reporter user not found');
      }

      final reporterData = reporterDoc.data()!;
      String reporterName = 'Unknown User';
      String reporterRole = reporterData['role'] ?? 'User';

      // Determine name and role based on role field first, then fallback to data objects
      if (reporterRole == 'Fighter') {
        if (reporterData['fighterData'] != null) {
          final fighterData = reporterData['fighterData'] as Map<String, dynamic>;
          reporterName = fighterData['fullName'] ?? 'Unknown Fighter';
        } else {
          reporterName = 'Unknown Fighter';
        }
      } else if (reporterRole == 'Promoter') {
        if (reporterData['promoterData'] != null) {
          final promoterData = reporterData['promoterData'] as Map<String, dynamic>;
          reporterName = promoterData['companyName'] ?? promoterData['prompterName'] ?? 'Unknown Promoter';
        } else {
          reporterName = 'Unknown Promoter';
        }
      } else {
        // Fallback: if role is not set, try to infer from data
        if (reporterData['promoterData'] != null) {
          final promoterData = reporterData['promoterData'] as Map<String, dynamic>;
          if (promoterData['companyName'] != null || promoterData['prompterName'] != null) {
            reporterRole = 'Promoter';
            reporterName = promoterData['companyName'] ?? promoterData['prompterName'] ?? 'Unknown Promoter';
          }
        }
        if (reporterRole == 'User' && reporterData['fighterData'] != null) {
          final fighterData = reporterData['fighterData'] as Map<String, dynamic>;
          if (fighterData['fullName'] != null) {
            reporterRole = 'Fighter';
            reporterName = fighterData['fullName'] ?? 'Unknown Fighter';
          }
        }
      }

      // Get reported user's information
      final reportedDoc = await _firestore
          .collection('userData')
          .doc(reportedUserId)
          .get();

      if (!reportedDoc.exists) {
        throw Exception('Reported user not found');
      }

      final reportedData = reportedDoc.data()!;
      String reportedName = 'Unknown User';
      String reportedRole = reportedData['role'] ?? 'User';

      // Determine name and role based on role field first, then fallback to data objects
      if (reportedRole == 'Fighter') {
        if (reportedData['fighterData'] != null) {
          final fighterData = reportedData['fighterData'] as Map<String, dynamic>;
          reportedName = fighterData['fullName'] ?? 'Unknown Fighter';
        } else {
          reportedName = 'Unknown Fighter';
        }
      } else if (reportedRole == 'Promoter') {
        if (reportedData['promoterData'] != null) {
          final promoterData = reportedData['promoterData'] as Map<String, dynamic>;
          reportedName = promoterData['companyName'] ?? promoterData['prompterName'] ?? 'Unknown Promoter';
        } else {
          reportedName = 'Unknown Promoter';
        }
      } else {
        // Fallback: if role is not set, try to infer from data
        if (reportedData['promoterData'] != null) {
          final promoterData = reportedData['promoterData'] as Map<String, dynamic>;
          if (promoterData['companyName'] != null || promoterData['prompterName'] != null) {
            reportedRole = 'Promoter';
            reportedName = promoterData['companyName'] ?? promoterData['prompterName'] ?? 'Unknown Promoter';
          }
        }
        if (reportedRole == 'User' && reportedData['fighterData'] != null) {
          final fighterData = reportedData['fighterData'] as Map<String, dynamic>;
          if (fighterData['fullName'] != null) {
            reportedRole = 'Fighter';
            reportedName = fighterData['fullName'] ?? 'Unknown Fighter';
          }
        }
      }

      // Create report document
      final reportData = {
        'reportedUserId': reportedUserId,
        'reportedUserName': reportedName,
        'reportedUserRole': reportedRole,
        'reporterUserId': reporterId,
        'reporterUserName': reporterName,
        'reporterUserRole': reporterRole,
        'reason': reason,
        'description': description,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'pending',
      };

      await _firestore.collection(_collectionName).add(reportData);

      print('Report submitted successfully');
    } catch (e) {
      print('Error submitting report: $e');
      throw Exception('Failed to submit report: $e');
    }
  }

  // Get all reports (for admin panel)
  static Stream<List<ReportModel>> getAllReports() {
    return _firestore
        .collection(_collectionName)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['createdAt'] = (data['createdAt'] as Timestamp).toDate().toIso8601String();
        return ReportModel.fromJson(data, doc.id);
      }).toList();
    });
  }

  // Get reports for a specific user
  static Stream<List<ReportModel>> getReportsForUser(String userId) {
    return _firestore
        .collection(_collectionName)
        .where('reportedUserId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['createdAt'] = (data['createdAt'] as Timestamp).toDate().toIso8601String();
        return ReportModel.fromJson(data, doc.id);
      }).toList();
    });
  }
}

import 'dart:math';

class FighterDataModel {
  final int age;
  final String coachContact;
  final String coachName;
  final String? fightingStyle;
  final int fightWin;
  final int fightsKnockout;
  final int fightsLose;
  final String fightsStyle;
  final String fullName;
  final String height;
  final String lastBlood;
  final String lastExam;
  final String? eyeExam;
  final String? uploadProfile;
  final String urlProfile;
  final String? weight;
  final String? location;
  final double? latitude;
  final double? longitude;
  final List<dynamic>? reviews;

  FighterDataModel({
    required this.age,
    required this.coachContact,
    required this.coachName,
    this.fightingStyle,
    required this.fightWin,
    required this.fightsKnockout,
    required this.fightsLose,
    required this.fightsStyle,
    required this.fullName,
    required this.height,
    required this.lastBlood,
    required this.lastExam,
    this.eyeExam,
    this.uploadProfile,
    required this.urlProfile,
    this.weight,
    this.location,
    this.latitude,
    this.longitude,
    this.reviews,
  });

  factory FighterDataModel.fromMap(Map<String, dynamic> map) {
    return FighterDataModel(
      age: int.tryParse(map['age']?.toString() ?? '0') ?? 0,
      coachContact: map['coachContact'] ?? '',
      coachName: map['coachName'] ?? '',
      fightingStyle: map['fightingStyle'],
      fightWin: int.tryParse(map['fightWin']?.toString() ?? '0') ?? 0,
      fightsKnockout:
          int.tryParse(map['fightsKnockout']?.toString() ?? '0') ?? 0,
      fightsLose: int.tryParse(map['fightsLose']?.toString() ?? '0') ?? 0,
      fightsStyle: map['fightsStyle'] ?? 'options',
      fullName: map['fullName'] ?? '',
      height: map['height'] ?? '',
      //weight image location
      lastBlood: map['lastBlood'] ?? 'Not set',
      lastExam: map['lastExam'] ?? 'Not set',
      eyeExam: map['eyeExam'],
      uploadProfile: map['uploadProfile'],
      urlProfile: map['urlProfile'] ?? 'https',
      weight: map['weight'],
      location: map['selectLocation'] is Map<String, dynamic> 
          ? map['selectLocation']['address'] 
          : map['selectLocation']?.toString(),
      latitude: map['selectLocation'] is Map<String, dynamic> 
          ? map['selectLocation']['latitude']?.toDouble() 
          : null,
      longitude: map['selectLocation'] is Map<String, dynamic> 
          ? map['selectLocation']['longitude']?.toDouble() 
          : null,
      reviews: map['reviews'] != null ? List<dynamic>.from(map['reviews']) : null,
    );
  }
}

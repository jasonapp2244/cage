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
  final int lastBlood;
  final String lastExam;
  final String? uploadProfile;
  final String urlProfile;
  final String? weight;

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
    this.uploadProfile,
    required this.urlProfile,
    this.weight,
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
      fightsLose: int.tryParse(map['fightslose']?.toString() ?? '0') ?? 0,
      fightsStyle: map['fightsStyle'] ?? 'options',
      fullName: map['fullName'] ?? '',
      height: map['height'] ?? '',
      //weight image location
      lastBlood: int.tryParse(map['lastBlood']?.toString() ?? '0') ?? 0,
      lastExam: map['lastExam'] ?? '0',
      uploadProfile: map['uploadProfile'],
      urlProfile: map['urlProfile'] ?? 'https',
      weight: map['weight'],
    );
  }
}

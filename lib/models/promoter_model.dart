class PromoterDataModel {
  final String? companyAbout;
  final String? companyLogo;
  final String? companyName;
  final String? contactEmail;
  final String? contactNumber;
  final String? eventHistory;
  final String? prompterName;
  final String? location;
  final int? numberOfEvents;

  PromoterDataModel({
    this.companyAbout,
    this.companyLogo,
    this.companyName,
    this.contactEmail,
    this.contactNumber,
    this.eventHistory,
    this.prompterName,
    this.location,
    this.numberOfEvents,
  });

  factory PromoterDataModel.fromMap(Map<String, dynamic> map) {
    return PromoterDataModel(
      companyAbout: map['companyAbout'],
      companyLogo: map['companyLogo'],
      companyName: map['companyName'],
      contactEmail: map['contactEmail'],
      contactNumber: map['contactNumber'],
      eventHistory: map['eventHistory'],
      prompterName: map['prompterName'],
      location: map['location'],
      numberOfEvents: map['numberOfEvents'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'companyAbout': companyAbout,
      'companyLogo': companyLogo,
      'companyName': companyName,
      'contactEmail': contactEmail,
      'contactNumber': contactNumber,
      'eventHistory': eventHistory,
      'prompterName': prompterName,
      'location': location,
      'numberOfEvents': numberOfEvents,
    };
  }
}

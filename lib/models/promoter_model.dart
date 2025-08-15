class PromoterDataModel {
  final String? companyAbout;
  final String? companyLogo;
  final String? companyName;
  final String? contactEmail;
  final String? contactNumber;
  //image

  PromoterDataModel({
    this.companyAbout,
    this.companyLogo,
    this.companyName,
    this.contactEmail,
    this.contactNumber,
  });

  factory PromoterDataModel.fromMap(Map<String, dynamic> map) {
    return PromoterDataModel(
      companyAbout: map['companyAbout'],
      companyLogo: map['companyLogo'],
      companyName: map['companyName'],
      contactEmail: map['contactEmail'],
      contactNumber: map['contactNumber'],
    );
  }
}

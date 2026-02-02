class FighterFilterModel {
  final double? minRating;
  final double? maxRating; // For rating range (e.g., 1.0-1.99)
  final String? sortBy; // 'new' or 'old'
  final String? fightingStyle;
  final String? weight;
  final double? radiusInKm;
  final double? userLatitude;
  final double? userLongitude;

  FighterFilterModel({
    this.minRating,
    this.maxRating,
    this.sortBy,
    this.fightingStyle,
    this.weight,
    this.radiusInKm,
    this.userLatitude,
    this.userLongitude,
  });

  bool get hasActiveFilters {
    return minRating != null ||
        maxRating != null ||
        sortBy != null ||
        fightingStyle != null ||
        weight != null ||
        (radiusInKm != null && userLatitude != null && userLongitude != null);
  }

  FighterFilterModel copyWith({
    double? minRating,
    double? maxRating,
    String? sortBy,
    String? fightingStyle,
    String? weight,
    double? radiusInKm,
    double? userLatitude,
    double? userLongitude,
  }) {
    return FighterFilterModel(
      minRating: minRating ?? this.minRating,
      maxRating: maxRating ?? this.maxRating,
      sortBy: sortBy ?? this.sortBy,
      fightingStyle: fightingStyle ?? this.fightingStyle,
      weight: weight ?? this.weight,
      radiusInKm: radiusInKm ?? this.radiusInKm,
      userLatitude: userLatitude ?? this.userLatitude,
      userLongitude: userLongitude ?? this.userLongitude,
    );
  }

  FighterFilterModel clear() {
    return FighterFilterModel();
  }
}

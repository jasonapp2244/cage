class PromoterFilterModel {
  final double? minRating;
  final double? maxRating; // For rating range (e.g., 1.0-1.99)
  final int? minReviewCount;
  final int? minNumberOfEvents;
  final int? maxNumberOfEvents;

  PromoterFilterModel({
    this.minRating,
    this.maxRating,
    this.minReviewCount,
    this.minNumberOfEvents,
    this.maxNumberOfEvents,
  });

  bool get hasActiveFilters {
    return minRating != null ||
        maxRating != null ||
        minReviewCount != null ||
        minNumberOfEvents != null ||
        maxNumberOfEvents != null;
  }

  PromoterFilterModel copyWith({
    double? minRating,
    double? maxRating,
    int? minReviewCount,
    int? minNumberOfEvents,
    int? maxNumberOfEvents,
  }) {
    return PromoterFilterModel(
      minRating: minRating ?? this.minRating,
      maxRating: maxRating ?? this.maxRating,
      minReviewCount: minReviewCount ?? this.minReviewCount,
      minNumberOfEvents: minNumberOfEvents ?? this.minNumberOfEvents,
      maxNumberOfEvents: maxNumberOfEvents ?? this.maxNumberOfEvents,
    );
  }

  PromoterFilterModel clear() {
    return PromoterFilterModel();
  }
}

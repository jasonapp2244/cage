import 'package:cage/models/fighter_filter_model.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/services/fighting_styles_service.dart';
import 'package:cage/utils/location_helper.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FighterFilterDialog extends StatefulWidget {
  final FighterFilterModel currentFilter;
  final double? userLatitude;
  final double? userLongitude;

  const FighterFilterDialog({
    super.key,
    required this.currentFilter,
    this.userLatitude,
    this.userLongitude,
  });

  @override
  State<FighterFilterDialog> createState() => _FighterFilterDialogState();
}

class _FighterFilterDialogState extends State<FighterFilterDialog> {
  late FighterFilterModel _filter;
  final FightingStylesService _fightingStylesService = FightingStylesService();
  List<String> _fightingStyles = [];
  bool _isLoadingStyles = true;
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _radiusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filter = widget.currentFilter;
    _weightController.text = widget.currentFilter.weight ?? '';
    _radiusController.text = widget.currentFilter.radiusInKm?.toString() ?? '';
    _loadFightingStyles();
    _loadUserLocation();
  }

  Future<void> _loadFightingStyles() async {
    try {
      final styles = await _fightingStylesService.getAllFightingStyles();
      setState(() {
        _fightingStyles = styles;
        _isLoadingStyles = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingStyles = false;
      });
    }
  }

  Future<void> _loadUserLocation() async {
    if (widget.userLatitude == null || widget.userLongitude == null) {
      try {
        final uid = Utils.getCurrentUid();
        final location = await LocationHelper.getSavedLocation(uid);
        if (location != null && mounted) {
          setState(() {
            _filter = _filter.copyWith(
              userLatitude: location.latitude,
              userLongitude: location.longitude,
            );
          });
        }
      } catch (e) {
        print('Error loading user location: $e');
      }
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Dialog(
      backgroundColor: AppColor.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColor.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter Fighters',
                    style: GoogleFonts.dmSans(
                      color: AppColor.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: AppColor.white),
                  ),
                ],
              ),
            ),

            // Filter Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Star Rating Filter
                    _buildSectionTitle('Star Rating'),
                    SizedBox(height: Responsive.h(1)),
                    _buildStarRatingFilter(),
                    SizedBox(height: Responsive.h(2)),

                    // Sort By (New/Old)
                    _buildSectionTitle('Sort By'),
                    SizedBox(height: Responsive.h(1)),
                    _buildSortByFilter(),
                    SizedBox(height: Responsive.h(2)),

                    // Fighting Style Filter
                    _buildSectionTitle('Fighting Style'),
                    SizedBox(height: Responsive.h(1)),
                    _buildFightingStyleFilter(),
                    SizedBox(height: Responsive.h(2)),

                    // Weight Filter
                    _buildSectionTitle('Weight'),
                    SizedBox(height: Responsive.h(1)),
                    _buildWeightFilter(),
                    SizedBox(height: Responsive.h(2)),

                    // Radius Filter
                    _buildSectionTitle('Radius (km)'),
                    SizedBox(height: Responsive.h(1)),
                    _buildRadiusFilter(),
                    SizedBox(height: Responsive.h(2)),
                  ],
                ),
              ),
            ),

            // Action Buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppColor.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context, _filter.clear());
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColor.red),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Clear All',
                        style: GoogleFonts.dmSans(
                          color: AppColor.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: Responsive.w(3)),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, _filter);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Apply Filters',
                        style: GoogleFonts.dmSans(
                          color: AppColor.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.dmSans(
        color: AppColor.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildStarRatingFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColor.white.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Star Rating',
            style: GoogleFonts.dmSans(
              color: AppColor.white.withValues(alpha: 0.7),
              fontSize: 14,
            ),
          ),
          SizedBox(height: Responsive.h(1)),
          Row(
            children: List.generate(5, (index) {
              final rating = index + 1.0;
              final minRating = rating;
              final maxRating = rating + 0.99;
              final isSelected = _filter.minRating != null &&
                  _filter.maxRating != null &&
                  _filter.minRating! == minRating &&
                  _filter.maxRating! == maxRating;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _filter = _filter.copyWith(minRating: null, maxRating: null);
                    } else {
                      _filter = _filter.copyWith(
                        minRating: minRating,
                        maxRating: maxRating,
                      );
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    isSelected ? Icons.star : Icons.star_border,
                    color: isSelected ? AppColor.red : AppColor.white.withValues(alpha: 0.5),
                    size: 32,
                  ),
                ),
              );
            }),
          ),
          if (_filter.minRating != null && _filter.maxRating != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                '${_filter.minRating!.toStringAsFixed(1)} - ${_filter.maxRating!.toStringAsFixed(2)} stars',
                style: GoogleFonts.dmSans(
                  color: AppColor.red,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSortByFilter() {
    return Row(
      children: [
        Expanded(
          child: _buildFilterChip(
            label: 'New',
            isSelected: _filter.sortBy == 'new',
            onTap: () {
              setState(() {
                _filter = _filter.copyWith(
                  sortBy: _filter.sortBy == 'new' ? null : 'new',
                );
              });
            },
          ),
        ),
        SizedBox(width: Responsive.w(2)),
        Expanded(
          child: _buildFilterChip(
            label: 'Old',
            isSelected: _filter.sortBy == 'old',
            onTap: () {
              setState(() {
                _filter = _filter.copyWith(
                  sortBy: _filter.sortBy == 'old' ? null : 'old',
                );
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFightingStyleFilter() {
    if (_isLoadingStyles) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: CircularProgressIndicator(color: AppColor.red),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _filter.fightingStyle != null
              ? AppColor.red
              : AppColor.white.withValues(alpha: 0.2),
        ),
      ),
      child: DropdownButtonFormField<String>(
        initialValue: _filter.fightingStyle,
        decoration: InputDecoration(
          hintText: 'Select Fighting Style',
          hintStyle: GoogleFonts.dmSans(
            color: AppColor.white.withValues(alpha: 0.5),
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        dropdownColor: AppColor.black,
        style: GoogleFonts.dmSans(
          color: AppColor.white,
          fontSize: 14,
        ),
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: AppColor.white.withValues(alpha: 0.7),
        ),
        items: [
          DropdownMenuItem<String>(
            value: null,
            child: Text(
              'All Styles',
              style: GoogleFonts.dmSans(
                color: AppColor.white.withValues(alpha: 0.7),
              ),
            ),
          ),
          ..._fightingStyles.map((style) {
            return DropdownMenuItem<String>(
              value: style,
              child: Text(style),
            );
          }),
        ],
        onChanged: (value) {
          setState(() {
            _filter = _filter.copyWith(fightingStyle: value);
          });
        },
      ),
    );
  }

  Widget _buildWeightFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColor.white.withValues(alpha: 0.2),
        ),
      ),
      child: TextField(
        controller: _weightController,
        style: GoogleFonts.dmSans(color: AppColor.white),
        decoration: InputDecoration(
          hintText: 'Enter weight (e.g., 70kg, 150lbs)',
          hintStyle: GoogleFonts.dmSans(
            color: AppColor.white.withValues(alpha: 0.5),
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        onChanged: (value) {
          setState(() {
            _filter = _filter.copyWith(
              weight: value.isEmpty ? null : value,
            );
          });
        },
      ),
    );
  }

  Widget _buildRadiusFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColor.white.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _radiusController,
            keyboardType: TextInputType.number,
            style: GoogleFonts.dmSans(color: AppColor.white),
            decoration: InputDecoration(
              hintText: 'Enter radius in km',
              hintStyle: GoogleFonts.dmSans(
                color: AppColor.white.withValues(alpha: 0.5),
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            onChanged: (value) {
              setState(() {
                final radius = double.tryParse(value);
                _filter = _filter.copyWith(
                  radiusInKm: radius,
                );
              });
            },
          ),
          if (_filter.radiusInKm != null && _filter.userLatitude != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Searching within ${_filter.radiusInKm!.toStringAsFixed(1)} km',
                style: GoogleFonts.dmSans(
                  color: AppColor.red,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.red
              : AppColor.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColor.red
                : AppColor.white.withValues(alpha: 0.2),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.dmSans(
              color: isSelected ? AppColor.white : AppColor.white.withValues(alpha: 0.7),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

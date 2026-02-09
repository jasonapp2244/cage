import 'package:cage/models/promoter_filter_model.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PromoterFilterDialog extends StatefulWidget {
  final PromoterFilterModel currentFilter;

  const PromoterFilterDialog({
    super.key,
    required this.currentFilter,
  });

  @override
  State<PromoterFilterDialog> createState() => _PromoterFilterDialogState();
}

class _PromoterFilterDialogState extends State<PromoterFilterDialog> {
  late PromoterFilterModel _filter;
  final TextEditingController _minReviewCountController = TextEditingController();
  final TextEditingController _minEventsController = TextEditingController();
  final TextEditingController _maxEventsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filter = widget.currentFilter;
    _minReviewCountController.text = widget.currentFilter.minReviewCount?.toString() ?? '';
    _minEventsController.text = widget.currentFilter.minNumberOfEvents?.toString() ?? '';
    _maxEventsController.text = widget.currentFilter.maxNumberOfEvents?.toString() ?? '';
  }

  @override
  void dispose() {
    _minReviewCountController.dispose();
    _minEventsController.dispose();
    _maxEventsController.dispose();
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
                    'Filter Promoters',
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
                    _buildSectionTitle('Star Rating (Minimum)'),
                    SizedBox(height: Responsive.h(1)),
                    _buildStarRatingFilter(),
                    SizedBox(height: Responsive.h(2)),

                    // Number of Reviews Filter
                    _buildSectionTitle('Number of Reviews (Minimum)'),
                    SizedBox(height: Responsive.h(1)),
                    _buildReviewCountFilter(),
                    SizedBox(height: Responsive.h(2)),

                    // Number of Events Filter
                    _buildSectionTitle('Number of Events (Minimum OR Maximum)'),
                    SizedBox(height: Responsive.h(1)),
                    _buildNumberOfEventsFilter(),
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

  Widget _buildReviewCountFilter() {
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
        controller: _minReviewCountController,
        keyboardType: TextInputType.number,
        style: GoogleFonts.dmSans(color: AppColor.white),
        decoration: InputDecoration(
          hintText: 'Enter minimum number of reviews',
          hintStyle: GoogleFonts.dmSans(
            color: AppColor.white.withValues(alpha: 0.5),
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        onChanged: (value) {
          setState(() {
            final count = int.tryParse(value);
            _filter = _filter.copyWith(
              minReviewCount: count,
            );
          });
        },
      ),
    );
  }

  Widget _buildNumberOfEventsFilter() {
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
            'Minimum Number of Events',
            style: GoogleFonts.dmSans(
              color: AppColor.white.withValues(alpha: 0.7),
              fontSize: 14,
            ),
          ),
          SizedBox(height: Responsive.h(1)),
          TextField(
            controller: _minEventsController,
            keyboardType: TextInputType.number,
            style: GoogleFonts.dmSans(color: AppColor.white),
            decoration: InputDecoration(
              hintText: 'Enter minimum',
              hintStyle: GoogleFonts.dmSans(
                color: AppColor.white.withValues(alpha: 0.5),
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            onChanged: (value) {
              setState(() {
                final count = int.tryParse(value);
                _filter = _filter.copyWith(
                  minNumberOfEvents: count,
                );
              });
            },
          ),
          SizedBox(height: Responsive.h(2)),
          Text(
            'Maximum Number of Events',
            style: GoogleFonts.dmSans(
              color: AppColor.white.withValues(alpha: 0.7),
              fontSize: 14,
            ),
          ),
          SizedBox(height: Responsive.h(1)),
          TextField(
            controller: _maxEventsController,
            keyboardType: TextInputType.number,
            style: GoogleFonts.dmSans(color: AppColor.white),
            decoration: InputDecoration(
              hintText: 'Enter maximum',
              hintStyle: GoogleFonts.dmSans(
                color: AppColor.white.withValues(alpha: 0.5),
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            onChanged: (value) {
              setState(() {
                final count = int.tryParse(value);
                _filter = _filter.copyWith(
                  maxNumberOfEvents: count,
                );
              });
            },
          ),
        ],
      ),
    );
  }
}

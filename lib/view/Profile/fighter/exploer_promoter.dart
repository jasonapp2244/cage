import 'package:cached_network_image/cached_network_image.dart';
import 'package:cage/models/promoter_filter_model.dart';
import 'package:cage/models/promoter_model.dart';
import 'package:cage/models/user_model.dart';
import 'package:cage/provider/promoter_provider.dart';
import 'package:cage/repository/review_repository.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/view/Profile/Promoter/promoter_public_profile.dart';
import 'package:cage/view/Profile/fighter/promoter_filter_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ExploerPromoter extends StatefulWidget {
  const ExploerPromoter({super.key});

  @override
  State<ExploerPromoter> createState() => _ExploerPromoterState();
}

class _ExploerPromoterState extends State<ExploerPromoter> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  PromoterFilterModel _filter = PromoterFilterModel();
  List<UserModel> _filteredPromoters = [];
  bool _isFiltering = false;

  @override
  void initState() {
    super.initState();
    // Fetch promoters when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PromoterProvider>().fetchPromoters();
    });
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
      if (_filter.hasActiveFilters) {
        _applyFilters();
      }
    });
  }

  Future<void> _showFilterDialog() async {
    final result = await showDialog<PromoterFilterModel>(
      context: context,
      builder: (context) => PromoterFilterDialog(
        currentFilter: _filter,
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _filter = result;
      });
      await _applyFilters();
    }
  }

  Future<void> _applyFilters() async {
    if (!_filter.hasActiveFilters) {
      setState(() {
        _filteredPromoters = [];
        _isFiltering = false;
      });
      return;
    }

    setState(() {
      _isFiltering = true;
    });

    try {
      final promoterProvider = context.read<PromoterProvider>();
      final allPromoters = promoterProvider.promoters;
      
      // Apply search first
      final searchFiltered = _searchQuery.isEmpty
          ? allPromoters
          : promoterProvider.searchPromoters(_searchQuery);

      // Then apply other filters
      final filtered = await promoterProvider.filterPromoters(
        promoters: searchFiltered,
        filter: _filter,
      );

      if (mounted) {
        setState(() {
          _filteredPromoters = filtered;
          _isFiltering = false;
        });
      }
    } catch (e) {
      print('Error applying filters: $e');
      if (mounted) {
        setState(() {
          _isFiltering = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      backgroundColor: AppColor.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Field and Filter Button
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: Responsive.h(7.0),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(color: AppColor.white),
                          cursorColor: AppColor.red,
                          cursorErrorColor: AppColor.red,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                Responsive.w(12),
                              ),
                              borderSide: BorderSide(color: AppColor.red),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                Responsive.w(12),
                              ),
                              borderSide: BorderSide(color: AppColor.red),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColor.red),
                              borderRadius: BorderRadius.circular(
                                Responsive.w(12),
                              ),
                            ),
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(
                                Responsive.w(3),
                              ),
                              child: SvgPicture.asset(
                                "assets/icons/search.svg",
                              ),
                            ),
                            filled: true,
                            fillColor: AppColor.white.withValues(alpha: 0.08),
                            hintText: "Search by promoter name...",
                            hintStyle: GoogleFonts.dmSans(
                              color: AppColor.white,
                              fontWeight: FontWeight.normal,
                              fontSize: Responsive.sp(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: Responsive.w(2)),
                  // Filter Button
                  GestureDetector(
                    onTap: _showFilterDialog,
                    child: Container(
                      width: Responsive.h(7.0),
                      height: Responsive.h(7.0),
                      decoration: BoxDecoration(
                        color: _filter.hasActiveFilters
                            ? AppColor.red
                            : AppColor.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(Responsive.w(12)),
                        border: Border.all(
                          color: _filter.hasActiveFilters
                              ? AppColor.red
                              : AppColor.white.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Icon(
                              Icons.tune,
                              color: _filter.hasActiveFilters
                                  ? AppColor.white
                                  : AppColor.white.withValues(alpha: 0.7),
                              size: 20,
                            ),
                          ),
                          if (_filter.hasActiveFilters)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: AppColor.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: Responsive.h(2)),

              // Promoters List
              Expanded(
                child: Consumer<PromoterProvider>(
                  builder: (context, promoterProvider, child) {
                    if (promoterProvider.isLoading) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: AppColor.red),
                            SizedBox(height: 16),
                            Text(
                              "Loading promoters...",
                              style: TextStyle(
                                color: AppColor.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (promoterProvider.error != null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: AppColor.red,
                              size: 48,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Error loading promoters',
                              style: TextStyle(
                                color: AppColor.white,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                promoterProvider.fetchPromoters();
                              },
                              child: Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    // Apply filters if active, otherwise just search
                    List<UserModel> promoters;
                    
                    if (_isFiltering) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: AppColor.red),
                            SizedBox(height: 16),
                            Text(
                              "Applying filters...",
                              style: TextStyle(
                                color: AppColor.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    
                    if (_filter.hasActiveFilters && _filteredPromoters.isNotEmpty) {
                      promoters = _filteredPromoters;
                    } else if (_filter.hasActiveFilters) {
                      // Filters are active but no results yet, trigger filter
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _applyFilters();
                      });
                      promoters = [];
                    } else {
                      // No filters, just apply search
                      promoters = _searchQuery.isEmpty
                          ? promoterProvider.promoters
                          : promoterProvider.searchPromoters(_searchQuery);
                    }

                    print('UI: Found ${promoters.length} promoters to display');

                    if (promoters.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              color: AppColor.white.withValues(alpha: 0.5),
                              size: 48,
                            ),
                            SizedBox(height: 16),
                            Text(
                              _filter.hasActiveFilters
                                  ? "No promoters match your filters"
                                  : _searchQuery.isEmpty
                                      ? "No promoters found"
                                      : "No promoters match your search",
                              style: TextStyle(
                                color: AppColor.white.withValues(alpha: 0.7),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: promoters.length,
                      itemBuilder: (context, index) {
                        final user = promoters[index];
                        print(
                          'Building promoter card for index $index: ${user.id}',
                        );

                        if (user.roleData == null) {
                          print('User ${user.id} has no roleData');
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              color: AppColor.black,
                              border: Border.all(
                                color: AppColor.white.withValues(alpha: 0.1),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'No promoter data',
                                style: TextStyle(color: AppColor.white),
                              ),
                            ),
                          );
                        }

                        if (user.roleData is! PromoterDataModel) {
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              color: AppColor.black,
                              border: Border.all(
                                color: AppColor.white.withValues(alpha: 0.1),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Invalid data',
                                style: TextStyle(color: AppColor.white),
                              ),
                            ),
                          );
                        }

                        final promoter = user.roleData as PromoterDataModel;

                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            color: AppColor.black,
                            border: Border.all(
                              color: AppColor.white.withValues(alpha: 0.1),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Profile Row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CircleAvatar(
                                    radius: 35,
                                    backgroundColor:
                                        AppColor.white.withValues(alpha: 0.1),
                                    child: promoter.profileImageUrl != null &&
                                            promoter.profileImageUrl!.isNotEmpty
                                        ? ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl: promoter.profileImageUrl!,
                                              width: 70,
                                              height: 70,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => Image(
                                                image: AssetImage(
                                                  "assets/images/Ellipse 24 (1).png",
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Image(
                                                image: AssetImage(
                                                  "assets/images/Ellipse 24 (1).png",
                                                ),
                                              ),
                                            ),
                                          )
                                        : Image(
                                            image: AssetImage(
                                              "assets/images/Ellipse 24 (1).png",
                                            ),
                                          ),
                                  ),
                                  const SizedBox(width: 8),
                                  FutureBuilder<double>(
                                    future: ReviewRepository.getAveragePromoterRating(user.id),
                                    builder: (context, ratingSnapshot) {
                                      double averageRating = 0.0;
                                      
                                      if (ratingSnapshot.hasData) {
                                        averageRating = ratingSnapshot.data!;
                                      }
                                      
                                      return Row(
                                        children: [
                                          Text(
                                            averageRating.toStringAsFixed(1),
                                            style: GoogleFonts.dmSans(
                                              color: AppColor.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(width: Responsive.w(2)),
                                          SvgPicture.asset(
                                            "assets/icons/Vector (3).svg",
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),

                              SizedBox(height: Responsive.h(1)),

                              // Company Name
                              Text(
                                promoter.companyName ?? "Company Name",
                                style: GoogleFonts.dmSans(
                                  color: AppColor.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),

                              SizedBox(height: Responsive.h(1)),

                              // Location Row
                              if (promoter.location != null &&
                                  promoter.location!.isNotEmpty)
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/location-05.svg",
                                      height: 16,
                                      color: AppColor.white
                                          .withValues(alpha: 0.7),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        promoter.location!,
                                        style: GoogleFonts.dmSans(
                                          color: AppColor.white
                                              .withValues(alpha: 0.7),
                                          fontSize: 12,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              SizedBox(height: Responsive.h(1)),

                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PromoterPublicProfile(userData: user),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(22),
                                    color:
                                        AppColor.white.withValues(alpha: 0.09),
                                  ),
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0,
                                      vertical: 4.5,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "View Profile",
                                        style: GoogleFonts.dmSans(
                                          color: AppColor.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              Responsive.textScaleFactor * 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

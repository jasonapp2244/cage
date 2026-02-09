import 'package:cached_network_image/cached_network_image.dart';
import 'package:cage/models/fighter_filter_model.dart';
import 'package:cage/models/fighter_model.dart';
import 'package:cage/models/user_model.dart';
import 'package:cage/provider/fighter_provider.dart';
import 'package:cage/repository/review_repository.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/location_helper.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:cage/view/Profile/Promoter/fighter_filter_dialog.dart';
import 'package:cage/view/Profile/fighter/fighter_personal_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ExploreFightersView extends StatefulWidget {
  const ExploreFightersView({super.key});

  @override
  State<ExploreFightersView> createState() => _FightersViewState();
}

class _FightersViewState extends State<ExploreFightersView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  FighterFilterModel _filter = FighterFilterModel();
  List<UserModel> _filteredFighters = [];
  bool _isFiltering = false;
  double? _userLatitude;
  double? _userLongitude;

  @override
  void initState() {
    super.initState();
    // Fetch fighters when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FighterProvider>().fetchFighters();
      _loadUserLocation();
    });
    
    // Listen to search field changes
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  Future<void> _loadUserLocation() async {
    try {
      final uid = Utils.getCurrentUid();
      final location = await LocationHelper.getSavedLocation(uid);
      if (location != null && mounted) {
        setState(() {
          _userLatitude = location.latitude;
          _userLongitude = location.longitude;
        });
      }
    } catch (e) {
      print('Error loading user location: $e');
    }
  }

  Future<void> _showFilterDialog() async {
    final result = await showDialog<FighterFilterModel>(
      context: context,
      builder: (context) => FighterFilterDialog(
        currentFilter: _filter,
        userLatitude: _userLatitude,
        userLongitude: _userLongitude,
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _filter = result;
        // Update location if provided in filter
        if (result.userLatitude != null && result.userLongitude != null) {
          _userLatitude = result.userLatitude;
          _userLongitude = result.userLongitude;
        }
      });
      await _applyFilters();
    }
  }

  Future<void> _applyFilters() async {
    if (!_filter.hasActiveFilters) {
      setState(() {
        _filteredFighters = [];
        _isFiltering = false;
      });
      return;
    }

    setState(() {
      _isFiltering = true;
    });

    try {
      final fighterProvider = context.read<FighterProvider>();
      final allFighters = fighterProvider.fighters;
      
      // Apply search first
      final searchFiltered = _searchQuery.isEmpty
          ? allFighters
          : fighterProvider.searchFighters(_searchQuery);

      // Then apply other filters
      final filtered = await fighterProvider.filterFighters(
        fighters: searchFiltered,
        filter: _filter.copyWith(
          userLatitude: _userLatitude ?? _filter.userLatitude,
          userLongitude: _userLongitude ?? _filter.userLongitude,
        ),
      );

      if (mounted) {
        setState(() {
          _filteredFighters = filtered;
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
              // Header
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Explore Fighters",
                      style: GoogleFonts.dmSans(
                        color: AppColor.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<FighterProvider>().fetchFighters();
                      },
                      icon: Icon(Icons.refresh, color: AppColor.white),
                    ),
                  ],
                ),
              ),

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
                          scrollController: ScrollController(
                            keepScrollOffset: true,
                          ),
                          style: TextStyle(color: AppColor.white),
                          cursorColor: AppColor.red,
                          cursorErrorColor: AppColor.red,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                            // Apply filters if active, otherwise just search is handled in builder
                            if (_filter.hasActiveFilters) {
                              _applyFilters();
                            }
                          },
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
                              padding: EdgeInsets.all(Responsive.w(3)),
                              child: SvgPicture.asset(
                                "assets/icons/search.svg",
                              ),
                            ),
                            filled: true,
                            fillColor: AppColor.white.withValues(alpha: 0.08),
                            hintText: "Search Fighters ...",
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

              // Fighters List
              Expanded(
                child: Consumer<FighterProvider>(
                  builder: (context, fighterProvider, child) {
                    if (fighterProvider.isLoading) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: AppColor.red),
                            SizedBox(height: 16),
                            Text(
                              "Loading fighters...",
                              style: TextStyle(
                                color: AppColor.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (fighterProvider.error != null) {
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
                              'Error loading fighters',
                              style: TextStyle(
                                color: AppColor.white,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                fighterProvider.fetchFighters();
                              },
                              child: Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    // Apply filters if active, otherwise just search
                    List<UserModel> fighters;
                    
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
                    
                    if (_filter.hasActiveFilters && _filteredFighters.isNotEmpty) {
                      fighters = _filteredFighters;
                    } else if (_filter.hasActiveFilters) {
                      // Filters are active but no results yet, trigger filter
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _applyFilters();
                      });
                      fighters = [];
                    } else {
                      // No filters, just apply search
                      final allFighters = fighterProvider.fighters;
                      fighters = _searchQuery.isEmpty
                          ? allFighters
                          : fighterProvider.searchFighters(_searchQuery);
                    }
                    
                    print('UI: Found ${fighters.length} fighters to display');

                    if (fighters.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.sports_martial_arts_outlined,
                              color: AppColor.red,
                              size: 48,
                            ),
                            SizedBox(height: 16),
                            Text(
                              _filter.hasActiveFilters
                                  ? "No fighters match your filters"
                                  : _searchQuery.isEmpty
                                      ? "No fighters found"
                                      : "No fighters match your search",
                              style: TextStyle(
                                color: AppColor.white,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              _filter.hasActiveFilters
                                  ? "Try adjusting your filter criteria"
                                  : _searchQuery.isEmpty
                                      ? "Be the first fighter to join!"
                                      : "Try searching with a different name",
                              style: TextStyle(
                                color: AppColor.white.withValues(alpha: 0.7),
                                fontSize: 14,
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
                      itemCount: fighters.length,
                      itemBuilder: (context, index) {
                        final user = fighters[index];
                        print(
                          'Building fighter card for index $index: ${user.id}',
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
                                'No fighter data',
                                style: TextStyle(color: AppColor.white),
                              ),
                            ),
                          );
                        }

                        if (user.roleData is! FighterDataModel) {
                          print(
                            'User ${user.id} roleData is not FighterDataModel: ${user.roleData.runtimeType}',
                          );
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
                                'Invalid fighter data',
                                style: TextStyle(color: AppColor.white),
                              ),
                            ),
                          );
                        }

                        final fighter = user.roleData as FighterDataModel;

                        return Container(
                          padding: const EdgeInsets.all(10),
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
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Profile Row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CircleAvatar(
                                    radius: 35,
                                    backgroundColor: AppColor.white.withValues(
                                      alpha: 0.1,
                                    ),
                                    child: fighter.profileImageUrl != null && fighter.profileImageUrl!.isNotEmpty
                                        ? ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl: fighter.profileImageUrl!,
                                              width: 70,
                                              height: 70,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => Image(
                                                image: AssetImage(
                                                  "assets/images/Ellipse 24 (1).png",
                                                ),
                                              ),
                                              errorWidget: (context, url, error) => Image(
                                                image: AssetImage(
                                                  "assets/images/Ellipse 24 (1).png",
                                                ),
                                              ),
                                            ),
                                          )
                                        : fighter.uploadProfile != null && fighter.uploadProfile!.isNotEmpty
                                            ? ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl: fighter.uploadProfile!,
                                                  width: 70,
                                                  height: 70,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) => Image(
                                                    image: AssetImage(
                                                      "assets/images/Ellipse 24 (1).png",
                                                    ),
                                                  ),
                                                  errorWidget: (context, url, error) => Image(
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
                                    future: ReviewRepository.getAverageRating(user.id),
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

                              SizedBox(height: Responsive.h(0.6)),

                              // Fighter Name
                              Text(
                                fighter.fullName.isNotEmpty
                                    ? fighter.fullName
                                    : "Unknown Fighter",
                                style: GoogleFonts.dmSans(
                                  color: AppColor.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),

                              SizedBox(height: Responsive.h(0.6)),

                              // Fighting Style
                              if (fighter.fightingStyle != null &&
                                  fighter.fightingStyle!.isNotEmpty)
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/boxing.svg",
                                      height: 16,
                                      color: AppColor.white.withValues(
                                        alpha: 0.7,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        fighter.fightingStyle!,
                                        style: GoogleFonts.dmSans(
                                          color: AppColor.white.withValues(
                                            alpha: 0.7,
                                          ),
                                          fontSize: 12,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),

                              // Stats Row
                              SizedBox(height: Responsive.h(0.4)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildStatChip(
                                    _extractCityFromLocation(fighter.location),
                                  ),
                                ],
                              ),

                              SizedBox(height: Responsive.h(0.6)),

                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FighterPublicProfile(userData: user),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(22),
                                    color: AppColor.white.withValues(
                                      alpha: 0.05,
                                    ),
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

  // Extract city from location data to avoid long text
  String _extractCityFromLocation(String? location) {
    if (location == null || location.isEmpty) {
      return "Unknown";
    }

    // Check if it's coordinates (contains comma and numbers)
    if (RegExp(r'^[\d\.-]+,\s*[\d\.-]+$').hasMatch(location.trim())) {
      return "Location";
    }

    // If it's an address string, extract city
    final parts = location.split(',').map((e) => e.trim()).toList();

    if (parts.length >= 4) {
      // For US format: "Street, City, State ZipCode, Country"
      return parts[parts.length - 3];
    } else if (parts.length == 3) {
      // For format: "Street, City, Country"
      return parts[1];
    } else if (parts.length == 2) {
      // For format: "City, Country"
      return parts[0];
    } else if (parts.length == 1) {
      // Single location name - limit length
      return parts[0].length > 12
          ? "${parts[0].substring(0, 12)}..."
          : parts[0];
    }

    return location.length > 12 ? "${location.substring(0, 12)}..." : location;
  }
}

// Helper widget for stats
Widget _buildStatChip(String location) {
  return Flexible(
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColor.red.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        location.isNotEmpty ? location : 'Unknown',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.dmSans(
          color: AppColor.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

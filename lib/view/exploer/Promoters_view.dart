import 'package:cage/models/fighter_model.dart';
import 'package:cage/models/user_model.dart';
import 'package:cage/provider/fighter_provider.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FightersView extends StatefulWidget {
  const FightersView({super.key});

  @override
  State<FightersView> createState() => _FightersViewState();
}

class _FightersViewState extends State<FightersView> {
  @override
  void initState() {
    super.initState();
    // Fetch fighters when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FighterProvider>().fetchFighters();
    });
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

              // Search Field
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: Responsive.h(7.0),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: TextField(
                          scrollController: ScrollController(
                            keepScrollOffset: true,
                          ),
                          style: TextStyle(color: AppColor.white),
                          cursorColor: AppColor.red,
                          cursorErrorColor: AppColor.red,
                          keyboardType: TextInputType.emailAddress,
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
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.black.withValues(alpha: 0.05),
                    ),
                    child: SvgPicture.asset("assets/icons/solar_bell-bold.svg"),
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

                    final fighters = fighterProvider.fighters;
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
                              "No fighters found",
                              style: TextStyle(
                                color: AppColor.white,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Be the first fighter to join!",
                              style: TextStyle(
                                color: AppColor.white.withOpacity(0.7),
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
                                color: AppColor.white.withOpacity(0.1),
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
                                color: AppColor.white.withOpacity(0.1),
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
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            color: AppColor.black,
                            border: Border.all(
                              color: AppColor.white.withOpacity(0.1),
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
                                    backgroundColor: AppColor.white.withValues(
                                      alpha: 0.1,
                                    ),
                                    child: fighter.uploadProfile != null
                                        ? ClipOval(
                                            child: Image.network(
                                              fighter.uploadProfile!,
                                              width: 70,
                                              height: 70,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return Image(
                                                      image: AssetImage(
                                                        "assets/images/Ellipse 24 (1).png",
                                                      ),
                                                    );
                                                  },
                                            ),
                                          )
                                        : Image(
                                            image: AssetImage(
                                              "assets/images/Ellipse 24 (1).png",
                                            ),
                                          ),
                                  ),
                                  const SizedBox(width: 8),
                                  Row(
                                    children: [
                                      Text(
                                        "4.7", // You can add rating to fighter model later
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
                                  ),
                                ],
                              ),

                              SizedBox(height: Responsive.h(1)),

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

                              SizedBox(height: Responsive.h(1)),

                              // Fighting Style
                              if (fighter.fightingStyle != null &&
                                  fighter.fightingStyle!.isNotEmpty)
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/boxing.svg",
                                      height: 16,
                                      color: AppColor.white.withOpacity(0.7),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        fighter.fightingStyle!,
                                        style: GoogleFonts.dmSans(
                                          color: AppColor.white.withOpacity(
                                            0.7,
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
                              SizedBox(height: Responsive.h(0.5)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildStatChip(fighter.location.toString()),
                                  // _buildStatChip(
                                  //   "L",
                                  //   fighter.fightsLose.toString(),
                                  // ),
                                  // _buildStatChip(
                                  //   "KO",
                                  //   fighter.fightsKnockout.toString(),
                                  // ),
                                ],
                              ),

                              SizedBox(height: Responsive.h(1)),

                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22),
                                  color: AppColor.white.withValues(alpha: 0.05),
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

  // Helper widget for stats
  Widget _buildStatChip(String location) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColor.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "${location ?? 'San Francisco, California'}",
        style: GoogleFonts.dmSans(
          color: AppColor.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

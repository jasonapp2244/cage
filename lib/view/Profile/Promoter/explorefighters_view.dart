import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ExploreFighters extends StatelessWidget {
  const ExploreFighters({super.key});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      backgroundColor: AppColor.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  "Explore Fighters",
                  style: GoogleFonts.dmSans(
                    color: AppColor.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
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
                          // controller: phoneController,
                          // focusNode: phoneFoucsNode,
                          cursorColor: AppColor.red,
                          cursorErrorColor: AppColor.red,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                Responsive.w(12),
                              ), // 6% of width
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
                              ), // 2% of width
                              child: SvgPicture.asset(
                                "assets/icons/search.svg",
                              ),
                            ),
                            filled: true,

                            fillColor: AppColor.white.withValues(alpha: 0.08),
                            hintText: "Search Event ...",
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

              // Grid View
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 items per row
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75, // Adjust card proportions
                  ),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        color: AppColor.black,
                        border: Border.all(
                          color: AppColor.white.withValues(alpha:0.1),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: 35,
                                backgroundColor: AppColor.white.withValues(
                                  alpha: 0.1,
                                ),
                                child: Image(
                                  image: AssetImage(
                                    "assets/images/Ellipse 24 (1).png",
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Row(
                                children: [
                                  Text(
                                    "4.7",
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

                          // Name
                          Text(
                            "Corey Herwitz",
                            style: GoogleFonts.dmSans(
                              color: AppColor.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: Responsive.h(1)),

                          // Location Row
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/location-05.svg",
                                height: 16,
                                color: AppColor.white.withValues(alpha:0.7),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  "San Francisco, California",
                                  style: GoogleFonts.dmSans(
                                    color: AppColor.white.withValues(alpha:0.7),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: Responsive.h(1)),

                          GestureDetector(
                            onTap: () => Navigator.pushNamed(
                              context,
                              RoutesName.FighterPublicProfile,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                color: AppColor.white.withValues(alpha: 0.09),
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
                                      fontSize: Responsive.textScaleFactor * 12,
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

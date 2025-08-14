import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/view/Profile/fighter/eidt_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PromoterView extends StatefulWidget {
  const PromoterView({super.key});

  @override
  State<PromoterView> createState() => _PromoterViewState();
}

class _PromoterViewState extends State<PromoterView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Sample data
  final List<String> photoUrls = const [
    "assets/images/photo1.jpg",
    "assets/images/photo2.jpg",
    "assets/images/photo3.jpg",
    "assets/images/photo4.jpg",
    "assets/images/photo5.jpg",
    "assets/images/photo6.jpg",
  ];

  final List<String> videoThumbnails = const [
    "assets/videos/thumb1.jpg",
    "assets/videos/thumb2.jpg",
  ];

  final List<Map<String, dynamic>> events = const [
    {
      "title": "Jake \"The Beast\" Miller - 💤️ Win (KO)",
      "date": "20 May",
      "status": "View Details",
    },
    {
      "title": "MMA Championship Finals",
      "date": "15 June",
      "status": "View Details",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      backgroundColor: AppColor.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: SvgPicture.asset(
                        "assets/icons/arrow-left-01.svg",
                        color: AppColor.red,
                      ),
                    ),
                    Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: Responsive.textScaleFactor * 24,
                        color: AppColor.white,
                        fontFamily: AppFonts.appFont,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Responsive.h(2)),

                // Profile Header Section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: AppColor.white.withOpacity(0.1),
                      child: Image(
                        image: AssetImage("assets/images/image.png"),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "UFC Fighting Club",
                          style: TextStyle(
                            fontSize: Responsive.textScaleFactor * 14,
                            color: AppColor.white,
                            fontFamily: AppFonts.appFont,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            SvgPicture.asset("assets/icons/call.svg"),
                            SizedBox(width: Responsive.w(1)),
                            Text(
                              "+1 2654 564 169",
                              style: TextStyle(
                                fontSize: Responsive.textScaleFactor * 12,
                                color: AppColor.white,
                                fontFamily: AppFonts.appFont,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SvgPicture.asset("assets/icons/mail-02.svg"),
                            SizedBox(width: Responsive.w(1)),
                            Text(
                              "rubenkenter2@gmail.com",
                              style: TextStyle(
                                fontSize: Responsive.textScaleFactor * 12,
                                color: AppColor.white,
                                fontFamily: AppFonts.appFont,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => EidtProfile()),
                        );
                      },
                      child: SvgPicture.asset("assets/icons/edits.svg"),
                    ),
                  ],
                ),
                SizedBox(height: Responsive.h(2)),

                // Bio Section
                Text(
                  "Looking for aggressive strikers with clean records. The winner will be featured on our official YouTube broadcast with cash bonus + sponsor exposure.",
                  style: TextStyle(
                    fontSize: Responsive.textScaleFactor * 12,
                    color: AppColor.white,
                    fontFamily: AppFonts.appFont,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: Responsive.h(2)),

                // Stats Section
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColor.black,
                          border: Border.all(
                            color: AppColor.white.withOpacity(0.1),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "No of Event Managed",
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontFamily: AppFonts.appFont,
                                  fontWeight: FontWeight.normal,
                                  fontSize: Responsive.sp(10.5),
                                ),
                              ),
                              Text(
                                "20",
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontFamily: AppFonts.appFont,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Responsive.sp(24),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: Responsive.w(2)),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColor.black,
                          border: Border.all(
                            color: AppColor.white.withOpacity(0.1),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Average Rating",
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontFamily: AppFonts.appFont,
                                  fontWeight: FontWeight.normal,
                                  fontSize: Responsive.sp(10.5),
                                ),
                              ),
                              Text(
                                "10",
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontFamily: AppFonts.appFont,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Responsive.sp(24),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Responsive.h(2)),

                // Reviews Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Reviews",
                      style: TextStyle(
                        color: AppColor.white,
                        fontFamily: AppFonts.appFont,
                        fontWeight: FontWeight.normal,
                        fontSize: Responsive.sp(10),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "View All",
                          style: TextStyle(
                            color: AppColor.white,
                            fontFamily: AppFonts.appFont,
                            fontWeight: FontWeight.bold,
                            fontSize: Responsive.sp(10),
                          ),
                        ),
                        SizedBox(width: Responsive.w(2)),
                        SvgPicture.asset("assets/icons/Vector (2).svg"),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: Responsive.h(1)),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColor.white.withOpacity(0.1),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    color: AppColor.black,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image(
                              image: AssetImage(
                                "assets/images/Frame 1410120835.png",
                              ),
                            ),
                            SizedBox(width: Responsive.w(2)),
                            Text(
                              "Ruben Kenter",
                              style: TextStyle(
                                color: AppColor.white,
                                fontFamily: AppFonts.appFont,
                                fontWeight: FontWeight.bold,
                                fontSize: Responsive.sp(10),
                              ),
                            ),
                            Spacer(),
                            Column(
                              children: [
                                Text(
                                  "3h ago",
                                  style: TextStyle(
                                    color: AppColor.white.withOpacity(0.4),
                                    fontFamily: AppFonts.appFont,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Responsive.sp(10),
                                  ),
                                ),
                                Image(
                                  image: AssetImage(
                                    "assets/icons/material-symbols_star.png",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: Responsive.h(1)),
                        Text(
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                          style: TextStyle(
                            color: AppColor.white,
                            fontFamily: AppFonts.appFont,
                            fontWeight: FontWeight.bold,
                            fontSize: Responsive.sp(10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: Responsive.h(2)),

                // Tab Bar Section
                Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(text: 'Events'),
                        Tab(text: 'Photos'),
                        Tab(text: 'Videos'),
                      ],
                      labelColor: AppColor.white,
                      unselectedLabelColor: AppColor.white.withOpacity(0.5),
                      indicatorColor: AppColor.red,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelStyle: TextStyle(
                        fontFamily: AppFonts.appFont,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(14),
                      ),
                    ),
                    SizedBox(
                      height: Responsive.h(30),
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Events Tab
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: events.length,
                            itemBuilder: (context, index) {
                              final event = events[index];
                              return Container(
                                margin: EdgeInsets.only(bottom: Responsive.h(1)),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColor.white.withOpacity(0.1),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListTile(
                                  title: Text(
                                    event['title'],
                                    style: TextStyle(
                                      color: AppColor.white,
                                      fontFamily: AppFonts.appFont,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    event['date'],
                                    style: TextStyle(
                                      color: AppColor.white.withOpacity(0.7),
                                      fontFamily: AppFonts.appFont,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        event['status'],
                                        style: TextStyle(
                                          color: AppColor.red,
                                          fontFamily: AppFonts.appFont,
                                        ),
                                      ),
                                      SizedBox(width: Responsive.w(1)),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: AppColor.red,
                                        size: Responsive.sp(12),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          // Photos Tab
                          GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: Responsive.w(2),
                              mainAxisSpacing: Responsive.h(1),
                              childAspectRatio: 1,
                            ),
                            itemCount: photoUrls.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  // Handle photo tap
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: AssetImage(photoUrls[index]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          // Videos Tab
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: videoThumbnails.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  // Handle video tap
                                },
                                child: Container(
                                  height: Responsive.h(15),
                                  margin: EdgeInsets.only(bottom: Responsive.h(1)),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: AssetImage(videoThumbnails[index]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.play_circle_filled,
                                      color: AppColor.white.withOpacity(0.8),
                                      size: Responsive.sp(30),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
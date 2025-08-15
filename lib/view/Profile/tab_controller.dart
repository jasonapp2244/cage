// import 'package:amore/services/massage_main_view.dart';
// import 'package:amore/utils/app_color.dart';
// import 'package:amore/utils/responsive_res.dart';
// import 'package:amore/viewmodel/activity_viewmodel.dart';
// import 'package:amore/widgets/credits_tabs.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

// class ActivityView extends StatefulWidget {
//   const ActivityView({super.key});

//   @override
//   State<ActivityView> createState() => _ActivityViewState();
// }

// class _ActivityViewState extends State<ActivityView> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     final viewModel = Provider.of<TabController>(context, listen: false);
//     _tabController = TabController(length: 2, vsync: this, initialIndex: viewModel.currentIndex);

//     _tabController.addListener(() {
//       if (!_tabController.indexIsChanging) {
//         viewModel.updateIndex(_tabController.index);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     ScreenSize.init(context); // Initialize responsive sizing

//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0.5,
//         shadowColor: AppColor.boraderColor,
//         title: Text(
//           'Messages',
//           style: GoogleFonts.raleway(
//             color: AppColor.textColor,
//             fontWeight: FontWeight.w600,
//             fontSize: Responsive.fontSize(4, context),
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(Responsive.height(6, context)),
//           child: Container(
//             decoration: BoxDecoration(
//               border: Border(
//                 bottom: BorderSide(
//                   color: Colors.grey.shade200,
//                   width: Responsive.width(0.2, context),
//                 ),
//               ),
//             ),
//             child: _buildTabBar(),
//           ),
//         ),
//       ),
//       body: _buildTabView(),
//     );
//   }

//   Widget _buildTabBar() {
//     return TabBar(
//       controller: _tabController,
//       labelPadding: EdgeInsets.symmetric(
//         horizontal: Responsive.width(2, context)),
//       tabs: [
//         Tab(
//           child: Text(
//             'Messages',
//             style: GoogleFonts.raleway(
//               fontSize: Responsive.fontSize(3.5, context),
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//         Tab(
//           child: Text(
//             'Credits',
//             style: GoogleFonts.raleway(
//               fontSize: Responsive.fontSize(3.5, context),
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//       ],
//       labelColor: AppColor.buttonColor,
//       unselectedLabelColor: Colors.grey,
//       indicatorSize: TabBarIndicatorSize.label,
//       indicatorWeight: Responsive.width(0.8, context),
//       indicatorPadding: EdgeInsets.symmetric(
//         horizontal: Responsive.width(5, context)),
//       indicatorColor: AppColor.buttonColor,
//     );
//   }

//   Widget _buildTabView() {
//     return Consumer<TabController>(
//       builder: (context, vm, _) {
//         return TabBarView(
//           controller: _tabController,
//           physics: const BouncingScrollPhysics(), // Better scroll feel
//           children: const [
//             MessagesMainView(),
//             CreditsTab(),
//           ],
//         );
//       },
//     );
//   }

//   // Optional: Add notification badge to tabs
//   Widget _tabWithBadge(String text, int? count) {
//     return Stack(
//       clipBehavior: Clip.none,
//       children: [
//         Text(
//           text,
//           style: GoogleFonts.raleway(
//             fontSize: Responsive.fontSize(3.5, context),
//           ),
//         ),
//         if (count != null && count > 0)
//           Positioned(
//             right: -8,
//             top: -5,
//             child: Container(
//               padding: EdgeInsets.all(Responsive.width(1, context)),
//               decoration: const BoxDecoration(
//                 color: Colors.red,
//                 shape: BoxShape.circle,
//               ),
//               constraints: BoxConstraints(
//                 minWidth: Responsive.width(4, context),
//                 minHeight: Responsive.width(4, context),
//               ),
//               child: Center(
//                 child: Text(
//                   count > 9 ? '9+' : count.toString(),
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: Responsive.fontSize(2.5, context),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }

//-----------responsive ui

import 'package:cage/fonts/fonts.dart';
import 'package:cage/provider/tab_controller.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/view/Profile/fighter/enter_name_view.dart';
import 'package:cage/view/Profile/fighter/exploer_promoter.dart';
import 'package:cage/view/exploer/events_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ActivityView extends StatefulWidget {
  const ActivityView({super.key});

  @override
  State<ActivityView> createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<TabProvider>(context, listen: false);
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: viewModel.currentIndex,
    );

    // Sync TabController changes to ViewModel
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        viewModel.updateIndex(_tabController.index);
      }
    });
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
      backgroundColor: Colors.black,

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
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
            ),
            Container(
              color: AppColor.black,
              child: TabBar(
                dividerColor: AppColor.black,
                controller: _tabController,
                tabs: [
                  Tab(
                    child: Text(
                      'Events',
                      style: GoogleFonts.raleway(
                        // fontSize: Responsive.fontSize(5, context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Promoters',
                      style: GoogleFonts.raleway(
                        // fontSize: Responsive.fontSize(5, context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],

                labelColor: AppColor.white,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppColor.red,
              ),
            ),
            Consumer<TabProvider>(
              builder: (context, vm, _) {
                return Flexible(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [EventsView(), ExploerPromoter()],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

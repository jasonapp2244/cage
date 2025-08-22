import 'package:cage/provider/drawer_provider.dart';
import 'package:cage/provider/tab_controller.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/view/Profile/Promoter/test.dart';
import 'package:cage/view/Profile/promoter_profile.dart';
import 'package:cage/view/enter_name_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cage/fonts/fonts.dart';
import 'package:cage/provider/tab_controller.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/view/exploer/events_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
    final drawerProvider = Provider.of<DrawerControllerProvider>(
      context,
      listen: false,
    );

    Responsive.init(context);

    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  GestureDetector(
                    onTap: drawerProvider.toggleDrawer,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.white.withValues(alpha: 0.1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SvgPicture.asset("assets/icons/menu-11.svg"),
                      ),
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
                    children: const [EventsView(), PromoterView()],
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

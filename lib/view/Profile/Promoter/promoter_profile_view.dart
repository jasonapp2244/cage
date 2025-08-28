// import 'package:cage/fonts/fonts.dart';
// import 'package:cage/res/components/app_color.dart';
// import 'package:cage/utils/routes/responsive.dart';
// import 'package:cage/utils/routes/routes_name.dart';
// import 'package:cage/view/Profile/Promoter/edit_promoter_profile.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:cage/repository/home_repository.dart';
// import 'package:cage/models/user_model.dart';
// import 'package:cage/models/promoter_model.dart';

// class PromoterProfileView extends StatelessWidget {
//   const PromoterProfileView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Responsive.init(context);
//     return Scaffold(
//       backgroundColor: AppColor.black,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     GestureDetector(
//                       onTap: () => Navigator.pop(context),
//                       child: SvgPicture.asset(
//                         "assets/icons/arrow-left-01.svg",
//                         color: AppColor.red,
//                       ),
//                     ),
//                     Text(
//                       "Profile",
//                       style: TextStyle(
//                         fontSize: Responsive.textScaleFactor * 24,
//                         color: AppColor.white,
//                         fontFamily: AppFonts.appFont,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),

//                 // 🔹 Promoter Profile Section with StreamBuilder
//                 StreamBuilder<UserModel>(
//                   stream: UserRepository.fetchCurrentUserStream(),
//                   builder: (context, snapshot) {
//                     // Debug prints
//                     print('=== Promoter Profile Debug ===');
//                     print('Connection State: ${snapshot.connectionState}');
//                     print('Has Data: ${snapshot.hasData}');
//                     print('Has Error: ${snapshot.hasError}');
//                     if (snapshot.hasError) {
//                       print('Error: ${snapshot.error}');
//                     }

//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return Column(
//                         children: [
//                           SizedBox(height: Responsive.h(2)),
//                           CircularProgressIndicator(color: AppColor.red),
//                           const SizedBox(height: 8),
//                           Text(
//                             "Loading profile...",
//                             style: TextStyle(
//                               color: AppColor.white,
//                               fontSize: Responsive.sp(12),
//                             ),
//                           ),
//                         ],
//                       );
//                     }

//                     if (!snapshot.hasData || snapshot.data == null) {
//                       print('No data available');
//                       return _buildDefaultProfileSection(context);
//                     }

//                     final user = snapshot.data!;
//                     print('User ID: ${user.id}');
//                     print('User Email: ${user.email}');
//                     print('Role Data Type: ${user.roleData.runtimeType}');
//                     print('Is Promoter: ${user.isPromoter}');
//                     print('Is Fighter: ${user.isFighter}');

//                     if (user.roleData != null) {
//                       print('Role Data: $user.roleData');
//                     }

//                     if (!user.isPromoter) {
//                       print('User is not a promoter');
//                       return _buildDefaultProfileSection(context);
//                     }

//                     final promoter = user.roleData as PromoterDataModel;

//                     return _buildPromoterProfileSection(context, promoter);
//                   },
//                 ),

//                 SizedBox(height: Responsive.h(1)),

//                 // 🔹 Company Description Section
//                 StreamBuilder<UserModel>(
//                   stream: UserRepository.fetchCurrentUserStream(),
//                   builder: (context, snapshot) {
//                     String companyAbout = "No description available";

//                     print('=== Company Description Debug ===');
//                     print('Has Data: ${snapshot.hasData}');
//                     print(
//                       'Is Promoter: ${snapshot.hasData && snapshot.data != null ? snapshot.data!.isPromoter : false}',
//                     );

//                     if (snapshot.hasData &&
//                         snapshot.data != null &&
//                         snapshot.data!.isPromoter) {
//                       final promoterData =
//                           snapshot.data!.roleData as PromoterDataModel;
//                       companyAbout =
//                           promoterData.companyAbout ??
//                           "No description available";
//                       print('Company About: $companyAbout');
//                     }

//                     return Text(
//                       companyAbout,
//                       style: TextStyle(
//                         fontSize: Responsive.textScaleFactor * 12,
//                         color: AppColor.white,
//                         fontFamily: AppFonts.appFont,
//                         fontWeight: FontWeight.normal,
//                       ),
//                     );
//                   },
//                 ),

//                 // 🔹 Stats Cards Section
//                 StreamBuilder<UserModel>(
//                   stream: UserRepository.fetchCurrentUserStream(),
//                   builder: (context, snapshot) {
//                     String numberOfEvents = "0";
//                     String averageRating = "0";

//                     print('=== Stats Cards Debug ===');
//                     print('Has Data: ${snapshot.hasData}');
//                     print(
//                       'Is Promoter: ${snapshot.hasData && snapshot.data != null ? snapshot.data!.isPromoter : false}',
//                     );

//                     if (snapshot.hasData &&
//                         snapshot.data != null &&
//                         snapshot.data!.isPromoter) {
//                       final promoterData =
//                           snapshot.data!.roleData as PromoterDataModel;
//                       numberOfEvents = (promoterData.numberOfEvents ?? 0)
//                           .toString();
//                       // For now, using a placeholder rating - you can add rating field to model later
//                       averageRating = "4.5";
//                       print('Number of Events: $numberOfEvents');
//                       print('Average Rating: $averageRating');
//                     }

//                     return Row(
//                       children: [
//                         Expanded(
//                           child: _buildStatCard(
//                             "No of Event Managed",
//                             numberOfEvents,
//                           ),
//                         ),
//                         SizedBox(width: Responsive.w(2)),
//                         Expanded(
//                           child: _buildStatCard(
//                             "Average Rating",
//                             averageRating,
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),

//                 SizedBox(height: Responsive.h(1)),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Reviews",
//                       style: TextStyle(
//                         color: AppColor.white,
//                         fontFamily: AppFonts.appFont,
//                         fontWeight: FontWeight.normal,
//                         fontSize: Responsive.sp(10),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () =>
//                           Navigator.pushNamed(context, RoutesName.review),
//                       child: Row(
//                         children: [
//                           Text(
//                             "View All",
//                             style: TextStyle(
//                               color: AppColor.white,
//                               fontFamily: AppFonts.appFont,
//                               fontWeight: FontWeight.bold,
//                               fontSize: Responsive.sp(10),
//                             ),
//                           ),
//                           SizedBox(width: Responsive.w(2)),
//                           SvgPicture.asset("assets/icons/Vector (2).svg"),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: Responsive.h(1)),

//                 // 🔹 Sample Review (you can make this dynamic later)
//                 Container(
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     border: BoxBorder.all(
//                       color: AppColor.white.withValues(alpha: 0.1),
//                       width: 2,
//                     ),
//                     borderRadius: BorderRadius.circular(14),
//                     color: AppColor.black,
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Image(
//                               image: AssetImage(
//                                 "assets/images/Frame 1410120835.png",
//                               ),
//                             ),
//                             SizedBox(width: Responsive.w(2)),
//                             Text(
//                               "Ruben Kenter",
//                               style: TextStyle(
//                                 color: AppColor.white,
//                                 fontFamily: AppFonts.appFont,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: Responsive.sp(10),
//                               ),
//                             ),
//                             Spacer(),
//                             Column(
//                               children: [
//                                 Text(
//                                   "3h ago",
//                                   style: TextStyle(
//                                     color: AppColor.white.withValues(
//                                       alpha: 0.4,
//                                     ),
//                                     fontFamily: AppFonts.appFont,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: Responsive.sp(10),
//                                   ),
//                                 ),
//                                 Image(
//                                   image: AssetImage(
//                                     "assets/icons/material-symbols_star.png",
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: Responsive.h(1)),
//                         Text(
//                           "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
//                           style: TextStyle(
//                             color: AppColor.white,
//                             fontFamily: AppFonts.appFont,
//                             fontWeight: FontWeight.bold,
//                             fontSize: Responsive.sp(10),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: Responsive.h(2)),

//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     "Photos",
//                     style: TextStyle(
//                       color: AppColor.white,
//                       fontFamily: AppFonts.appFont,
//                       fontWeight: FontWeight.bold,
//                       fontSize: Responsive.sp(16),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: Responsive.h(1)),

//                 // Add your photos grid or list view here
//                 Container(
//                   height: Responsive.h(20),
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       color: AppColor.white.withOpacity(0.1),
//                       width: 2,
//                     ),
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   child: Center(
//                     child: Text(
//                       "Photos will be displayed here",
//                       style: TextStyle(color: AppColor.white.withOpacity(0.5)),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: Responsive.h(2)),

//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     "Videos",
//                     style: TextStyle(
//                       color: AppColor.white,
//                       fontFamily: AppFonts.appFont,
//                       fontWeight: FontWeight.bold,
//                       fontSize: Responsive.sp(16),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: Responsive.h(1)),

//                 // Add your videos grid or list view here
//                 Container(
//                   height: Responsive.h(20),
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       color: AppColor.white.withOpacity(0.1),
//                       width: 2,
//                     ),
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   child: Center(
//                     child: Text(
//                       "Videos will be displayed here",
//                       style: TextStyle(color: AppColor.white.withOpacity(0.5)),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   /// Build default profile section when no data is available
//   Widget _buildDefaultProfileSection(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         CircleAvatar(
//           radius: 35,
//           backgroundColor: AppColor.white.withValues(alpha: 0.1),
//           child: Image(image: AssetImage("assets/images/image.png")),
//         ),
//         Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Company Name",
//               style: TextStyle(
//                 fontSize: Responsive.textScaleFactor * 14,
//                 color: AppColor.white,
//                 fontFamily: AppFonts.appFont,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Row(
//               children: [
//                 SvgPicture.asset("assets/icons/call.svg"),
//                 SizedBox(width: Responsive.w(1)),
//                 Text(
//                   "Phone not set",
//                   style: TextStyle(
//                     fontSize: Responsive.textScaleFactor * 12,
//                     color: AppColor.white,
//                     fontFamily: AppFonts.appFont,
//                     fontWeight: FontWeight.normal,
//                   ),
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 SvgPicture.asset("assets/icons/mail-02.svg"),
//                 SizedBox(width: Responsive.w(1)),
//                 Text(
//                   "Email not set",
//                   style: TextStyle(
//                     fontSize: Responsive.textScaleFactor * 12,
//                     color: AppColor.white,
//                     fontFamily: AppFonts.appFont,
//                     fontWeight: FontWeight.normal,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => EditPromoterProfile()),
//             );
//           },
//           child: SvgPicture.asset("assets/icons/edits.svg"),
//         ),
//       ],
//     );
//   }

//   /// Build promoter profile section with actual data
//   Widget _buildPromoterProfileSection(
//     BuildContext context,
//     PromoterDataModel promoter,
//   ) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         CircleAvatar(
//           radius: 35,
//           backgroundColor: AppColor.white.withValues(alpha: 0.1),
//           child:
//               promoter.companyLogo != null && promoter.companyLogo!.isNotEmpty
//               ? ClipOval(
//                   child: Image.network(
//                     promoter.companyLogo!,
//                     width: 70,
//                     height: 70,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) {
//                       return Image(
//                         image: AssetImage("assets/images/image.png"),
//                       );
//                     },
//                   ),
//                 )
//               : Image(image: AssetImage("assets/images/image.png")),
//         ),
//         Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               promoter.companyName ?? "Company Name",
//               style: TextStyle(
//                 fontSize: Responsive.textScaleFactor * 14,
//                 color: AppColor.white,
//                 fontFamily: AppFonts.appFont,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Row(
//               children: [
//                 SvgPicture.asset("assets/icons/call.svg"),
//                 SizedBox(width: Responsive.w(1)),
//                 Text(
//                   promoter.contactNumber ?? "Phone not set",
//                   style: TextStyle(
//                     fontSize: Responsive.textScaleFactor * 12,
//                     color: AppColor.white,
//                     fontFamily: AppFonts.appFont,
//                     fontWeight: FontWeight.normal,
//                   ),
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 SvgPicture.asset("assets/icons/mail-02.svg"),
//                 SizedBox(width: Responsive.w(1)),
//                 Text(
//                   promoter.contactEmail ?? "Email not set",
//                   style: TextStyle(
//                     fontSize: Responsive.textScaleFactor * 12,
//                     color: AppColor.white,
//                     fontFamily: AppFonts.appFont,
//                     fontWeight: FontWeight.normal,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => EditPromoterProfile(promoterData: promoter),
//               ),
//             );
//           },
//           child: SvgPicture.asset("assets/icons/edits.svg"),
//         ),
//       ],
//     );
//   }

//   /// Reusable Stat Card
//   Widget _buildStatCard(String title, String value) {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColor.black,
//         border: BoxBorder.all(
//           color: AppColor.white.withValues(alpha: 0.1),
//           width: 2,
//         ),
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 color: AppColor.white,
//                 fontFamily: AppFonts.appFont,
//                 fontWeight: FontWeight.normal,
//                 fontSize: Responsive.sp(10.5),
//               ),
//             ),
//             Text(
//               value,
//               style: TextStyle(
//                 color: AppColor.white,
//                 fontFamily: AppFonts.appFont,
//                 fontWeight: FontWeight.bold,
//                 fontSize: Responsive.sp(24),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

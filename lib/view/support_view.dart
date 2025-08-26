import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:cage/view/Profile/fighter/createnew_ticticket_view.dart';
import 'package:cage/widgets/button.dart';
import 'package:cage/models/ticket_model.dart';
import 'package:cage/provider/ticket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;
import 'package:provider/provider.dart';

class SupportView extends StatefulWidget {
  SupportView({super.key});

  @override
  State<SupportView> createState() => _SupportViewState();
}

class _SupportViewState extends State<SupportView> {
  @override
  void initState() {
    super.initState();
    // Fetch tickets when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TicketProvider>().fetchTickets();
    });
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return ChangeNotifierProvider(
      create: (_) => TicketProvider(),
      child: Scaffold(
        backgroundColor: AppColor.black,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                      "Support Tickets",
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

                // Tickets List
                Expanded(
                  child: Consumer<TicketProvider>(
                    builder: (context, ticketProvider, child) {
                      if (ticketProvider.isLoading) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: AppColor.red),
                              SizedBox(height: 16),
                              Text(
                                "Loading tickets...",
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      if (ticketProvider.error != null) {
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
                                'Error loading tickets',
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  ticketProvider.fetchTickets();
                                },
                                child: Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }

                      final tickets = ticketProvider.tickets;

                      if (tickets.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.support_agent,
                                color: AppColor.red,
                                size: 48,
                              ),
                              SizedBox(height: 16),
                              Text(
                                "No tickets found",
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Create your first support ticket!",
                                style: TextStyle(
                                  color: AppColor.white.withOpacity(0.7),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: tickets.length,
                        itemBuilder: (context, index) {
                          final ticket = tickets[index];
                          return _buildTicketCard(ticket);
                        },
                      );
                    },
                  ),
                ),

                SizedBox(height: Responsive.h(2)),

                Button(
                  text: "Create New Ticket",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreatenewTicticketView(),
                      ),
                    );
                  },
                  focusNode: FocusNode(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTicketCard(TicketModel ticket) {
    Color statusColor;
    switch (ticket.status) {
      case 'open':
        statusColor = Colors.green;
        break;
      case 'in-progress':
        statusColor = const Color(0xFFFF7700);
        break;
      case 'closed':
        statusColor = Colors.grey;
        break;
      default:
        statusColor = Colors.green;
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: Responsive.h(2)),
      decoration: BoxDecoration(
        border: BoxBorder.all(color: AppColor.white.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: statusColor,
                    border: BoxBorder.all(
                      color: AppColor.white.withValues(alpha: 0.5),
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Center(
                      child: Text(
                        ticket.status.replaceAll('-', ' ').toUpperCase(),
                        style: TextStyle(
                          fontSize: Responsive.textScaleFactor * 12,
                          color: AppColor.white,
                          fontFamily: AppFonts.appFont,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  Utils.convertDateFormat(
                    ticket.createdAt.toString().split(' ')[0],
                  ),
                  style: TextStyle(
                    fontSize: Responsive.textScaleFactor * 12,
                    color: AppColor.white,
                    fontFamily: AppFonts.appFont,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: Responsive.h(1)),
            Text(
              ticket.subject,
              style: TextStyle(
                fontSize: Responsive.textScaleFactor * 14,
                color: AppColor.white,
                fontFamily: AppFonts.appFont,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: Responsive.h(1)),
            Text(
              ticket.message,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: Responsive.textScaleFactor * 12,
                color: AppColor.white,
                fontFamily: AppFonts.appFont,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

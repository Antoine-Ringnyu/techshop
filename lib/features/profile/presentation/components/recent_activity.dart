import 'package:flutter/material.dart';
import 'package:techrx/features/profile/data/supabase_profile_repo.dart';
import 'package:techrx/features/profile/presentation/components/recent_activity_tile.dart';
import 'package:techrx/features/ticket/presentation/pages/ticket_details.dart';

class RecentActivity extends StatefulWidget {
  final String? userId;
  const RecentActivity({super.key, this.userId});

  @override
  State<RecentActivity> createState() => _RecentActivityState();
}

class _RecentActivityState extends State<RecentActivity> {
  final supabaseProfileRepo =
      SupabaseProfileRepo(); // Instance of TicketDb to access stream

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: StreamBuilder(
        // Listening to the stream from supabaeTicketRepo
        stream: supabaseProfileRepo.fetchTicket(widget.userId),

        // Building UI based on stream data
        builder: (context, snapshot) {
          // Show loading indicator while waiting for data
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // If data is loaded, display the tickets
          final tickets = snapshot.data!;

          // Display tickets in a ListView
          return ListView.builder(
            shrinkWrap: true,

            // Number of tickets
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              // Each ticket in the list
              final ticket = tickets[index];

              // Display each ticket's issue description
              return RecentActivityTile(
                userName: ticket.userName,
                userLocation: ticket.location,
                issueDescription: ticket.issueDescription,
                detailPage: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TicketDetails(
                      id: ticket.id!,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

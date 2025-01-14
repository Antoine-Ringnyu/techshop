import 'package:flutter/material.dart';
import 'package:techrx/core/utils/ticket_utils.dart';
import 'package:techrx/features/profile/presentation/components/recent_activity_tile.dart';
import 'package:techrx/features/ticket/data/supaabase_ticket_repo.dart';
import 'package:techrx/features/ticket/presentation/pages/ticket_details.dart';

class SampleTickets extends StatefulWidget {
  const SampleTickets({
    super.key,
  });

  @override
  State<SampleTickets> createState() => _SampleTicketsState();
}

class _SampleTicketsState extends State<SampleTickets> {
  final supabaseTicketRepo =
      SupaabaseTicketRepo(); // Instance of TicketDb to access stream
  final int contact = 652605131;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
          // maxHeight: 300,
          ),
      child: FutureBuilder(
        // Listening to the stream from supabaseTicketRepo
        future:
            supabaseTicketRepo.fetchTicketByContactAndId(contact.toString()),

        // Building UI based on stream data
        builder: (context, snapshot) {
          // Show loading indicator while waiting for data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // If there's an error (e.g., no internet connection)
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Make sure you enable internet access",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
            );
          }

          // If no data is available (empty tickets)
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No tickets found. Please check your internet connection.",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
            );
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

              // Call the utility function to get the status and color
              final status = getTicketStatusAndColor(ticket);
              final statusColor = status['statusColor'];

              // Display each ticket's issue description
              return RecentActivityTile(
                userName: ticket.userName,
                userLocation: ticket.location,
                issueDescription: ticket.issueDescription,
                statusColor: statusColor,
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

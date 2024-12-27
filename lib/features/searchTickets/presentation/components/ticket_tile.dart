import 'package:flutter/material.dart';
import 'package:techrx/features/ticket/domain/entities/ticket.dart';
import 'package:techrx/features/ticket/presentation/pages/ticket_page.dart';

class TicketTile extends StatelessWidget {
  final Ticket ticket;
  const TicketTile({
    super.key,
    required this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    // Set the color for ticket status
    Color statusColor;

    switch (ticket.status) {
      case 'Closed':
        statusColor = Colors.green; // Green for closed
        break;
      case 'Completed':
        statusColor = Colors.blue; // Blue for completed
        break;
      case 'Pending':
        statusColor = Colors.yellow; // Yellow for pending
        break;
      case 'In_Progress':
        statusColor = Colors.orange; // Orange for in progress
        break;
      default:
        statusColor = Colors.grey; // Default if no match
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TicketPage(
              ticket: ticket,
            ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).colorScheme.primary),
          ),
          child: Row(
            children: [
              Expanded(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  // textColor: Colors.black,
                  title: Text(ticket.userName),
                  subtitle: Text(ticket.issueDescription),
                  titleTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold),
                  subtitleTextStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              // Status color container
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(45),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

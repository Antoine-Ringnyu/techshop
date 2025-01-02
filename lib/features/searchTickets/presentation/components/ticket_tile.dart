import 'package:flutter/material.dart';
import 'package:techrx/features/ticket/domain/entities/ticket.dart';
import 'package:techrx/features/ticket/presentation/pages/ticket_page.dart';
import 'package:techrx/core/utils/ticket_utils.dart'; // Import the utility function

class TicketTile extends StatelessWidget {
  final Ticket ticket;

  const TicketTile({
    super.key,
    required this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    // Call the utility function to get the status and color
    final status = getTicketStatusAndColor(ticket);
    final statusColor = status['statusColor'];

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
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).colorScheme.secondary),
          ),
          child: Row(
            children: [
              Expanded(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(ticket.userName),
                  subtitle: SizedBox(
                      height: 45, child: Text(ticket.issueDescription)),
                  titleTextStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  subtitleTextStyle: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
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

import 'package:flutter/material.dart';

class TicketTile extends StatelessWidget {
  // final Ticket ticket;
  final String? ticketId;
  final String userName;
  final String issueDescription;
  final Color? statusColor;
  final Function detailPage;

  const TicketTile({
    super.key,
    // required this.ticket,
    this.ticketId,
    required this.userName,
    required this.issueDescription,
    this.statusColor,
    required this.detailPage,
  });

  @override
  Widget build(BuildContext context) {
    // Call the utility function to get the status and color
    // final status = getTicketStatusAndColor(ticket);
    // final statusColor = status['statusColor'];

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        onTap: () => detailPage(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).colorScheme.secondary),
          ),
          child: Row(
            children: [
              Expanded(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(0), // Ensures no padding
                  horizontalTitleGap: 0, // Removes the horizontal gap
                  minVerticalPadding: 0, // Removes vertical padding
                  dense: true,
                  // contentPadding: EdgeInsets.zero,
                  title: Text(userName),
                  subtitle: SizedBox(
                      height: 45,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(issueDescription),
                      )),
                  titleTextStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  subtitleTextStyle: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),

              const SizedBox(
                width: 10,
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

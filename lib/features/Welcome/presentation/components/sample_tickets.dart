import 'package:flutter/material.dart';
import 'package:techrx/features/ticket/data/supaabase_ticket_repo.dart';

class SampleTickets extends StatefulWidget {
  const SampleTickets({super.key});

  @override
  State<SampleTickets> createState() => _SampleTicketsState();
}

class _SampleTicketsState extends State<SampleTickets> {
  final supabaseTicketRepo =
      SupaabaseTicketRepo(); // Instance of TicketDb to access stream

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: StreamBuilder(
        // Listening to the stream from TicketDb
        stream: supabaseTicketRepo.stream,

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
            itemCount: 7,
            itemBuilder: (context, index) {
              // Each ticket in the list
              final ticket = tickets[index];

              // Display each ticket's issue description
              return Column(
                children: [
                  Divider(
                    color: Colors.grey[400],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary),
                            borderRadius: BorderRadius.circular(8)),
                        child: Icon(
                          Icons.person,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Expanded(
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.all(0), // Ensures no padding
                          horizontalTitleGap: 0, // Removes the horizontal gap
                          minVerticalPadding: 0, // Removes vertical padding
                          dense:
                              true, // Makes the ListTile more compact by reducing height
                          title: Text(ticket.userName),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(
                                top: 4.0), // Add vertical padding to subtitle
                            child: Text(ticket.issueDescription),
                          ),
                          titleTextStyle: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                          subtitleTextStyle: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

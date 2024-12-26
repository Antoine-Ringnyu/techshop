import 'package:flutter/material.dart';
import 'package:techrx/features/ticket/data/datasources/ticket_db.dart';

class SampleTickets extends StatefulWidget {
  const SampleTickets({super.key});

  @override
  State<SampleTickets> createState() => _SampleTicketsState();
}

class _SampleTicketsState extends State<SampleTickets> {
  final ticketdb = TicketDb(); // Instance of TicketDb to access stream

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: StreamBuilder(
        // Listening to the stream from TicketDb
        stream: ticketdb.stream,

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
              return ListTile(
                title: Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary),
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
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

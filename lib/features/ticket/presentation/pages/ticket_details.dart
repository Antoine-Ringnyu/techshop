import 'package:flutter/material.dart';
import 'package:techrx/core/utils/ticket_utils.dart';
import 'package:techrx/features/ticket/data/supaabase_ticket_repo.dart';
import 'package:techrx/features/ticket/domain/entities/ticket.dart';
import 'package:techrx/features/ticket/presentation/components/ticket_info_tile.dart';
import 'package:techrx/features/ticket/presentation/pages/edit_ticket.dart';

class TicketDetails extends StatefulWidget {
  final int id;
  const TicketDetails({super.key, required this.id});

  @override
  State<TicketDetails> createState() => _TicketDetailsState();
}

class _TicketDetailsState extends State<TicketDetails> {
  final supabaseTicketRepo =
      SupaabaseTicketRepo(); // Instance of TicketDb to access stream

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: StreamBuilder<List<Ticket>>(
        // Listen to the stream of data from supabaseTicketRepo
        stream: supabaseTicketRepo.fetchTicket(widget.id),
        builder: (context, snapshot) {
          // Show loading indicator while waiting for the data
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // If data is loaded, display the ticket details
          final tickets = snapshot.data!;
          Ticket ticket = tickets[0];

          // Parse the image URLs from the comma-separated string
          List<String> imageUrls = ticket.imageUrl?.split(',') ?? [];
          final status = getTicketStatusAndColor(ticket);
          final statusText = status['statusText'];
          final statusColor = status['statusColor'];

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_sharp,
                      color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                expandedHeight: 200,
                floating: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.asset(
                    'lib/assets/images/smile.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50)),
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    color: Theme.of(context).colorScheme.primary,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Ticket 3750-${ticket.id}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                              ),
                            ),
                            Icon(
                              Icons.perm_contact_cal_rounded,
                              color: statusColor,
                              size: 50,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(45),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                color: statusColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              statusText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 50),
                        TextButton.icon(
                          onPressed: () {
                            // Call Technician functionality
                          },
                          icon: Icon(
                            Icons.call,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          label: Text(
                            'Call Technician',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontSize: 18,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 64, vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TicketInfoTile(
                        icon: Icons.person_outline,
                        text: ticket.userName,
                        bold: FontWeight.bold,
                        crossAxisAlignment: CrossAxisAlignment.center,
                      ),
                      const SizedBox(height: 30),
                      TicketInfoTile(
                        icon: Icons.location_on_outlined,
                        text: ticket.location,
                        crossAxisAlignment: CrossAxisAlignment.center,
                      ),
                      const SizedBox(height: 30),
                      TicketInfoTile(
                        icon: Icons.notes,
                        text: ticket.issueDescription,
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                      const SizedBox(height: 30),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.local_phone_outlined,
                            color: Theme.of(context).colorScheme.primary,
                            size: 30,
                          ),
                          const SizedBox(width: 25),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                color: Theme.of(context).colorScheme.secondary,
                                child: Text(
                                  ticket.contact,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            color: Theme.of(context).colorScheme.primary,
                            size: 32,
                          ),
                          const SizedBox(width: 25),
                          Expanded(
                            child: Row(
                              children: imageUrls.isEmpty ||
                                      imageUrls[0].isEmpty
                                  ? [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Container(
                                            child: const Text('No Attachment'),
                                          ),
                                        ),
                                      )
                                    ]
                                  : imageUrls.map((url) {
                                      return Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 2.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Image.network(url,
                                                width: double.infinity,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ClipRRect(
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    height: 300,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: StreamBuilder<List<Ticket>>(
        stream: supabaseTicketRepo.fetchTicket(widget.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox(); // Don't show the button if ticket data is not available
          }

          final tickets = snapshot.data!;
          Ticket ticket =
              tickets[0]; // Ensure you have access to the ticket object

          return FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditTicket(ticket: ticket), // Pass ticket here
                ),
              );
            },
            backgroundColor: Theme.of(context).colorScheme.secondary,
            tooltip: 'Edit Ticket',
            child: const Icon(
              Icons.edit_note,
              size: 40,
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:techrx/core/utils/ticket_utils.dart';
import 'package:techrx/features/comments/data/supabase_comment_repo.dart';
import 'package:techrx/features/comments/domain/entity/comment.dart';
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
  final supabaseTicketRepo = SupaabaseTicketRepo();
  final supabaseCommentRepo = SupabaseCommentRepo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: StreamBuilder<List<Ticket>>(
        stream: supabaseTicketRepo
            .getTicketStream(widget.id), // Use Stream-based method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            String errorMessage;

            // Check the type of error and customize the message
            if (snapshot.error is SocketException) {
              errorMessage =
                  'Network error: \nPlease check your internet connection.';
            } else if (snapshot.error is HttpException) {
              errorMessage =
                  'HTTP error: \nUnable to fetch data from the server.';
            } else if (snapshot.error is FormatException) {
              errorMessage = 'Format error: \nInvalid data received.';
            } else {
              errorMessage = 'Unexpected error: \n${snapshot.error}';
            }

            return _buildErrorWidget(errorMessage);
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Details yet.'));
          }

          final ticket = snapshot.data!.first;
          return _buildTicketDetails(context, ticket);
        },
      ),
      floatingActionButton: StreamBuilder<List<Ticket>>(
        stream: supabaseTicketRepo.getTicketStream(widget.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const SizedBox();
          }
          final ticket = snapshot.data!.first;
          return FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditTicket(ticket: ticket),
                ),
              );
            },
            backgroundColor: Theme.of(context).colorScheme.secondary,
            tooltip: 'Edit Ticket',
            child: const Icon(Icons.edit_note, size: 40),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildTicketDetails(BuildContext context, Ticket ticket) {
    final status = getTicketStatusAndColor(ticket);
    final statusText = status['statusText'];
    final statusColor = status['statusColor'];
    final imageUrls = ticket.imageUrl?.split(',') ?? [];

    return CustomScrollView(
      slivers: [
        _buildAppBar(context),
        _buildHeader(ticket, statusText, statusColor),
        _buildTicketInfo(ticket, imageUrls),
        _buildComments(ticket.id!), // Separate comments builder
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_sharp,
            color: Colors.white, size: 30),
        onPressed: () => Navigator.pop(context),
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
    );
  }

  Widget _buildHeader(Ticket ticket, String statusText, Color statusColor) {
    return SliverToBoxAdapter(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
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
                  Icon(Icons.perm_contact_cal_rounded,
                      color: statusColor, size: 50),
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
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              TextButton.icon(
                onPressed: () {}, // Call technician functionality
                icon: Icon(Icons.call,
                    color: Theme.of(context).colorScheme.tertiary),
                label: Text(
                  'Call Technician',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 18,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 64, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketInfo(Ticket ticket, List<String> imageUrls) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
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
            _buildImages(imageUrls),
          ],
        ),
      ),
    );
  }

  Widget _buildImages(List<String> imageUrls) {
    return Row(
      children: imageUrls.isEmpty || imageUrls[0].isEmpty
          ? [const Text('No Attachment')]
          : imageUrls.map((url) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(url, width: double.infinity),
                  ),
                ),
              );
            }).toList(),
    );
  }

  Widget _buildComments(int ticketId) {
    return SliverToBoxAdapter(
      child: StreamBuilder<List<Comment>>(
        stream: supabaseCommentRepo.getTicketComment(ticketId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No comments yet.'));
          }

          final comments = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
              return ListTile(
                title: Text(comment.note),
                subtitle: Text('@${comment.ticketId}'),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildErrorWidget(dynamic error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error, // Choose an appropriate error icon
            color: Colors.red,
            size: 100, // Adjust the size as needed
          ),
          const SizedBox(height: 10), // Add spacing between the icon and text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              error,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

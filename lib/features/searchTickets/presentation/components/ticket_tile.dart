import 'package:flutter/material.dart';
import 'package:techrx/features/ticket/domain/entities/ticket.dart';

class TicketTile extends StatelessWidget {
  final Ticket ticket;
  const TicketTile({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      textColor: Colors.black,
      title: Text(ticket.userName),
      subtitle: Text(ticket.issueDescription),
    );
  }
}

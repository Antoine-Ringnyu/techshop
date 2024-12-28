import 'package:flutter/material.dart';
import 'package:techrx/features/ticket/domain/entities/ticket.dart';

/// Utility function to get ticket status and color
Map<String, dynamic> getTicketStatusAndColor(Ticket ticket) {
  Color statusColor;
  String statusText;

  switch (ticket.status) {
    case 'Closed':
      statusColor = Colors.green;
      statusText = 'Closed';
      break;
    case 'Completed':
      statusColor = Colors.blue;
      statusText = 'Completed';
      break;
    case 'Pending':
      statusColor = Colors.yellow;
      statusText = 'Pending';
      break;
    case 'In_Progress':
      statusColor = Colors.orange;
      statusText = 'In Progress';
      break;
    default:
      statusColor = Colors.yellow;
      statusText = 'Pending';
  }

  return {
    'statusText': statusText,
    'statusColor': statusColor,
  };
}

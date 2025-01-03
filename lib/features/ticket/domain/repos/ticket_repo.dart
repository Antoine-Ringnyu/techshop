import 'package:techrx/features/ticket/domain/entities/ticket.dart';

abstract class TicketRepo {
  Future<List<Ticket>> fetchAllTickets();
  Future<void> createTicket(Ticket ticket);
  Future<void> deleteTicket(Ticket ticketId);
  Future<List<Ticket>> fetchTicketByContactAndId(String query);
  Future<void> updateTicket(
    Ticket oldTicket,
    String newUserName,
    String newLocation,
    String newContact,
    String newIssueDescription,
    String? newStatus,
    String? imageUrl,
  );
}

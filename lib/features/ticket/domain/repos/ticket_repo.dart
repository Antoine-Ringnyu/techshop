import 'package:techrx/features/ticket/domain/entities/ticket.dart';

abstract class TicketRepo {
  Future<List<Ticket>> fetchAllTickets();
  Future<void> createTicket(Ticket ticket);
  Future<void> deleteTicket(Ticket ticketId);
  Future<List<Ticket>> fetchTicketByContactAndId(String query);
  Stream<List<Ticket>> fetchTicket(int query);
  Future<void> updateTicket(
    Ticket oldTicket,
    Ticket updatedTicket
  );
}

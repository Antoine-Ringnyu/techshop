import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:techrx/features/ticket/domain/entities/ticket.dart';
import 'package:techrx/features/ticket/domain/repos/ticket_repo.dart';
// Import Supabase package

class SupaabaseTicketRepo implements TicketRepo {
  final supabase = Supabase.instance.client;

  //...................................all testings go in herr...................................

  @override
  Stream<List<Ticket>> fetchTicket(int query) {
    return supabase
        .from('tickets')
        .stream(primaryKey: ['id']) // Listen for changes in the tickets table
        .eq('id', query)
        .map((data) =>
            data.map((ticketMap) => Ticket.fromMap(ticketMap)).toList());
  }

  //...................................end of testing section...................................

  @override
  Future<void> createTicket(Ticket newTicket) async {
    //database tickets
    final database = Supabase.instance.client.from('tickets');
    await database.insert(newTicket.toMap());
  }

  @override
  Future<void> deleteTicket(Ticket ticket) async {
    //database tickets
    final database = Supabase.instance.client.from('tickets');
    await database.delete().eq('id', ticket.id!);
  }

  @override
  Future<List<Ticket>> fetchAllTickets() async {
    try {
      // Fetch all tickets from the 'tickets' table
      final response = await supabase.from('tickets').select();

      // Map the response data to Ticket objects
      return List<Ticket>.from(
        response.map((item) => Ticket.fromMap(item)),
      );
    } catch (e) {
      throw Exception('Error searching tickets: $e');
    }
  }

  @override
  Future<List<Ticket>> fetchTicketByContactAndId(String query) async {
    try {
      // Perform case-insensitive search on 'name' and 'contact' fields
      final response = await supabase
          .from('tickets')
          .select()
          .eq('contact', query)
          .order('created_at', ascending: false);
      // .ilike('contact', '%$query%');

      // Map the response data to Ticket objects
      return List<Ticket>.from(
        response.map((item) => Ticket.fromMap(item)),
      );
    } catch (e) {
      throw Exception('Error searching tickets: $e');
    }
  }

  Stream<List<Ticket>> get stream {
    return Supabase.instance.client
        .from('tickets')
        .stream(primaryKey: ['id']) // Listen for changes in the tickets table
        .map((data) =>
            data.map((ticketMap) => Ticket.fromMap(ticketMap)).toList());
  }

  @override
  Future<void> updateTicket(Ticket oldTicket, Ticket updatedTicket) async {
    if (oldTicket.id == null) {
      // Handle the case when the id is null (you can throw an exception, return early, or show an error)
      throw Exception("Ticket id is null. Cannot update ticket.");
    }

    final database = Supabase.instance.client.from('tickets');

    try {
      await database.update({
        'userName': updatedTicket.userName, // Update fields individually
        'location': updatedTicket.location,
        'contact': updatedTicket.contact,
        'issueDescription': updatedTicket.issueDescription,
        'emergency': updatedTicket.emergency,
        'imageUrl': updatedTicket.imageUrl,
      }).eq('id', oldTicket.id!); // Use the id safely after null check
    } catch (e) {
      // Handle any errors that occur during the update
      throw Exception("Error updating ticket: $e");
    }
  }
}

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:techrx/features/ticket/domain/entities/ticket.dart';

class TicketDb {
  //database tickets
  final database = Supabase.instance.client.from('tickets');

  //create ticket
  Future createTicket(Ticket newTicket) async {
    await database.insert(newTicket.toMap());
  }

  //read ticket

  /*
      final stream = Supabase.instance.client.from('tickets').stream(
    primaryKey: ['id'],
  ).map((data) => data.map((ticketMap) => Ticket.fromMap(ticketMap)).toList());
  */

  Stream<List<Ticket>> get stream {
    return Supabase.instance.client
        .from('tickets')
        .stream(primaryKey: ['id']) // Listen for changes in the tickets table
        .map((data) =>
            data.map((ticketMap) => Ticket.fromMap(ticketMap)).toList());
  }

  //update ticket
  Future updateTicket(Ticket oldTicket, String newUserName, String newLocation,
      String newContact, String newIssueDescription) async {
    await database.update({
      'userName': newUserName,
      'location': newLocation,
      'contact': newContact,
      'issueDescription': newIssueDescription,
    }).eq('id', oldTicket.id!);
  }

  //delete ticket
  Future deleteTicket(Ticket ticket) async {
    await database.delete().eq('id', ticket.id!);
  }
}

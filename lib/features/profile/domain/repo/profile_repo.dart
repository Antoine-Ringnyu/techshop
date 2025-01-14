import 'package:techrx/features/ticket/domain/entities/ticket.dart';

abstract class ProfileRepo {
  Stream<List<Ticket>> fetchTicket(String query);
}

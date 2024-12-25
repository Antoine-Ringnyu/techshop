import 'package:techrx/features/ticket/domain/entities/ticket.dart';

abstract class SearchRepo {
  Future<List<Ticket?>> searchTickets(String query);
}

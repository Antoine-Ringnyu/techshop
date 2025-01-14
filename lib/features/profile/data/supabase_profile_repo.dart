import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:techrx/features/profile/domain/repo/profile_repo.dart';
import 'package:techrx/features/ticket/domain/entities/ticket.dart';

class SupabaseProfileRepo implements ProfileRepo {
  final supabase = Supabase.instance.client;

  @override
  Stream<List<Ticket>> fetchTicket(String? query) {
    return supabase
        .from('tickets')
        .stream(primaryKey: ['id']) // Listen for changes in the tickets table
        .eq('userId', query ?? Null)
        .map((data) =>
            data.map((ticketMap) => Ticket.fromMap(ticketMap)).toList());
  }
}

import 'package:techrx/features/searchTickets/domain/search_repo.dart';
import 'package:techrx/features/ticket/domain/entities/ticket.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase package

class SupabaseSearchRepo implements SearchRepo {
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Future<List<Ticket?>> searchTickets(String query) async {
    try {
      // Perform case-insensitive search on 'name' and 'contact' fields
      final response =
          await supabase.from('tickets').select().eq('contact', query);
          // .ilike('contact', '%$query%');

      // Map the response data to Ticket objects
      return List<Ticket>.from(
        response.map((item) => Ticket.fromMap(item)),
      );
    } catch (e) {
      throw Exception('Error searching tickets: $e');
    }
  }
}

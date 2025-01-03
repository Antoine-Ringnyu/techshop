import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techrx/features/searchTickets/presentation/cubit/search_state.dart';
import 'package:techrx/features/ticket/domain/repos/ticket_repo.dart';

class SearchCubit extends Cubit<SearchState> {
  final TicketRepo ticketRepo;
  SearchCubit({required this.ticketRepo}) : super(SearchInitial());

  Future<void> searchTickets(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    try {
      emit(SearchLoading());
      final tickets = await ticketRepo.fetchTicketByContactAndId(query);
      emit(SearchLoaded(tickets));
    } catch (e) {
      emit(SearchError("Error fetching search results"));
    }
  }
}

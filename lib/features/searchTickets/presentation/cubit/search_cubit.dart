import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techrx/features/searchTickets/domain/search_repo.dart';
import 'package:techrx/features/searchTickets/presentation/cubit/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepo searchRepo;
  SearchCubit({required this.searchRepo}) : super(SearchInitial());

  Future<void> searchTickets(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    try {
      emit(SearchLoading());
      final tickets = await searchRepo.searchTickets(query);
      emit(SearchLoaded(tickets));
    } catch (e) {
      emit(SearchError("Error fetching search results"));
    }
  }
}

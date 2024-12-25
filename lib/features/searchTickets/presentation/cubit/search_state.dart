import 'package:techrx/features/ticket/domain/entities/ticket.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Ticket?> tickets;

  SearchLoaded(this.tickets);
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techrx/features/searchTickets/presentation/components/ticket_tile.dart';
import 'package:techrx/features/searchTickets/presentation/cubit/search_cubit.dart';
import 'package:techrx/features/searchTickets/presentation/cubit/search_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  late final searchCubit = context.read<SearchCubit>();

  void onSearchChanged() {
    final query = searchController.text;
    searchCubit.searchTickets(query);
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400]!),
              borderRadius: BorderRadius.circular(12),
            ),
            hintText: "Enter ticket ID or your contact",
            hintStyle: TextStyle(color: Colors.grey[500]!),
            fillColor: Theme.of(context).colorScheme.surface,
            filled: true,

            //prefixIcon
            prefixIcon: Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.secondary,
            ),

            //clear text icon button
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  searchController.clear();
                });
              },
              icon: Icon(
                Icons.cancel,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),

            //border when selected
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.tertiary),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),

      //search results
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          //loaded
          if (state is SearchLoaded) {
            //no tickets
            if (state.tickets.isEmpty) {
              return const Center(
                child: Text("No Tickets found"),
              );
            }

            //tickets
            return ListView.builder(
              itemCount: state.tickets.length,
              itemBuilder: (context, index) {
                final ticket = state.tickets[index];
                return TicketTile(ticket: ticket!);
              },
            );
          }
          //loading
          else if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          //error

          else if (state is SearchError) {
            return Center(child: Text(state.message));
          }
          //default
          return const Center(child: Text("Start serching for tickets.."));
        },
      ),
    );
  }
}

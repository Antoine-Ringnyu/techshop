import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techrx/features/searchTickets/presentation/components/ticket_tile.dart';
import 'package:techrx/features/searchTickets/presentation/cubit/search_cubit.dart';
import 'package:techrx/features/searchTickets/presentation/cubit/search_state.dart';

class SearchTickets extends StatefulWidget {
  const SearchTickets({super.key});

  @override
  State<SearchTickets> createState() => _SearchTicketsState();
}

class _SearchTicketsState extends State<SearchTickets> {
  // Get the search cubit
  late final searchCubit = context.read<SearchCubit>();

  // Controller
  final TextEditingController searchController = TextEditingController();

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
    return Column(
      children: [
        // Search text field
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[400]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "Your contact or ticket ID ",
                  hintStyle: TextStyle(color: Colors.grey[500]!),
                  fillColor: Theme.of(context).colorScheme.surface,
                  filled: true,

                  // Prefix icon
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.secondary,
                  ),

                  // Clear text icon button
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

                  // Border when selected
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.tertiary),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            // Search icon button
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                border: Border.all(color: Colors.grey[400]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.search,
                  size: 32,
                ),
                color: Theme.of(context).colorScheme.tertiary,
                onPressed: onSearchChanged,
              ),
            )
          ],
        ),

        const SizedBox(
          height: 10,
        ),

        // Search results dropdown
        BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            // Only show the dropdown when there is text in the search field
            if (searchController.text.isNotEmpty) {
              if (state is SearchLoaded) {
                if (state.tickets.isEmpty) {
                  return _buildDropdownContent(
                    "No tickets found",
                  );
                }

                return _buildDropdownList(state.tickets);
              }

              if (state is SearchLoading) {
                return _buildDropdownContent(
                  "Loading...",
                );
              }

              if (state is SearchError) {
                return _buildDropdownContent(
                  state.message,
                );
              }
            }
            // Return empty if no input
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  // Widget to build the dropdown content
  Widget _buildDropdownContent(String message) {
    return Material(
      color: Colors.transparent, // Transparent to show overlay
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).colorScheme.surface),
        ),
        child: Center(child: Text(message)),
      ),
    );
  }

  // Widget to build the list of search results
  Widget _buildDropdownList(List tickets) {
    return Material(
      color: Colors.transparent, // Transparent to show overlay
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 300.0, // Set your desired max height
        ),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).colorScheme.surface),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(
                tickets.length,
                (index) {
                  final ticket = tickets[index];
                  return TicketTile(ticket: ticket!);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

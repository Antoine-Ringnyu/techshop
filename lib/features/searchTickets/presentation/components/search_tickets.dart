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
  //get the search cubit
  late final searchCubit = context.read<SearchCubit>();

  //controller
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
    return ListView(
      shrinkWrap: true,
      children: [
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
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.tertiary),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(
              width: 4,
            ),

            //search iconbutton
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                border: Border.all(color: Colors.grey[400]!),
                borderRadius: BorderRadius.circular(8),
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

        //the search body
        SizedBox(
          child: BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              //loaded
              if (state is SearchLoaded) {
                //no users..
                if (state.tickets.isEmpty) {
                  return const Center(
                    child: Text("No tickets found"),
                  );
                }
                //users...
                return SizedBox(
                  height: 200,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.tickets.length,
                    itemBuilder: (context, index) {
                      final ticket = state.tickets[index];
                      return TicketTile(ticket: ticket! );
                    },
                  ),
                );
              }
          
              //loading
              else if (state is SearchLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
          
              //erroe
              else if (state is SearchError) {
                return Center(
                  child: Text(state.message),
                );
              }
          
              //default
              return const Center(
                child: Text("Start searching for users.."),
              );
            },
          ),
        )
      ],
    );
  }
}

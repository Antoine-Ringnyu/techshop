import 'package:flutter/material.dart';

class SearchTickets extends StatefulWidget {
  const SearchTickets({super.key});

  @override
  State<SearchTickets> createState() => _SearchTicketsState();
}

class _SearchTicketsState extends State<SearchTickets> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
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
                onPressed: () {},
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
            onPressed: () {},
          ),
        )
      ],
    );
  }
}

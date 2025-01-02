import 'package:flutter/material.dart';

class RecentActivityTile extends StatelessWidget {
  const RecentActivityTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(2),
            color: Theme.of(context).colorScheme.inversePrimary,
            child: Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.secondary,
              size: 30,
            ),
          ),
        ),

        const SizedBox(width: 25), // Adds space between avatar and text

        // Content
        Expanded(
          // Ensures the content uses remaining space
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Name and Time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Antoine Ringnyu",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 14, // Adjusted for better consistency
                    ),
                  ),
                  Text(
                    "3 hours ago",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 12, // Adjusted font size
                    ),
                  ),
                ],
              ),

              const SizedBox(
                  height: 2), // Adds space between header and content

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First part with a maxLine of 1
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 14,
                      ),
                      children: const [
                        TextSpan(
                          text:
                              'é simplesmente uma simulação de texto da indústria tipográfica e de impressos, ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    maxLines: 1, // Limit the number of lines for the first part
                    overflow:
                        TextOverflow.ellipsis, // Handle overflow with ellipsis
                  ),

                  // Second part with a maxLine of 3
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 14,
                      ),
                      children: const [
                        TextSpan(
                          text:
                              'e vem sendo utilizado desde o século XVI, quando um impressor desconhecido pegou uma bandeja de tipos e osquando um impressor desconhecido pegou uma bandeja de tipos e osquando um impressor desconhecido pegou uma bandeja de tipos e os',
                          style: TextStyle(
                            fontWeight: FontWeight
                                .normal, // Example of a different style
                          ),
                        ),
                      ],
                    ),
                    maxLines:
                        2, // Limit the number of lines for the second part
                    overflow:
                        TextOverflow.ellipsis, // Handle overflow with ellipsis
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

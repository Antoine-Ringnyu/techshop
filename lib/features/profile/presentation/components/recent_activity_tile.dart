import 'package:flutter/material.dart';

class RecentActivityTile extends StatelessWidget {
  final String? userName;
  final String? issueDescription;
  final String? userLocation;
  final Function detailPage;
  final Color? statusColor;
  const RecentActivityTile(
      {super.key,
      this.userName,
      this.issueDescription,
      this.userLocation,
      required this.detailPage, this.statusColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => detailPage(),
          child: Row(
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
                    color: statusColor ?? Theme.of(context).colorScheme.secondary,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            userName ?? "My Ticket",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 14, // Adjusted for better consistency
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          "3 hours ago",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 10, // Adjusted font size
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
                            children: [
                              TextSpan(
                                text: userLocation,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          maxLines:
                              1, // Limit the number of lines for the first part
                          overflow: TextOverflow
                              .ellipsis, // Handle overflow with ellipsis
                        ),

                        // Second part with a maxLine of 3
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                text: issueDescription,
                                style: const TextStyle(
                                  fontWeight: FontWeight
                                      .normal, // Example of a different style
                                ),
                              ),
                            ],
                          ),
                          maxLines:
                              2, // Limit the number of lines for the second part
                          overflow: TextOverflow
                              .ellipsis, // Handle overflow with ellipsis
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Divider(
          color: Colors.grey[400],
        ),
      ],
    );
  }
}

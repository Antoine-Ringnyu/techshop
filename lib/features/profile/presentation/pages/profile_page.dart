import 'package:flutter/material.dart';
import 'package:techrx/features/auth/data/supabase_auth_repo.dart';
import 'package:techrx/features/auth/presentation/components/my_button.dart';
import 'package:techrx/features/profile/presentation/components/circular_tag.dart';
import 'package:techrx/features/profile/presentation/components/my_drawer.dart';
import 'package:techrx/features/profile/presentation/components/recent_activity_tile.dart';
import 'package:techrx/features/ticket/presentation/pages/create_ticket.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _HomePageState();
}

class _HomePageState extends State<ProfilePage> {
  //get auth service
  final supabaseAuthRepo = SupabaseAuthRepo();

  //logout button pressed
  void logout() async {
    await supabaseAuthRepo.logout();
  }

  //user wants to create a ticket
  void createTicket() {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        // title: Text("Create Ticket"),
        content: SingleChildScrollView(child: CreateTicket()),
      ),
    );
  }

  //BUILD UI
  @override
  Widget build(BuildContext context) {
    //get user email
    final currentUser = supabaseAuthRepo.getCurrentUser();

    //SCAFFOLD
    return Scaffold(
      //APP BAR
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
            // currentUser!.userMetadata!['username'] ?? 'No phone available',
            'T e c h R x'),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          //logout
          IconButton(onPressed: logout, icon: const Icon(Icons.logout_rounded)),
        ],
      ),

      //DRAWER
      drawer: MyDrawer(),

      //BODY
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PROFILE BANNER
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // //TRYING OUT
                  // Text(currentUser.toString()),
                  // const Divider(),
                  Text(
                    "Hello ${currentUser ?? 'Friend'}",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 18, // Adjusted font size for consistency
                    ),
                  ),

                  // Grand text
                  Text(
                    "Welcome back!",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 28,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30), // Adds space between sections

              //ABOUT MY TICKETS
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
                  color: Theme.of(context).colorScheme.primary,

                  //total number of tickets
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    //ticket statistics
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircularTag(
                            value: "109",
                            label: "All",
                            borderOutline:
                                Theme.of(context).colorScheme.tertiary,
                            fill: Theme.of(context).colorScheme.primary,
                          ),
                          CircularTag(
                            value: "07",
                            label: "Pending",
                            borderOutline:
                                Theme.of(context).colorScheme.tertiary,
                            fill: Theme.of(context).colorScheme.tertiary,
                          ),
                          const CircularTag(
                            value: "109",
                            label: "In Progress",
                            borderOutline: Colors.blue,
                            fill: Colors.blue,
                          ),
                          const CircularTag(
                            value: "10",
                            label: "Completed",
                            borderOutline: Colors.green,
                            fill: Colors.green,
                          ),
                        ],
                      ),
                      Divider(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "We don't just fix your devices, We restore trust. \nOur experts treat your tech with care because every devices has a story, \nLet's write the next chapter together.",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      const SizedBox(height: 24),

                      //action section
                      Row(
                        children: [
                          Expanded(
                            child: MyButton(
                              onTab: createTicket,
                              text: 'Create Ticket',
                              containerColor:
                                  Theme.of(context).colorScheme.tertiary,
                              textColor:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                          MyButton(
                            onTab: () {},
                            text: 'View Tickets',
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30), // Adds space between sections

              // RECENT ACTIVITIES
              Text(
                'MY RECENT ACTIVITY',
                style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.secondary),
              ),

              //divider
              Divider(
                color: Colors.grey[400],
              ),
              const SizedBox(height: 8),
              // Adds space between sections
              const RecentActivityTile(),

              //divider
              const SizedBox(height: 18),
              Divider(
                color: Colors.grey[400],
              ),
              const SizedBox(height: 8),
              const RecentActivityTile(),

              //divider
              const SizedBox(height: 18),
              Divider(
                color: Colors.grey[400],
              ),
              const SizedBox(height: 8),
              const RecentActivityTile(),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}

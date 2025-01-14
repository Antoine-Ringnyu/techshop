import 'package:flutter/material.dart';
import 'package:techrx/features/auth/data/supabase_auth_repo.dart';
import 'package:techrx/features/auth/domain/entities/app_user.dart';
import 'package:techrx/features/auth/presentation/components/my_button.dart';
import 'package:techrx/features/profile/data/supabase_profile_repo.dart';
import 'package:techrx/features/profile/presentation/components/circular_tag.dart';
import 'package:techrx/features/profile/presentation/components/my_drawer.dart';
import 'package:techrx/features/profile/presentation/components/recent_activity.dart';
import 'package:techrx/features/ticket/presentation/pages/create_ticket.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _HomePageState();
}

class _HomePageState extends State<ProfilePage> {
  // get supabaseAuth repository
  final supabaseAuthRepo = SupabaseAuthRepo();

  //get supabaseprofile repository
  final supabaseProfileRepo = SupabaseProfileRepo();

  // current user data
  AppUser? currentUser;

  // logout button pressed
  void logout() async {
    await supabaseAuthRepo.logout();
  }

  // user wants to create a ticket
  void createTicket() {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        // title: Text("Create Ticket"),
        content: SingleChildScrollView(child: CreateTicket()),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser(); // Fetch user data when the page loads
  }

  // GET CURRENT USER
  void getCurrentUser() async {
    final user = await supabaseAuthRepo.getCurrentUser() as AppUser;
    setState(() {
      currentUser = user; // Update state to trigger UI rebuild
    });
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          // logout button
          IconButton(onPressed: logout, icon: const Icon(Icons.logout_rounded)),
        ],
      ),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PROFILE BANNER
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Check if currentUser is not null before showing its info
                  Text(
                    "Hello ${currentUser?.name ?? 'Friend'}", // Default to 'Friend' if user is null
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Grand text
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Welcome to ',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 32,
                          ),
                        ),
                        TextSpan(
                          text: 'Tech',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text: 'Rx',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 50), // Adds space between sections

              // ABOUT MY TICKETS
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ticket statistics row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircularTag(
                          value: "109",
                          label: "All",
                          borderColor: Theme.of(context).colorScheme.secondary,
                          fill: Theme.of(context).colorScheme.inversePrimary,
                          valueColor: Theme.of(context).colorScheme.primary,
                        ),
                        CircularTag(
                          value: "07",
                          label: "Pending",
                          borderColor: Theme.of(context).colorScheme.tertiary,
                          fill: Theme.of(context).colorScheme.tertiary,
                        ),
                        const CircularTag(
                          value: "109",
                          label: "In Progress",
                          borderColor: Colors.blue,
                          fill: Colors.blue,
                        ),
                        const CircularTag(
                          value: "10",
                          label: "Completed",
                          borderColor: Colors.green,
                          fill: Colors.green,
                        ),
                      ],
                    ),
                    Divider(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "We don't just fix your devices, We restore trust. \nOur experts treat your tech with care because every device has a story, \nLet's write the next chapter together.",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                    const SizedBox(height: 24),

                    // Action section (Create Ticket and View Tickets buttons)
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
                            borderRadius: 64,
                            borderColor: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        MyButton(
                          onTab: () {},
                          text: 'View Tickets',
                          borderRadius: 6,
                          borderColor:
                              Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30), // Adds space between sections

              // RECENT ACTIVITIES
              Text(
                'MY RECENT ACTIVITY',
                style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.secondary),
              ),

              // divider
              Divider(
                color: Colors.grey[400],
              ),
              RecentActivity(userId: currentUser?.uid)
            ],
          ),
        ),
      ),
    );
  }
}
